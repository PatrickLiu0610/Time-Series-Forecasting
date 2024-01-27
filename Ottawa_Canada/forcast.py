# Name: Patrick Liu
# Student Number: 101142730

import os
import numpy as np
from Ottawa_Canada.data_prep import scaler, df_for_training
from Weather_API.open_weather_api import api_data_df
from keras import models

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

model = models.load_model(os.path.join('../models', 'ottawa_model.h5'))

api_data_scaled = scaler.transform(api_data_df)
scaled_data_array = np.array([api_data_scaled])

prediction = model.predict(scaled_data_array)
prediction_copies = np.repeat(prediction, df_for_training.shape[1], axis=-1)
y_pred_future = scaler.inverse_transform(prediction_copies)

if y_pred_future[0][2] < 0:
    y_pred_future[0][2] = 0.0


def get_prediction():
    forcast_weather = []

    for x in range(len(y_pred_future[0])):
        forcast_weather.append(y_pred_future[0][x])

    return forcast_weather


if __name__ == "__main__":
    print(get_prediction())
