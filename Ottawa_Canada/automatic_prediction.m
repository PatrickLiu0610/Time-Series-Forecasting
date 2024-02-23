% author: Gabriel Evensen #101119814
% This script will run the get_prediction() function, and store the 
% resulting values in an array, 'result'.

% run forcast.py
pyrunfile("forcast.py");

% import the prediction function from forcast.py
pyrun("from forcast import get_prediction");

% store the get_prediction() result
result = pyrun("result = get_prediction()", "result");
disp(result)