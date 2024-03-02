import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

file_path = r"C:\Users\cical\Desktop\Università\Start2Impact\Data_science\Progetto_SQL\FoodBalanceSheets_E_All_Data.csv"
df = pd.read_csv(file_path, encoding='ISO-8859-1')

# Filter data for wheat and products in Europe
df = df[df['Item'] == 'Wheat and products']
df = df[df['Area'] == 'Europe']

data = []
years = np.array([x for x in range(2010, 2021)])
for x in range(2010, 2021):
    key = 'Y' + str(x)
    data.append(df[key].mean())

# Plot the data with dashed lines
plt.plot(years, data, linestyle='--', marker='o')

# Set axis labels and title
plt.xlabel('Years')
plt.ylabel('Wheat and Products Request')
plt.title('Overview of Wheat and Products Request in Europe')

# Remove x-axis tick labels
plt.xticks()
plt.yticks()

plt.grid()

# Show the plot
plt.tight_layout()
