import numpy as np
from pymoo.visualization.pcp import PCP

# Carica i risultati
F = np.load("F_results.npy")  # Soluzioni decisionali

# Filtro: condizioni per evidenziare
highlight_mask = (F[:, 0] >= -950) & (F[:, 0] <= -940)

# Seleziona i due gruppi
F_normal = F[~highlight_mask]
F_highlight = F[highlight_mask]

# Crea il plot PCP
pcp = PCP(title="Parallel Coordinates - Obiettivi",
          labels=["-Ia", "TSFC", "EINOX", "EICO"]
          )

# Linee normali in blu
pcp.add(F_normal, color="green")

# Linee evidenziate in rosso e più spesse
pcp.add(F_highlight, color="magenta", linewidth=2)
# Mostra il grafico
pcp.show()
