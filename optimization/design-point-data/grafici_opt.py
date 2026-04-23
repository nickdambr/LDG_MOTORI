import numpy as np
import pandas as pd

# Load numpy arrays
X = np.load("X_results.npy")
F = np.load("F_results.npy")
xl= np.array([0.8, 5000.0, 0.2, 5.0])
xu= np.array([1.6, 15000.0, 0.8, 8.0])


import matplotlib.pyplot as plt
plt.figure(figsize=(7, 5))
plt.scatter(X[:, 0], X[:, 1], s=30, facecolors='none', edgecolors='r')
plt.xlabel("Mach")
plt.ylabel("Quota")
plt.xlim(xl[0], xu[0])
plt.ylim(xl[1], xu[1])
plt.title("Design Space: Mach vs Quota")

plt.figure(figsize=(7, 5))
plt.scatter(X[:, 2], X[:, 3], s=30, facecolors='none', edgecolors='r')
plt.xlabel("BPR")
plt.ylabel("Beta_c")
plt.xlim(xl[2], xu[2])
plt.ylim(xl[3], xu[3])
plt.title("Design Space: BPR vs Beta_c")

plt.figure(figsize=(7, 5))
plt.scatter(-F[:, 0], F[:, 1], s=30, facecolors='none', edgecolors='blue')
plt.xlabel("Ia")
plt.ylabel("TSFC")
plt.title("Objective Space: Ia vs TSFC")


from pymoo.visualization.scatter import Scatter
from pymoo.visualization.pcp import PCP
import seaborn as sns
import pandas as pd

#Visualizzazioni
#Parallel Coordinates

PCP(title="Parallel Coordinates - Obiettivi").add(F).show(block=False)

PCP(title="Parallel Coordinates - Variabili").add(X).show(block=False)

#Bubble Chart

plt.figure(figsize=(7, 5))
plt.scatter(-F[:, 0], F[:, 1], s=F[:, 2]*100, c=F[:, 3], cmap='viridis', alpha=0.6)
plt.xlabel("Ia")
plt.ylabel("TSFC")
plt.title("Bubble Chart: Ia vs TSFC (size=EINOX, color=EICO)")
plt.colorbar(label="EICO")
plt.grid(True)

#Scatter Matrix (correlazione tra le coppie di obiettivi)

df = pd.DataFrame(F, columns=["-Ia", "TSFC", "EINOX", "EICO"])
sns.pairplot(df)
plt.suptitle("Scatter Matrix degli Obiettivi", y=1.02)


plt.show()
