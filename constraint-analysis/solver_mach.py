import numpy as np
from scipy.optimize import root_scalar

# Define known parameters
gamma = 1.4         # Specific heat ratio (example)
alpha1_deg = 0     # Angle in degrees (example)
alpha1 = np.radians(alpha1_deg)  # Convert to radians
mred = 0.646919        # Example value of mred

# Define the function to find the root of
def equation(Machd):
    term1 = np.sqrt(gamma)
    term2 = Machd * np.cos(alpha1)
    term3 = (1 + (gamma - 1) / 2 * Machd**2)**(0.5 - gamma / (gamma - 1))
    return mred - term1 * term2 * term3

# Solve the equation numerically in the interval [0, 1]
sol = root_scalar(equation, x0=0.6, method='newton')

# Check and print the result
if sol.converged:
    print(f"Solution Machd = {sol.root}")
else:
    print("Root finding did not converge.")
