import numpy as np
from scipy.interpolate import griddata

# Scattered data (as you might get from experiments or simulations)
mred_vals = np.array([0.1, 0.2, 0.3, 0.2, 0.3, 0.1])
nred_vals = np.array([0.05, 0.03, 0.1, 0.15, 0.15, 0.2])
pi_c_vals = np.array([1.2, 2.2, 1.5, 1.7, 2.0, 1.2])

mred_grid = np.linspace(0.1, 0.3, 4)   # [0.1, 0.2, 0.3]
nred_grid = np.linspace(0.05, 0.2, 4)  # [0.05, 0.1, 0.15, 0.2]
M, N = np.meshgrid(mred_grid, nred_grid)

Pi_grid = griddata((mred_vals, nred_vals), pi_c_vals, (M, N), method='cubic')
print("Pi_grid:\n", Pi_grid)

stability_boundary = np.nanmax(Pi_grid, axis=1)
print("stability_boundary:", stability_boundary)

stability_boundary_bis = np.nanmax(Pi_grid, axis=0)
print("stability_boundary_bis:", stability_boundary_bis)

print('stability_boundary[:, None] : ',stability_boundary[:, None] ) 
print('stability_boundary[None, :] : ',stability_boundary[None, :] ) 
mask1 = Pi_grid > stability_boundary[:, None]  # shape (n_nred, n_mred)
print("mask1:\n", mask1)
mask2 = Pi_grid > stability_boundary[None, :]  # shape (n_nred, n_mred)
print("mask2:\n", mask2)
Pi_grid_masked1 = Pi_grid.copy()
Pi_grid_masked1[mask1] = np.nan
print("Pi_grid_masked1:\n", Pi_grid_masked1)
Pi_grid_masked2 = Pi_grid.copy()
Pi_grid_masked2[mask2] = np.nan
print("Pi_grid_masked2:\n", Pi_grid_masked2)