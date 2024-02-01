# Name: Patrick Liu
# Student Number: 101142730

import os
import numpy as np
from Ottawa_Canada.data_prep import scaler, df_for_training
from Weather_API.open_weather_api import api_data_df
from keras import models
import pandas as pd

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

model = models.load_model(os.path.join('../models', 'ottawa_model.h5'))


def perform_prediction(dataframe):
    api_data_scaled = scaler.transform(dataframe)
    scaled_data_array = np.array([api_data_scaled])

    prediction = model.predict(scaled_data_array)
    prediction_copies = np.repeat(prediction, df_for_training.shape[1], axis=-1)
    y_pred_future = scaler.inverse_transform(prediction_copies)

    if y_pred_future[0][2] < 0:
        y_pred_future[0][2] = 0.0

    if dataframe.loc[dataframe.index[0], 'Precip. Amount (mm)'] > 0:
        y_pred_future[0][2] = dataframe.loc[dataframe.index[0], 'Precip. Amount (mm)'] * 0.91

    return y_pred_future


def get_prediction():
    forcast_weather = []

    prediction = perform_prediction(api_data_df)

    for x in range(len(prediction[0])):
        forcast_weather.append(prediction[0][x])

    return forcast_weather


def get_prediction_with_input(temperature, humidity, precipitation, wind_speed, pressure):
    data = [{'Temp (°C)': temperature, 'Rel Hum (%)': humidity, 'Precip. Amount (mm)': precipitation,
             'Wind Spd (km/h)': wind_speed, 'Stn Press (kPa)': pressure}]

    weather_dataframe = pd.DataFrame(data).astype(float)
    prediction = perform_prediction(weather_dataframe)

    forcast_weather = []
    for x in range(len(prediction[0])):
        forcast_weather.append(prediction[0][x])

    return forcast_weather
