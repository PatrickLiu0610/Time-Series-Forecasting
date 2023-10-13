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
## Using the Prediction Model

#### 1. Create the model by running the following command:
```
python LSTM.py
```
#### 2. Obtained the prediction result by running the following command:
```
python forcast.py 'YYYY-MM-DD HH:MM:SS'
```
Note: command supports multiple arguments, separate the date time with a space. Output data will be stored in "output.txt"
