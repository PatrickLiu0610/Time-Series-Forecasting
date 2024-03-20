
function signalSNR = weatherAtten(weatherData)

    
    % weatherData = [15, 89, 1, 33.917, 103];
    % rainAnt = weather_impact_function(weatherData);
    
    temp = weatherData(1);
    tempK = temp + 273.15;
    RH = weatherData(2)/100;
    pressure = weatherData(5)*10^3;
    
    % On Liquid
    b = 17.502;             
    c = 240.97;                                   %Celsius
    
    % On Ice
    % b = 21.87;             
    % c = 265.5;                                  %Celsius
    
    % Saturation Vapor Pressure
    Ps = 0.611E3 * exp((b*temp)/(c+temp));        %Pascals
    
    % Actual Vapor Pressure
    Pa = RH * Ps;                                 %Pascals
    
    % Molecular weight of water in g/mol
    Mw = 18.02;
    
    % Gas constant in J/molK
    R = 8.31;
    
    % Vapor Density
    Vd = (Pa * Mw)/(R * tempK);                   %g/m^3
    
    rainEffect = rainpl(715000,28.5e9,weatherData(3),55);
    atmosL = gaspl(715000,28.5e9,temp,pressure,Vd)/10;
    fog = fogpl(715000,28.5e9, temp, 0.2);
    
    totalLoss = rainEffect + atmosL + fog;
    
    largeTL = 200;
    smallTL = 70;
    smallSNR = -3;
    largeSNR = 10;
    
    threshold = (largeTL+smallTL)/2;
    
    outputT = largeSNR - ((largeSNR - smallSNR)/2);
    
    m1 = (outputT - largeSNR)/(threshold - smallTL);
    
    m2 = (smallSNR - outputT)/(largeTL - threshold);
    
    b1 = largeSNR - (m1 * smallTL);
    
    b2 = smallSNR - (m2 * largeTL);
    
    if totalLoss <= threshold
        
        SNRLoss = m1 * totalLoss + b1;
    else

        SNRLoss = m2 * totalLoss + b2;
    end
    
    if(SNRLoss < smallSNR)

        SNRLoss = smallSNR;
    end

    signalSNR = min(SNRLoss, 10);

    % baselineSNR = 10;
    
    % signalSNR = baselineSNR - cappedSNR;
end

function weatherAtten = weather_impact_function(weather_data)
    
    elevation = 0.959; % radians

    %Atmopsheric attenuation using temperature and humidity
    aTemp = 7.91E-2;
    bTemp = 3.81E-2;
    cTemp = 1.44E-3;
    
    tempK = weather_data(1) + 273.15;

    % Ps = %saturation vapor pressure
    % 
    % absH = (weather_data(2) * Ps)/(461.5 * tempK * 100);
    % 
    % tempAtten = (aTemp + (bTemp*absH) + (cTemp*weather_data(1))) * csc(elevation);
    

    %Rain attenuation
    rainRate = weather_data(3);
    b = 2.3 * (rainRate^-0.17);
    c = 0.026 - (0.03 * log(rainRate));
    d = 3.8 - (0.6 * log(rainRate));
    
    u = (log(b*(exp(c*d))))/d;

    lat = [0, 10, 20, 30, 40, 50 ,60, 70];
    Ho = [5.2, 5.35, 5.4, 5.3, 4.8, 4.1, 3, 2.3]; % Km

    % D = (Ho(5) - 160)/tan(elevation);
    D = 1;

    aRain = 0.16;
    bRain = 1.81;

    term1 = (aRain * (rainRate^bRain))/cos(elevation);

    term2 = (exp(u*bRain*d) - 1)/(u * bRain);

    term3 = ((b^bRain)*exp(c * bRain * d))/(c*bRain);

    term4 = ((b^bRain)*exp(c * bRain * D))/(c*bRain);

    rainAtten = term1 * (term2 - term3 + term4);

    weatherAtten = [rainAtten];
end




