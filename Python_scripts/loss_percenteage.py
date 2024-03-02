import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Carica i dati dal file CSV in un DataFrame
df1 = pd.read_csv(r"C:\Users\cical\Desktop\Università\Start2Impact\Data_science\Progetto_SQL\Results\top_loss_percenteage.csv")
df2 = pd.read_csv(r"C:\Users\cical\Desktop\Università\Start2Impact\Data_science\Progetto_SQL\Results\worst_loss_percenteage.csv")
print(df1.columns)

# Creazione della figura e dei due assi
fig, axs = plt.subplots(2, 1, figsize=(8, 12))

# Crea mappe di colori diverse per ciascun grafico
color_map1 = plt.get_cmap('tab20', len(df1['country']))
color_map2 = plt.get_cmap('tab20b', len(df2['country']))

# Grafico a barre per il primo set di dati
bars1 = axs[0].bar(df1['country'], df1['avg_loss_percentage'], color=color_map1(np.arange(len(df1['country']))))
axs[0].set_title('Best 5 countries')
axs[0].set_ylabel('Avg_loss_percentage')
axs[0].set_xticks(df1['country'])
axs[0].set_xticklabels(df1['country'], rotation=45, ha="right")
axs[0].legend(bars1, df1['country'])



# Grafico a barre per il secondo set di dati
bars2 = axs[1].bar(df2['country'], df2['avg_loss_percentage'], color=color_map2(np.arange(len(df2['country']))))
axs[1].set_title('Worst 5 countries')
axs[1].set_ylabel('Avg_loss_percentage')
axs[1].set_xticks(df2['country'])
axs[1].set_xticklabels(df2['country'], rotation=45, ha="right")
axs[1].legend(bars2, df2['country'])



# Aggiungi un titolo di confronto
fig.suptitle('Loss Percentage World Country in 2018 - Comparison', fontsize=16)

# Regola il layout
plt.tight_layout()

# Salva l'immagine con sfondo trasparente
plt.savefig(r'C:\Users\cical\Desktop\Università\Start2Impact\Data_science\Progetto_SQL\Diagrams\confronto_grafici.png', bbox_inches='tight', transparent=True)

# Mostra la figura
plt.show()
