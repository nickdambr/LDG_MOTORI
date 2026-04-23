import os
import sys  # Per accedere agli argomenti passati da riga di comando (es. T0, p0, ecc.)
import numpy as np # Libreria per operazioni numeriche
from scipy.optimize import fsolve  # Funzione per risolvere sistemi di equazioni non lineari
import math  # Libreria per operazioni matematiche di base (es., funzioni trigonometriche e conversioni)
import json # Libreria per la gestione di file JSON

# Definizione della funzione principale per calcolare il triangolo di velocità
def triangle_design_updated_numeric(tau_s, DFactor, sigma, gamma, alpha1_deg):
     # Conversione dell'angolo α1 da gradi a radianti
    # Le funzioni trigonometriche in Python lavorano in radianti, quindi è necessario effettuare questa conversione
    alpha1 = math.radians(alpha1_deg)

    # Definizione del sistema di equazioni
    def equations(variables):
         # Variabili del sistema: M1 (numero di Mach) e α2 (angolo in radianti)
        Mach1, alpha2 = variables
        
        
    # La scrittura è nella forma τs - <espressione> = 0 piuttosto che nella forma esplicita τs = <espressione>
    # Questo è necessario perché il risolutore "fsolve" richiede che le equazioni siano espresse come uguaglianze a zero
        
        # Prima equazione: relazione tra τs, M1, alpha1, e alpha2
        eq1 = tau_s - (((gamma - 1) * Mach1**2) / (1 + (gamma - 1) * Mach1**2 / 2) 
                       * ((math.cos(alpha1)**2 / math.cos(alpha2)**2) - 1) + 1)
        
        # Seconda equazione: DF relazione tra DF, alpha1, alpha2, e sigma
        eq2 = DFactor - ((1 - math.cos(alpha2) / math.cos(alpha1)) + 
                    ((math.tan(alpha2) - math.tan(alpha1)) / (2 * sigma)) * math.cos(alpha2))
        return [eq1, eq2]

    # Stima iniziale necessaria per il risolutore
    # M1=0.5 stima iniziale ragionevole per il numero di Mach
    # alpha2=45° stima iniziale per l'angolo (convertito in radianti)
    initial_guess = [0.5, math.radians(45)]
    
    # Risoluzione numerica del sistema di equazioni
    # fsolve utilizza metodi iterativi (Newton-Raphson o sue varianti) per trovare una soluzione che soddisfi eq1=0 ed eq2=0
    solution = fsolve(equations, initial_guess)
   
    # Estrazione dei risultati
    # La soluzione contiene i valori calcolati per M1 e α2 (in radianti)
    Mach1, alpha2 = solution

    # Conversione di α2 in gradi
    alpha2_deg = math.degrees(alpha2)

    # Costruzione del dizionario dei risultati
    output_data = {
        "Mach1": Mach1,
        "alpha2_degrees": alpha2_deg
    }

    # Salvataggio su file JSON
    _output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "triangledesign.json")
    with open(_output_path, 'w') as f_out:
        json.dump(output_data, f_out, indent=4)

    print(f"Solution found: M1 = {Mach1:.5f}, alpha2 = {alpha2_deg:.2f} degrees")
    print("Risultati salvati in TriangleDesign.json")

    return Mach1, alpha2_deg

# Blocco principale per eseguire il codice
if __name__ == "__main__":
    if len(sys.argv) != 6:
        print("Usage: py triangle_design_noigv.py tau_s DFactor sigma gamma alpha1_deg")
        sys.exit(1)

    try:
        # Lettura degli argomenti dalla riga di comando
        tau_s = float(sys.argv[1]) 
        DFactor = float(sys.argv[2]) 
        sigma = float(sys.argv[3])
        gamma = float(sys.argv[4])
        alpha1_deg = float(sys.argv[5])

        # Chiamata della funzione principale per risolvere il sistema
        triangle_design_updated_numeric(tau_s, DFactor, sigma, gamma, alpha1_deg)

    except Exception as e:
        print(f"Error solving the system: {e}")
        sys.exit(1)
