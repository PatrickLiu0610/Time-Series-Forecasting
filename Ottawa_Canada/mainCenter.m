% LINE 140 HAVE the 'BASE' VARIABLE CHANGED TO 'CALLER' FOR
% ERROR CORRECTION. IF YOU RUN INTO AN ERROR ON ANY OF THESE LINES CHANGE
% THE 'CALLER' TO 'BASE' ON THIS LINE
mainCenterString = ""; % String for the GS links
linkBudgetString = ""; % String for getting the Satellites using the Weather Prediction
commsLinkString = ""; % String for calling the link 

mainString = "";
guiString = "";
close all;

fprintf('------------------------------------------------------------------------------- \n');

startTime = datetime(2023,10,21,12,13,0);

stopTime = startTime + hours(2) + minutes(15);
sampleTime = 60;
sc = satelliteScenario(startTime,stopTime,sampleTime);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Satellite 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semiMajorAxis = 8371000;                                                                  % meters
eccentricity = 0;
inclination = 95;                                                                          % degrees
rightAscensionOfAscendingNode = 320;                                                         % degrees
argumentOfPeriapsis = 0;                                                                   % degrees
trueAnomaly = 0;                                                                            % degrees
sat1 = satellite(sc,semiMajorAxis,eccentricity,inclination,rightAscensionOfAscendingNode, ...
    argumentOfPeriapsis,trueAnomaly,Name="Satelitte 1");

gimbalrxSat1 = gimbal(sat1);
gimbaltxSat1 = gimbal(sat1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Satellite 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semiMajorAxis = 8371000;                                                                   % meters
eccentricity = 0;
inclination = 95;                                                                           % degrees
rightAscensionOfAscendingNode = 120;                                                        % degrees
argumentOfPeriapsis = 0;                                                                    % degrees
trueAnomaly = 0;                                                                            % degrees
sat2 = satellite(sc,semiMajorAxis,eccentricity,inclination,rightAscensionOfAscendingNode, ...
    argumentOfPeriapsis,trueAnomaly,Name="Satelitte 2");

gimbalrxSat2 = gimbal(sat2);
gimbaltxSat2 = gimbal(sat2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Satellite 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semiMajorAxis = 8371000;                                                                  % meters
eccentricity = 0;
inclination = 95;                                                                          % degrees
rightAscensionOfAscendingNode = 520;                                                         % degrees
argumentOfPeriapsis = 0;                                                                   % degrees
trueAnomaly = -160;                                                                        % degrees
sat3 = satellite(sc,semiMajorAxis,eccentricity,inclination,rightAscensionOfAscendingNode, ...
    argumentOfPeriapsis,trueAnomaly,Name="Satelitte 3");

gimbalrxSat3 = gimbal(sat3);
gimbaltxSat3 = gimbal(sat3);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Receving antennas of satellites %%%%%%%%%%%%%%%%
gainToNoiseTemperatureRatio = 5;                                                        % dB/K
systemLoss = 3;                                                                         % dB
rxSat1 = receiver(gimbalrxSat1,Name="Satellite 1 Receiver",GainToNoiseTemperatureRatio= ...
    gainToNoiseTemperatureRatio,SystemLoss=systemLoss);
rxSat2 = receiver(gimbalrxSat2,Name="Satellite 2 Receiver",GainToNoiseTemperatureRatio= ...
    gainToNoiseTemperatureRatio,SystemLoss=systemLoss);
rxSat3 = receiver(gimbalrxSat3,Name="Satellite 3 Receiver",GainToNoiseTemperatureRatio= ...
    gainToNoiseTemperatureRatio,SystemLoss=systemLoss);

%%%%%%%%%%%%%%%%%%%%%%%%%%% transmitting antennas of satellites %%%%%%%%%%%%%%%%
frequency = 27e9;                                                                     % Hz
power = 20;                                                                           % dBW
bitRate = 20;                                                                         % Mbps
systemLoss = 3;                                                                       % dB
txSat1 = transmitter(gimbaltxSat1,Name="Satellite 1 Transmitter",Frequency=frequency, ...
    power=power,BitRate=bitRate,SystemLoss=systemLoss);
txSat2 = transmitter(gimbaltxSat2,Name="Satellite 2 Transmitter",Frequency=frequency, ...
    power=power,BitRate=bitRate,SystemLoss=systemLoss);
txSat3 = transmitter(gimbaltxSat3,Name="Satellite 3 Transmitter",Frequency=frequency, ...
    power=power,BitRate=bitRate,SystemLoss=systemLoss);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% transmit and receive antenna properties %%%%%%%%
dishDiameter = 0.5;                                                                    % meters
apertureEfficiency = 0.5;
gaussianAntenna(txSat1,DishDiameter=dishDiameter,ApertureEfficiency=apertureEfficiency);
gaussianAntenna(rxSat1,DishDiameter=dishDiameter,ApertureEfficiency=apertureEfficiency);
gaussianAntenna(txSat2,DishDiameter=dishDiameter,ApertureEfficiency=apertureEfficiency);
gaussianAntenna(rxSat2,DishDiameter=dishDiameter,ApertureEfficiency=apertureEfficiency);
gaussianAntenna(txSat3,DishDiameter=dishDiameter,ApertureEfficiency=apertureEfficiency);
gaussianAntenna(rxSat3,DishDiameter=dishDiameter,ApertureEfficiency=apertureEfficiency);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ground stations %%%%%%%%%%%%%%%%%%%%%%%%


% Data for provinces for Gs1
disp("provIndx1: "+provinceIndex1);
provinces = {'British Columbia', 'Alberta', 'Saskatchewan'}; 

latitudes = [53.726669, 55, 55]; 
longitudes = [-127.647621, -115, -106];

% Display list of provinces
for i = 1:length(provinces)
    disp([num2str(i), '. ', provinces{i}]);
end

% Get user input (based on number from the list)
% provinceIndex = input('Enter the number of the desired province from the list for ground station 1: ');

% Validate input
while provinceIndex1 < 1 || provinceIndex1 > length(provinces)
    disp('Incorrect province number. Please try again.');
    provinceIndex = input('Enter the number of the desired province from the list for ground station 1: ');
end

% Assign coordinates to GS1
latitudeGs1 = latitudes(provinceIndex1);
longitudeGs1 = longitudes(provinceIndex1);

latitudeGs1
longitudeGs1


gs1 = groundStation(sc,latitudeGs1,longitudeGs1,Name="Ground Station 1");


% Data for provinces for Gs2
disp("provIndx2: "+provinceIndex2);
provinces = {'Manitoba', 'Ontario', 'Quebec'}; 

latitudes = [56.415211,50.000000, 	53.000000]; 
longitudes = [-98.739075,-85.000000, -70.000000];

% Display list of provinces
for i = 1:length(provinces)
    disp([num2str(i), '. ', provinces{i}]);
end

% Get user input (based on number from the list)
% provinceIndex = input('Enter the number of the desired province from the list for ground station 2: ');

% Validate input
while provinceIndex2 < 1 || provinceIndex2 > length(provinces)
    disp('Incorrect province number. Please try again.');
    provinceIndex = input('Enter the number of the desired province from the list for ground station 2: ');
end

% Assign coordinates to GS2
latitudeGs2 = latitudes(provinceIndex2);
longitudeGs2 = longitudes(provinceIndex2);

latitudeGs2
longitudeGs2

gs2 = groundStation(sc,latitudeGs2,longitudeGs2,Name="Ground Station 2");

gimbalgs1 = gimbal(gs1);
gimbalgs2 = gimbal(gs2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% transmitting antenna of GS1 %%%%%%%%%%%%%%%%
frequency = 30e9;                                                                          % Hz
power = 40;                                                                                % dBW
bitRate = 20;                                                                              % Mbps
txGs1 = transmitter(gimbalgs1,Name="Ground Station 1 Transmitter",Frequency=frequency, ...
        Power=power,BitRate=bitRate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% receiving antenna of GS2 %%%%%%%%%%%%%%%%
requiredEbNo = 14;                                                                     % dB
rxGs2 = receiver(gimbalgs2,Name="Ground Station 2 Receiver",RequiredEbNo=requiredEbNo);


%%%%%%%%%%%%%%% transmit and receive antennas properties of GSs %%%%%%%%%%%%%%%%
dishDiameter = 5;                                % meters
gaussianAntenna(txGs1,DishDiameter=dishDiameter);
gaussianAntenna(rxGs2,DishDiameter=dishDiameter);

%%%%%%%%%%%%%%%%%%%%%%%%% antenna pointings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pointAt(gimbalgs1,sat1); % Aim Ground Station 1 towards Satellite 1
pointAt(gimbalrxSat1,gs1); % Aim Satellite 1's receiver towards Ground Station 1
pointAt(gimbaltxSat1,gs2); % Aim Satellite 1's transmitter towards Ground Station 2
pointAt(gimbalgs2, sat1); % Aim Ground Station 2 towards Satellite 1

pointAt(gimbalgs1,sat2);  % Aim Ground Station 1 towards Satellite 2
pointAt(gimbalrxSat2,gs1); % Aim Satellite 2's receiver towards Ground Station 1
pointAt(gimbaltxSat2,gs2); % Aim Satellite 2's transmitter towards Ground Station 2
pointAt(gimbalgs2, sat2); % Aim Ground Station 2 towards Satellite 2

pointAt(gimbalgs1, sat3); % Aim Ground Station 1 towards Satellite 3
pointAt(gimbalrxSat3, gs1); % Aim Satellite 3's receiver towards Ground Station 1
pointAt(gimbaltxSat3, gs2); % Aim Satellite 3's transmitter towards Ground Station 2
pointAt(gimbalgs2, sat3); % Aim Ground Station 2 towards Satellite 3

%%%%%%%%%%%%%%%%%%%%% Getting best satellites from weatherStation %%%%%%%%%%%%%%%%

% Set the desired number of satellites 
numSat = 3;

[bestSats, weatherData]= linkBudget(numSat);
satellites = cell(1, numel(bestSats)); % Convert to row array

% Get best satellite names
for i = 1:numel(bestSats)
    satellites{i} = ['sat' num2str(bestSats(i))];
end
bestSatsName = cellfun(@(x) evalin('caller', x), satellites);

s = bestSatsName;     % list of all good weather satellites


%%%%%%%%%%%%%%%%%% Link assigning to GSs and Satellites %%%%%%%%%%%%%%%%
ac = access(gs1, s, gs2); 
acinterval = accessIntervals(ac);
linkNumber = size(acinterval, 1);


%%%%%%%% Getting start and end times for each satellite GSs links %%%%%%%%%
for i = 1:linkNumber

    % Extract the times from the ith row of the table
    startTimes = acinterval.StartTime(i);
    endTimes = acinterval.EndTime(i);
    duration = endTimes - startTimes;

    % Format and append strings
    formattedString1 = sprintf('Running commLink.m for link %d:\n', i);
    mainString = [mainString formattedString1];
    
    formattedString2 = sprintf('Start Time: %s\n', startTimes);
    mainString = [mainString formattedString2];
    
    formattedString3 = sprintf('End Time: %s\n', endTimes);
    mainString = [mainString formattedString3];
    
    mainString = [mainString '------------------------------------------------------------------------------- \n'];

    % Append newline character
    %mainString = [mainString '\n'];
    % guiString = [guiString mainString];
    % assignin('caller', 'outString', linkBudgetString);

end
guiString = [guiString mainString];
fprintf('------------------------------------------------------------------------------- \n');
guiString = [linkBudgetString guiString];

if numel(s) > 1

    for i = 1:linkNumber-1

    % Extract the times from the ith row of the table
    startTimes = acinterval.StartTime(i+1);
    endTimes = acinterval.EndTime(i);
    duration = endTimes - startTimes;


    end

end


lat1 = deg2rad(latitudeGs1);  % Convert degrees to radians
lon1 = deg2rad(longitudeGs1);
lat2 = deg2rad(latitudeGs2);
lon2 = deg2rad(longitudeGs2);

R = 6371E3;

dlon = lon2 - lon1;
dlat = lat2 - lat1;

a = sin(dlat/2) * sin(dlat/2) + cos(lat1) * cos(lat2) * sin(dlon/2) * sin(dlon/2);
c = 2 * atan2(sqrt(a), sqrt(1-a));

locDistance = R * c; %Meters
disp(['Distance (meters): ', num2str(locDistance)])
midDis = locDistance/2;
satDist = 2000E3;


%%%%%%%%%%%% Calling link code as many times as satellites available %%%%%
for i = 1:numel(s)
    % Call the MATLAB file "linkSingleHop.m"

    % Single Hop
    images = linkSingleHop(weatherData(i,:));
    
    % Image Display
    iText = imresize(imread("text/iText.png"), [height(images{1}), width(images{1})]);
    ibText = imresize(imread("text/ibText.png"), [height(images{1}), width(images{1})]);
    oText = imresize(imread("text/oText.png"), [height(images{1}), width(images{1})]);
    
    finalImages = {iText images{1} ibText images{2} oText images{3}};
    % figure("Name","Images");
    tiledImage = imtile(finalImages, 'GridSize', [3 2]);
    % img = imshow(tiledImage);
    imwrite(tiledImage, "./out/sat"+i+"Img.jpg", "jpg");
    assignin('caller', "outputImage"+i, 0);


end

totalDist = (sqrt((midDis^2) + (satDist^2))) * 2;
dP = (totalDist/(3*10^8))*10^3;
disp('Calculating delay:');
disp("Prop Delay = " + dP + " ms");

dT = ((numel(images{1})/(250E6))*2)*10^3;
disp("Transmission Time = " + dT + " ms");
totalDelay = dP + dT;
disp("Total Delay = " + totalDelay + " ms");

% Format and append strings
formattedString4 = sprintf('Calculating delay:\n');
mainString = [mainString formattedString4];

formattedString5 = sprintf("Prop Delay = %d ms \n", dP);
mainString = [mainString formattedString5];

formattedString6 = sprintf('Transmission Time = %d ms \n', dT);
mainString = [mainString formattedString6];

formattedString7 = sprintf("Total Delay = %d ms \n", totalDelay);
mainString = [mainString formattedString7];

formattedString8 = sprintf("RUN SINGLE-HOP COMPLETE \n");
mainString = [mainString formattedString8];

mainString = [mainString '------------------------------------------------------------------------------- \n'];
guiString = [guiString mainString];
guiString = [guiString commsLinkString];
assignin('caller', 'outString', guiString);


%%%%%%%%%%%%%%%%%%%%%%%%%% Earth graphics %%%%%%%%%%%%%%%%%%%%%%%%%%%%
play(sc);
% close all;