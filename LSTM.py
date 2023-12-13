# Name: Patrick Liu
# Student Number: 101142730

import os
from keras import models
from keras import layers
from keras.callbacks import Callback
from data_prep import trainX, trainY

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
MIN_LOSS = 0.0100

class MinLossCallback(Callback):
    def on_epoch_end(self, epoch, logs={}):
        if logs.get('loss') is not None and logs.get('loss') <= MIN_LOSS:
            print(f"Reached max accuracy of {MIN_LOSS}. Ending training")
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

print("Compiling the model...")
model.compile(
    loss='mse',
    optimizer='adam',
)
print("Finished compiling the model!")
# model.summary()

callbacks = [MinLossCallback()]

print("Fitting the training data onto the model...")
history = model.fit(trainX, trainY, batch_size=32, validation_split=0.1, verbose=2, callbacks=callbacks)
print("Finished fitting the model!")

model.save(os.path.join('models', 'model.h5'))

