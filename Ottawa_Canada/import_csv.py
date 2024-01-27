# Name: Patrick Liu
# Student Number: 101142730

import pandas as pd

# Read the csv file
df = pd.read_csv('../Data/Ottawa_Weather_2014_2024.csv', dtype={"Temp Flag": "string",
                                                                "Dew Point Temp Flag": "string",
                                                                "Rel Hum Flag": "string",
                                                                "Wind Dir Flag": "string",
                                                                "Wind Spd Flag": "string",
                                                                "Stn Press Flag": "string"})

# Remove all unused columns
df.drop(['Longitude (x)', 'Latitude (y)', 'Station Name', 'Climate ID', 'Date/Time (LST)', 'Year', 'Month',
         'Day', 'Time (LST)', 'Temp Flag', 'Dew Point Temp (°C)', 'Dew Point Temp Flag', 'Rel Hum Flag',
         'Precip. Amount Flag', 'Wind Dir (10s deg)', 'Wind Dir Flag', 'Wind Spd Flag', 'Visibility (km)',
         'Visibility Flag', 'Stn Press Flag', 'Hmdx', 'Hmdx Flag', 'Wind Chill', 'Wind Chill Flag', 'Weather'],
        axis=1, inplace=True)

# Remove all rows with nan value
df.dropna(inplace=True)
