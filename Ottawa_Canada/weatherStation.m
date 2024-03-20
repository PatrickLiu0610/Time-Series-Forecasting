function [bestSatIndexArrayToSend, dataRequiredToSend] = weatherStation(numSat)
    linkBudgetGUIString = "";
    % Empty array to store the results
    data = [];

    % Loop numSat value times
    for i = 1:numSat
        
        % Random values to be generated for the weather components within
        % the specified ranges

        randomTemp = randi([-40 80]);
        randomHumidity = randi([20 80]);
        randomPrecipitation = randi([1 5]);
        randomWind_speed = randi([20 50]);
        randomPressure = randi([80 100]);
        
        % Call the python weather "manual_prediction()" function
        result = manual_prediction(randomTemp,randomHumidity,randomPrecipitation,randomWind_speed,randomPressure);

        % Append the result to above array
        data = [data; result];
        assignin('caller', 'guiStringC', linkBudgetGUIString);
    end    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    temp_range = [-40, 80]; % Optimal temperature range in degrees Celsius
    humidity_range = [20, 80]; % Optimal humidity range in percentage
    precipitation_range = [1, 5]; % Optimal precipitation range in mm
    windspeed_range = [20, 50]; % Optimal wind speed range in km/hr

    scores = zeros(size(data, 1), 1);
    for i = 1:size(data, 1)
        % Temperature score
        if data(i, 1) >= temp_range(1) && data(i, 1) <= temp_range(2)
            temp_score = 100; % Score of 100 if within optimal temperature range
        else
            temp_score = 0; % 0 Score outside optimal range
        end
        
        % Humidity score
        if data(i, 2) >= humidity_range(1) && data(i, 2) <= humidity_range(2)
            humidity_score = 100 - data(i, 2); % Better scores for lower humidity
        else
            humidity_score = 0; % 0 Score outside optimal range
        end
        
        % Precipitation score
        if data(i, 3) >= precipitation_range(1) && data(i, 3) <= precipitation_range(2)
            precip_score = 1 / (data(i, 3) + 1); % Better scores for lower precipitation
        else
            precip_score = 0; % 0 Score outside optimal range
        end
        
        % Wind speed score
        if data(i, 4) >= windspeed_range(1) && data(i, 4) <= windspeed_range(2)
            wind_score = 1 / (data(i, 4) + 1); % Better scores for lower wind speed
        else
            wind_score = 0; % 0 Score outside optimal range
        end
        
        % Calculate total score for each satellite (no station pressure)
        scores(i) = temp_score + humidity_score + precip_score + wind_score;
    end

    % Sort the satellites number based on their weather scores
    [sorted_scores, idx] = sort(scores, 'descend');
    
    % Select the best satellites (50%)
    top_2_satellites = idx(1:floor(numSat/2)+1);
    disp('-------------------------------------------------------------------------------');
    disp(['Number of satellites passed to weather station: ', num2str(numSat)]);
    
    % Print the list of satellites with positive link margins  
    fprintf("Best 2 satellites from weather station are: \n");
    for i=1:numel(top_2_satellites)
        fprintf('Satellite %d \n', top_2_satellites(i,1));
    end
    disp('-------------------------------------------------------------------------------');

    result = top_2_satellites;

    
    % Fetching the selected satellite's weather data
    
    combinedDataResult = {data, result};
    dataArray = combinedDataResult{1};  
    bestSatIndexArray = combinedDataResult{2};

    bestSatIndexArrayToSend = sort(bestSatIndexArray, 'ascend');
    dataRequiredToSend = [];

    for i = 1:size(bestSatIndexArrayToSend, 1)  % Iterate over each row
        rowIndex = bestSatIndexArrayToSend(i);
        rowToPrint = dataArray(rowIndex, :);
        dataRequiredToSend = [dataRequiredToSend; rowToPrint];
    end

end
