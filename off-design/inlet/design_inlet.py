import numpy as np

# --- Constants ---
gamma = 1.4  # Specific heat ratio for air
R = 287   # Specific gas constant for air [J/(kg*K)]

# --- Isentropic Flow Relations ---

def mass_flow_parameter(M, gamma=1.4, R=287):
    """Calculates the mass flow parameter: (mdot * sqrt(T0)) / (P0 * A)."""
    if M == 0: return 0
    return M * np.sqrt(gamma) * (1 + (gamma - 1) / 2 * M**2)**(- (gamma + 1) / (2 * (gamma - 1)))

def isentropic_pressure_ratio(M, gamma=1.4):
    """Calculates total-to-static pressure ratio (P0/P) for a given Mach number."""
    return (1 + (gamma - 1) / 2 * M**2)**(gamma / (gamma - 1))

def isentropic_temperature_ratio(M, gamma=1.4):
    """Calculates total-to-static temperature ratio (T0/T) for a given Mach number."""
    return 1 + (gamma - 1) / 2 * M**2

def isentropic_area_ratio(M, gamma=1.4):
    """Calculates area-to-sonic-throat-area ratio (A/A*) for a given Mach number."""
    term1 = 2 / (gamma + 1)
    term2 = 1 + (gamma - 1) / 2 * M**2
    return (1 / M) * (term1 * term2)**((gamma + 1) / (2 * (gamma - 1)))

# --- Normal Shock Relations ---

def normal_shock_mach(M1, gamma=1.4):
    """Calculates Mach number (M2) after a normal shock."""
    num = 1 + (gamma - 1) / 2 * M1**2
    den = gamma * M1**2 - (gamma - 1) / 2
    return np.sqrt(num / den)

def normal_shock_total_pressure_ratio(M1, gamma=1.4):
    """Calculates total pressure ratio (P02/P01) across a normal shock."""
    term1 = ((gamma + 1) / 2 * M1**2) / (1 + (gamma - 1) / 2 * M1**2)
    term2 = 1 / ((2 * gamma / (gamma + 1)) * M1**2 - (gamma - 1) / (gamma + 1))
    return term1**(gamma / (gamma - 1)) * term2**(1 / (gamma - 1))

# --- Main Design Function ---

def design_pitot_inlet(M0, P_inf, T_inf, mdot, M_exit, eta_d, gamma=1.4, R=287):
    """
    Performs a simplified aerodynamic design of a supersonic pitot inlet.
    This design assumes a normal shock occurs at the inlet throat.

    Args:
        M0 (float): Freestream (flight) Mach number.
        P_inf (float): Freestream static pressure [Pa].
        T_inf (float): Freestream static temperature [K].
        mdot (float): Desired mass flow rate [kg/s].
        M_exit (float): Desired Mach number at the engine face (subsonic).
        gamma (float): Specific heat ratio.
        R (float): Specific gas constant [J/(kg*K)].

    Returns:
        dict: A dictionary containing the design parameters.
    """
    if M0 <= 1.0:
        raise ValueError("Freestream Mach number M0 must be supersonic (> 1.0)")

    print(f"--- Designing Pitot Inlet for M0 = {M0} ---")

    # 1. Freestream conditions (station 0)
    rho_inf = P_inf / (R * T_inf)
    V_inf = M0 * np.sqrt(gamma * R * T_inf)
    T0_total = T_inf * isentropic_temperature_ratio(M0, gamma)
    P0_total_freestream = P_inf * isentropic_pressure_ratio(M0, gamma)

    # 2. Normal shock at the throat (station 1 -> station 2)
    # For a pitot inlet, the Mach number just before the shock (M1) is the freestream Mach M0.
    M1 = M0
    M2 = normal_shock_mach(M1, gamma)
    pi_shock = total_pressure_recovery = normal_shock_total_pressure_ratio(M1, gamma)
    P0_2 = P0_total_freestream * pi_shock

    print(f"Normal shock at M1 = {M1:.3f}")
    print(f"Mach number after shock, M2 = {M2:.3f}")
    print(f"Total pressure recovery across shock (pi_shock) = {pi_shock:.4f}")

    # 3. Calculate required areas
    # Capture area is sized based on freestream conditions and required mass flow.
    A_capture = mdot / (rho_inf * V_inf)
    # For a simple pitot inlet, the throat area is the same as the capture area.
    A_throat = A_capture
    # Exit area is calculated using the mass flow equation, which is consistent
    # with the non-isentropic pressure calculation.
    mfp_exit = mass_flow_parameter(M_exit, gamma, R)
    print('mfp_exit : ', mfp_exit)

    # 4. Subsonic diffuser performance with adiabatic efficiency (station 2 -> station exit)
    # Calculate the actual total pressure at the exit considering diffuser efficiency.
    # The efficiency relates the actual pressure rise to the ideal pressure rise.
    # P0_exit = P2 + eta_d * (P0_2 - P2)
    P2 = P0_2 / isentropic_pressure_ratio(M2, gamma)
    P0_total_exit = P2 + eta_d * (P0_2 - P2)
    pi_diffuser = P0_total_exit / P0_2

    # Now calculate exit area after P0_total_exit is defined
    A_exit = (mdot * np.sqrt(R*T0_total)) / (P0_total_exit * mfp_exit)
    


    # Overall total pressure recovery is the product of shock and diffuser recoveries
    total_pressure_recovery = pi_shock * pi_diffuser

    print(f"Subsonic diffuser efficiency eta_d = {eta_d:.3f}")
    print(f"Subsonic diffuser pressure recovery (pi_d) = {pi_diffuser:.4f}")
    print(f"Overall total pressure recovery (pi_inlet) = {total_pressure_recovery:.4f}")

    # 5. Conditions at the engine face (exit)
    P_exit = P0_total_exit / isentropic_pressure_ratio(M_exit, gamma)
    T_exit = T0_total / isentropic_temperature_ratio(M_exit, gamma) # Total temp is constant

    results = {
        "Flight Mach": M0,
        "Freestream Static Pressure [Pa]": P_inf,
        "Freestream Static Temperature [K]": T_inf,
        "Mass Flow [kg/s]": mdot,
        "Engine Face Mach": M_exit,
        "Diffuser Adiabatic Efficiency": eta_d,
        "--- Geometry ---": "",
        "Capture Area [m^2]": A_capture,
        "Throat Area [m^2]": A_throat,
        "Exit Area [m^2]": A_exit,
        "Diffuser Area Ratio (A_exit/A_throat)": A_exit / A_throat,
        "--- Performance ---": "",
        "Shock Pressure Recovery (pi_shock)": pi_shock,
        "Diffuser Pressure Recovery (pi_d)": pi_diffuser,
        "Overall Total Pressure Recovery (pi_inlet)": total_pressure_recovery,
        "--- Engine Face Conditions ---": "",
        "Total Pressure [Pa]": P0_total_exit,
        "Static Pressure [Pa]": P_exit,
        "Total Temperature [K]": T0_total,
        "Static Temperature [K]": T_exit,
    }

    return results

if __name__ == '__main__':
    # --- Input Parameters ---
    # Example for a supersonic aircraft at high altitude
    flight_mach = 1.49081  # Freestream Mach number
    # Standard atmosphere conditions at 12.3727 kmkm (approx. 36,000 ft)
    freestream_pressure = 18144.4  # Pa
    freestream_temperature = 216.65 # K
    mass_flow = 124.44318661191535 # kg/s 
    M_exit = 0.665303 # Desired Mach number at the engine face (subsonic)
    eta_d = 0.9  # Efficiency of the diffuser (assumed)
    # --- Run Design ---
    try:
        design_results = design_pitot_inlet(
            M0=flight_mach,
            P_inf=freestream_pressure,
            T_inf=freestream_temperature,
            mdot=mass_flow,
            M_exit=M_exit,
            eta_d=eta_d,
        )

        # --- Print Results ---
        print("\n--- Supersonic Inlet Design Results ---")
        for key, value in design_results.items():
            if isinstance(value, str):
                print(f"\n{key}")
            else:
                print(f"{key:<40}: {value:.10f}")

    except ValueError as e:
        print(f"Error: {e}")