import numpy as np
import matplotlib.pyplot as plt
from tabulate import tabulate

# --- Constants & Core Functions ---
gamma = 1.4
R = 287

def isentropic_pressure_ratio(M, gamma=1.4):
    return (1 + (gamma - 1) / 2 * M**2)**(gamma / (gamma - 1))

def isentropic_temperature_ratio(M, gamma=1.4):
    return 1 + (gamma - 1) / 2 * M**2

def normal_shock_total_pressure_ratio(M1, gamma=1.4):
    term1 = ((gamma + 1) * M1**2) / (2 + (gamma - 1) * M1**2)
    term2 = (gamma + 1) / (2 * gamma * M1**2 - (gamma - 1))
    return term1**(gamma / (gamma - 1)) * term2**(1 / (gamma - 1))

def normal_shock_mach(M1, gamma=1.4):
    num = 1 + (gamma - 1) / 2 * M1**2
    den = gamma * M1**2 - (gamma - 1) / 2
    return np.sqrt(num / den)

def mass_flow_parameter(M, gamma=1.4, R=287):
    return M * gamma / np.sqrt(gamma * R) * (1 + (gamma - 1) / 2 * M**2)**(- (gamma + 1) / (2 * (gamma - 1)))

def solve_mach_from_mass_param(param, gamma=1.4, R=287):
    from scipy.optimize import fsolve
    # Function to find the root of
    func = lambda M: mass_flow_parameter(M, gamma, R) - param
    # Use fsolve to find the Mach number, with an initial guess of 0.5
    # Add a comma to unpack the single-element array returned by fsolve into a scalar
    mach_solution, = fsolve(func, 0.5)
    return mach_solution

# --- New Isolated Inlet Analysis ---

def analyze_inlet_isolated(M0, M_design, geometry, P_inf, T_inf, eta_d):
    """
    Analyzes inlet performance assuming it's connected to an engine
    that maintains a constant exit Mach number.
    """
    A_throat = geometry['A_throat']
    A_exit = geometry['A_exit']
    results = {"Operating Mach": M0}

    # --- Calculate Freestream Conditions for the current M0 ---
    rho_inf = P_inf / (R * T_inf)
    V_inf = M0 * np.sqrt(gamma * R * T_inf)
    T0 = T_inf * isentropic_temperature_ratio(M0)
    P0_freestream = P_inf * isentropic_pressure_ratio(M0)

    # --- 1. First, analyze the DESIGN point to find the target M_exit ---
    V_design = M_design * np.sqrt(gamma * R * T_inf)
    mdot_design = (P_inf / (R * T_inf)) * V_design * A_throat
    T0_design = T_inf * isentropic_temperature_ratio(M_design)
    P0_design = P_inf * isentropic_pressure_ratio(M_design)
    pi_shock_design = normal_shock_total_pressure_ratio(M_design, gamma)
    M2_design = normal_shock_mach(M_design, gamma)
    P0_2_design = P0_design * pi_shock_design
    P2_design = P0_2_design / isentropic_pressure_ratio(M2_design, gamma)
    P0_exit_design = P2_design + eta_d * (P0_2_design - P2_design)
    param_exit_design = (mdot_design * np.sqrt(T0_design)) / (P0_exit_design * A_exit)
    M_exit_design_target = solve_mach_from_mass_param(param_exit_design)
    results["Design Exit Mach"] = M_exit_design_target

    # --- 2. Determine Operating Mode for the current M0 ---
    # First, calculate the pressure recovery for the current M0
    pi_shock = normal_shock_total_pressure_ratio(M0, gamma)
    M2 = normal_shock_mach(M0, gamma)
    P0_2 = P0_freestream * pi_shock
    P2 = P0_2 / isentropic_pressure_ratio(M2, gamma)
    P0_exit = P2 + eta_d * (P0_2 - P2)
    pi_inlet = P0_exit / P0_freestream

    if M0 < M_design:
        # --- SUBCRITICAL MODE ---
        # Assume engine maintains the design exit Mach. This sets the back pressure.
        results["Status"] = "Subcritical (Spillage)"
        # Calculate the mass flow required to achieve this exit Mach with the current P0_exit
        param_exit_actual = mass_flow_parameter(M_exit_design_target, gamma, R)
        mdot_actual = (param_exit_actual * P0_exit * A_exit) / np.sqrt(T0)
        
    elif np.isclose(M0, M_design):
        # --- CRITICAL MODE ---
        results["Status"] = "Critical (Design Point)"
        mdot_actual = mdot_design
        
    else: # M0 > M_design
        # --- SUPERCRITICAL MODE ---
        # Inlet swallows all potential flow; this is the limiting factor.
        results["Status"] = "Supercritical (Flow Surplus)"
        mdot_actual = rho_inf * V_inf * A_throat # Captures everything

    # --- 3. Calculate Final Performance Metrics ---
    A0 = mdot_actual / (rho_inf * V_inf) if V_inf > 0 else 0
    capture_ratio = A0 / A_throat if A_throat > 0 else 0
    flow_surplus = mdot_actual - mdot_design

    results.update({
        "Actual Mass Flow [kg/s]": mdot_actual,
        "Overall Pressure Recovery (pi_inlet)": pi_inlet,
        "Capture Area Ratio (A0/A_throat)": capture_ratio,
        "Mass Flow Surplus vs. Design [kg/s]": flow_surplus
    })
    return results

if __name__ == '__main__':
    # --- Define Design Point ---
    DESIGN_MACH = 1.49081
    DESIGN_GEOMETRY = {
        'A_throat': 0.9695327684,
        'A_exit': 1.0256858841  # Exit area must be defined
    }
    DESIGN_ETA_D = 0.9
    
    # --- Define Flight Conditions ---
    freestream_pressure = 18144.4
    freestream_temperature = 216.65

    # --- Run Simulation Sweep ---
    M0_range = np.linspace(1, 2.0, 51)
    all_results = []
    for M0 in M0_range:
        performance = analyze_inlet_isolated(
            M0, DESIGN_MACH, DESIGN_GEOMETRY, freestream_pressure, freestream_temperature, DESIGN_ETA_D
        )
        all_results.append(performance)

    # --- Print Results Table ---
    headers = ["M0", "Status", "pi_inlet", "Capture Ratio", "Mass Flow [kg/s]", "Surplus [kg/s]"]
    table_data = [
        [
            f"{r['Operating Mach']:.2f}",
            r['Status'],
            f"{r['Overall Pressure Recovery (pi_inlet)']:.4f}",
            f"{r['Capture Area Ratio (A0/A_throat)']:.4f}",
            f"{r['Actual Mass Flow [kg/s]']:.2f}",
            f"{r['Mass Flow Surplus vs. Design [kg/s]']:.2f}"
        ] for r in all_results
    ]
    print(tabulate(table_data, headers=headers, tablefmt="grid"))

    # --- Plot Results ---
    fig, axs = plt.subplots(3, 1, figsize=(9, 10), sharex=True)
    
    m0_vals = [r['Operating Mach'] for r in all_results]
    pi_vals = [r['Overall Pressure Recovery (pi_inlet)'] for r in all_results]
    cr_vals = [r['Capture Area Ratio (A0/A_throat)'] for r in all_results]
    surplus_vals = [r['Mass Flow Surplus vs. Design [kg/s]'] for r in all_results]

    axs[0].plot(m0_vals, pi_vals, 'b-')
    axs[0].set_ylabel('Pressure Recovery ($\Pi_D$)')
    axs[0].axvline(x=DESIGN_MACH, color='r', linestyle='--', label=f'Design $M_0$ = {DESIGN_MACH}')
    axs[0].grid(True)
    
    axs[1].plot(m0_vals, cr_vals, 'g-')
    axs[1].set_ylabel('Capture Area Ratio ($A_0$/$A_{throat}$)')
    axs[1].axvline(x=DESIGN_MACH, color='r', linestyle='--')
    axs[1].grid(True)
    axs[1].set_ylim(0.8, 1.1)

    axs[2].plot(m0_vals, surplus_vals, 'm-')
    axs[2].set_ylabel('Mass Flow Surplus [kg/s]')
    axs[2].set_xlabel('Flight Mach Number ($M_0$)')
    axs[2].axvline(x=DESIGN_MACH, color='r', linestyle='--')
    axs[2].grid(True)

    plt.tight_layout()
    plt.show()