import numpy as np
from scipy.interpolate import griddata
import os
import off_inlet
import nozzle

# --- Global variables to store map data so we only load it once ---
_lpc_data = None
_hpc_data = None
_inlet_map_data = None
_nozzle_map_data = None




def _load_map_data(compressor_type):
    """
    Loads and processes compressor map data from an NPZ file.
    This function is now robust to cases where one coordinate axis is a 1D vector.
    """
    if compressor_type == 'LPC':
        # Correct path including the 'maps' subfolder
        path = os.path.join('maps', 'LPC_compressor_map_grid.npz')
    elif compressor_type == 'HPC':
        # Correct path including the 'maps' subfolder
        path = os.path.join('maps', 'HPC_compressor_map_grid.npz')
    else:
        raise ValueError("Unknown compressor type specified.")

    if not os.path.exists(path):
        raise FileNotFoundError(f"Compressor map file not found at: {path}")
        
    data = np.load(path)
    
    n_red_in = data['nred_grid']
    pi_in = data['Pi_grid']
    mred_in = data['mred_grid']

    # Case 1: Both coordinate arrays are 2D grids (ideal case)
    if n_red_in.ndim == 2 and pi_in.ndim == 2:
        n_red_grid = n_red_in
        pi_grid = pi_in
    
    # Case 2: N_red is a 1D vector (e.g., speed lines), and Pi is a 2D grid
    elif n_red_in.ndim == 1 and pi_in.ndim == 2:
        # The vector length must match the number of rows in the grid
        if n_red_in.shape[0] != pi_in.shape[0]:
            raise ValueError(f"Shape mismatch in {compressor_type} map: n_red vector length ({n_red_in.shape[0]}) does not match Pi grid rows ({pi_in.shape[0]})")
        # Reshape the n_red vector to a column and tile it horizontally to create a full grid
        n_red_grid = np.tile(n_red_in.reshape(-1, 1), (1, pi_in.shape[1]))
        pi_grid = pi_in

    # Case 3: Pi is a 1D vector, and N_red is a 2D grid (less common)
    elif pi_in.ndim == 1 and n_red_in.ndim == 2:
        # The vector length must match the number of columns in the grid
        if pi_in.shape[0] != n_red_in.shape[1]:
            raise ValueError(f"Shape mismatch in {compressor_type} map: Pi vector length ({pi_in.shape[0]}) does not match n_red grid columns ({n_red_in.shape[1]})")
        # Tile the Pi vector vertically to create a full grid
        pi_grid = np.tile(pi_in, (n_red_in.shape[0], 1))
        n_red_grid = n_red_in
    
    else:
        raise ValueError(f"Unsupported grid dimensions for {compressor_type}: n_red is {n_red_in.ndim}D, Pi is {pi_in.ndim}D. Expecting two 2D grids or one 1D and one 2D grid.")

    # Handle inconsistent mred_grid shape by attempting to tile it
    if mred_in.ndim == 1 and n_red_grid.ndim == 2:
        # If mred is a vector but coordinates are a grid, assume mred corresponds to the rows and should be tiled.
        print(f"WARNING: Inconsistent data in {compressor_type} map. 'mred_grid' is 1D but coordinate grids are 2D. Assuming 'mred_grid' should be tiled.")
        if mred_in.shape[0] == n_red_grid.shape[0]:
             mred_grid = np.tile(mred_in.reshape(-1, 1), (1, n_red_grid.shape[1]))
        else:
            # This case is unrecoverable, raise the original error with more context.
            pass # Let the check below handle it.
    else:
        mred_grid = mred_in

    # Final validation: all three grids (n_red, pi, mred) must now have the exact same shape
    if not (n_red_grid.shape == pi_grid.shape == mred_grid.shape):
        raise ValueError(
            f"Grid shape inconsistency in {compressor_type} map file. "
            f"Final shapes are: n_red_grid={n_red_grid.shape}, "
            f"pi_grid={pi_grid.shape}, mred_grid={mred_grid.shape}. "
            "All three must match for interpolation."
        )

    # Create the points and values for interpolation
    points = np.vstack((n_red_grid.ravel(), pi_grid.ravel())).T
    values = mred_grid.ravel()

    return {
        'points': points,
        'mred_values': values
    }

def get_lpc_map_data(Pi_LPC, N_red_LPC):
    """
    Interpolates the LPC map to find reduced mass flow.
    Efficiency is now treated as a fixed parameter.
    """
    global _lpc_data
    if _lpc_data is None:
        print("Loading LPC map data for the first time...")
        _lpc_data = _load_map_data('LPC')
        
    target_point = (N_red_LPC, Pi_LPC)
    # Interpolate for mass flow only
    mdot_red = griddata(_lpc_data['points'], _lpc_data['mred_values'], target_point, method='linear')
    
    return mdot_red # Return only the mass flow

def get_hpc_map_data(Pi_HPC, N_red_HPC):
    """
    Interpolates the HPC map to find the reduced mass flow.
    Efficiency is now treated as a fixed parameter.
    """
    global _hpc_data
    if _hpc_data is None:
        print("Loading HPC map data for the first time...")
        _hpc_data = _load_map_data('HPC')
        
    target_point = (N_red_HPC, Pi_HPC)
    # Interpolate for mass flow only
    mdot_red = griddata(_hpc_data['points'], _hpc_data['mred_values'], target_point, method='linear')

    return mdot_red # Return only the mass flow

def _generate_inlet_map():
    """
    Private helper function to run the inlet simulation from map_inlet.py
    and generate the performance curves. This is run only once.
    """
    print("--- Generating inlet performance map for the first time... ---")
    
    # --- Simulation Setup (from map_inlet.py) ---
    DESIGN_MACH = 1.49081
    DESIGN_GEOMETRY = {
        'A_throat': 0.9695327684,
        'A_exit': 1.0256858841,
    }
    DESIGN_ETA_D = 0.9
    freestream_pressure = 18144.4
    freestream_temperature = 216.65
    mdot_engine_req = 124.4431866 # Fixed demand for map generation
    M0_range = np.linspace(0.1, 2.2, 200) # Range for interpolation
    M0_results = []
    pi_inlet_results = []
    capture_ratio_results = []

    for M0 in M0_range:
        performance = off_inlet.analyze_inlet_off_design(
            geometry=DESIGN_GEOMETRY,
            M_design=DESIGN_MACH,
            M0=M0,
            P_inf=freestream_pressure,
            T_inf=freestream_temperature,
            mdot_engine_req=mdot_engine_req,
            eta_d=DESIGN_ETA_D
        )
    
        M0_results.append(M0)
        pi_inlet_results.append(performance.get("Overall Pressure Recovery (pi_inlet)", np.nan))
        
        mdot_captured = performance.get("Engine Face Mass Flow [kg/s]", 0)
        rho_inf = freestream_pressure / (off_inlet.R * freestream_temperature)
        a_inf = np.sqrt(off_inlet.gamma * off_inlet.R * freestream_temperature)
        V_inf = M0 * a_inf
        
        if V_inf > 0:
            A0 = mdot_captured / (rho_inf * V_inf)
            capture_ratio = A0 / DESIGN_GEOMETRY['A_throat']
            capture_ratio_results.append(capture_ratio)
        else:
            capture_ratio_results.append(0)

        # Return a dictionary of numpy arrays for interpolation
    return {
        'M0': np.array(M0_results),
        'pi_inlet': np.array(pi_inlet_results),
        'capture_ratio': np.array(capture_ratio_results),
        'A_throat': DESIGN_GEOMETRY['A_throat']
    }

def get_inlet_map_data(M0):
    """
    Interpolates the pre-generated inlet performance map to find pi_inlet
    and capture_ratio for a given flight Mach number M0.
    """
    global _inlet_map_data
    if _inlet_map_data is None:
        _inlet_map_data = _generate_inlet_map()
        
    # Use numpy's interpolation function
    pi_inlet = np.interp(M0, _inlet_map_data['M0'], _inlet_map_data['pi_inlet'])
    capture_ratio = np.interp(M0, _inlet_map_data['M0'], _inlet_map_data['capture_ratio'])
    
    return {
        'pi_inlet': pi_inlet,
        'capture_ratio': capture_ratio,
        'A_throat': _inlet_map_data['A_throat']
    }

def get_freestream_mass_flow_param(M0):
    """
    Calculates the dimensionless mass flow parameter for the freestream (mdot_red_D).
    Formula: sqrt(gamma) * M * (1+(g-1)/2*M^2)^(-(g+1)/(2(g-1)))
    """
    if M0 <= 0:
        return 0.0
    
    gamma = off_inlet.gamma
    term1 = np.sqrt(gamma) * M0
    term2 = (1 + (gamma - 1) / 2 * M0**2)**(- (gamma + 1) / (2 * (gamma - 1)))
    return term1 * term2

def _generate_nozzle_map():
    """
    Private helper function to run the nozzle simulation and generate
    the performance curve (NPR vs. mdot_reduced).
    """
    print("--- Generating nozzle performance map for the first time... ---")
    
    # --- Nozzle Definition (from nozzle_map.py) ---
    inlet_P0 = 372858
    inlet_T0 = 1308.5
    throat_area = 0.22875
    exit_area = 0.75992
    gamma = 1.33
    R = 287.0
    back_pressure_range = np.linspace(1000, inlet_P0, 500)

    npr_results = []
    mdot_reduced_results = []

    for p_back in back_pressure_range:
        performance = nozzle.analyze_cd_nozzle(
            P0=inlet_P0, T0=inlet_T0, A_throat=throat_area, A_exit=exit_area,
            P_back=p_back, gamma=gamma, R=R
        )
    mdot = performance.get("Mass Flow Rate [kg/s]", 0)
    npr = inlet_P0 / p_back
    # The definition from nozzle_map.py
    mdot_reduced = (mdot * np.sqrt(inlet_T0)) / (inlet_P0 * throat_area)

    npr_results.append(npr)
    mdot_reduced_results.append(mdot_reduced)
    
    # Return sorted arrays for interpolation
    # Sorting is important for np.interp
    sort_indices = np.argsort(npr_results)
    return {
        'npr': np.array(npr_results)[sort_indices],
        'mdot_red': np.array(mdot_reduced_results)[sort_indices]
    }
def get_nozzle_mdot_red(npr):
    """
    Interpolates the nozzle map to find the reduced mass flow for a given
    Nozzle Pressure Ratio (NPR).
    """
    global _nozzle_map_data
    if _nozzle_map_data is None:
        _nozzle_map_data = _generate_nozzle_map()
        
    # Use numpy's interpolation function.
    # np.interp finds the mdot_red corresponding to the input npr.
    mdot_red = np.interp(npr, _nozzle_map_data['npr'], _nozzle_map_data['mdot_red'])
    return mdot_red


    """Calculates LPT performance using the analytical model."""
    return _get_turbine_performance_analytical(Pi_LPT, N_red_LPT, 'LPT', gamma_gas)