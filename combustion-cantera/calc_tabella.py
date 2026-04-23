from itertools import product
import numpy as np
import cantera as ct
import json
import time

def compute_flame_temperature(T0, p0, phi, fuel, oxid):
    gas = ct.Solution('kerosene.yaml')
    gas.TP = T0, p0
    gas.set_equivalence_ratio(phi, fuel, oxid)
    gas.equilibrate('HP')
    return gas.T, gas

def calc_table_to_import(T0vals, p0vals, fvals, fst, fuel, oxid):
    start_time = time.time()
    data = []
    for T0,p0,f in product(T0vals, p0vals, fvals):
        phi = f/fst
        try:
            T_eq, gas = compute_flame_temperature(T0, p0, phi, fuel, oxid)
            cp_mixture = float(gas.cp_mass)
            data.append({
                "T01": float(T0),
                "p01": float(p0),
                "f": float(f),
                "phi": float(phi),
                "T02": float(T_eq),
                "cpB": cp_mixture
            })
        except Exception:
            continue
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

## Nascono l'esegutore perché ho fatto un iterazione da 8h 30 min con 50 000 combinazioni salvate e non voglio rischiare di sovrascrivere la tabella json

# if __name__ == "__main__":
#    T0vals = np.linspace(300, 1300, 50)
#    p0vals = np.linspace(50000, 5050000, 100)
#    fst = 1/14.472211680741129
#    fvals = np.linspace(0.01, fst, 10)


#    fuel = "NC10H22:0.23,AC10H21:0.32,CYC6H12:0.21,CYC9H18:0.06,NAPHT:0.18"
#    oxid = "O2:1,N2:3.76"

#  calc_table_to_import(T0vals, p0vals, fvals, fst, fuel, oxid)