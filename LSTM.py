# Name: Patrick Liu
# Student Number: 101142730

import os
from keras import models
from keras import layers
import tensorflow as tf
from data_prep import trainX, trainY

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
MAX_ACCURACY = 0.99

class MaxAccuracyCallback(tf.keras.callbacks.Callback):
    def on_epoch_end(self, epoch, logs={}):
        if logs.get('accuracy') is not None and logs.get('accuracy') > MAX_ACCURACY:
            print(f"Reached max accuracy of {MAX_ACCURACY}. Ending training")
            self.model.stop_training = True

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
    loss='mse',
    optimizer='adam',
)
# model.summary()

history = model.fit(trainX, trainY, batch_size=32, validation_split=0.1, verbose=2, callbacks=[MaxAccuracyCallback])

model.save(os.path.join('models', 'model.h5'))

