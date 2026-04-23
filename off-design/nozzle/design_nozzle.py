import numpy as np

# --- Gas Dynamics Helper Functions ---

def isentropic_pressure_ratio(M, gamma=1.33):
    """Calculates total-to-static pressure ratio (P0/P) for a given Mach number."""
    return (1 + (gamma - 1) / 2 * M**2)**(gamma / (gamma - 1))

def isentropic_temperature_ratio(M, gamma=1.33):
    """Calculates total-to-static temperature ratio (T0/T) for a given Mach number."""
    return 1 + (gamma - 1) / 2 * M**2

def mass_flow_parameter_choked(gamma=1.33, R=287):
    """Calculates the mass flow parameter for choked flow (M=1)."""
    return np.sqrt(gamma / R) * ((gamma + 1) / 2)**(- (gamma + 1) / (2 * (gamma - 1)))

# --- Main Nozzle Design Function ---

def design_adapted_nozzle(P0_inlet, T0_inlet, P_ambient, thrust_req, eta_nozzle, gamma=1.33, R=287):
    """
    Designs a perfectly expanded (adapted) convergent-divergent nozzle.

    Args:
        P0_inlet (float): Inlet total pressure [Pa].
        T0_inlet (float): Inlet total temperature [K].
        P_ambient (float): Ambient pressure at the exit [Pa].
        thrust_req (float): Required thrust [N].
        eta_nozzle (float): Adiabatic efficiency of the nozzle (0 to 1).
        gamma (float): Specific heat ratio.
        R (float): Specific gas constant [J/(kg*K)].

    Returns:
        dict: A dictionary containing the nozzle design parameters.
    """
    # For an adapted nozzle, exit pressure equals ambient pressure
    P_exit = P_ambient

    # 1. Calculate IDEAL exit conditions (isentropic expansion)
    pressure_ratio_ideal = P0_inlet / P_exit
    if pressure_ratio_ideal < isentropic_pressure_ratio(1.0, gamma):
        raise ValueError("Pressure ratio is too low for supersonic flow. Nozzle will be convergent only.")
        
    M_exit_ideal_sq = ((pressure_ratio_ideal**((gamma - 1) / gamma)) - 1) * (2 / (gamma - 1))
    M_exit_ideal = np.sqrt(M_exit_ideal_sq)
    
    T_exit_ideal = T0_inlet / isentropic_temperature_ratio(M_exit_ideal, gamma)

    # 2. Calculate ACTUAL exit conditions using nozzle efficiency
    # eta = (h0 - h_exit_actual) / (h0 - h_exit_ideal) => (T0 - T_exit_actual) / (T0 - T_exit_ideal)
    T_exit_actual = T0_inlet - eta_nozzle * (T0_inlet - T_exit_ideal)
    
    # Find actual exit Mach number from the actual exit temperature
    M_exit_actual_sq = ((T0_inlet / T_exit_actual) - 1) * (2 / (gamma - 1))
    M_exit_actual = np.sqrt(M_exit_actual_sq)

    # 3. Calculate required mass flow from thrust
    # For an adapted nozzle, Thrust = mdot * V_exit
    V_exit_actual = M_exit_actual * np.sqrt(gamma * R * T_exit_actual)
    mdot = thrust_req / V_exit_actual

    # 4. Calculate Throat Area (A_throat)
    # Flow is choked (M=1) at the throat. Conditions are based on INLET P0, T0.
    mdot_param_choked = mass_flow_parameter_choked(gamma, R)
    A_throat = (mdot * np.sqrt(T0_inlet)) / (P0_inlet * mdot_param_choked)

    # 5. Calculate Exit Area (A_exit)
    # Based on actual conditions at the exit plane
    rho_exit_actual = P_exit / (R * T_exit_actual)
    A_exit = mdot / (rho_exit_actual * V_exit_actual)

    # 6. Calculate post-expansion total pressure for reference
    P0_exit_actual = P_exit * isentropic_pressure_ratio(M_exit_actual, gamma)
    pi_nozzle = P0_exit_actual / P0_inlet

    results = {
        "--- Design Inputs ---": "",
        "Required Thrust [N]": thrust_req,
        "Inlet Total Pressure [Pa]": P0_inlet,
        "Inlet Total Temperature [K]": T0_inlet,
        "Ambient Pressure [Pa]": P_ambient,
        "Nozzle Efficiency": eta_nozzle,
        "--- Geometry ---": "",
        "Throat Area [m^2]": A_throat,
        "Exit Area [m^2]": A_exit,
        "Area Ratio (A_exit/A_throat)": A_exit / A_throat,
        "--- Performance ---": "",
        "Mass Flow Rate [kg/s]": mdot,
        "Exit Mach Number": M_exit_actual,
        "Exit Velocity [m/s]": V_exit_actual,
        "Exit Static Temperature [K]": T_exit_actual,
        "Exit Total Pressure [Pa]": P0_exit_actual,
        "Nozzle Total Pressure Ratio": pi_nozzle,
        "Nozzle Pressure Ratio": P0_inlet / P_exit,
    }
    return results

if __name__ == '__main__':
    # --- Example Design Case ---
    # Inputs for a typical jet engine nozzle at altitude
    P0_in = 372858      # Inlet total pressure [Pa] (e.g., after turbine)
    T0_in = 1308.5        # Inlet total temperature [K]
    P_amb = 18144.4    # Ambient pressure [Pa] (e.g., at 12.3 km altitude)
    Thrust = 116523.     # Required thrust [N]
    eta_n = 0.97       # Adiabatic efficiency

    print("--- Designing Adapted CD Nozzle ---")
    
    try:
        design_results = design_adapted_nozzle(
            P0_inlet=P0_in,
            T0_inlet=T0_in,
            P_ambient=P_amb,
            thrust_req=Thrust,
            eta_nozzle=eta_n
        )
        
        for key, value in design_results.items():
            if isinstance(value, float):
                print(f"{key:<30}: {value:.5f}")
            else:
                print(f"{key:<30}: {value}")

    except ValueError as e:
        print(f"Error: {e}")
