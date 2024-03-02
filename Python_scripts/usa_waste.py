import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

file_path = r"C:\Users\cical\Desktop\Università\Start2Impact\Data_science\Progetto_SQL\Data.csv"
df = pd.read_csv(file_path)

print(df.columns)


df = df[df['country']=='United States of America']
df = df[df['year']==2018]

file_path = r"C:\Users\cical\Desktop\Università\Start2Impact\Data_science\Progetto_SQL\FoodBalanceSheets_E_All_Data.csv"
df2 = pd.read_csv(file_path, encoding='ISO-8859-1')
df2 = df2[df2['Unit'] == '1000 tonnes']
df2 = df2[df2['Area'] == 'United States of America']
quantity = df2['Y2018'].mean()
loss_percentage = df['loss_percentage'].mean()
print(quantity*loss_percentage*0.57)