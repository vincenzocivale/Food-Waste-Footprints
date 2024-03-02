import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Load data from the CSV file into a DataFrame
df = pd.read_csv(r"C:\Users\cical\Desktop\Università\Start2Impact\Data_science\Progetto_SQL\Results\food_stage_count.csv")

# Create a list of different colors using tab20c color map
num_bars = len(df)
colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf']


# Create the bar plot with different colors
bars = plt.bar(df['food_supply_stage'], df['count'], color=colors)

# Set axis labels and title
plt.xlabel('Supply Stage')
plt.ylabel('Count')
plt.title('Overview of Critical Food Supply Stage in 2018')

# Add a legend with the supply stage names
plt.legend(bars, df['food_supply_stage'])
# Remove x-axis tick labels
plt.xticks([])
plt.yticks()

# Set transparent background color
fig = plt.gcf()
fig.patch.set_facecolor('none')
ax = plt.gca()
ax.set_facecolor('none')

# Show the plot
plt.tight_layout()
plt.show()
