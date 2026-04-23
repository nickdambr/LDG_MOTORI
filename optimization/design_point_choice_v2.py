import numpy as np
import pandas as pd

# Load numpy arrays
X = np.load("X_results.npy")
F = np.load("F_results.npy")

# Create ID column (starting from 0)
ids = np.arange(0, X.shape[0]).reshape(-1, 1)

# Define column names
X_columns = ["M", "h", "BPR", "Beta_c"]
F_columns = ["-Ia", "TSFC", "EINOX", "EICO"]

# Convert to DataFrames
X_df = pd.DataFrame(X, columns=X_columns)
F_df = pd.DataFrame(F, columns=F_columns)

# Join the DataFrames side by side
result = pd.concat([X_df, F_df], axis=1)

# Join X and F side by side (column-wise) with ID
XF_matrix = np.hstack((ids, X, F))

# List of reference points: (M_ref, h_ref)
reference_points = [
    (1.5, 12192),
    (1.6, 10000),
    (1.4, 10000)
]

for idx, (M_ref, h_ref) in enumerate(reference_points, 1):
    print(f"\n=== Reference Point {idx}: M={M_ref}, h={h_ref} ===")

    # Find the 20 design IDs with M closest to M_ref
    M_values = XF_matrix[:, 1]  # M is the second column (index 1)
    abs_diff_M = np.abs(M_values - M_ref)
    closest_indices_M = np.argsort(abs_diff_M)[:20]
    closest_designs_M = XF_matrix[closest_indices_M]
    closest_ids_M = closest_designs_M[:, 0].astype(int)

    print("\nIDs of the 20 closest designs (by M):")
    print(closest_ids_M)
    print("\nRows corresponding to the 20 closest IDs (by M):")
    print(result.iloc[closest_ids_M])

    # Find the 20 design IDs with h closest to h_ref
    h_values = XF_matrix[:, 2]  # h is the third column (index 2)
    abs_diff_h = np.abs(h_values - h_ref)
    closest_indices_h = np.argsort(abs_diff_h)[:20]
    closest_designs_h = XF_matrix[closest_indices_h]
    closest_ids_h = closest_designs_h[:, 0].astype(int)

    print("\nIDs of the 20 closest designs (by h):")
    print(closest_ids_h)
    print("\nRows corresponding to the 20 closest IDs (by h):")
    print(result.iloc[closest_ids_h])

    # Find intersection of IDs
    common_ids = np.intersect1d(closest_ids_M, closest_ids_h)
    print("\nIDs present in both the 20 closest-by-M and 20 closest-by-h selections:")
    print(common_ids)

    if len(common_ids) > 0:
        print("\nRows corresponding to the common IDs:")
        print(result.iloc[common_ids])
    else:
        print("\nNo common IDs found.")
