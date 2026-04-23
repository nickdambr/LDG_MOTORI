import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d, griddata

# Simulated sample data
np.random.seed(0)
n_points = 100
mred_vals = np.random.uniform(0.2, 1.0, n_points)
nred_vals = np.random.uniform(0.3, 1.0, n_points)
pi_c_vals = 5 + 2 * np.exp(-(mred_vals - 0.6)**2 / 0.01) * (1 - (nred_vals - 0.65)**2 / 0.09)

# Create regular grid
plot_resolution = (100, 100)
mred_grid = np.linspace(mred_vals.min(), mred_vals.max(), plot_resolution[0])
nred_grid = np.linspace(nred_vals.min(), nred_vals.max(), plot_resolution[1])
M, N = np.meshgrid(mred_grid, nred_grid)

# Interpolate pi_c on the grid
Pi_grid = griddata((mred_vals, nred_vals), pi_c_vals, (M, N), method='cubic')

# Step 1: Find stability boundary (max pi_c for each nred)
n_rows, n_cols = Pi_grid.shape
pi_max_boundary = np.full(n_rows, np.nan)
mred_boundary = np.full(n_rows, np.nan)

for i in range(n_rows):
    row = Pi_grid[i, :]
    if np.all(np.isnan(row)):
        continue
    j_max = np.nanargmax(row)
    pi_max_boundary[i] = row[j_max]
    mred_boundary[i] = M[i, j_max]

# Interpolator for pi_max as a function of mred
valid = ~np.isnan(mred_boundary) & ~np.isnan(pi_max_boundary)
interp_stability = interp1d(mred_boundary[valid], pi_max_boundary[valid],
                            kind='linear', bounds_error=False, fill_value=np.nan)

# Step 2: Mask points above stability boundary at same mred
Pi_grid_masked = Pi_grid.copy()
for i in range(n_rows):
    for j in range(n_cols):
        pi_val = Pi_grid[i, j]
        if np.isnan(pi_val):
            continue
        pi_stab = interp_stability(M[i, j])
        if pi_val > pi_stab:
            Pi_grid_masked[i, j] = np.nan

# Plot: isolines of nred in the (mred, pi_c) plane
plt.figure(figsize=(8, 6))
contour = plt.contourf(M, Pi_grid_masked, N, levels=30, cmap='viridis')
plt.plot(mred_boundary[valid], pi_max_boundary[valid], 'r--', label='Stability Boundary')
plt.colorbar(contour, label=r'$n_{red}$')
plt.xlabel('Mass Flow (mred)')
plt.ylabel(r'Pressure Ratio $\pi_c$')
plt.title('Isolines of Reduced Speed $n_{red}$ with Stability Mask')
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
