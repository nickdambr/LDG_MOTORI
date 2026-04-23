import numpy as np

mred_grid = np.array([0.1, 0.2, 0.3])      # 3 points for m_red (x-axis)
nred_grid = np.array([0.05, 0.10, 0.15, 0.20])  # 4 points for n_red (y-axis)

M, N = np.meshgrid(mred_grid, nred_grid)
print("mred_grid:", mred_grid)
print("nred_grid:", nred_grid)
print("\nM (mred values):\n", M)
print("\nN (nred values):\n", N)