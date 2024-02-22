%generate the model
%pyrunfile("LSTM.py");

%run forcast.py
pyrunfile("forcast.py");

%import the prediction function from forcast.py
pyrun("from forcast import get_prediction, get_prediction_with_input");

x = input('Are you using manual entry? (y/n) ', 's');

%manually get the weater prediction
if strcmp(x,'y')
    temperature = input('Enter the temperature: ');
    humidity = input('Enter the humidity: ');
    precipitation = input('Enter the precipitation: ');
    wind_speed = input('Enter the wind speed: ');
    pressure = input('Enter the pressure: ');
    result = pyrun("result = get_prediction_with_input(t, h, p, ws, pr)", "result", t=temperature, h=humidity, p=precipitation, ws=wind_speed, pr=pressure);

%automatically get the weather prediction
else
    result = pyrun("result = get_prediction()", "result");
end

disp(result);




