close all;
clear all;

startTime = datetime(2023,10,21,1,13,0);
stopTime = startTime + hours(5);
sampleTime = 60;
sc = satelliteScenario(startTime,stopTime,sampleTime);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Satellite 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semiMajorAxis = 10000000;                  % meters
eccentricity = 0;
inclination = 0;                           % degrees
rightAscensionOfAscendingNode = 0;         % degrees
argumentOfPeriapsis = 0;                   % degrees
trueAnomaly = 0;                           % degrees
sat1 = satellite(sc, ...
    semiMajorAxis, ...
    eccentricity, ...
    inclination, ...
    rightAscensionOfAscendingNode, ...
    argumentOfPeriapsis, ...
    trueAnomaly, ...
    "Name","Satellite 1");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Satellite 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semiMajorAxis = 10000000;                  % meters
eccentricity = 0;
inclination = -30;                          % degrees
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
semiMajorAxis = 10000000;                  % meters
eccentricity = 0;
inclination = -30;                          % degrees
rightAscensionOfAscendingNode = 120;       % degrees
argumentOfPeriapsis = 0;                   % degrees
trueAnomaly = 280;                         % degrees
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
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels
sat2Rx = receiver(gimbalSat2Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels
sat3Rx = receiver(gimbalSat3Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels

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
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels
sat2Rx = receiver(gimbalSat2Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels
sat3Rx = receiver(gimbalSat3Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels

gaussianAntenna(sat1Rx, ...
    "DishDiameter",0.5);    % meters
gaussianAntenna(sat2Rx, ...
    "DishDiameter",0.5);    % meters
gaussianAntenna(sat3Rx, ...
    "DishDiameter",0.5);    % meters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ground Stations %%%%%%%%%%%%%%%%%%%%%%%%
latitude1 = 12.9436963;          % degrees
longitude1 = 77.6906568;         % degrees
gs1 = groundStation(sc,latitude1,longitude1,"Name","Ground Station 1");

latitude2 = -33.7974039;        % degrees
longitude2 = 151.1768208;       % degrees
gs2 = groundStation(sc,latitude2,longitude2,"Name","Ground Station 2");

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
    "GainToNoiseTemperatureRatio",3, ...   % decibels/Kelvin
    "RequiredEbNo",1);                     % decibels

gaussianAntenna(gs2Rx, ...
    "DishDiameter",2); % meters


%%%%%%%%%%%%%%%%%%%%%%%%% Antenna Pointings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pointAt(gimbalGs1,sat1);
pointAt(gimbalSat1Rx,gs1);
pointAt(gimbalSat1Tx,sat2);
pointAt(gimbalSat2Rx,sat1);
pointAt(gimbalSat2Tx,sat3);
pointAt(gimbalSat3Rx,sat2);
pointAt(gimbalSat3Tx,gs2);
pointAt(gimbalGs2,sat3);

% top_2 = multihop();

% Define link configurations in separate link objects
link_config1 = link(gs1Tx, sat1Rx);
link_config2 = link(sat1Tx, sat2Rx);
link_config3 = link(sat2Tx, sat3Rx);
link_config4 = link(sat3Tx, gs2Rx);

% Create a cell array to hold link configurations
link_configurations = {link_config1, link_config2, link_config3, link_config4};

lnk = cat(2, link_configurations{:});  % Concatenate links horizontally

% Perform link analysis with linkIntervals
link = linkIntervals(lnk);

% lnk = link(gs1Tx,sat1Rx,sat1Tx,sat2Rx,sat2Tx,sat3Rx,sat3Tx,gs2Rx);
% link = linkIntervals(lnk);

%%%%%%%%%%%%%%%%%%%%%%%%%% Earth Graphics %%%%%%%%%%%%%%%%%%%%%%%%%%%%
play(sc);

