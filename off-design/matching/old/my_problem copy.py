from solver_framework import EquationSystem
import numpy as np
# Import the map functions from your new file
from component_maps import get_lpc_map_data,get_hpc_map_data, get_freestream_mass_flow_param, get_nozzle_mdot_red, get_inlet_map_data


def _calculate_turbine_mdot_red(Pi_T, eta_T, gamma):
    """
    Calculates turbine reduced mass flow based on the analytical relations.
    """
    Pi_cr = ((gamma + 1) / 2)**(gamma / (gamma - 1))

    if Pi_T <= Pi_cr:
        # Unchoked flow
        pi_term = (1 / Pi_T)**((gamma - 1) / gamma)
        numerator = eta_T * (1 - pi_term)
        denominator = 1 - numerator
        
        if denominator <= 1e-9: return np.nan # Avoid division by zero
        
        term_inside_sqrt = numerator / denominator
        mdot_red = (1 / Pi_T) * np.sqrt((2 * gamma) / (gamma - 1)) * np.sqrt(term_inside_sqrt)
    else:
        # Choked flow
        pi_term_cr = (1 / Pi_cr)**((gamma - 1) / gamma)
        numerator_cr = eta_T * (1 - pi_term_cr)
        denominator_cr = 1 - numerator_cr

        if denominator_cr <= 1e-9: return np.nan

        term_inside_sqrt_cr = numerator_cr / denominator_cr
        mdot_red = (1 / Pi_cr) * np.sqrt((2 * gamma) / (gamma - 1)) * np.sqrt(term_inside_sqrt_cr)
        
    return mdot_red





class TurboFan(EquationSystem):
    """
    Defines the equations.
    
    This system solves on a given Mach number (M).
    """
    def get_equations(self, var_values):
        """
        Overrides the base method to define the specific equations for this problem.
        
        Variables: P_ratio (P/P0), T_ratio (T/T0), A_ratio (A/A*)
        Parameters: M (Mach number), gamma (specific heat ratio)
        """
        # Unpack the variables for readability
        Pi_LPC, Pi_HPC, N_red_HPC, N_red_LPC, Pi_HPT, Pi_LPT, N_red_HPT, N_red_LPT, T04T021 = var_values


                # Unpack the parameters
        M = self.params['M0']
        gamma_air = self.params['gamma_air']
        A1, A2, A21, A4, A41, A5, A7, A8, A9 = self.params['A1'], self.params['A2'], self.params['A21'], self.params['A4'], self.params['A41'], self.params['A5'], self.params['A7'], self.params['A8'], self.params['A9']
        eps1, eps2 = self.params['eps1'], self.params['eps2']
        BPR = self.params['BPR']
        # NOTE: eta_LPT and eta_HPT are still from params, but could also come from maps
        eta_LPT, eta_HPT = self.params['eta_LPT'], self.params['eta_HPT']
        gamma_gas = self.params['gamma_gas']
        Pi_CC = self.params['Pi_CC']
        D_HPC, D_HPT = self.params['D_HPC'], self.params['D_HPT']
        R_air, R_gas = self.params['R_air'], self.params['R_gas']
        eta_m = self.params['eta_m']
        D_LPC, D_LPT = self.params['D_LPC'], self.params['D_LPT']
        P_a = self.params['P_a']  # Ambient pressure

        T0_a = self.params['T0_a']


         # --- Call Component Maps ---
        # Get performance data from the maps based on the current variable state
        lpc_map = get_lpc_map_data(Pi_LPC, N_red_LPC)
        hpc_map = get_hpc_map_data(Pi_HPC, N_red_HPC)

         # --- Analytical Turbine Calculation ---
        # Calculate turbine reduced mass flows using the analytical model
        mdot_red_HPT = _calculate_turbine_mdot_red(Pi_HPT, eta_HPT, gamma_gas)
        mdot_red_LPT = _calculate_turbine_mdot_red(Pi_LPT, eta_LPT, gamma_gas)

         # Get inlet performance from its map based on flight condition M0
        inlet_data = get_inlet_map_data(self.params['M0'])
        epsD = inlet_data['pi_inlet']  # This is your pi_inlet
        capture_ratio = inlet_data['capture_ratio']
        A_throat = inlet_data['A_throat']
        A0 = capture_ratio * A_throat  # Calculate A0 directly, don't solve for it

        # Get the freestream reduced mass flow parameter (mdot_red_D)
        mdot_red_D = get_freestream_mass_flow_param(self.params['M0'])

        # Extract interpolated values from the maps
        mdot_red_LPC = lpc_map['mdot_red']
        eta_LPC = lpc_map['eta']
        mdot_red_HPC = hpc_map['mdot_red']
        eta_HPC = hpc_map['eta']

        
        
        # --- Intermediate Calculations ---
        # Inlet
        P0_2 = self.params['P0_a'] * epsD # Use pi_inlet (epsD) from the map
        T0_2 = self.params['T0_a'] # Total temperature is constant through the inlet
        

        
        


        # intermediate parameters
        k1 = (1 + eps1 + eps2)/(1 + eps1 + eps2 + BPR)
        k2 = 1/(1 + eps1 + eps2)
        k3 = (1 +eps1)/1
        k4 = (1+ eps1 + eps2)/(1 +eps1)
        k5 = (1 + eps1 + eps2 +BPR)/(1 + eps1)
        k6 = (1 + eps1 + eps2)
        k7 = (1 + eps1) /(1+ BPR + eps1 +eps2)
        delta_air = (gamma_air-1)/2
        delta_gas = (gamma_gas-1)/2
        cp_air = R_air * gamma_air / (gamma_air - 1) 
        cp_gas = R_gas * gamma_gas / (gamma_gas - 1) 
        
        # Define the equations in the form: f(vars, params) = 0
        
        # eq1 - Mass flow continuity from freestream to LPC face
        # A0 is now a calculated parameter, not a variable.
        eq1 = mdot_red_LPC - mdot_red_D * (A0/A1) * (A1/A2) * 1/(epsD) * np.sqrt(T0_2/T0_a)
         
        # eq2
        term2_1 = np.sqrt(1 + (1/eta_LPC) * (Pi_LPC**((gamma_air - 1)/gamma_air) - 1))
        eq2 = mdot_red_LPC - mdot_red_HPC * k1 * (A2/A21) * 1/(Pi_LPC) * term2_1
        
        # eq3
        eq3 = mdot_red_HPT - mdot_red_HPC * k2 * (A21/A4) * (Pi_CC/(Pi_LPC) * np.sqrt(T04T021))

        # eq4
        term4_1 = np.sqrt(1 - eta_HPT * (1- (1/Pi_HPT)**((gamma_gas - 1)/gamma_gas)))
        eq4 = mdot_red_LPT - mdot_red_HPT * k3 * (A4/A41) * (Pi_HPT) * term4_1



        # eq5 - Mass flow continuity from LPT exit to Nozzle throat
        # This calculates the reduced mass flow at the nozzle throat based on upstream conditions.
        # NOTE: A8 is the nozzle throat area, must be in params.
        A8 = self.params['A8']
        mdot_red_N = mdot_red_LPT * (A41 / A8)
        eq5 = 0 # This equation is now an intermediate calculation, not a residual.
        # eq5
        term5_1 = np.sqrt(1 - eta_LPT * (1- (1/Pi_LPT)**((gamma_gas - 1)/gamma_gas)))
        #eq5 = mdot_red_N - mdot_red_LPT * k3 * (A4/A41) * (Pi_HPT) * term5_1

        # eq6 - Nozzle Performance Matching
        # Calculate the available Nozzle Pressure Ratio (NPR)
        P0_5 = P0_2 * Pi_LPC * Pi_HPC * Pi_CC * Pi_HPT * Pi_LPT
        Pi_N = P0_5 / P_a
        
        # Get the reduced mass flow the nozzle *can* pass at this Pi_N from its map
        mdot_red_N_from_map = get_nozzle_mdot_red(Pi_N)
        
        # The residual is the difference between what the engine supplies and what the nozzle can pass.
        # Note: The definition of mdot_red from the nozzle map might differ slightly.
        # The map uses (mdot*sqrt(T0))/(P0*A), while the solver might use (mdot*sqrt(R*T0))/(P0*A).
        # We assume they are consistent for now.
        eq6 = mdot_red_N - mdot_red_N_from_map
        
        
        
        # eq7
        eq7 = N_red_HPC - N_red_HPT * (D_HPC/D_HPT) * np.sqrt(T04T021)

        # eq8
        term8_1 = T04T021*term4_1*term2_1
        eq8 = N_red_LPC - N_red_LPT * (D_LPC/D_LPT) * term8_1

        # eq9
        term9_1 = 1 - term4_1
        term9_2 = np.sqrt(1/eta_HPC) * (Pi_HPC**((gamma_air - 1)/gamma_air) - 1)
        eq9 = term9_1 - term9_2 * (cp_air/cp_gas) * (1/eta_m) * (1/T04T021) * k6

        # eq10
        term10_1 = 1 - term5_1
        term10_2 = np.sqrt(1/eta_LPC) * (Pi_LPC**((gamma_air - 1)/gamma_air) - 1)
        eq10 = term10_1 - term10_2 * (cp_air/cp_gas) * (1/eta_m) * (1/term8_1) * k7




        return [eq1, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9, eq10]

