import numpy as np
from scipy.optimize import fsolve

# --- Gas Dynamics Helper Functions ---

def isentropic_pressure_ratio(M, gamma=1.4):
    """Calculates total-to-static pressure ratio (P0/P) for a given Mach number."""
    return (1 + (gamma - 1) / 2 * M**2)**(gamma / (gamma - 1))

def isentropic_temperature_ratio(M, gamma=1.4):
    """Calculates total-to-static temperature ratio (T0/T) for a given Mach number."""
    return 1 + (gamma - 1) / 2 * M**2

def isentropic_area_ratio(M, gamma=1.4):
    """Calculates area-to-sonic-throat-area ratio (A/A*) for a given Mach number."""
    if M == 0: return np.inf
    term1 = 2 / (gamma + 1)
    term2 = 1 + (gamma - 1) / 2 * M**2
    return (1 / M) * (term1 * term2)**((gamma + 1) / (2 * (gamma - 1)))

def normal_shock_total_pressure_ratio(M1, gamma=1.4):
    """Calculates total pressure ratio (P02/P01) across a normal shock."""
    term1 = ((gamma + 1) / 2 * M1**2) / (1 + (gamma - 1) / 2 * M1**2)
    term2 = 1 / ((2 * gamma / (gamma + 1)) * M1**2 - (gamma - 1) / (gamma + 1))
    return term1**(gamma / (gamma - 1)) * term2**(1 / (gamma - 1))

def solve_mach_from_area_ratio(AR, gamma=1.4):
    """Numerically solves for Mach number given the area ratio A/A*."""
    def equation(M):
        return isentropic_area_ratio(M, gamma) - AR
    
    # Find subsonic solution
    M_sub = fsolve(equation, 0.2)
    # Find supersonic solution
    M_sup = fsolve(equation, 2.0)
    return M_sub, M_sup

# --- Main Nozzle Analysis Function ---

def analyze_cd_nozzle(P0, T0, A_throat, A_exit, P_back, gamma=1.4, R=287.0):
    """
    Computes the performance of a convergent-divergent nozzle.

    Args:
        P0 (float): Inlet total pressure [Pa].
        T0 (float): Inlet total temperature [K].
        A_throat (float): Throat area [m^2].
        A_exit (float): Exit area [m^2].
        P_back (float): Ambient back pressure [Pa].
        gamma (float): Specific heat ratio.
        R (float): Specific gas constant [J/(kg*K)].

    Returns:
        dict: A dictionary containing the nozzle performance parameters.
    """
    AR_exit = A_exit / A_throat
    
    # Find the design Mach number (supersonic, isentropic expansion to A_exit)
    _, M_design_tuple = solve_mach_from_area_ratio(AR_exit, gamma)
    M_design = float(M_design_tuple[0])
    P_design = P0 / isentropic_pressure_ratio(M_design, gamma)

    # Find the critical pressure for subsonic flow (flow is subsonic everywhere)
    M_sub_exit, _ = solve_mach_from_area_ratio(AR_exit, gamma)
    P_crit_subsonic = P0 / isentropic_pressure_ratio(M_sub_exit, gamma)

    # --- Determine Operating Condition ---
    
    if P_back >= P_crit_subsonic:
        # --- Case 1: Unchoked, Subsonic Flow ---
        status = "Unchoked (Subsonic Flow)"
        P_exit = P_back
        M_exit = np.sqrt((2 / (gamma - 1)) * ((P0 / P_exit)**((gamma - 1) / gamma) - 1))
        T_exit = T0 / isentropic_temperature_ratio(M_exit, gamma)
        V_exit = M_exit * np.sqrt(gamma * R * T_exit)
        rho_exit = P_exit / (R * T_exit)
        mdot = rho_exit * A_exit * V_exit
        
    else:
        # --- Cases 2-5: Choked Flow ---
        # Mass flow is choked and constant
        mdot_param_choked = np.sqrt(gamma / R) * (1 + (gamma - 1) / 2)**(- (gamma + 1) / (2 * (gamma - 1)))
        mdot = mdot_param_choked * P0 * A_throat / np.sqrt(T0)

        if P_back < P_design:
            # --- Case 2: Under-expanded (Supersonic Exit) ---
            status = "Under-expanded (Supersonic Exit)"
            M_exit = M_design
            P_exit = P_design
        
        elif P_back == P_design:
            # --- Case 3: Perfectly Expanded (Design Condition) ---
            status = "Perfectly Expanded (Design Condition)"
            M_exit = M_design
            P_exit = P_design

        else: # P_design < P_back < P_crit_subsonic
            # --- Case 4 or 5: Shock in Nozzle or Over-expanded ---
            # Find the exit Mach assuming a normal shock occurred upstream
            def shock_pressure_match(M1_shock):
                pi_shock = normal_shock_total_pressure_ratio(M1_shock, gamma)
                P02 = P0 * pi_shock
                AR_shock_to_exit = AR_exit / isentropic_area_ratio(M1_shock, gamma)
                M_exit_sub, _ = solve_mach_from_area_ratio(AR_shock_to_exit, gamma)
                P_exit_calc = P02 / isentropic_pressure_ratio(M_exit_sub, gamma)
                return P_exit_calc - P_back
            
            # If a shock at the exit plane results in P_exit > P_back, it's over-expanded
            P_exit_shock_at_exit = P0 / isentropic_pressure_ratio(M_design, gamma) * (1 + (2*gamma/(gamma+1))*(M_design**2 - 1))
            
            if P_back > P_exit_shock_at_exit:
                status = "Shock in Nozzle (Subsonic Exit)"
                # Find the pre-shock Mach that results in P_exit = P_back
                M1_shock = fsolve(shock_pressure_match, 1.5)[0]
                pi_shock = normal_shock_total_pressure_ratio(M1_shock, gamma)
                P02 = P0 * pi_shock
                AR_shock_to_exit = AR_exit / isentropic_area_ratio(M1_shock, gamma)
                M_exit, _ = solve_mach_from_area_ratio(AR_shock_to_exit, gamma)
                P_exit = P_back
            else:
                status = "Over-expanded (Supersonic Exit, Oblique Shocks)"
                M_exit = M_design
                P_exit = P_design

        T_exit = T0 / isentropic_temperature_ratio(M_exit, gamma)
        V_exit = M_exit * np.sqrt(gamma * R * T_exit)

    # --- Calculate Thrust ---
    thrust = mdot * V_exit + (P_exit - P_back) * A_exit

    return {
        "Status": status,
        "Mass Flow Rate [kg/s]": mdot,
        "Exit Mach": M_exit,
        "Exit Pressure [Pa]": P_exit,
        "Exit Temperature [K]": T_exit,
        "Thrust [N]": thrust,
    }

if __name__ == '__main__':
    # --- Nozzle Definition ---
    inlet_P0 = 372858  # 30 bar
    inlet_T0 = 1308.50000 # 1500 K
    throat_area = 0.22875 # m^2
    exit_area = 0.75992  # m^2

    print(f"--- Analyzing CD Nozzle ---")
    print(f"Inlet P0: {inlet_P0/1e5:.1f} bar, T0: {inlet_T0} K")
    print(f"Throat Area: {throat_area} m^2, Exit Area: {exit_area} m^2")
    print("-" * 30)

    p_des = 18144.4  # Design pressure at exit (e.g., ambient pressure at altitude)

    # --- Test Cases for Different Back Pressures ---
    back_pressures = {
        "Subsonic": 20.4*p_des, # Subsonic flow with back pressure higher than critical
        "Shock in Nozzle": 15*p_des, # Pressure at which shock occurs in nozzle
        "Over-expanded": 1.05*p_des,
        "Perfectly Expanded": p_des, # Calculated design pressure
        "Under-expanded": 0.8*18144.4,
    }

    for name, p_back in back_pressures.items():
        print(f"\nAnalyzing Case: {name} (P_back = {p_back/1e5:.2f} bar)")
        results = analyze_cd_nozzle(inlet_P0, inlet_T0, throat_area, exit_area, p_back)
        for key, value in results.items():
            if isinstance(value, float):
                print(f"{key:<25}: {value:.4f}")
            else:
                print(f"{key:<25}: {value}")


