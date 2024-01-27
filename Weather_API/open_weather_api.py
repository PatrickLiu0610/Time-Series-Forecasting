# Name: Patrick Liu
# Student Number: 101142730

import pandas as pd
import requests

request_url = "https://api.openweathermap.org/data/2.5/weather?"
api_key = "OPEN WEATHER API KEY"

city = "Ottawa"
url = request_url + "appid=" + api_key + "&q=" + city
response = requests.get(url).json()

temperature = round(response['main']['temp'] - 273.15, 1)
humidity = response['main']['humidity']
wind_speed = round(response['wind']['speed'] * 3.6, 1)
pressure = round(response['main']['pressure'] / 10, 1)
precipitation = 0.0
try:
    precipitation = response['rain']['1h']
except:
    pass

data = [{'Temp (°C)': temperature, 'Rel Hum (%)': humidity, 'Precip. Amount (mm)': precipitation,
         'Wind Spd (km/h)': wind_speed, 'Stn Press (kPa)': pressure}]

api_data_df = pd.DataFrame(data).astype(float)
