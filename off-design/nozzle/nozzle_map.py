import numpy as np
import matplotlib.pyplot as plt
from nozzle import analyze_cd_nozzle

def plot_nozzle_operating_map():
    """
    Runs a sweep of simulations for the CD nozzle and plots its operating map.
    """
    print("--- Starting Nozzle Performance Map Generation ---")

    # --- Nozzle Definition (from nozzle.py) ---
    inlet_P0 = 372858
    inlet_T0 = 1308.5
    throat_area = 0.22875
    exit_area = 0.75992
    gamma = 1.33
    R = 287.0

    # --- Simulation Sweep Setup ---
    # Create a range of back pressures to cover all operating regimes
    # Start from just below P0 (unchoked) to very low (highly under-expanded)
    back_pressure_range = np.linspace(1000, inlet_P0, 2500)

    # --- Data Collection ---
    inv_npr_results = []
    mdot_reduced_results = []

    print(f"Running {len(back_pressure_range)} simulations...")
    for p_back in back_pressure_range:
        # Run the analysis for the current back pressure
        performance = analyze_cd_nozzle(
            P0=inlet_P0,
            T0=inlet_T0,
            A_throat=throat_area,
            A_exit=exit_area,
            P_back=p_back,
            gamma=gamma,
            R=R
        )

        # Calculate the required parameters for the plot
        mdot = performance.get("Mass Flow Rate [kg/s]", 0)
        
        # Nozzle Pressure Ratio (NPR)
        npr = inlet_P0 / p_back
        
        # Reduced mass flow at the throat: (mdot * sqrt(T0)) / P0
        mdot_reduced = (mdot * np.sqrt(R*inlet_T0)) / (inlet_P0* throat_area)

        inv_npr_results.append(1 / npr)
        mdot_reduced_results.append(mdot_reduced)

    print("--- Simulation sweep complete. Generating plot... ---")

    # --- Plotting ---
    plt.style.use('seaborn-v0_8-whitegrid')
    plt.figure(figsize=(10, 7))

    plt.plot(inv_npr_results, mdot_reduced_results, 'b-', marker='.', markersize=4, label='Nozzle Operating Line')
    
    # Find the choked mass flow value to highlight it
    mdot_reduced_choked = max(mdot_reduced_results)
    plt.axhline(y=mdot_reduced_choked, color='r', linestyle='--', label=f'Choked Flow (mdot_red = {mdot_reduced_choked:.4f})')

    plt.ylabel('Reduced Mass Flow at Throat', fontsize=12)
    plt.xlabel('Inverse Nozzle Pressure Ratio $(P_{back}/ P_0)$', fontsize=12)
    plt.title('Nozzle Operating Map', fontsize=16)
    plt.legend()
    plt.grid(True)
    plt.xlim(0, 1.1)

    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    plot_nozzle_operating_map()