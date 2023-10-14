# Name: Patrick Liu
# Student Number: 101142730

import pandas as pd

# Read the csv file
df = pd.read_csv('Data/jena_climate_2009_2016.csv')
# print(df.head(10))
# Slice [start:stop:step], starting from index 5 take every 6th record
df = df[5::6]
date_time = pd.to_datetime(df['Date Time'], format='%d.%m.%Y %H:%M:%S')
# print(df.head())

# Replace bad wind speed data with 0

# print(df['wv (m/s)'].min())
# print(df['max. wv (m/s)'].min())

wv = df['wv (m/s)']
bad_wv = wv == -9999.0
wv[bad_wv] = 0.0

max_wv = df['max. wv (m/s)']
bad_max_wv = max_wv == -9999.0
max_wv[bad_max_wv] = 0.0

# print(df['wv (m/s)'].min())
# print(df['max. wv (m/s)'].min())

