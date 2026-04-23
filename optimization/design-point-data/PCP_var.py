import numpy as np
from pymoo.visualization.pcp import PCP

# Carica i risultati
X = np.load("X_results.npy")  # Soluzioni decisionali

# Filtro: condizioni per evidenziare
highlight_mask = (X[:, 0] >= 1.45) & (X[:, 0] <= 1.55) & \
                 (X[:, 1] >= 1.2e+4) & (X[:, 1] <= 1.3e+4)

# Seleziona i due gruppi
X_normal = X[~highlight_mask]
X_highlight = X[highlight_mask]

# Crea il plot PCP
pcp = PCP(title="Parallel Coordinates - Variabili",
          labels=["Mach", "Quota", "BPR", "Beta_c"]
          )

# Linee normali in blu
pcp.add(X_normal, color="green")

# Linee evidenziate in rosso e più spesse
pcp.add(X_highlight, color="magenta", linewidth=2)
# Mostra il grafico
pcp.show()
