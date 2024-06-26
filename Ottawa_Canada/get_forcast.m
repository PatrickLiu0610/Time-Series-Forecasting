clear all;
close all;
%generate the model
%pyrunfile("LSTM.py");
existingGUIString = evalin('base', 'guiString');
guiString = "";

%run forcast.py
pyrunfile("forcast.py");

%import the prediction function from forcast.py
pyrun("from forcast import get_prediction");

%store the get_prediction() result
result = pyrun("result = get_prediction()", "result");
disp(result)


%%% my codee


% Convert the Python list to a MATLAB cell array
result_cell = cell(result);

% Convert each element to a double individually 
result_array = zeros(1, numel(result_cell)); % Preallocate for efficiency
for i = 1:numel(result_cell)
    result_array(i) = double(result_cell{i});
end

% Display the MATLAB array
disp(result_array);


disp(['Variable - Temp (°C):  ', num2str(result_array(1))]);
disp(['Variable - Rel Hum (%):  ', num2str(result_array(2))]);
disp(['Variable - Precip. Amount (mm):  ', num2str(result_array(3))]);
disp(['Variable - Wind Spd (km/h):  ', num2str(result_array(4))]);
disp(['Variable - Station Pressure (kPa):  ', num2str(result_array(5))]);

formattedString = ['Variable - Temp (°C):  ', num2str(result_array(1))];
guiString = [guiString formattedString];
guiString.append('\n');

formattedString2 = ['Variable - Rel Hum (%):  ', num2str(result_array(2))];
guiString = [guiString formattedString];
guiString.append('\n');

formattedString3 = ['Variable - Precip. Amount (mm):  ', num2str(result_array(3))];
guiString = [guiString formattedString];
guiString.append('\n');

formattedString4 = ['Variable - Wind Spd (km/h):  ', num2str(result_array(4))];
guiString = [guiString formattedString];
guiString.append('\n');

formattedString5 = ['Variable - Station Pressure (kPa):  ', num2str(result_array(5))];
guiString = [guiString formattedString];
guiString.append('\n');

guiString = [existingGUIString guiString];
assignin('caller', 'outString', guiString);

clear get_prediction result
