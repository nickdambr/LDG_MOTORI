import numpy as np
from scipy.optimize import root_scalar
from tabulate import tabulate 
from scipy.interpolate import griddata
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt
import json

mred_des=0.50406;
Pi_des=3.47813;

data = np.load('compressor_map_grid.npz')
Pi_grid = data['Pi_grid']
mred_grid = data['mred_grid']
nred_grid = data['nred_grid']
choked_points = data['choked_points']
M, N = np.meshgrid(mred_grid, nred_grid)

# For each N_red (row), find the m_red (column) where Pi_c is maximum
max_indices = np.nanargmax(Pi_grid, axis=1)
mred_boundary = mred_grid[max_indices]
pi_max_boundary = Pi_grid[np.arange(len(nred_grid)), max_indices]


# Interpolate the stability boundary as a function of mred
boundary_interp = interp1d(mred_boundary, pi_max_boundary, kind='linear', bounds_error=False, fill_value=np.nan)

# Evaluate the boundary at all mred_grid points
pi_max_interp = boundary_interp(mred_grid)  # shape: (len(mred_grid),)

# Broadcast and mask: for each column (mred), mask Pi_grid values above the interpolated boundary
mask = Pi_grid > pi_max_interp[None, :]  # shape: (len(nred_grid), len(mred_grid))
Pi_grid_masked = Pi_grid.copy()
Pi_grid_masked[mask] = np.nan


print("Shape of pi_max_boundary:", pi_max_boundary.shape)
print("Shape of Pi_grid:", Pi_grid.shape)
print("Shape of Pi_grid_masked:", Pi_grid_masked.shape)



#mask = Pi_grid > pi_max_boundary[:, None]  # Broadcasts max value for each row
#Pi_grid_masked = Pi_grid.copy()
#Pi_grid_masked[mask] = np.nan

 # Plot the map
plt.figure(figsize=(8,6))
cp = plt.contourf(M, Pi_grid_masked, N, levels=128, cmap='coolwarm')
# Add contour lines of N
contour_N = plt.contour(M, Pi_grid_masked, N,levels=32, colors='black', linewidths=1.5, linestyles='dotted')
plt.clabel(contour_N, fmt="N = %.2f", colors='black', fontsize=14, inline_spacing=5)
plt.colorbar(cp, label='$N_{red}$')
plt.plot(mred_boundary, pi_max_boundary, 'r--', label='Stability Boundary', linewidth=1.5)
plt.scatter(mred_des, Pi_des, color='black', marker='o', s=80, label='Design Point')
# Plot choked points
choked_points = np.array(choked_points)
plt.scatter(
    choked_points[:,0],  # mred
    choked_points[:,2],  # pi_c
    c='orange', marker='x', label='Choked Points'
)
plt.xlabel('$\dot{m}_{red}$')
plt.ylabel('$\Pi_c$')
plt.title('HPC Map')
plt.legend()
plt.xlim(0.1, np.nanmax(mred_grid) * 1.01)  # Add some padding to the x-axis
plt.ylim(0, 10)  # Add some padding to the y-axis
plt.show()