%generate the model
%pyrunfile("LSTM.py");

%run forcast.py
pyrunfile("forcast.py");

%import the prediction function from forcast.py
pyrun("from forcast import get_prediction");

%store the get_prediction() result
result = pyrun("result = get_prediction()", "result");
disp(result)