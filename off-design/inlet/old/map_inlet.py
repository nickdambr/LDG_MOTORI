import numpy as np
import matplotlib.pyplot as plt
from off_inlet import analyze_inlet_off_design, R, gamma

# --- Global variables to store inlet map data so we only load it once ---
_inlet_map_data = None



def run_simulations_and_plot():
    """
    Runs a sweep of simulations for the fixed-geometry inlet and plots the results.
    """
    print("--- Starting Inlet Performance Simulation Sweep ---")

    # --- Simulation Setup ---
    # Use the same design parameters from your off_inlet.py script
    DESIGN_MACH = 1.49081
    DESIGN_GEOMETRY = {
        'A_throat': 0.9695327684,
        'A_exit': 1.0256858841,
    }
    DESIGN_ETA_D = 0.9

    # Define the constant atmospheric conditions for the sweep
    freestream_pressure = 18144.4  # Pa
    freestream_temperature = 216.65 # K

    # Define the engine's mass flow requirement for this analysis.
    # We will keep this constant to see how the inlet performs.
    # Using the design point mass flow is a good choice.
    mdot_engine_req = 124.4431866 # kg/s

    # Define the range of flight Mach numbers to simulate
    M0_range = np.linspace(0., 2.2, 1000) # From subsonic to supersonic

    # --- Data Collection ---
    # Create empty lists to store the results from each simulation run
    M0_results = []
    pi_inlet_results = []
    capture_ratio_results = []
    mdot_reduced_results = []
    mdot_param_freestream_results = []
    mdot_param_throat_results = []

    for M0 in M0_range:
        # Run the analysis for the current Mach number
        performance = analyze_inlet_off_design(
            geometry=DESIGN_GEOMETRY,
            M_design=DESIGN_MACH,
            M0=M0,
            P_inf=freestream_pressure,
            T_inf=freestream_temperature,
            mdot_engine_req=mdot_engine_req,
            eta_d=DESIGN_ETA_D
        )

        # Store the results
        M0_results.append(M0)
        pi_inlet_results.append(performance.get("Overall Pressure Recovery (pi_inlet)", np.nan))
        
        # Calculate the capture area ratio (A0 / A_throat)
        mdot_captured = performance.get("Engine Face Mass Flow [kg/s]", 0)
        rho_inf = freestream_pressure / (R * freestream_temperature)
        a_inf = np.sqrt(gamma * R * freestream_temperature)
        V_inf = M0 * a_inf
        
        if V_inf > 0:
            A0 = mdot_captured / (rho_inf * V_inf)
            capture_ratio = A0 / DESIGN_GEOMETRY['A_throat']
            capture_ratio_results.append(capture_ratio)
        else:
            A0 = 0
            capture_ratio_results.append(0)

        # --- Calculate Mass Flow Parameters for New Plot ---
        pi_inlet = performance.get("Overall Pressure Recovery (pi_inlet)", np.nan)

        # Freestream total conditions
        T0_inf = freestream_temperature * (1 + (gamma - 1) / 2 * M0**2)
        P0_inf = freestream_pressure * (1 + (gamma - 1) / 2 * M0**2)**(gamma / (gamma - 1)) if M0 > 0 else freestream_pressure
        
        # Freestream parameter (at capture area A0)
        if P0_inf > 0 and A0 > 0:
            param_freestream = (mdot_captured * np.sqrt(R * T0_inf)) / (P0_inf * A0)
            mdot_param_freestream_results.append(param_freestream)
        else:
            mdot_param_freestream_results.append(np.nan)

        # Throat parameter (at throat area A_throat)
        A_throat = DESIGN_GEOMETRY['A_throat']
        if not np.isnan(pi_inlet) and P0_inf > 0:
            P0_throat = P0_inf * pi_inlet
            # T0 is constant across shocks, so T0_throat = T0_inf
            param_throat = (mdot_captured * np.sqrt(R * T0_inf)) / (P0_throat * A_throat)
            mdot_param_throat_results.append(param_throat)
        else:
            mdot_param_throat_results.append(np.nan)

        # Calculate the reduced mass flow parameter at the engine face per user definition
        T0_exit = performance.get("Engine Face Total Temperature [K]", np.nan)
        P0_exit = performance.get("Engine Face Total Pressure [Pa]", np.nan)
        mdot_face = performance.get("Engine Face Mass Flow [kg/s]", 0)
        A_exit = DESIGN_GEOMETRY['A_exit']

        if not np.isnan(T0_exit) and not np.isnan(P0_exit) and P0_exit > 0:
            # User's formula: (mdot * sqrt(R*T0)) / (p0*A)
            mdot_reduced = (mdot_face * np.sqrt(R * T0_exit)) / (P0_exit * A_exit)
            mdot_reduced_results.append(mdot_reduced)
        else:
            mdot_reduced_results.append(np.nan)

    print("--- Simulation sweep complete. Generating plots... ---")

    # --- Plotting ---
    plt.style.use('seaborn-v0_8-whitegrid')
    
    # Figure 1: Overall Pressure Recovery vs. M0
    plt.figure(figsize=(10, 6))
    plt.plot(M0_results, pi_inlet_results, 'b-', label='Pressure Recovery')
    plt.axvline(x=DESIGN_MACH, color='r', linestyle='--', label=f'Design Mach = {DESIGN_MACH:.2f}')
    plt.xlabel('Flight Mach Number (M0)', fontsize=12)
    plt.ylabel('Overall Pressure Recovery (π_inlet)', fontsize=12)
    plt.title(f'Pressure Recovery vs. Flight Mach Number\n(mdot_req = {mdot_engine_req:.1f} kg/s)', fontsize=14)
    plt.legend()
    plt.grid(True)

    # Figure 2: Capture Area Ratio vs. M0
    plt.figure(figsize=(10, 6))
    plt.plot(M0_results, capture_ratio_results, 'g-', label='Capture Ratio')
    plt.axvline(x=DESIGN_MACH, color='r', linestyle='--', label=f'Design Mach = {DESIGN_MACH:.2f}')
    plt.xlabel('Flight Mach Number ($M_0$)', fontsize=12)
    plt.ylabel('Capture Area Ratio ($A_0$ / $A_{throat}$)', fontsize=12)
    plt.title(f'Captured Mass Flow vs. Flight Mach Number\n(mdot_req = {mdot_engine_req:.1f} kg/s)', fontsize=14)
    plt.ylim(0, 1.1)
    plt.legend()
    plt.grid(True)

    # Figure 3: Reduced Mass Flow Parameter vs. M0
    plt.figure(figsize=(10, 6))
    plt.plot(M0_results, mdot_reduced_results, 'm-', label='Reduced Mass Flow Parameter')
    plt.axvline(x=DESIGN_MACH, color='r', linestyle='--', label=f'Design Mach = {DESIGN_MACH:.2f}')
    plt.xlabel('Flight Mach Number ($M_0$)', fontsize=12)
    plt.ylabel('Exit Reduced Mass Flow Parameter (Dimensionless)', fontsize=12)
    plt.title(f'Exit Reduced Mass Flow Parameter vs. Flight Mach Number\n(mdot_req = {mdot_engine_req:.1f} kg/s)', fontsize=14)
    plt.legend()
    plt.grid(True)

    # Figure 4: Mass Flow Parameters vs. M0
    plt.figure(figsize=(10, 6))
    plt.plot(M0_results, mdot_param_freestream_results, 'c-', label='Freestream Parameter (at $A_0$)')
    plt.plot(M0_results, mdot_param_throat_results, 'k--', label='Throat Parameter (at A_throat)')
    plt.axvline(x=DESIGN_MACH, color='r', linestyle='--', label=f'Design Mach = {DESIGN_MACH:.2f}')
    plt.xlabel('Flight Mach Number ($M_0$)', fontsize=12)
    plt.ylabel('Mass Flow Parameter (Dimensionless)', fontsize=12)
    plt.title('Inlet Mass Flow Parameters vs. Flight Mach Number', fontsize=14)
    plt.legend()
    plt.grid(True)

    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    run_simulations_and_plot()
