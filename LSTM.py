# Name: Patrick Liu
# Student Number: 101142730

import os
from keras import models
from keras import layers
from keras import losses
from data_prep import trainX, trainY

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

model = models.Sequential()
model.add(layers.LSTM(128,
                      activation='tanh',
                      input_shape=(trainX.shape[1], trainX.shape[2]),
                      return_sequences=True))
model.add(layers.LSTM(64,
                      activation='tanh',
                      return_sequences=True))
model.add(layers.LSTM(32,
                      activation='tanh',
                      return_sequences=False))
model.add(layers.Dropout(0.2))
model.add(layers.Dense(trainY.shape[1]))

model.compile(
    loss=losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer='adam',
    metrics=["accuracy"]
)
# model.summary()

history = model.fit(trainX, trainY, batch_size=32, epochs=5, validation_split=0.1, verbose=2)

model.save(os.path.join('models', 'model.h5'))

