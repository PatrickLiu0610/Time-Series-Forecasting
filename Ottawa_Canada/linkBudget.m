function bestSatsChecked = linkBudget(numSat)
    
    [bestSats, requiredData] = weatherStation(numSat);
    
    bestSatsList = bestSats;
    % List to store indices of satellites with positive link margins
    bestSatsChecked = []; 
    
    calcPrxSatUplink = [];
    calcPrxGroundDownlink = [];
    
    systemLinkMarginUplinkdata = [];
    systemLinkMarginDownlinkdata = [];


    [num_rows, num_columns] = size(requiredData);

    for i=1:num_rows
        temperature = requiredData(i,1);
        relative_humidity = requiredData(i,2);
        precipitaiton =  requiredData(i,3);
        wind_speed =  requiredData(i,4);
        pressure = requiredData(i,5);

        % Calculate and print vapor density
        vapor_density_g_m3 = vapour_density(requiredData(i,:));
        disp('Vapor density in g/m^3');
        disp(vapor_density_g_m3);
        fprintf('Vapor density is %d g/m^3 and relative humidity is %d%% \n',vapor_density_g_m3, relative_humidity);
        

        range = 715000; % range represents the signal path length.(In m)
        T = temperature; % T represents the ambient temperature. (In Degree celcius)
        P = pressure*1000; % P represents the atmospheric pressure. (In Pa)
        den = vapor_density_g_m3; % den represents the atmospheric water vapor density. (in g/^3)
        rainrate = precipitaiton; % rainrate. (In mm/hr) 
        
        upLink_freq = 28.5e+9; % freq represents the signal carrier frequency. (In Hz)
        downLink_freq = 13.5e+9; % freq represents the signal carrier frequency. (In Hz)
        
        
        %%%%%%% Uplink attenuation %%%%%%%%%%

        lambda_uplink = physconst('LightSpeed')/upLink_freq;
        fspValUplink = fspl(range,lambda_uplink);

        gasAttenUplink = gaspl(range,upLink_freq,T,P,den)/10;
        rainAttenUplink = rainpl(range,upLink_freq,rainrate,55);
        fogAttenUplink = fogpl(range,upLink_freq,T,den);

        totalAttenUplink = gasAttenUplink + rainAttenUplink + fogAttenUplink;


        %%%%%%% Downlink attenuation %%%%%%%%%%

        lambda_downlink = physconst('LightSpeed')/downLink_freq;
        fspValDownlink = fspl(range,lambda_downlink);

        gasAttenDownlink = gaspl(range,downLink_freq,T,P,den)/10;
        rainAttenDownlink = rainpl(range,downLink_freq,rainrate);
        fogAttenDownlink = fogpl(range,downLink_freq,T,den);
        
        totalAttenDownlink = gasAttenDownlink+rainAttenDownlink+fogAttenDownlink;


        
        polarizationLoss_uplink = 3; % dB
        polarizationLoss_downlink = 3; % dB
        antennaMisalignmentLoss_uplink = 1; % dB
        antennaMisalignmentLoss_downlink = 1; % dB


        Ptx_ground = 15.1; % dBW
        Gtx_ground = 59.7; % dB
        Ltx_ground = 3.75; % dB
        Grx_sat = 37.8; % dB
        Lrx_sat = 1.02; % dB
        Lfs_ground = fspValUplink; % FSPL dB
        Lprop_ground = totalAttenUplink+polarizationLoss_uplink+antennaMisalignmentLoss_uplink; % Atmosphere losses dB

        Prx_sat = Ptx_ground + Gtx_ground - Ltx_ground - Lfs_ground - Lprop_ground + Grx_sat - Lrx_sat;
        
        calcPrxSatUplink = [calcPrxSatUplink; Prx_sat];

        Ptx_satellite = 7; % dBW
        Gtx_satellite = 31.3; % dB
        Ltx_satellite = 1.02; % dB
        Grx_ground = 53.2; % dB
        Lrx_ground = 3.75; % dB
        Lfs_satellite = fspValDownlink; % FSPL dB
        Lprop_satellite = totalAttenDownlink + polarizationLoss_downlink + antennaMisalignmentLoss_downlink; % Atmosphere losses dB

        Prx_ground = Ptx_satellite + Gtx_satellite - Ltx_satellite - Lfs_satellite - Lprop_satellite + Grx_ground - Lrx_ground;
        
        calcPrxGroundDownlink = [calcPrxGroundDownlink; Prx_ground];

        

        %%%%%%%%%%%%%%%%%%%%%%%%%% UPLINK BUDGET %%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp(['Uplink Command Budget:']);
        %%%%%%%%%%%%%%%%%%%%%%%%%% groundStation %%%%%%%%%%%%
        
        disp(['Ground Station:---------------------------------']);

        groundStationEIRP = Ptx_ground - Ltx_ground + Gtx_ground;
        
        disp(['Ground Station Transmitter Power Output:']);
        disp(Ptx_ground);
        disp(['Ground Stn. Total Transmission Line Losses:']);
        disp(Ltx_ground);
        disp(['Antenna Gain:']);
        disp(Gtx_ground);

        disp(['Ground Station EIRP:']);
        disp(groundStationEIRP);
        

        %%%%%%%%%%%%%%%%%%% UPLINK PATH %%%%%%%%%%%%%%%%%%%%%%
        % antennaMisalignmentLoss_uplink = 1;
        % polarizationLoss_uplink = 3;
        % Lfs_ground = 180.2;
        %gasAttenUplink = 0.3;
        %rainAttenUplink = 2.7;
        isoTropicSignal = groundStationEIRP-(antennaMisalignmentLoss_uplink + polarizationLoss_uplink + Lfs_ground + gasAttenUplink + rainAttenUplink);

        disp(['Uplink Path:-----------------------------------------------']);
        disp('Ground Station Antenna Pointing Loss:');
        disp(antennaMisalignmentLoss_uplink);
        disp('Gnd-to-S/C Antenna Polarization Losses:');
        disp(polarizationLoss_uplink);
        disp('Path Loss:');
        disp(Lfs_ground);
        disp('Atmospheric Losses:')
        disp(gasAttenUplink);
        disp('rain loss:')
        disp(rainAttenUplink);
        disp('Rain Losses included in Atmospheric Losses:');
        disp('Isotropic Signal Level at Spacecraft:');
        disp(isoTropicSignal);




        %%%%%%%%%%%%%%%% Eb/No Method &&&&&&&&&&&&&&&&&&&&&&&&
        disp('------- Eb/No Method -------');
        SpacecraftAntennaPointingLoss = 1;
        SpacecraftAntennaGain = 37.8;
        SpacecraftTotalTransmissionLineLosses = 1;
        SpacecraftEffectiveNoiseTemperature = 448;
        SpacecraftFigureofMerrit = SpacecraftAntennaGain - SpacecraftTotalTransmissionLineLosses - 10*log10(SpacecraftEffectiveNoiseTemperature);
        signaltoNoisePowerDensity = isoTropicSignal - SpacecraftAntennaPointingLoss - (-228.6) + SpacecraftFigureofMerrit;
        
        disp('Spacecraft Antenna Pointing Loss:');
        disp(SpacecraftAntennaPointingLoss);
        disp('Spacecraft Antenna Gain:');
        disp(SpacecraftAntennaGain);
        disp('Spacecraft Total Transmission Line Losses:');
        disp(SpacecraftTotalTransmissionLineLosses);
        disp('Spacecraft Effective Noise Temperature:');
        disp(SpacecraftEffectiveNoiseTemperature);
        disp('Spacecraft Figure of Merrit (G/T):')
        disp(SpacecraftFigureofMerrit);
        disp('S/C Signal-to-Noise Power Density (S/No):')
        disp(signaltoNoisePowerDensity);


        dataRate = 860000000;
        dataRateindB = 10*log10(dataRate);
        commandSystemEb_No = signaltoNoisePowerDensity - dataRateindB;
        Eb_No_Threshold = 12.3;
        % This is the bottom line.  
        % This value must be > 0.0 dB for the link to work or "close."  
        % A target value should be approximately 10 dB for a low cost system, 
        % 6 dB for a professional system and 3 dB for a deep space system.
        systemLinkMarginUplink = commandSystemEb_No - Eb_No_Threshold;
        disp('System Desired Data Rate:')
        disp(dataRateindB)
        disp('Command System Eb/No:');
        disp(commandSystemEb_No);
        disp('Eb/No Threshold:');
        disp(Eb_No_Threshold);
        disp(['systemLinkMarginUplink']);
        disp(systemLinkMarginUplink);
        systemLinkMarginUplinkdata = [systemLinkMarginUplinkdata;systemLinkMarginUplink];
        

        %%%%%%%%%%%%%%%%%%%%%%%%%% DOWNLINK BUDGET %%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%% satellite %%%%%%%%%%%%
        
        satelliteEIRP = Ptx_satellite - Ltx_satellite + Gtx_satellite;
        

        %%%%%%%%%%%%%%%%%%% DOWNLINK PATH %%%%%%%%%%%%%%%%%%%%%%
        %antennaMisalignmentLoss_downlink = 1;
        %polarizationLoss_downlink = 3;
        %Lfs_satellite = 173.7;
        %gasAttenDownlink = 0.3;
        %rainAttenDownlink = 2.7;

        isoTropicSignal = satelliteEIRP-(antennaMisalignmentLoss_downlink + polarizationLoss_downlink + Lfs_satellite + gasAttenDownlink + rainAttenDownlink);
        
        %%%%%%%%%%%%%%%% Eb/No Method &&&&&&&&&&&&&&&&&&&&&&&&
        groundStationAntennaPointingLoss = 1.1;
        groundStationAntennaGain = 53.2;
        groundStationTotalTransmissionLineLosses = 3.8;
        groundStationEffectiveNoiseTemperature = 350;
        groundStationFigureofMerrit = groundStationAntennaGain - groundStationTotalTransmissionLineLosses - 10*log10(groundStationEffectiveNoiseTemperature);
        signaltoNoisePowerDensity = isoTropicSignal - groundStationAntennaPointingLoss - (-228.6) + groundStationFigureofMerrit;
        
        dataRate = 860000000;
        dataRateindB = 10*log10(dataRate);
        commandSystemEb_No = signaltoNoisePowerDensity - dataRateindB;
        Eb_No_Threshold = 5.9;
        % This is the bottom line.  
        % This value must be > 0.0 dB for the link to work or "close."  
        % A target value should be approximately 10 dB for a low cost system, 
        % 6 dB for a professional system and 3 dB for a deep space system.
        systemLinkMarginDownlink = commandSystemEb_No - Eb_No_Threshold;
        disp(['systemLinkMarginDownlink']);
        disp(systemLinkMarginDownlink);
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
    disp('Satellites with positive link margins:');
    disp(bestSatsChecked);   
    

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
        disp('satellite number:')
        disp(bestSatsChecked);
    end

end
