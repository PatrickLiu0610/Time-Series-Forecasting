% Vapor pressure function (in kPa)
function vp = vapor_pressure(relative_humidity, T_ref)
    saturation_pressure = 0.611 * exp(17.67 * T_ref / (T_ref - 243.04));
    vp = relative_humidity * saturation_pressure / 100; 
end

% Vapor density function (in kg/m^3)
function vd = vapor_density(relative_humidity, T_ref)
    molar_mass = 0.018015; % Molar mass of water vapor (kg/mol)
    gas_constant = 8.31447; % Universal gas constant (kJ/mol*K)
    pressure = 101.325; % Atmospheric pressure (in kPa) 

    vapor_pressure_kPa = vapor_pressure(relative_humidity, T_ref);
    vd = vapor_pressure_kPa * molar_mass / (gas_constant * T_ref) / pressure;
end
