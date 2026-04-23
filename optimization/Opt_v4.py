import json
import subprocess
import os
import sys
import numpy as np
from pymoo.core.problem import Problem
import uuid
import multiprocessing as mp
from pymoo.core.problem import StarmapParallelization
from pymoo.util.nds.non_dominated_sorting import NonDominatedSorting
import shutil
import time



# TF.wls lives next to this script. Resolving via __file__ keeps the
# pipeline runnable regardless of the caller's working directory.
Wolfram_script_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "TF.wls")

# wolframscript executable: override via the WOLFRAMSCRIPT environment
# variable (e.g. when it is not on PATH, as is common on Windows).
wolframscript_exe = os.environ.get("WOLFRAMSCRIPT", "wolframscript")


# Ensure the inputDesign folder exists
input_folder = "inputDesign"
os.makedirs(input_folder, exist_ok=True)

# Ensure the equilibriumDesign folder exists
equilibrium_folder = "eqDesign"
os.makedirs(equilibrium_folder, exist_ok=True)

# Ensure the outputDesign folder exists
output_folder = "outputDesign"
os.makedirs(output_folder, exist_ok=True)

from pymoo.core.callback import Callback




def evaluate_single(xi, equilibrium_folder, input_folder, output_folder):
    Mach = float(xi[0])
    quota = float(xi[1])
    BPR = float(xi[2])
    Beta_c = float(xi[3])

    inputs = {
        "BPR": BPR,
        "Beta_c": Beta_c,
        "Mach": Mach,
        "quota": quota
    }
    unique_id = uuid.uuid4().hex
    input_file = os.path.join(input_folder, f"input_ID_{unique_id}.json").replace("\\", "/")
    output_file = os.path.join(output_folder, f"output_ID_{unique_id}.json").replace("\\", "/")
    equilibrium_file = os.path.join(equilibrium_folder, f"equilibrium_ID_{unique_id}.json").replace("\\", "/")
    #equilibrium_file = os.path.join(equilibrium_folder, f"equilibrium_ID_{unique_id}.json").replace("\\", "/")

    try:
        with open(input_file, "w") as f:
            json.dump(inputs, f, indent=4)
    except (OSError, IOError) as e:
        print(f"Errore nella scrittura del file di input JSON: {e}")
        print(f"Input che ha causato errore: {inputs}")
        return [1e6, 1e6, 1e6, 1e6]  # Penalizzazione pesante

    try:
        subprocess.run([
            wolframscript_exe,
            "-file",
            Wolfram_script_path,
            input_file,
            equilibrium_file,
            output_file
        ], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Errore durante l'esecuzione dello script Wolfram: {e}")
        print(f"Input che ha causato errore: {inputs}")
        return [1e6, 1e6, 1e6, 1e6]  # Penalizzazione pesante

    try:
        with open(output_file, "r") as f:
            data = json.load(f)

        Ia = data["Ia"]
        TSFC = data["TSFC"]
        EINOX = data["EINOX"]
        EICO = data["EICO"]
        MinusIa = -Ia

        return [MinusIa, TSFC, EINOX, EICO]

    except (FileNotFoundError, json.JSONDecodeError, KeyError, TypeError) as e:
        print(f"Errore nel parsing del file di output: {e}")
        print(f"Input che ha causato errore: {inputs}")
        return [1e6, 1e6, 1e6, 1e6]  # Penalizzazione pesante


    
class Motori(Problem):
    def __init__(self):
        # Define the number of objectives and variables
        n_objectives = 4
        n_variables = 4

        # Define the variable bounds
        xl = np.array([1.3,  # Mach
                       9000,  # quota
                       0.1,    # BPR
                       3])  # Beta_c
        xu = np.array([1.7,    # Mach
                       14000,  # quota
                       0.6,    # BPR
                       9])  # Beta_c

        # Initialize the parent class
        super().__init__(
            # Problem dimension
            n_var=n_variables,
            # Number of objectives
            n_obj=n_objectives,
            # Number of constraints
            n_constr=0,
            # Variable bounds
            xl=xl,
            xu=xu
        )
        self.generation = 1

    def set_generation(self, generation):
        self.generation = generation

    def _evaluate(self, X, out, *args, **kwargs):
        eq_folder = f"eqDesign{self.generation}"
        os.makedirs(eq_folder, exist_ok=True)
        input_folder = f"inputDesign{self.generation}"
        os.makedirs(input_folder, exist_ok=True)
        output_folder = f"outputDesign{self.generation}"
        os.makedirs(output_folder, exist_ok=True)


        # Pass eq_folder to evaluate_single
        #F = np.array(runner(evaluate_single(X, eq_folder)))


        F = np.array(runner(evaluate_single_wrapper, [(xi, eq_folder, input_folder, output_folder) for xi in X]))
        out["F"] = F


        #F = np.array(runner(evaluate_single, [(xi, eq_folder) for xi in X]))

def evaluate_single_wrapper(args):
    xi, eq_folder, input_folder, output_folder = args
    return evaluate_single(xi, eq_folder, input_folder, output_folder)


class GenerationCallback(Callback):
    def notify(self, algorithm):
        gen = algorithm.n_gen
        problem.set_generation(algorithm.n_gen)

        # Get the population variables and objective values
        X = algorithm.pop.get("X")
        F = algorithm.pop.get("F")

        # Find indices of the non-dominated front (rank=0)
        nds = NonDominatedSorting()
        nd_indices = nds.do(F, only_non_dominated_front=True)

        # Extract non-dominated solutions
        X_nd = X[nd_indices]
        F_nd = F[nd_indices]

        # Save non-dominated solutions only
        np.save(f"X_non_dominated_gen_{gen}.npy", X_nd)
        np.save(f"F_non_dominated_gen_{gen}.npy", F_nd)

        print(f"Saved non-dominated solutions for generation {gen}: X_non_dominated_gen_{gen}.npy, F_non_dominated_gen_{gen}.npy")




if __name__ == "__main__":
    start_time = time.time()  # Start timer
    # Delete the folders and all their contents
    for folder in ["inputDesign", "eqDesign", "outputDesign"]:
        if os.path.exists(folder):
            shutil.rmtree(folder)

    # Pool and runner setup
    #processes = mp.cpu_count()
    pool = mp.Pool(16)
    runner = StarmapParallelization(pool.starmap)

    problem = Motori()
    callback= GenerationCallback()
    

    from pymoo.algorithms.moo.nsga2 import NSGA2
    from pymoo.operators.crossover.sbx import SBX
    from pymoo.operators.mutation.pm import PM
    from pymoo.operators.sampling.rnd import FloatRandomSampling

    algorithm = NSGA2(
        pop_size=400,  #numero di individui in una generazione: 400 va bene, se troppo lento prova 300-200
        n_offsprings=400, #numero di figli generati in ogni generazione: di solito si mette = pop_size quindi 400 per una popolazione meno incompleta
        sampling=FloatRandomSampling(),
        crossover=SBX(prob=0.9, eta=15),
        mutation=PM(eta=20), #controlla la variabilita' delle soluzioni: se alla fine ci sono troppe soluzioni simili posso abbassare un po'
        eliminate_duplicates=True
    )
        
    from pymoo.termination import get_termination

    termination = get_termination("n_gen", 50) #anche 50 per i primi test, poi in quelli finali anche 100

    from pymoo.optimize import minimize

    res = minimize(problem,
                   algorithm,
                   termination,
                   seed=1, #Serve a fare in modo che ogni volta che eseguo il codice ottengo esattamente gli stessi risultati
                   save_history=True,
                   verbose=True,
                   callback=callback
                   )
    
    # Print the total computation time
    end_time = time.time()  # End timer
    print(f"Total computation time: {end_time - start_time:.2f} seconds")

    # Extract the results
    X = res.X
    F = res.F
    

    # At the end, close the pool
    pool.close()
    pool.join()

    #Se vogliamo stampare tutte le soluzioni
    np.save("X_results.npy", X)
    np.save("F_results.npy", F)
    for i in range(len(X)):
        print(f"Soluzione {i+1}:")
        print(f"  X = {X[i]}")
        print(f"  F = {F[i]}")
        print()


    import matplotlib.pyplot as plt
    xl, xu = problem.bounds()
    plt.figure(figsize=(7, 5))
    plt.scatter(X[:, 0], X[:, 1], s=30, facecolors='none', edgecolors='r')
    plt.xlim(xl[0], xu[0])
    plt.ylim(xl[1], xu[1])
    plt.title("Design Space Mach vs Quota")

    plt.figure(figsize=(7, 5))
    plt.scatter(X[:, 2], X[:, 3], s=30, facecolors='none', edgecolors='r')
    plt.xlim(xl[2], xu[2])
    plt.ylim(xl[3], xu[3])
    plt.title("Design Space BPR vs Beta_c")

    plt.figure(figsize=(7, 5))
    plt.scatter(-F[:, 0], F[:, 1], s=30, facecolors='none', edgecolors='blue')
    plt.title("Objective Space -Minus Ia vs TSFC")


    from pymoo.visualization.scatter import Scatter
    from pymoo.visualization.pcp import PCP
    import seaborn as sns
    import pandas as pd

    #Visualizzazioni
    #Parallel Coordinates

    PCP(title="Parallel Coordinates - Obiettivi").add(F).show(block=False)
    PCP(title="Parallel Coordinates - Variabili").add(X).show(block=False)

    #Bubble Chart

    plt.figure(figsize=(7, 5))
    plt.scatter(-F[:, 0], F[:, 1], s=F[:, 2]*100, c=F[:, 3], cmap='viridis', alpha=0.6)
    plt.xlabel("-Ia")
    plt.ylabel("TSFC")
    plt.title("Bubble Chart: -Ia vs TSFC (size=EINOX, color=EICO)")
    plt.colorbar(label="EICO")
    plt.grid(True)

    #Scatter Matrix (correlazione tra le coppie di obiettivi)

    df = pd.DataFrame(F, columns=["-Ia", "TSFC", "EINOX", "EICO"])
    sns.pairplot(df)
    plt.suptitle("Scatter Matrix degli Obiettivi", y=1.02)


    plt.show()


