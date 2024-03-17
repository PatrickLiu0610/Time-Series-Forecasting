function vd = vapour_density(weatherData)
    
    
    temp = weatherData(1);
    tempK = temp + 273.15;
    RH = weatherData(2)/100;
    
    % On Liquid
    b = 17.502;             
    c = 240.97;                                   %Celsius
    
    % Saturation Vapour Pressure
    Ps = 0.611E3 * exp((b*temp)/(c+temp));        %Pascals
    
    % Actual Vapour Pressure
    Pa = RH * Ps;                                 %Pascals
    
    % Molecular weight of water in g/mol
    Mw = 18.02;
    
    % Gas constant in J/molK
    R = 8.31;
    
    % Vapor Density
    vd = (Pa * Mw)/(R * tempK);                   %g/m^3
    
end
