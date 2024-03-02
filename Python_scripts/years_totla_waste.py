import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Carica i dati dal file CSV in un DataFrame
df2 = pd.read_csv(r"C:\Users\cical\Desktop\Università\Start2Impact\Data_science\Progetto_SQL\Results\total_waste.csv")

# Imposta lo sfondo trasparente
fig = plt.figure()
fig.patch.set_facecolor('none')
ax = fig.add_subplot(111, facecolor='none')

# Disegna i punti scatter
scatter = ax.scatter(df2['year'][33:], df2['total_loss'][33:], alpha=0.7, c='b', edgecolors='none', s=50, label='Data Points')

# Disegna linee tratteggiate che collegano i dati
for i in range(33, len(df2['year']) - 1):
    ax.plot([df2['year'][i], df2['year'][i + 1]], [df2['total_loss'][i], df2['total_loss'][i + 1]], linestyle='--', color='gray')

# Imposta etichette degli assi e titolo
ax.set_xlabel('Year')
ax.set_ylabel('Total Food Waste (kg/MT)')
ax.set_title('Scatter Plot with Dashed Connecting Lines')

# Imposta le etichette dell'asse x
years = df2['year'][33:]
ax.set_xticks(years)
ax.set_xticklabels(years, rotation=45, ha="right")

# Aggiungi una griglia
ax.grid(True)

# Aggiungi legenda
ax.legend()
ax.set_title("Increase in Food Waste Worldwide Over the Years")

# Mostra il grafico
plt.tight_layout()
plt.show()
