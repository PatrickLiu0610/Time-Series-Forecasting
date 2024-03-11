    clear all;
    close all



    numSat  = 3;
    
    [bestSats, requiredData] = weatherStation(numSat);
    
    calcDataUplink = [];
    calcDataDownlink = [];


    [num_rows, num_columns] = size(requiredData);

    for i=1:num_rows
        temperature = requiredData(i,1);
        relative_humidity = requiredData(i,2);
        precipitaiton =  requiredData(i,3);
        wind_speed =  requiredData(i,4);
        pressure = requiredData(i,5);

        % Calculate and print vapor density
        vapor_density_kg_m3 = vapour_density(relative_humidity, temperature);
        fprintf('Vapor density at %d%% relative humidity: %d kg/m^3\n', relative_humidity, vapor_density_kg_m3);
        

        range = 715000; % range represents the signal path length.(In m)
        freq = 10e+9; % freq represents the signal carrier frequency. (In Hz)
        T = temperature; % T represents the ambient temperature. (PATRICK'S CODE) (In Degree celcius)
        P = pressure; % P represents the atmospheric pressure. (PATRICK'S CODE) (In kPa)
        den = vapor_density_kg_m3 * 1000; % den represents the atmospheric water vapor density.(vapour_density.m CODE) (in g/^3)
        rainrate = precipitaiton; % rainrate. (In mm/hr) (Patrick's code)
        
        upLink_freq = 28.5e+9; % freq represents the signal carrier frequency. (In Hz)
        downLink_freq = 13.5e+9; % freq represents the signal carrier frequency. (In Hz)
        
        %%%%%%% Up link attenuation %%%%%%%%%%

        gasAttenUplink = gaspl(range,upLink_freq,T,P,den);
        rainAttenUplink = rainpl(range,upLink_freq,rainrate);
        fogAttenUplink = fogpl(range,upLink_freq,T,den);


        totalAttenUplink = gasAttenUplink+rainAttenUplink+fogAttenUplink;
        calcDataUplink = [calcDataUplink; totalAttenUplink];

        %%%%%%% down link attenuation %%%%%%%%%%

        gasAttenDownlink = gaspl(range,downLink_freq,T,P,den);
        rainAttenDownlink = rainpl(range,downLink_freq,rainrate);
        fogAttenDownlink = fogpl(range,downLink_freq,T,den);
        
       
        totalAttenDownlink = gasAttenDownlink+rainAttenDownlink+fogAttenDownlink;
        calcDataDownlink = [calcDataDownlink; totalAttenDownlink];

        

    end
    

    

    
    
    
    % L = gaspl(range,freq,T,P,den);
    % 
    % 
    % % Attenuation (In dB) 
    % 
    % % range represents the signal path length.(In m)
    % 
    % % freq represents the signal carrier frequency. (In Hz)
    % 
    % % T represents the ambient temperature. (PATRICK'S CODE) (In Degree celcius)
    % 
    % % P represents the atmospheric pressure. (PATRICK'S CODE) (In kPa)
    % 
    % % den represents the atmospheric water vapor density.(below CODE) (in g/^3)
    % 
    % 
    % 
    % L = rainpl(range,freq,rainrate);
    % 
    % % returns the signal attenuation, L, due to rainfall.
    % % In this syntax, attenuation is a function of signal path length, (In dB)
    % % range,(In m)
    % % signal frequency, freq, (In Hz)
    % % and rain rate, rainrate. (In mm/hr)
    % % The path elevation angle and polarization tilt angles are assumed to be zero.
    % 
    % 
    % L = fogpl(R,freq,T,den)
    % 
    % %returns attenuation, L, when signals propagate in fog or clouds. 
    % % R represents the signal path length. 
    % % freq represents the signal carrier frequency, 
    % % T is the ambient temperature, and den specifies the liquid water density in the fog or cloud.
    % 
    
    
    


