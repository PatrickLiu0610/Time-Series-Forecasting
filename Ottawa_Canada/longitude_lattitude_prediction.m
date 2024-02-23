% author: Gabriel Evensen #101119814
% This script will run the get_prediction_with_longitude_lattitude()
% function, and store the resulting values in an array, 'result'

% run forcast.py
pyrunfile("forcast.py");

% import the prediction function from forcast.py
pyrun("from forcast import get_prediction_with_coordinate");

% store the get_prediction_with_longitude_lattitude() result
result = pyrun("result = get_prediction_with_coordinate(latittude, longitude)", "result", latittude = 45.4, longitude = 75.7);
disp(result)