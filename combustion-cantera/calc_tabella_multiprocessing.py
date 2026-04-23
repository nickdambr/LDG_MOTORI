from itertools import product
import numpy as np
import cantera as ct
import json
import time
import multiprocessing

def compute_flame_temperature(T0, p0, phi, fuel, oxid):
    gas = ct.Solution('kerosene_hipress.yaml')
    gas.TP = T0, p0
    gas.set_equivalence_ratio(phi, fuel, oxid)
    gas.equilibrate('HP')
    return gas.T, float(gas.cp_mass)

def compute_entry(args):
    T0, p0, f, fst, fuel, oxid = args
    phi = f / fst
    try:
        T_eq, cp_mixture = compute_flame_temperature(T0, p0, phi, fuel, oxid)
        return {
            "T01": float(T0),
            "p01": float(p0),
            "f": float(f),
            "phi": float(phi),
            "T02": float(T_eq),
            "cpB": cp_mixture
        }
    except Exception:
        return None

def calc_table_to_import(T0vals, p0vals, fvals, fst, fuel, oxid):
    start_time = time.time()
    combinations = list(product(T0vals, p0vals, fvals))
    input_data = [(T0, p0, f, fst, fuel, oxid) for T0, p0, f in combinations]

    # Use multiprocessing
    with multiprocessing.Pool(processes=multiprocessing.cpu_count()) as pool:
        results = pool.map(compute_entry, input_data)
   
    # Filter out failed cases (None)
    data = [res for res in results if res is not None]

    with open("tabella_combustione.json", "w") as outfile:
        json.dump(data, outfile, indent=4)

    stop_time = time.time() - start_time
    hours = int(stop_time // 3600)
    minutes = int((stop_time % 3600) // 60)
    seconds = int(stop_time % 60)
    
    print()
    print(f"{len(data)} combinazioni salvate.")
    print(f"Tempo impiegato: {hours}h {minutes}min {seconds}s")
    print()

if __name__ == "__main__":
    T0vals = np.linspace(40, 2000, 50)         #(20, 2000, 100)
    p0vals = np.linspace(60000, 1500000, 250)   #(30000, 1500000, 500)
    fst = 1 / 14.287159546238891
    fvals = np.linspace(0, fst, 10)             #(0, fst, 20)

    fuel = "CYC9H18:0.292,AC10H21:0.319,NC10H22:0.090,NAPHT:0.228,TOLUEN:0.071"
    oxid = "O2:1,N2:3.76"

    calc_table_to_import(T0vals, p0vals, fvals, fst, fuel, oxid)
