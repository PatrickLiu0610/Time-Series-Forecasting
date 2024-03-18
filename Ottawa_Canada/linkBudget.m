function bestSatsChecked = linkBudget(numSat)

% This function is responsible for finding the best satellites based on the
% weather link budget links
    
    fprintf('------------------------------------------------------------------------------- \n');
    % This calls the weather station code which returns the best satellites
    % numbers and their assciated weather data based on their weather 
    % receving and transmitting vicinity

    [bestSats, requiredData] = weatherStation(numSat);
    
    bestSatsList = bestSats;

    % List to store indices of satellites with positive link margins
    bestSatsChecked = []; 
    
    % Received power of receving  satellites (uplink) and 
    % receiving ground stations (downlink)

    calcPrxSatUplink = [];
    calcPrxGroundDownlink = [];
    
    % System link margin data stored for uplink and downlink in an array
    systemLinkMarginUplinkdata = [];
    systemLinkMarginDownlinkdata = [];

    % Number of rows and columns of the weather data received of the satellites
    [num_rows, num_columns] = size(requiredData);

    % Link budget analysis of each satellite
    for i=1:num_rows

        fprintf('------------------------------------------------------------------------------- \n');
        fprintf('Running link budget analysis for satellite %d:\n \n', bestSats(i,1));

        % Separating the weather data components of each satellite.
        temperature = requiredData(i,1);
        relative_humidity = requiredData(i,2);
        precipitaiton =  requiredData(i,3);
        wind_speed =  requiredData(i,4);
        pressure = requiredData(i,5);

        % Calculate and print vapor density
        vapor_density_g_m3 = vapour_density(requiredData(i,:));
        fprintf('Vapor density is %d g/m^3 and relative humidity is %d%% \n \n',vapor_density_g_m3, relative_humidity);
        

        range = 715000; % range represents the signal path length.(In m)
        T = temperature; % T represents the ambient temperature. (In Degree celcius)
        P = pressure*1000; % P represents the atmospheric pressure. (In Pa)
        den = vapor_density_g_m3; % den represents the atmospheric water vapor density. (In g/^3)
        rainrate = precipitaiton; % rain rate. (In mm/hr) 
        
        upLink_freq = 28.5e+9; % freq represents the signal carrier frequency. (In Hz)
        downLink_freq = 13.5e+9; % freq represents the signal carrier frequency. (In Hz)
        
        
        %%%%%%% Uplink attenuation %%%%%%%%%%

        lambda_uplink = physconst('LightSpeed')/upLink_freq;
        fspValUplink = fspl(range,lambda_uplink); % Free space path loss attenuation

        gasAttenUplink = gaspl(range,upLink_freq,T,P,den)/10; % Gas attenuation
        rainAttenUplink = rainpl(range,upLink_freq,rainrate,55); % Rain attenuation
        fogAttenUplink = fogpl(range,upLink_freq,T,den); % Fog attenuation

        totalAttenUplink = gasAttenUplink + rainAttenUplink + fogAttenUplink; % Sum of all attenuations

        fprintf('Total attenuation for uplink: %d dB \n', totalAttenUplink);

        %%%%%%% Downlink attenuation %%%%%%%%%%

        lambda_downlink = physconst('LightSpeed')/downLink_freq;
        fspValDownlink = fspl(range,lambda_downlink);  % Free space path loss attenuation

        gasAttenDownlink = gaspl(range,downLink_freq,T,P,den)/10; % Gas attenuation
        rainAttenDownlink = rainpl(range,downLink_freq,rainrate); % Rain attenuation
        fogAttenDownlink = fogpl(range,downLink_freq,T,den); % Fog attenuation
        
        totalAttenDownlink = gasAttenDownlink+rainAttenDownlink+fogAttenDownlink; % Sum of all attenuations
        
        fprintf('Total attenuation for downlink: %d dB \n \n', totalAttenDownlink);

        % Polarization loss and antenna misalignment loss
        polarizationLoss_uplink = 3; % dB
        polarizationLoss_downlink = 3; % dB
        antennaMisalignmentLoss_uplink = 1; % dB
        antennaMisalignmentLoss_downlink = 1; % dB

        

        Ptx_ground = 15.1; % dBW (Ground station transmission power)
        Gtx_ground = 59.7; % dB (Ground station transmission gain)
        Ltx_ground = 3.75; % dB (Ground station transmission loss)
        Grx_sat = 37.8; % dB (Satellite receving gain)
        Lrx_sat = 1.02; % dB (Satellite receving loss)
        Lfs_ground = fspValUplink; % dB (Uplink Free space path loss)
        Lprop_ground = totalAttenUplink+polarizationLoss_uplink+antennaMisalignmentLoss_uplink; % dB (Atmospheric loss)

        Prx_sat = Ptx_ground + Gtx_ground - Ltx_ground - Lfs_ground - Lprop_ground + Grx_sat - Lrx_sat; % dBW (Received satellite power) 
        
        calcPrxSatUplink = [calcPrxSatUplink; Prx_sat]; % Storage of received power data of satellite (uplink) 

        Ptx_satellite = 7; % dBW (Satellite transmission power)
        Gtx_satellite = 31.3; % dB (Satellite transmission gain)
        Ltx_satellite = 1.02; % dB (Satellite transmission loss)
        Grx_ground = 53.2; % dB (Ground station receiving gain)
        Lrx_ground = 3.75; % dB (Ground station receiving loss)
        Lfs_satellite = fspValDownlink; % dB (Downlink Free space path loss)
        Lprop_satellite = totalAttenDownlink + polarizationLoss_downlink + antennaMisalignmentLoss_downlink; % dB (Atmospheric loss)

        Prx_ground = Ptx_satellite + Gtx_satellite - Ltx_satellite - Lfs_satellite - Lprop_satellite + Grx_ground - Lrx_ground; % dBW (Received ground station power)
        
        calcPrxGroundDownlink = [calcPrxGroundDownlink; Prx_ground]; % Storage of received power data of ground station (downlink)

        

        %%%%%%%%%%%%%%%%%%%%%%%%%% UPLINK BUDGET %%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf('Uplink Budget:\n');
        %%%%%%%%%%%%%%%%%%%%%%%%%% groundStation %%%%%%%%%%%%
        
        % Ground Station EIRP value
        groundStationEIRP = Ptx_ground - Ltx_ground + Gtx_ground;
        

        %%%%%%%%%%%%%%%%%%% UPLINK PATH %%%%%%%%%%%%%%%%%%%%%%
        
        % Isotropic Signal Level at satellite
        isoTropicSignal = groundStationEIRP-(antennaMisalignmentLoss_uplink + polarizationLoss_uplink + Lfs_ground + gasAttenUplink + rainAttenUplink);

        %%%%%%%%%%%%%%%% Eb/No Method &&&&&&&&&&&&&&&&&&&&&&&&

        % Signal to Noise Power Density calculation

        SpacecraftAntennaPointingLoss = 1;
        SpacecraftAntennaGain = 37.8;
        SpacecraftTotalTransmissionLineLosses = 1;
        SpacecraftEffectiveNoiseTemperature = 448;
        SpacecraftFigureofMerrit = SpacecraftAntennaGain - SpacecraftTotalTransmissionLineLosses - 10*log10(SpacecraftEffectiveNoiseTemperature);
        signaltoNoisePowerDensity = isoTropicSignal - SpacecraftAntennaPointingLoss - (-228.6) + SpacecraftFigureofMerrit;
        
        
        dataRate = 860000000;
        dataRateindB = 10*log10(dataRate);

        % Eb/No calculation for uplink

        commandSystemEb_No = signaltoNoisePowerDensity - dataRateindB;
        Eb_No_Threshold = 12.3;
 
        % "systemLinkMarginUplink" value needs to be greater than 0.0 dB for the link to be
        % considered healthy


        systemLinkMarginUplink = commandSystemEb_No - Eb_No_Threshold;
        
        fprintf('systemLinkMarginUplink: %d dB \n \n',systemLinkMarginUplink)

        % "systemLinkMarginUplink" stored in array
        systemLinkMarginUplinkdata = [systemLinkMarginUplinkdata;systemLinkMarginUplink];
        

        %%%%%%%%%%%%%%%%%%%%%%%%%% DOWNLINK BUDGET %%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp(['Downlink Budget:']);
        %%%%%%%%%%%%%%%%%%%%%%%%%% satellite %%%%%%%%%%%%
        
        % Satellite EIRP value
        satelliteEIRP = Ptx_satellite - Ltx_satellite + Gtx_satellite;
        

        %%%%%%%%%%%%%%%%%%% DOWNLINK PATH %%%%%%%%%%%%%%%%%%%%%%
        
        % Isotropic signal level at ground station
        isoTropicSignal = satelliteEIRP-(antennaMisalignmentLoss_downlink + polarizationLoss_downlink + Lfs_satellite + gasAttenDownlink + rainAttenDownlink);
        
        %%%%%%%%%%%%%%%% Eb/No Method &&&&&&&&&&&&&&&&&&&&&&&&

        % Signal to Noise Power Density calculation
        groundStationAntennaPointingLoss = 1.1;
        groundStationAntennaGain = 53.2;
        groundStationTotalTransmissionLineLosses = 3.8;
        groundStationEffectiveNoiseTemperature = 350;
        groundStationFigureofMerrit = groundStationAntennaGain - groundStationTotalTransmissionLineLosses - 10*log10(groundStationEffectiveNoiseTemperature);
        signaltoNoisePowerDensity = isoTropicSignal - groundStationAntennaPointingLoss - (-228.6) + groundStationFigureofMerrit;
        
        dataRate = 860000000;
        dataRateindB = 10*log10(dataRate);

        % Eb/No calculation for downlink
        commandSystemEb_No = signaltoNoisePowerDensity - dataRateindB;
        Eb_No_Threshold = 5.9;

        % "systemLinkMarginDownlink" value needs to be greater than 0.0 dB for the link to be
        % considered healthy

        systemLinkMarginDownlink = commandSystemEb_No - Eb_No_Threshold;
        fprintf('systemLinkMarginDownlink: %d dB \n \n',systemLinkMarginDownlink);
        fprintf('------------------------------------------------------------------------------- \n');

        % "systemLinkMarginDownlink" values stored in an array
        systemLinkMarginDownlinkdata = [systemLinkMarginDownlinkdata;systemLinkMarginDownlink];

        % Extract the current satellite index
        current_sat = bestSatsList(i, 1); 

        % Check if both link margins are positive
        if systemLinkMarginUplink > 0 && systemLinkMarginDownlink > 0
            % Append the current satellite index to the list
            bestSatsChecked = [bestSatsChecked; current_sat]; 
        end

    end

    % Print the list of satellites with positive link margins  
    fprintf('Satellites with positive link margins: \n');
    for i=1:numel(bestSatsChecked)
        fprintf('Satellite %d \n', bestSatsChecked(i,1));
    end


    fprintf(' \n')

    % ENSURES THERE'S ONE SATELLITE AT ALL TIMES
    if size(bestSatsChecked, 1) == 0  % Check if bestSatsChecked is empty
        % Calculate combined margins
        marginsCombined = systemLinkMarginUplinkdata + systemLinkMarginDownlinkdata;
    
        % Find the satellite index with the least negative combined margin
        [~, best_sat_index] = max(marginsCombined);
    
        % Return the index
        disp('None of the satellites have positive link margins.');
        disp('Therefore selecting one satellite with the least negative link margin');
        bestSatsChecked = [bestSatsChecked; bestSatsList(best_sat_index, 1)];
        disp('Satellite number:')
        disp(bestSatsChecked);
    end
    fprintf('------------------------------------------------------------------------------- \n');
end
