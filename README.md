## Running Tensorflow with GPU on Windows Native Environment

#### 1. Ensure your Nvidia GPU has the required compute capability: https://developer.nvidia.com/cuda-gpus

#### 2. Install the latest driver for your Nvidia GPU: https://www.nvidia.com/Download/index.aspx

#### 3. Install Anaconda: https://www.anaconda.com/download

#### 4. Run the following commands in Anaconda Prompt:
```
conda create --name tensorflowgpu python=3.10
conda activate tensorflowgpu
conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0
pip install tensorflow==2.10
pip install numpy==1.26.0
pip install pandas
pip install -U scikit-learn
```
Note: pip might throw dependency errors since it automatically upgrades certain packages during installation, downgrade them if the version number is too high

#### 5. Verify tensorflow can detect your GPU by running the following command:
```
python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
```
## Using the Jena_Germany Prediction Model

#### 1. Create the model by running the following command:
```
python Jena_Germany/LSTM.py
```
#### 2. Obtained the prediction result by calling function "get_prediction" from forcast.py:
```
get_prediction(["YYYY-MM-DD HH:MM:SS", "YYYY-MM-DD HH:MM:SS", ...])
```
#### Return format:
```
[{'Date Time': '2024-01-16T12:00:00.000000000', 'Pressure': 998.18726, 'Temperature in Degree': 18.494009, 
'Temperature in Kelvin': 292.62372, 'temperature dew point': 12.183469, 'relative humidity': 93.700836, 
'saturation vapor pressure': 21.885607, 'vapor pressure': 14.027145, 'vapor pressure deficit': 9.299135, 
'specific humidity': 8.8748255, 'water vapor concentration': 14.188606, 'airtight': 1258.99, 'wind speed': 3.7843738, 
'maximum wind speed': 6.0429506, 'wind direction in degrees': 267.67197}, {...}, ...]
```
## Using the Ottawa_Canada Prediction Model
#### 1. Create the model by running the following command:
```
python Ottawa_Canada/LSTM.py
```
#### 2. Obtained the prediction result by calling function "get_prediction" from forcast.py:
```
get_prediction()
```
#### Return format:
```
[0.77169657, 61.60594, 0.0, 8.173939, 100.1585]
```
The values in the list represents Temp (°C), Rel Hum (%), Precip. Amount (mm), Wind Spd (km/h), 'Station Pressure (kPa)' 
respectively