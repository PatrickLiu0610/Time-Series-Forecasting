# Name: Patrick Liu
# Student Number: 101142730

import os
import numpy as np
from import_csv import date_time
from data_prep import trainX, scaler, df_for_training
from keras import models
import pandas as pd

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

model = models.load_model(os.path.join('models', 'model.h5'))

n_future = 7 * 365 * 24
forecast_period_hours = pd.date_range(list(date_time)[-1], periods=n_future, freq='1h').to_list()
# print(forecast_period_hours)

prediction = model.predict(trainX[-n_future:])
# print(prediction)

prediction_copies = np.repeat(prediction, df_for_training.shape[1], axis=-1)
y_pred_future = scaler.inverse_transform(prediction_copies)
# print(y_pred_future)

forcast_hours = []
pressure = []
temperature_in_degree = []
temperature_in_Kelvin = []
temperature_dew_point = []
relative_humidity = []
saturation_vapor_pressure = []
vapor_pressure = []
vapor_pressure_deficit = []
specific_humidity = []
water_vapor_concentration = []
airtight = []
wind_speed = []
maximum_wind_speed = []
wind_direction_in_degrees = []

for x in range(len(forecast_period_hours)):
    forcast_hours.append(forecast_period_hours[x])
    pressure.append(y_pred_future[x][0])
    temperature_in_degree.append(y_pred_future[x][1])
    temperature_in_Kelvin.append(y_pred_future[x][2])
    temperature_dew_point.append(y_pred_future[x][3])
    relative_humidity.append(y_pred_future[x][4])
    saturation_vapor_pressure.append(y_pred_future[x][5])
    vapor_pressure.append(y_pred_future[x][6])
    vapor_pressure_deficit.append(y_pred_future[x][7])
    specific_humidity.append(y_pred_future[x][8])
    water_vapor_concentration.append(y_pred_future[x][9])
    airtight.append(y_pred_future[x][10])
    wind_speed.append(y_pred_future[x][11])
    maximum_wind_speed.append(y_pred_future[x][12])
    wind_direction_in_degrees.append(y_pred_future[x][13])

df_forecast = pd.DataFrame({'Date Time': np.array(forcast_hours),
                            'Pressure': pressure,
                            'Temperature in Degree': temperature_in_degree,
                            'Temperature in Kelvin': temperature_in_Kelvin,
                            'temperature dew point': temperature_dew_point,
                            'relative humidity': relative_humidity,
                            'saturation vapor pressure': saturation_vapor_pressure,
                            'vapor pressure': vapor_pressure,
                            'vapor pressure deficit': vapor_pressure_deficit,
                            'specific humidity': specific_humidity,
                            'water vapor concentration': water_vapor_concentration,
                            'airtight': airtight,
                            'wind speed': wind_speed,
                            'maximum wind speed': maximum_wind_speed,
                            'wind direction in degrees': wind_direction_in_degrees
                            })

df_forecast['Date Time'] = pd.to_datetime(df_forecast['Date Time'], format='%d.%m.%Y %H:%M:%S')

# Format: 'YYYY-MM-DD HH:MM:SS'
# user_input = input("Enter Time Stamp: ")
# weather_prediction = df_forecast.loc[df_forecast['Date Time'] == user_input]
#
# print(str(weather_prediction['Date Time']) + "\n" + str(weather_prediction['Pressure']) + "\n" +
#       str(weather_prediction['Temperature in Degree']) + "\n" + str(weather_prediction['Temperature in Kelvin']) +
#       "\n" + str(weather_prediction['temperature dew point']) + "\n" + str(weather_prediction['relative humidity'])
#       + "\n" + str(weather_prediction['saturation vapor pressure']) + "\n" + str(weather_prediction['vapor pressure'])
#       + "\n" + str(weather_prediction['vapor pressure deficit']) + "\n" + str(weather_prediction['specific humidity'])
#       + "\n" + str(weather_prediction['water vapor concentration']) + "\n" + str(weather_prediction['airtight'])
#       + "\n" + str(weather_prediction['wind speed']) + "\n" + str(weather_prediction['maximum wind speed']) + "\n" +
#       str(weather_prediction['wind direction in degrees']) + "\n"
#       )

