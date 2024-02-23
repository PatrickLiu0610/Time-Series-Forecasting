% author: Gabriel Evensen #101119814
% This script will run the get_prediction_with_inputs() function, and store the 
% resulting values in an array, 'result'.

% run forcast.py
pyrunfile("forcast.py");

% import the manual prediction function from forcast.py
pyrun("from forcast import get_prediction_with_input");

% store the get_prediction_with_input() result
% the temperature, humidity, precipitaiton, wind speed and pressure are
% static for now. Once I find where they are calculated I will replace the
% values
result = pyrun("result = get_prediction_with_input(temperature, humidity, precipitation, " + ...
    "wind_speed, pressure)", "result", temperature = 100, humidity = 100, ...
    precipitation = 100, wind_speed = 100, pressure = 100);
disp(result)