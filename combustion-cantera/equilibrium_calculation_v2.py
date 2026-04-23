import os
import sys
import numpy as np
import cantera as ct
import json

_KEROSENE_YAML = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'kerosene.yaml')

def compute_flame_temperature(T0, p0, phi, fuel, oxid):
    gas = ct.Solution(_KEROSENE_YAML)
    gas.TP = T0, p0
    gas.set_equivalence_ratio(phi, fuel, oxid)
    gas.equilibrate('HP')
    return gas.T, gas

def get_combustion_properties(T0, p0, phi, fuel, oxid, equilibriumFile):

    T_eq, gas = compute_flame_temperature(T0, p0, phi, fuel, oxid)

    # Lista delle specie chimiche da filtrare
    target_species = {"NO", "NO2", "CO", "CO2", "H2O", "O2"}

    # Filtro delle specie
    filtered_species = {
        name: float(Y) for name, Y in zip(gas.species_names, gas.Y) if name in target_species
    }

    # Identify fuel species from the input string (can be comma or + separated, and may include ratios)
    fuel_species = []
    for s in fuel.replace('+', ',').split(','):
        s = s.strip()
        if not s:
            continue
        # Split by ':' if present, take only the species name
        species_name = s.split(':')[0].strip()
        if species_name:
            fuel_species.append(species_name)

    # Get the mass fraction for each fuel species
    fuel_sum = sum(gas.Y[gas.species_index(s)] for s in fuel_species if s in gas.species_names)

    # Get O2 and N2 fractions
    o2 = gas.Y[gas.species_index("O2")]
    n2 = gas.Y[gas.species_index("N2")]

    # Burned fuel fraction: 1 - (fuel + O2 + N2)
    burned_fuel_fraction = 1.0 - (fuel_sum + o2 + n2)


    # Calcolo delle frazioni normalizzate per NO, NO2, CO, CO2 rispetto al combustibile bruciato
    normalized_species = {}
    for specie in ["NO", "NO2", "CO", "CO2"]:
        val = filtered_species.get(specie, 0.0)
        normalized_species[specie] = val / burned_fuel_fraction if burned_fuel_fraction > 0 else 0.0


    output_data = {
        'T_flame': T_eq,
        'P_flame': float(gas.P),
        'phi': phi,
        'species': [{name: fraction for name, fraction in zip(gas.species_names, gas.Y)}],
        'filtered_species': filtered_species,
        'fuel_species': fuel_species,
        'burned_fuel_fraction': burned_fuel_fraction,
        'normalized_species': normalized_species
    }

    # Save to the specified equilibrium file
    with open(equilibriumFile, 'w') as f_out:
            json.dump(output_data, f_out, indent=4)

    #print(f"Risultati salvati in '{equilibriumFile}'")

if __name__ == "__main__":
    #print("sys.argv:", sys.argv)
    if len(sys.argv) != 7:
        print("Usage: python equilibrium_calculation_v2.py T0 p0 T02Burner fuel oxid equilibriumFile")
        sys.exit(1)

    try:
        T0 = float(sys.argv[1])
        p0 = float(sys.argv[2])
        phi = float(sys.argv[3])
        fuel = sys.argv[4]
        oxid = sys.argv[5]
        equilibriumFile = sys.argv[6]

        #print(f"Input ricevuti: T0 = {T0} K, p0 = {p0} Pa, phi = {phi} K, fuel = {fuel}, oxid = {oxid}")
        get_combustion_properties(T0, p0, phi, fuel, oxid, equilibriumFile)

     

    except Exception as e:
        print(f"Errore durante l'esecuzione: {e}")
        sys.exit(1)

