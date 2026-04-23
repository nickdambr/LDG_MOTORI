import numpy as np
import pandas as pd

# Load numpy arrays
X = np.load("X_results.npy")
F = np.load("F_results.npy")

# Create ID column (starting from 0 or 1 as you prefer)
ids = np.arange(0, X.shape[0]).reshape(-1, 1)
print(ids)

#print(type(X), X.shape)
#print(type(F), F.shape)

#for i in range(len(X)):
    #print(f"Soluzione {i+1}:")
    #print(f"  X = {X[i]}")
    #print(f"  F = {F[i]}")
    #print()

# Define column names
X_columns = ["M", "h", "BPR", "Beta_c"]
F_columns = ["-Ia", "TSFC", "EINOX", "EICO"]

# Convert to DataFrames
X_df = pd.DataFrame(X, columns=X_columns)
F_df = pd.DataFrame(F, columns=F_columns)

# Join the DataFrames side by side
result = pd.concat([X_df, F_df], axis=1)

# Reorder columns as specified (already in order)
result = result[["M", "h", "BPR", "Beta_c", "-Ia", "TSFC", "EINOX", "EICO"]]

# Save to CSV
#result.to_csv("XF_results.csv", index=False)

print(result)

# Join X and F side by side (column-wise)
XF_matrix = np.hstack((ids, X, F))

print(XF_matrix)

# Reference values
M_ref = 1.5
h_ref = 12192


# Find the 20 design IDs with M closest to M_ref
M_values = XF_matrix[:, 1]  # M is the second column (index 1)
abs_diff = np.abs(M_values - M_ref)
closest_indices = np.argsort(abs_diff)[:20]
closest_designs = XF_matrix[closest_indices]

print("\n10 designs with M closest to reference (M=1.5):")
print(closest_designs)

# If you want only the IDs:
closest_ids = closest_designs[:, 0].astype(int)
print("\nIDs of the 10 closest designs:")
print(closest_ids)

# Print the entire rows from the DataFrame corresponding to those IDs
# IDs start from 1, DataFrame index starts from 0
rows_to_print = result.iloc[closest_ids]
print("\nRows corresponding to the 10 closest IDs:")
print(rows_to_print)


# Find the 20 design IDs with h closest to h_ref
h_values = XF_matrix[:, 2]  # h is the third column (index 2)
abs_diff_h = np.abs(h_values - h_ref)
closest_indices_h = np.argsort(abs_diff_h)[:20]
closest_designs_h = XF_matrix[closest_indices_h]

print("\n20 designs with h closest to reference (h=12192):")
print(closest_designs_h)

# If you want only the IDs:
closest_ids_h = closest_designs_h[:, 0].astype(int)
print("\nIDs of the 20 closest designs (by h):")
print(closest_ids_h)

# Print the entire rows from the DataFrame corresponding to those IDs
rows_to_print_h = result.iloc[closest_ids_h]
print("\nRows corresponding to the 20 closest IDs (by h):")
print(rows_to_print_h)


# Find intersection of IDs
common_ids = np.intersect1d(closest_ids, closest_ids_h)
print("\nIDs present in both the 20 closest-by-M and 20 closest-by-h selections:")
print(common_ids)

# Optionally, print the corresponding rows
if len(common_ids) > 0:
    print("\nRows corresponding to the common IDs:")
    print(result.iloc[common_ids])
else:
    print("\nNo common IDs found.")


