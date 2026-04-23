import numpy as np
from scipy.optimize import fsolve

# --- Constants ---
gamma = 1.4  # Specific heat ratio for air
R = 287   # Specific gas constant for air [J/(kg*K)]

# --- Thermodynamic and Flow Functions ---

def isentropic_pressure_ratio(M, gamma=1.4):
    """Calculates ISENTROPIC total-to-static pressure ratio (P0/P)."""
    return (1 + (gamma - 1) / 2 * M**2)**(gamma / (gamma - 1))

def isentropic_temperature_ratio(M, gamma=1.4):
    """Calculates total-to-static temperature ratio (T0/T)."""
    return 1 + (gamma - 1) / 2 * M**2

def isentropic_area_ratio(M, gamma=1.4):
    """Calculates area-to-sonic-throat-area ratio (A/A*)."""
    if M == 0: return np.inf
    term1 = 2 / (gamma + 1)
    term2 = 1 + (gamma - 1) / 2 * M**2
    return (1 / M) * (term1 * term2)**((gamma + 1) / (2 * (gamma - 1)))

def normal_shock_mach(M1, gamma=1.4):
    """Calculates Mach number (M2) after a normal shock."""
    num = 1 + (gamma - 1) / 2 * M1**2
    den = gamma * M1**2 - (gamma - 1) / 2
    return np.sqrt(num / den)

def normal_shock_total_pressure_ratio(M1, gamma=1.4):
    """Calculates total pressure ratio (P02/P01) across a normal shock."""
    term1 = ((gamma + 1) * M1**2) / (2 + (gamma - 1) * M1**2)
    term2 = (gamma + 1) / (2 * gamma * M1**2 - (gamma - 1))
    return term1**(gamma / (gamma - 1)) * term2**(1 / (gamma - 1))

def mass_flow_parameter(M, gamma=1.4, R=287):
    """Calculates the mass flow parameter: (mdot * sqrt(T0)) / (P0 * A)."""
    if M == 0: return 0
    return M * np.sqrt(gamma / R) * (1 + (gamma - 1) / 2 * M**2)**(- (gamma + 1) / (2 * (gamma - 1)))

def solve_mach_from_mass_param(param, gamma=1.4, R=287, M_guess=0.5):
    """Numerically solves for Mach number given the mass flow parameter."""
    def equation(M):
        # fsolve passes an array, so we take the first element.
        m_val = M[0]
        if m_val < 0: m_val = 0 # Ensure Mach is not negative
        return mass_flow_parameter(m_val, gamma, R) - param
    
    M_solution = fsolve(equation, M_guess)
    return M_solution[0]

# --- Supercritical Operation Solver ---

def solve_supercritical_shock_pos(M0, P0_start, T0, mdot_actual, geometry, eta_d, gamma, R):
    """
    Finds the shock position and performance for supercritical operation.
    The solver finds the pre-shock Mach number (M1) that satisfies the geometry
    and mass flow constraints of the entire diffuser, starting from P0_start.
    """
    A_throat = geometry['A_throat']
    A_exit = geometry['A_exit']

    # This is the function whose root we want to find.
    def error_function(M1_shock_guess):
        M1 = M1_shock_guess[0]
        if M1 <= 1.0: return 1e6 # Invalid domain for a shock

        # 1. Conditions across the shock (P01 is now the starting pressure)
        P01 = P0_start
        M2 = normal_shock_mach(M1, gamma)
        pi_shock = normal_shock_total_pressure_ratio(M1, gamma)
        P02 = P01 * pi_shock

        # 2. Subsonic diffusion from shock to exit
        P2 = P02 / isentropic_pressure_ratio(M2, gamma)
        P0_exit = P2 + eta_d * (P02 - P2) # Total pressure at exit with losses

        # 3. Required exit Mach to pass the mass flow with the calculated P0_exit
        param_exit = (mdot_actual * np.sqrt(T0)) / (P0_exit * A_exit)
        M_exit = solve_mach_from_mass_param(param_exit, R=R, gamma=gamma)

        # 4. Consistency Check using sonic areas and pressure ratio
        A_star_supersonic = A_throat / isentropic_area_ratio(M0, gamma)
        A_shock = A_star_supersonic * isentropic_area_ratio(M1, gamma)
        A_star_subsonic_from_shock = A_shock / isentropic_area_ratio(M2, gamma)
        A_star_subsonic_from_exit = A_exit / isentropic_area_ratio(M_exit, gamma)
        
        # The error is the difference between the actual and required A* ratio,
        # adjusted for total pressure loss across the diffuser.
        return (A_star_subsonic_from_exit / A_star_subsonic_from_shock) - (P02 / P0_exit)

    # Solve for the pre-shock Mach number M1.
    try:
        M1_solution = float(fsolve(error_function, x0=M0)[0])
        if M1_solution <= 1.0: raise RuntimeError
    except (RuntimeError, TypeError):
        M1_solution = M0

    # Recalculate final values with the solved M1
    P02 = P0_start * normal_shock_total_pressure_ratio(M1_solution, gamma)
    M2 = normal_shock_mach(M1_solution, gamma)
    P2 = P02 / isentropic_pressure_ratio(M2, gamma)
    P0_exit = P2 + eta_d * (P02 - P2)
    pi_internal = P0_exit / P0_start # Pressure recovery relative to the start of the internal duct
    param_exit = (mdot_actual * np.sqrt(T0)) / (P0_exit * A_exit)
    M_exit = solve_mach_from_mass_param(param_exit, R=R, gamma=gamma)
    
    A_star_supersonic = A_throat / isentropic_area_ratio(M0, gamma)
    A_shock = A_star_supersonic * isentropic_area_ratio(M1_solution, gamma)

    return pi_internal, M_exit, P0_exit, A_shock

# --- Main Analysis Function ---

def analyze_inlet_off_design(geometry, M_design, M0, P_inf, T_inf, mdot_engine_req, eta_d):
    """
    Analyzes the off-design performance of a fixed-geometry pitot inlet.

    Args:
        geometry (dict): Inlet geometry {'A_throat': float, 'A_exit': float}.
        M_design (float): The Mach number the inlet was designed for.
        M0 (float): New freestream (flight) Mach number.
        P_inf (float): Freestream static pressure [Pa].
        T_inf (float): Freestream static temperature [K].
        mdot_engine_req (float): Mass flow rate required by the engine [kg/s].
        eta_d (float): Adiabatic efficiency of the subsonic diffuser.

    Returns:
        dict: A dictionary containing the off-design performance results.
    """
    A_throat = geometry['A_throat']
    A_exit = geometry['A_exit']

    # 1. Freestream conditions
    rho_inf = P_inf / (R * T_inf)
    V_inf = M0 * np.sqrt(gamma * R * T_inf)
    T0 = T_inf * isentropic_temperature_ratio(M0)
    P0_freestream = P_inf * isentropic_pressure_ratio(M0)

    results = {"Operating Mach": M0, "Engine Mass Flow Request [kg/s]": mdot_engine_req}

    # 2. Branch logic for Supersonic or Subsonic flight
    if M0 > 1.0:
        # --- SUPERSONIC OFF-DESIGN ---
        results["Flight Regime"] = "Supersonic"
        # Potential mass flow is the max the inlet can capture with the shock at the lip.
        mdot_potential = rho_inf * V_inf * A_throat
        results["Potential Mass Flow [kg/s]"] = mdot_potential

        # Compare requested mass flow to potential, using a tolerance for the design point.
        # np.isclose handles floating point comparisons robustly.
        if np.isclose(mdot_engine_req, mdot_potential):
            # --- CRITICAL OPERATION (Shock at Lip) ---
            # This is the design point or an equivalent off-design point.
            mdot_actual = mdot_potential
            results["Status"] = "Critical Operation (Shock at Lip)"
            results["Engine Starvation [kg/s]"] = 0.0
            # Performance is determined by a normal shock at M0 at the lip.
            pi_shock = normal_shock_total_pressure_ratio(M0, gamma)
            M2 = normal_shock_mach(M0, gamma)
            P0_2 = P0_freestream * pi_shock
            P2 = P0_2 / isentropic_pressure_ratio(M2, gamma)
            P0_exit = P2 + eta_d * (P0_2 - P2)
            pi_inlet = P0_exit / P0_freestream
            results["Shock Position Area [m^2]"] = A_throat

        elif mdot_engine_req < mdot_potential:
            # --- SUBCRITICAL OPERATION (Shock Standoff & Spillage) ---
            # Engine demand is clearly less than what the inlet can supply.
            mdot_actual = mdot_engine_req
            spillage = mdot_potential - mdot_actual
            results["Status"] = f"Subcritical (Shock Standoff, Spillage: {spillage:.2f} kg/s)"
            results["Engine Starvation [kg/s]"] = 0.0
            
            # A normal shock still occurs at M0, but the capture tube is smaller.
            pi_shock = normal_shock_total_pressure_ratio(M0, gamma)
            M2 = normal_shock_mach(M0, gamma)
            P0_2 = P0_freestream * pi_shock
            P2 = P0_2 / isentropic_pressure_ratio(M2, gamma)
            P0_exit = P2 + eta_d * (P0_2 - P2)
            pi_inlet = P0_exit / P0_freestream
            results["Shock Position Area [m^2]"] = "N/A (Standoff)"
            
        else: # mdot_engine_req > mdot_potential
            # --- SUPERCRITICAL OPERATION (Engine Starved, No Spillage) ---
            # Engine demands more than the inlet can capture.
            mdot_actual = mdot_potential
            starvation_flow = mdot_engine_req - mdot_actual
            results["Status"] = f"Supercritical (Engine Starved by {starvation_flow:.2f} kg/s)"
            results["Engine Starvation [kg/s]"] = starvation_flow
            
            # Performance is determined by a normal shock at M0 at the lip.
            pi_shock = normal_shock_total_pressure_ratio(M0, gamma)
            M2 = normal_shock_mach(M0, gamma)
            P0_2 = P0_freestream * pi_shock
            P2 = P0_2 / isentropic_pressure_ratio(M2, gamma)
            P0_exit = P2 + eta_d * (P0_2 - P2)
            pi_inlet = P0_exit / P0_freestream
            results["Shock Position Area [m^2]"] = A_throat

        # Calculate exit Mach based on the actual flow conditions
        M_exit = solve_mach_from_mass_param((mdot_actual * np.sqrt(T0)) / (P0_exit * A_exit))

        # Calculate capture ratio for the supersonic case
        if V_inf > 0:
            A0 = mdot_actual / (rho_inf * V_inf)
            capture_ratio = A0 / A_throat
        else:
            capture_ratio = np.nan

        results.update({
            "Overall Pressure Recovery (pi_inlet)": pi_inlet,
            "Actual Mass Flow Captured [kg/s]": mdot_actual,
            "Engine Face Mass Flow [kg/s]": mdot_actual,
            "Engine Face Mach (M_exit)": M_exit,
            "Engine Face Total Pressure [Pa]": P0_exit,
            "Engine Face Total Temperature [K]": T0,
            "Capture Area Ratio (A0/A_throat)": capture_ratio,
        })

    else:
        # --- SUBSONIC OFF-DESIGN ---
        results["Flight Regime"] = "Subsonic"
        A_star_max = A_throat / isentropic_area_ratio(M0)
        mdot_max_choked = mass_flow_parameter(1.0, gamma, R) * P0_freestream * A_star_max / np.sqrt(T0)
        
        mdot_actual = min(mdot_engine_req, mdot_max_choked)
        results["Actual Mass Flow Captured [kg/s]"] = mdot_actual
        
        if mdot_engine_req > mdot_max_choked * 1.001:
            results["Status"] = "Throat Choked - Inlet cannot provide requested flow."
        else:
            results["Status"] = "Normal Subsonic Operation"

        # Performance of the diffuser (entire inlet is a diffuser)
        P0_in = P0_freestream
        P_in = P_inf
        # Based on eta_d = (h0_in - h_exit_isen) / (h0_in - h_exit_real) which simplifies to pressure for adiabatic flow
        P0_exit = P_in + eta_d * (P0_in - P_in)
        pi_inlet = P0_exit / P0_freestream

        # Find exit Mach
        param_exit = (mdot_actual * np.sqrt(T0)) / (P0_exit * A_exit)
        M_exit = solve_mach_from_mass_param(param_exit)

        # Calculate capture ratio for the subsonic case
        if V_inf > 0:
            A0 = mdot_actual / (rho_inf * V_inf)
            capture_ratio = A0 / A_throat
        else:
            capture_ratio = np.nan

        results.update({
            "Overall Pressure Recovery (pi_inlet)": pi_inlet,
            "Engine Face Mass Flow [kg/s]": mdot_actual,
            "Engine Face Mach (M_exit)": M_exit,
            "Engine Face Total Pressure [Pa]": P0_exit,
            "Engine Face Total Temperature [K]": T0,
            "Capture Area Ratio (A0/A_throat)": capture_ratio,
        })

    return results


if __name__ == '__main__':
    # --- Define the Fixed Inlet Geometry ---
    # These values should come from your 'inlet.py' design point script.
    DESIGN_MACH = 1.49081
    DESIGN_GEOMETRY = {
        'A_throat': 0.9695327684,  # Capture area = Throat area for pitot inlet [m^2]
        'A_exit':  1.0256858841,   # Exit area [m^2]
    }
    # The diffuser efficiency used in the design
    DESIGN_ETA_D = 0.9

    # --- Define Off-Design Conditions to Analyze ---
    # Use the same altitude conditions as the design point
    freestream_pressure = 18144.4  # Pa
    freestream_temperature = 216.65 # K

    # --- Revised Test Cases to Demonstrate Correct Physics ---
    # Note: mdot_potential at M0=1.5 is ~125 kg/s. At M0=2.0 is ~168 kg/s.
    test_cases = [
        {"name": "Design Point (Critical)", "M0": 1.49, "mdot_req": 124.4431866},
        
        # Subcritical: Engine requests LESS than inlet can provide. Expect Spillage, Capture Ratio < 1.
        {"name": "Subcritical (Spillage)", "M0": 1.5, "mdot_req": 100.0}, 
        
        # Supercritical: Engine requests MORE than inlet can provide. Expect Starvation, Capture Ratio = 1.
        {"name": "Supercritical (Engine Starved)", "M0": 1.2, "mdot_req": 124.4431866}, 
        
        {"name": "High Mach Supercritical", "M0": 2.0, "mdot_req": 180.0}, # mdot_req > mdot_potential -> Starved
        {"name": "Subsonic Flight", "M0": 0.8, "mdot_req": 80.0},
        {"name": "Subsonic, High Demand (Choked)", "M0": 0.8, "mdot_req": 150.0},
    ]

    for case in test_cases:
        print(f"\n--- Analyzing: {case['name']} ---")
        performance = analyze_inlet_off_design(
            geometry=DESIGN_GEOMETRY,
            M_design=DESIGN_MACH,
            M0=case['M0'],
            P_inf=freestream_pressure,
            T_inf=freestream_temperature,
            mdot_engine_req=case['mdot_req'],
            eta_d=DESIGN_ETA_D
        )
        for key, value in performance.items():
            if isinstance(value, float):
                print(f"{key:<40}: {value:.6f}")
            else:
                print(f"{key:<40}: {value}")


# --- NEW ANALYSIS FUNCTION BASED ON EXIT MACH NUMBER ---

def analyze_inlet_with_exit_mach(geometry, M0, P_inf, T_inf, M_exit_req, eta_d):
    """
    Analyzes inlet performance given a required engine face Mach number instead of mass flow.

    Args:
        geometry (dict): Inlet geometry {'A_throat': float, 'A_exit': float}.
        M0 (float): Freestream (flight) Mach number.
        P_inf (float): Freestream static pressure [Pa].
        T_inf (float): Freestream static temperature [K].
        M_exit_req (float): Mach number required at the engine face.
        eta_d (float): Adiabatic efficiency of the subsonic diffuser.

    Returns:
        dict: A dictionary containing the off-design performance results.
    """
    A_throat = geometry['A_throat']
    A_exit = geometry['A_exit']

    # 1. Freestream conditions
    rho_inf = P_inf / (R * T_inf)
    V_inf = M0 * np.sqrt(gamma * R * T_inf)
    T0 = T_inf * isentropic_temperature_ratio(M0)
    P0_freestream = P_inf * isentropic_pressure_ratio(M0)

    results = {"Operating Mach": M0, "Engine Face Mach Request": M_exit_req}

    if M0 > 1.0:
        # --- SUPERSONIC ANALYSIS ---
        results["Flight Regime"] = "Supersonic"
        
        # First, calculate the performance assuming CRITICAL operation (shock at lip, no spillage).
        # This gives us the maximum possible mass flow and a corresponding "critical" exit Mach.
        mdot_potential = rho_inf * V_inf * A_throat
        pi_shock_critical = normal_shock_total_pressure_ratio(M0, gamma)
        M2_critical = normal_shock_mach(M0, gamma)
        P0_2_critical = P0_freestream * pi_shock_critical
        P2_critical = P0_2_critical / isentropic_pressure_ratio(M2_critical, gamma)
        P0_exit_critical = P2_critical + eta_d * (P0_2_critical - P2_critical)
        
        # This is the highest possible exit Mach the inlet can produce at this M0.
        param_exit_critical = (mdot_potential * np.sqrt(T0)) / (P0_exit_critical * A_exit)
        M_exit_critical = solve_mach_from_mass_param(param_exit_critical)
        
        # Now, compare the requested exit Mach to this critical value.
        if M_exit_req < M_exit_critical:
            # --- SUBCRITICAL OPERATION (Spillage) ---
            # The engine wants a lower exit Mach (higher back pressure) than the critical case.
            # This pushes the shock out, causing spillage.
            results["Status"] = "Subcritical (Spillage)"
            pi_inlet = P0_exit_critical / P0_freestream # Pressure recovery is still set by the shock at M0
            P0_exit = P0_exit_critical
            
            # We can now calculate the actual mass flow that produces M_exit_req with this P0_exit.
            param_exit_actual = mass_flow_parameter(M_exit_req, gamma, R)
            mdot_actual = (param_exit_actual * P0_exit * A_exit) / np.sqrt(T0)
            
        else:
            # --- CRITICAL / SUPERCRITICAL OPERATION (No Spillage) ---
            # The engine is pulling hard enough to keep the shock at the lip.
            # The inlet delivers its maximum potential mass flow.
            results["Status"] = "Critical / Supercritical (No Spillage)"
            mdot_actual = mdot_potential
            pi_inlet = P0_exit_critical / P0_freestream
            # The actual exit Mach will be the critical one, as the inlet cannot deliver more.
            results["Engine Face Mach Request"] = f"{M_exit_req} (Cannot be met, limited to {M_exit_critical:.4f})"

        # Update results dictionary for all supersonic cases
        results["Actual Mass Flow Captured [kg/s]"] = mdot_actual
        results["Overall Pressure Recovery (pi_inlet)"] = pi_inlet
        if V_inf > 0:
            A0 = mdot_actual / (rho_inf * V_inf)
            results["Capture Area Ratio (A0/A_throat)"] = A0 / A_throat
        else:
            results["Capture Area Ratio (A0/A_throat)"] = np.nan

    else:
        # Subsonic logic remains largely the same, as it's not driven by shock position.
        results["Flight Regime"] = "Subsonic"
        results["Status"] = "Normal Subsonic Operation"
        # In subsonic flow, pi_inlet is assumed constant for a simple pitot inlet.
        pi_inlet = 1.0 
        P0_exit = P0_freestream * pi_inlet
        param_exit = mass_flow_parameter(M_exit_req, gamma, R)
        mdot_actual = (param_exit * P0_exit * A_exit) / np.sqrt(T0)
        results["Actual Mass Flow Captured [kg/s]"] = mdot_actual
        results["Overall Pressure Recovery (pi_inlet)"] = pi_inlet
        results["Capture Area Ratio (A0/A_throat)"] = 1.0 # No spillage for subsonic pitot

    return results


if __name__ == '__main__':
    # This block now demonstrates the NEW function.
    # --- Define the Fixed Inlet Geometry ---
    DESIGN_GEOMETRY = {
        'A_throat': 0.9695327684,
        'A_exit':  1.0256858841,
    }
    DESIGN_ETA_D = 0.9

    # --- Define Off-Design Conditions to Analyze ---
    freestream_pressure = 18144.4
    freestream_temperature = 216.65

    # --- Test cases showing effect of changing engine back pressure (M_exit_req) ---
    # We will keep flight Mach constant at M0 = 1.5
    flight_mach = 1.5
    
    # At M0=1.5, the critical exit Mach is ~0.5.
    test_cases_exit_mach = [
        {"name": "High Back Pressure (Spillage)", "M_exit_req": 0.3},
        {"name": "Medium Back Pressure (Spillage)", "M_exit_req": 0.4},
        {"name": "Near Critical Point", "M_exit_req": 0.5},
        {"name": "Low Back Pressure (No Spillage)", "M_exit_req": 0.6},
    ]

    print("\n\n--- Analysis Based on Engine Face Mach Number (M0 = 1.5) ---")
    for case in test_cases_exit_mach:
        print(f"\n--- Analyzing: {case['name']} ---")
        performance = analyze_inlet_with_exit_mach(
            geometry=DESIGN_GEOMETRY,
            M0=flight_mach,
            P_inf=freestream_pressure,
            T_inf=freestream_temperature,
            M_exit_req=case['M_exit_req'],
            eta_d=DESIGN_ETA_D
        )
        for key, value in performance.items():
            if isinstance(value, float):
                print(f"{key:<40}: {value:.6f}")
            else:
                print(f"{key:<40}: {value}")