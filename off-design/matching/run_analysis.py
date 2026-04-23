import numpy as np
import matplotlib.pyplot as plt
from solver_framework import Solver
from my_problem import TurboFan

def main():
    """
    Sets up and runs the analysis, then plots the results.
    """
    # --- 1. Setup the Problem ---
    
    # Define the names of the variables you want to solve for.
    # This MUST match the order used in your `get_equations` method.
    variables = [
        'Pi_LPC', 'Pi_HPC', 'N_red_HPC', 'N_red_LPC', 
        'Pi_HPT', 'Pi_LPT', 'N_red_HPT', 'N_red_LPT', 'T04T021'
    ]
    
    # Instantiate your custom equation system
    my_equations = TurboFan(variable_names=variables)
    
    # Instantiate the solver with your equation system
    solver = Solver(my_equations)
    
    # --- 2. Define Simulation Parameters ---
    
    # Define fixed parameters with dummy values
    parameters = {
        # Gas Properties
        'gamma_gas': 1.33,
        'gamma_air': 1.4,
        'R_gas': 287.0,
        'R_air': 287.0,
        
        # Component Performance
        'eta_LPC': 0.90,  # Compressor efficiencies are now fixed parameters
        'eta_HPC': 0.88,  #
        'eta_LPT': 0.92,
        'eta_HPT': 0.91,
        'eta_m': 0.99,
        'Pi_CC': 0.96,
        
        # Engine Geometry (Areas in m^2, Diameters in m)
        'A1': 0.969532, 'A2': 1.03714, 'A21': 0.245039, 'A4': 1.0, 'A41': 1.0, 
        'A5': 1.0, 'A7': 1.0, 'A8': 1.0, 'A9': 1.0,
        'D_HPC': 0.5, 'D_HPT': 0.5, 'D_LPC': 1.0, 'D_LPT': 1.0,
        
        # Bleed Fractions & BPR
        'eps1': 0.075,
        'eps2': 0.075,
        'BPR': 0.1,
        
        # Ambient Conditions (at a given altitude)
        'P_a': 18144.4,   # Ambient static pressure [Pa]
        'T_a': 216.65,    # Ambient static temperature [K]
        'P0_a': 18144.4,  # Ambient total pressure [Pa] - will be updated in loop
        'T0_a': 216.65,   # Ambient total temperature [K] - will be updated in loop
    }
    
    # Define the "free parameter" range to sweep over
    free_parameter_name = 'M0'
    free_parameter_range = np.linspace(1.5, 2.0, 50)
    
    # Provide an initial guess for the solver. Must have 9 values.
    initial_guess = [
        6.5, 4.0, 0.9, 0.9, # Pi_LPC, Pi_HPC, N_red_HPC, N_red_LPC
        0.8, 0.7, 0.9, 0.9, # Pi_HPT, Pi_LPT, N_red_HPT, N_red_LPT
        6.0                 # T04T021
    ]
    
    # --- 3. Run the Simulation Sweep ---
    
    print(f"Running simulation sweep for '{free_parameter_name}'...")
    results = []
    for M0_val in free_parameter_range:
        # Update the free parameter in the parameters dictionary
        current_params = parameters.copy()
        current_params[free_parameter_name] = M0_val
        
        # Update total conditions based on M0
        current_params['T0_a'] = parameters['T_a'] * (1 + (parameters['gamma_air'] - 1) / 2 * M0_val**2)
        current_params['P0_a'] = parameters['P_a'] * (1 + (parameters['gamma_air'] - 1) / 2 * M0_val**2)**(parameters['gamma_air'] / (parameters['gamma_air'] - 1))

        # Solve the system for the current set of parameters
        solution = solver.solve(initial_guess, **current_params)
        
        # Store the free parameter value along with the solution
        solution[free_parameter_name] = M0_val
        results.append(solution)
        
        # Use the current solution as the initial guess for the next step (improves convergence)
        if not np.isnan(list(solution.values())[0]):
             initial_guess = [solution[v] for v in variables]

    print("Simulation complete.")
    
    # --- 4. Plot the Results ---
    
    # Extract data for plotting
    x_axis = [res[free_parameter_name] for res in results]
    
    plt.style.use('seaborn-v0_8-whitegrid')
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Plot each solved variable against the free parameter
    for var_name in variables:
        y_axis = [res[var_name] for res in results]
        ax.plot(x_axis, y_axis, label=var_name)
        
    ax.set_xlabel(f'Free Parameter: {free_parameter_name}')
    ax.set_ylabel('Solved Variable Values')
    ax.set_title('System Solution vs. Free Parameter')
    ax.legend()
    ax.grid(True)
    # ax.set_ylim(0, 10) # Adjust ylim as needed
    
    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    main()