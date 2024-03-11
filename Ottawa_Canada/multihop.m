function result = multihop(topSatIndices)
    % Load the forecast data or run the forecast script
    % pyrun("forcast.py");

    % Define the optimal ranges for weather conditions
    temp_range = [-40, 80]; % Optimal temperature range in degrees Celsius
    humidity_range = [20, 80]; % Optimal humidity range in percentage
    precipitation_range = [1, 5]; % Optimal precipitation range in mm
    windspeed_range = [20, 50]; % Optimal wind speed range in km/hr

    sat1 = [-10.45, 45.1, 10, 1.57];
    sat2 = [-5.66, 52.13, 3, 4.39];
    sat3 = [-8.37, 68.94, 1, 2.49];

    disp = [sat1,sat2,sat3];

    % disp('hardcodeVal - multihop: ');
    % disp(selectedData);

    % Get the forecasted data
    data = getPredicVal();

    % Extract the data for the selected satellites
    selectedData = data(topSatIndices, :);

    % Initialize an array to store the scores for the selected satellites
    scores = zeros(size(selectedData, 1), 1);

    % Calculate scores for each selected satellite
    for i = 1:size(selectedData, 1)
        % Temperature score
        if data(i, 1) >= temp_range(1) && data(i, 1) <= temp_range(2)
            temp_score = 100; % Score of 100 if within optimal temperature range
        else
            temp_score = 0; % 0 score outside optimal range
        end
        
        % Humidity score
        if data(i, 2) >= humidity_range(1) && data(i, 2) <= humidity_range(2)
            humidity_score = 100 - data(i, 2); % Better scores for lower humidity
        else
            humidity_score = 0; % 0 score outside optimal range
        end
        
        % Precipitation score
        if data(i, 3) >= precipitation_range(1) && data(i, 3) <= precipitation_range(2)
            precip_score = 1 / (data(i, 3) + 1); % Better scores for lower precipitation
        else
            precip_score = 0; % 0 score outside optimal range
        end
        
        % Wind speed score
        if data(i, 4) >= windspeed_range(1) && data(i, 4) <= windspeed_range(2)
            wind_score = 1 / (data(i, 4) + 1); % Better scores for lower wind speed
        else
            wind_score = 0; % 0 score outside optimal range
        end
        
        % Calculate total score for each satellite (no station pressure)
        scores(i) = temp_score + humidity_score + precip_score + wind_score;
    end

    % Sort the satellites based on their weather scores
    [~, sortedIdx] = sort(scores, 'descend');

    % Select the top 2 satellites
    top_2_satellites = topSatIndices(sortedIdx(1:2));

    % Display the top 2 satellites
    % disp("Top 2 satellites for multihop:")
    disp(top_2_satellites);

    % Perform multihop logic using the best satellites
    result = top_2_satellites;
    
end