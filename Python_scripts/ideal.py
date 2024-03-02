import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df =pd.read_csv(r"C:\Users\cical\Desktop\Università\Start2Impact\Data_science\Progetto_SQL\Results\ideal_real.csv")
# Creazione del grafico a barre
plt.figure(figsize=(10, 6))  # Dimensioni del grafico

# Barre per la colonna x
plt.bar(df['year'] - 0.2, df['real_wasted'], width=0.4, label='real_wasted')

# Barre per la colonna y
plt.bar(df['year'] + 0.2, df['ideal_wasted'], width=0.4, label='ideal_wasted')

plt.xlabel('Year')
plt.ylabel('Wasted Food 10^3 tonnes')
plt.title('Comparison between ideal and real wasted food quantity in 10^3 tonnes ')
plt.xticks(df['year'])
plt.legend()
plt.grid(axis='y')

plt.tight_layout()
# Set transparent background color
fig = plt.gcf()
fig.patch.set_facecolor('none')
ax = plt.gca()
ax.set_facecolor('none')
plt.show()



