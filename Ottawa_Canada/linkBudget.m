function bestSats = linkBudget(numSat)

    
    % Constants
    T_ref = 273.15; % Reference temperature in Kelvin (0 degrees Celsius) (PATRICK'S CODE)
    relative_humidity = 60; % Percentage (PATRICK'S CODE)
    
    % Calculate and print vapor density
    vapor_density_kg_m3 = vapour_density(relative_humidity, T_ref);
    fprintf('Vapor density at %d%% relative humidity: %d kg/m^3\n', relative_humidity, vapor_density_kg_m3);
    
    range = 0; % range represents the signal path length.(In m)
    freq = 10e+9; % freq represents the signal carrier frequency. (In Hz)
    T = 0; % T represents the ambient temperature. (PATRICK'S CODE) (In Degree celcius)
    P = 0; % P represents the atmospheric pressure. (PATRICK'S CODE) (In kPa)
    den = 0; % den represents the atmospheric water vapor density.(vapour_density.m CODE) (in g/^3)
    rainrate = 0; % rainrate. (In mm/hr) (Patrick's code)
    R = 0; % R represents the signal path length (In m) 
    
    gasAtten = gaspl(range,freq,T,P,den);
    rainAtten = rainpl(range,freq,rainrate);
    fogAtten = fogpl(R,freq,T,den);
    
    
    
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
    
    
    [bestSats, requiredData] = weatherStation(numSat);

end
