# Name: Patrick Liu
# Student Number: 101142730

import os
import numpy as np
from sklearn.preprocessing import StandardScaler
from import_csv import df

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

cols = list(df)[1:15]
# Date Time columns are not used in training.
# print(cols)
df_for_training = df[cols].astype(float)

# standardize the dataset
scaler = StandardScaler()
scaler = scaler.fit(df_for_training)
df_for_training_scaled = scaler.transform(df_for_training)

# print(df_for_training_scaled)

# Empty lists to be populated using formatted training data
trainX = []
trainY = []

n_future = 1  # Number of hours we want to look into the future based on the past days.
n_past = 14  # Number of past hours we want to use to predict the future.

# print(df_for_training_scaled.shape)

for i in range(n_past, len(df_for_training_scaled) - n_future + 1):
    trainX.append(df_for_training_scaled[i - n_past:i, 0:df_for_training.shape[1]])
    trainY.append(df_for_training_scaled[i + n_future - 1:i + n_future, 0])

trainX, trainY = np.array(trainX), np.array(trainY)

# print('trainX shape == {}.'.format(trainX.shape))
# print('trainY shape == {}.'.format(trainY.shape))

