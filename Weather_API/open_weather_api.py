# Name: Patrick Liu
# Student Number: 101142730

import pandas as pd
import requests

api_key = "OPEN WEATHER API KEY"


def get_ottawa_weather():
    request_url = "https://api.openweathermap.org/data/2.5/weather?"

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

    return pd.DataFrame(data).astype(float)


def get_current_weather(lat, lon):
    request_url = "https://api.openweathermap.org/data/2.5/onecall?"
    url = request_url + "lat=" + str(lat) + "&lon=" + str(lon) + "&appid=" + api_key
    response = requests.get(url).json()

    temperature = round(response['current']['temp'] - 273.15, 1)
    humidity = response['current']['humidity']
    wind_speed = round(response['current']['wind_speed'] * 3.6, 1)
    pressure = round(response['current']['pressure'] / 10, 1)
    precipitation = 0.0
    try:
        precipitation = response['current']['rain']['1h']
    except:
        pass

    data = [{'Temp (°C)': temperature, 'Rel Hum (%)': humidity, 'Precip. Amount (mm)': precipitation,
             'Wind Spd (km/h)': wind_speed, 'Stn Press (kPa)': pressure}]

    return pd.DataFrame(data).astype(float)
