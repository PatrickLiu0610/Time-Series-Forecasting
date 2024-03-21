close all;

startTime = datetime(2023,10,21,1,13,0);
stopTime = startTime + hours(3);
sampleTime = 60;
sc = satelliteScenario(startTime,stopTime,sampleTime);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Satellite 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semiMajorAxis = 8371000;                  % meters
eccentricity = 0;
inclination = -40;                           % degrees
rightAscensionOfAscendingNode = 80;         % degrees
argumentOfPeriapsis = 0;                   % degrees
trueAnomaly = 275;                           % degrees
sat1 = satellite(sc, ...
    semiMajorAxis, ...
    eccentricity, ...
    inclination, ...
    rightAscensionOfAscendingNode, ...
    argumentOfPeriapsis, ...
    trueAnomaly, ...
    "Name","Satellite 1");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Satellite 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semiMajorAxis = 8371000;                  % meters
eccentricity = 0;
inclination = -50;                          % degrees
rightAscensionOfAscendingNode = 120;       % degrees
argumentOfPeriapsis = 0;                   % degrees
trueAnomaly = 250;                         % degrees
sat2 = satellite(sc, ...
    semiMajorAxis, ...
    eccentricity, ...
    inclination, ...
    rightAscensionOfAscendingNode, ...
    argumentOfPeriapsis, ...
    trueAnomaly, ...
    "Name","Satellite 2");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Satellite 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semiMajorAxis = 8371000;                  % meters
eccentricity = 0;
inclination = -40;                          % degrees
rightAscensionOfAscendingNode = 120;       % degrees
argumentOfPeriapsis = 0;                   % degrees
trueAnomaly = 250;                         % degrees
sat3 = satellite(sc, ...
    semiMajorAxis, ...
    eccentricity, ...
    inclination, ...
    rightAscensionOfAscendingNode, ...
    argumentOfPeriapsis, ...
    trueAnomaly, ...
    "Name","Satellite 3");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Satelitte Gimbals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gimbalSat1Tx = gimbal(sat1, ...
    "MountingLocation",[0;1;2]);  % meters
gimbalSat2Tx = gimbal(sat2, ...
    "MountingLocation",[0;1;2]);  % meters
gimbalSat1Rx = gimbal(sat1, ...
    "MountingLocation",[0;-1;2]); % meters
gimbalSat2Rx = gimbal(sat2, ...
    "MountingLocation",[0;-1;2]); % meters
gimbalSat3Rx = gimbal(sat3, ...
    "MountingLocation",[0;-1;2]); % meters
gimbalSat3Tx = gimbal(sat3, ...
    "MountingLocation",[0;1;2]); % meters

%%%%%%%%%%%%%%%%%%%%%%%%%%% Receving Antennas of Satellites %%%%%%%%%%%%%%%%
sat1Rx = receiver(gimbalSat1Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",23, ... % decibels/Kelvin
    "RequiredEbNo",7);                   % decibels
sat2Rx = receiver(gimbalSat2Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",23, ... % decibels/Kelvin
    "RequiredEbNo",7);                   % decibels
sat3Rx = receiver(gimbalSat3Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",23, ... % decibels/Kelvin
    "RequiredEbNo",7);                   % decibels

%%%%%%%%%%%%%%%%%%%%%%%%%%% Transmitting Antennas Porperties %%%%%%%%%%%%%%%%
sat1Tx = transmitter(gimbalSat1Tx, ...
    "MountingLocation",[0;0;1], ...   % meters
    "Frequency",30e9, ...             % hertz
    "Power",15);                      % decibel watts
sat2Tx = transmitter(gimbalSat2Tx, ...
    "MountingLocation",[0;0;1], ...   % meters
    "Frequency",27e9, ...             % hertz
    "Power",15);                      % decibel watts
sat3Tx = transmitter(gimbalSat3Tx, ...
    "MountingLocation",[0;0;1], ...   % meters
    "Frequency",27e9, ...             % hertz
    "Power",15);                      % decibel watts

gaussianAntenna(sat1Tx, ...
    "DishDiameter",0.5);    % meters
gaussianAntenna(sat2Tx, ...
    "DishDiameter",0.5);    % meters
gaussianAntenna(sat3Tx, ...
    "DishDiameter",0.5);    % meters

%%%%%%%%%%%%%%%%%%%%%%%% Receiveing Antenna Properties %%%%%%%%%%%%%%%%%%%%
sat1Rx = receiver(gimbalSat1Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",0, ... % decibels/Kelvin
    "RequiredEbNo",7);                   % decibels
sat2Rx = receiver(gimbalSat2Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",0, ... % decibels/Kelvin
    "RequiredEbNo",7);                   % decibels
sat3Rx = receiver(gimbalSat3Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",0, ... % decibels/Kelvin
    "RequiredEbNo",7);                   % decibels

gaussianAntenna(sat1Rx, ...
    "DishDiameter",0.5);    % meters
gaussianAntenna(sat2Rx, ...
    "DishDiameter",0.5);    % meters
gaussianAntenna(sat3Rx, ...
    "DishDiameter",0.5);    % meters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ground Stations %%%%%%%%%%%%%%%%%%%%%%%%

% Data for provinces for Gs1

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


gs1 = groundStation(sc,latitudeGs1,longitudeGs1,Name="Ground Station 1");

% Data for provinces for Gs2

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


gs2 = groundStation(sc,latitudeGs2,longitudeGs2,Name="Ground Station 2");

gimbalgs1 = gimbal(gs1);
gimbalgs2 = gimbal(gs2);


gimbalGs1 = gimbal(gs1, ...
    "MountingAngles",[0;180;0], ... % degrees
    "MountingLocation",[0;0;-5]);   % meters
gimbalGs2 = gimbal(gs2, ...
    "MountingAngles",[0;180;0], ... % degrees
    "MountingLocation",[0;0;-5]);   % meters


gs1Tx = transmitter(gimbalGs1, ...
    "Name","Ground Station 1 Transmitter", ...
    "MountingLocation",[0;0;1], ...           % meters
    "Frequency",30e9, ...                     % hertz
    "Power",30);                              % decibel watts


gaussianAntenna(gs1Tx, ...
    "DishDiameter",2); % meters


gs2Rx = receiver(gimbalGs2, ...
    "Name","Ground Station 2 Receiver", ...
    "MountingLocation",[0;0;1], ...        % meters
    "GainToNoiseTemperatureRatio",20, ...   % decibels/Kelvin
    "RequiredEbNo",12);                     % decibels

gaussianAntenna(gs2Rx, ...
    "DishDiameter",2); % meters


%%%%%%%%%%%%%%%%%%%%%%%%% Antenna Pointings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the desired number of satellites 
numSat = 3;

[bestSats, weatherData]= linkBudget(numSat);


% bestSats = middleMan(3);
satellites = cell(1, numel(bestSats)); % Convert to row array
transmitters = cell(1,1); % Convert to row array
% Get best satellite names
for i = 1:numel(bestSats)
    satellites{i} = ['sat' num2str(bestSats(i))];
end

bestSatsName = cellfun(@(x) evalin('caller', x), satellites);
disp(bestSatsName);

% Get best satellite Receivers and Transmitters

for i = 1:length(bestSats)
    transmitter{i} = ['sat', num2str(bestSats(i)), 'Tx'];
end

transmitters = cellfun(@(x) evalin('caller', x), transmitter);
disp(transmitters);

for i = 1:length(bestSats)
    receiver{i} = ['sat', num2str(bestSats(i)), 'Rx'];
end

receivers = cellfun(@(x) evalin('caller', x), receiver);
disp(receivers)


% Get best satellite gimbals

for i = 1:length(bestSats)
    gimbalTx{i} = ['gimbalSat', num2str(bestSats(i)), 'Tx'];
end

gimbalTxs = cellfun(@(x) evalin('caller', x), gimbalTx);
disp(gimbalTxs);

for i = 1:length(bestSats)
    gimbalRx{i} = ['gimbalSat', num2str(bestSats(i)), 'Rx'];
end

gimbalRxs = cellfun(@(x) evalin('caller', x), gimbalRx);
disp(gimbalRxs)




if numel(bestSats)>=2

    bestSat1 = bestSatsName(1);
    bestSat1Rx = receivers(1);
    bestSat1Tx = transmitters(1);
    
    bestSat2 = bestSatsName(2);
    bestSat2Rx = receivers(2);
    bestSat2Tx = transmitters(2);
    
    gimbalbestSat1Tx = gimbalTxs(1);
    gimbalbestSat1Rx = gimbalRxs(1);
    gimbalbestSat2Tx = gimbalTxs(2);
    gimbalbestSat2Rx = gimbalRxs(2);
    
    pointAt(gimbalGs1,bestSat1);
    pointAt(gimbalbestSat1Rx,gs1);
    pointAt(gimbalbestSat1Tx,bestSat2);
    pointAt(gimbalbestSat2Rx,bestSat1);
    pointAt(gimbalbestSat2Tx,gs2);
    pointAt(gimbalGs2,bestSat2);
else
    
    bestSat1 = bestSatsName(1);
    bestSat1Rx = receivers(1);
    bestSat1Tx = transmitters(1);

    gimbalbestSat1Tx = gimbalTxs(1);
    gimbalbestSat1Rx = gimbalRxs(1);

    pointAt(gimbalGs1,bestSat1);
    pointAt(gimbalbestSat1Rx,gs1);
    pointAt(gimbalbestSat1Tx,gs2);
    pointAt(gimbalGs2,bestSat1);

end







if numel(bestSats)==1
    % Define link configurations in separate link objects
    link_config1 = link(gs1Tx, bestSat1Rx);
    link_config2 = link(bestSat1Tx, gs2Rx);

    % Create a cell array to hold link configurations
    link_configurations = {link_config1, link_config2};

    lnk = cat(1, link_configurations{:});  % Concatenate links horizontally
else
    % Define link configurations in separate link objects
    link_config1 = link(gs1Tx, bestSat1Rx);
    link_config2 = link(bestSat1Tx, bestSat2Rx);
    link_config3 = link(bestSat2Tx, gs2Rx);

    % Create a cell array to hold link configurations
    link_configurations = {link_config1, link_config2, link_config3};

    lnk = cat(2, link_configurations{:});  % Concatenate links horizontally
end


%%%%%%%%%%%% Calling link code as many times as satellites available %%%%%

% Call the MATLAB file "linkSingleHop.m"

images = linkMultiHop(numel(bestSats),weatherData);

% Image Display
iText = imresize(imread("text/iText.png"), [height(images{1}), width(images{1})]);
ibText = imresize(imread("text/ibText.png"), [height(images{1}), width(images{1})]);
oText = imresize(imread("text/oText.png"), [height(images{1}), width(images{1})]);

finalImages = {iText images{1} ibText images{2} oText images{3}};
% figure("Name","Images");
tiledImage = imtile(finalImages, 'GridSize', [3 2]);
% img = imshow(tiledImage);
imwrite(tiledImage, "./out/sat1Img.jpg", "jpg");
assignin('caller', "outputImage1", 0);


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

totalDist = (sqrt((midDis^2) + (satDist^2))) * 2;
dP = (totalDist/(3*10^8))*10^3;
fprintf('Calculating delay for Satellite %d \n', bestSats(i,1));
disp("Prop Delay = " + dP + " ms");
dT = (numel(images{1})/(250E6))*10^3;
disp("Transmission Time = " + dT + " ms");
disp("Total Delay = " + (dP + dT) + " ms");




% Perform link analysis with linkIntervals
link = linkIntervals(lnk);

%%%%%%%%%%%%%%%%%%%%%%%%%% Earth Graphics %%%%%%%%%%%%%%%%%%%%%%%%%%%%
play(sc);
% close all;
