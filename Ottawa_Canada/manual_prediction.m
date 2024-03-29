function result_array = manual_prediction(temperature, humidity, precipitaiton, wind_speed, pressure)
    existingGUIString = "";
    manualPredictionGUIString = "";
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
        "wind_speed, pressure)", "result", temperature = temperature, humidity = humidity, ...
        precipitation = precipitaiton, wind_speed = wind_speed, pressure = pressure);
    disp(result)

    %%% --------------Author: Farhat Ishhaq #101167972 -----------------
    
    
    % Convert the Python list to a MATLAB cell array
    result_cell = cell(result);
    
    % Convert each element to a double individually 
    result_array = zeros(1, numel(result_cell)); % Preallocate for efficiency
    for i = 1:numel(result_cell)
        result_array(i) = double(result_cell{i});
    end
    
    disp('-------------------------------------------------------------------------------');    
    % disp(['Variable - Temp (°C):  ', num2str(result_array(1))]);
    % disp(['Variable - Rel Hum (%):  ', num2str(result_array(2))]);
    % disp(['Variable - Precip. Amount (mm):  ', num2str(result_array(3))]);
    % disp(['Variable - Wind Spd (km/h):  ', num2str(result_array(4))]);
    % disp(['Variable - Station Pressure (kPa):  ', num2str(result_array(5))]);
    % disp('-------------------------------------------------------------------------------');
    formattedString = ['Variable - Temp (°C):  ', num2str(result_array(1))];
    manualPredictionGUIString = [formattedString];
    % manualPredictionGUIString.append('\n');
    
    formattedString2 = ['Variable - Rel Hum (%):  ', num2str(result_array(2))];
    manualPredictionGUIString = [manualPredictionGUIString formattedString2];
    % manualPredictionGUIString.append('\n');
    
    formattedString3 = ['Variable - Precip. Amount (mm):  ', num2str(result_array(3))];
    manualPredictionGUIString = [manualPredictionGUIString formattedString3];
    % manualPredictionGUIString.append('\n');
    
    formattedString4 = ['Variable - Wind Spd (km/h):  ', num2str(result_array(4))];
    manualPredictionGUIString = [manualPredictionGUIString formattedString4];
    % manualPredictionGUIString.append('\n');
    
    formattedString5 = ['Variable - Station Pressure (kPa):  ', num2str(result_array(5))];
    manualPredictionGUIString = [manualPredictionGUIString formattedString5];
    % manualPredictionGUIString.append('\n');
    
    manualPredictionGUIString = [manualPredictionGUIString existingGUIString];
    assignin('caller', 'linkBudgetString', manualPredictionGUIString);
    disp('-------------------------------------------------------------------------------');    


end