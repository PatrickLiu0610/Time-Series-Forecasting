
function images = linkMultiHop(numSat, weatherData)

    %% Variables
    % SNR = 10; % in dB %CONFIGURABLE
    
    modOrd = 16; % Modulation Order 
    % uFreq = 28.5E9; % Downlink Frequency
    % dFreq = 13.5E9; % Uplink Frequency
    % 
    % %Satellite Distance from ground station
    % satDist = 715E3;
    
    %Bandwidth
    B = 250E6; %CONFIGURABLE
    
    %Boltzman's Constant in J/ºK
    K = 1.23E-23;
    
    %Temperature in Kelvin
    T = 290;
    
    %Variables for IQ Imbalance
    amplitudeImb = 1; % amplitude imbalance in dB
    phaseImb = 10; %phase imbalance given in degrees
    
    %Variable for frequency offset - Doppler Shift
    offset = 2.85e10;
    
    %Variables for encoding and decoding
    n = 31; % Codeword length - n = (2^m)-1, m >= 3
    k = 26; % Message length - k = n-m
    
    %Variales for linear/binary encoding type
    % pol = cyclpoly(n,k);
    % parmat = cyclgen(n,pol);
    % genmat = gen2par(parmat);
    
    % Generation of random binary data
    % txData = randi([0 1], numSym * log2(modOrd), 1);
    
    %Image Sensitivities
    images = ["Flower1.png", "Flower2.jpeg", "Mountain.jpeg", "Color_Wheel.jpg",...
        "Landscape.jpg", "Denmark.jpeg", "Village.jpg", "Mickey.jpg", "Shrine.jpg", "Webcam"];
    
    sensitivity = [0.65 0.6 0.7 0.64 0.7 0.69 0.61 0.61 0.62 0.62];
    
    convSense = dictionary(images, sensitivity);
    
    image = {"Flower1.png", "Flower2.jpeg", "Mountain.jpeg", "Color_Wheel.jpg",...
        "Landscape.jpg", "Denmark.jpeg", "Village.jpg", "Mickey.jpg", "Shrine.jpg", "Webcam"};
    % choice = menu("Select an image: ", image);
    choice = evalin('caller', 'imageChoice');
    choice
    camera = false;

    image = images(choice);

    %Image Selection
    if(image == "Webcam")

        cam = webcam(1);
        preview(cam);
        pause(5);
        img = snapshot(cam);
        clear('cam');
        image = "Webcam";
    else
        img = imread("Images/" + image);
    end



    reduceH = round(height(img)/64);
    reduceW = round(width(img)/64);
    
    %% Image Reduction and Conversion
    if(mod(reduceH,2) ~= 0)
    
        reduceH = reduceH + 1;
    end
    
    if(mod(reduceW,2) ~= 0)
    
        reduceW = reduceW + 1;
    end
    
    altImg = imresize(img, [reduceH * log2(modOrd)*k, reduceW * log2(modOrd)*k]);
    
    grayImg = rgb2gray(altImg);
    
    % Image to binary
    BW = imbinarize(grayImg,"adaptive","ForegroundPolarity","bright","Sensitivity",lookup(convSense, image));
    
    % binaryData = cast(BW, 'int16');
    
    % binary = reshape(dec2bin(gray), 8*log2(modOrd), [])-'0';
    % userInput = input("Enter Email: ","s");
    % 
    % binary = (reshape(dec2bin(userInput, 8*log2(modOrd)).',1,[])-'0').';
    
    % %Signal processing for encodings
    enShaping = reshape(BW, [], k);
    
    %Encoding the data
    linkData = encode(enShaping,n,k,'hamming/binary');
    
    weatherCount = 1;
    
    %% Link Noise Addition 
    for s = 1:numSat + 1
    
        input = reshape(linkData, log2(modOrd),[]);
    
        % binary = reshape(dec2bin(gray), 8*log2(modOrd), [])-'0';
        % userInput = input("Enter Email: ","s"); 
        % binary = (reshape(dec2bin(userInput, 8*log2(modOrd)).',1,[])-'0').';
    
        % Modulate the data using QAM
        txSig = qammod(input, modOrd, InputType="bit");
    
        %Thermal Noise Power in dB
        % therCalc = 10*log10(K * T * B);
        % therNoise = awgn(txSig, therCalc);
    
        %Thermal Noise
        therNoise_Mod = comm.ThermalNoise('NoiseMethod','Noise figure', ...
        'NoiseFigure', 1.5, 'SampleRate', 2*B, 'Add290KAntennaNoise',true);
    
        therSig = therNoise_Mod(txSig);
    
    
        %Phase Noise
        %As level decreases, phase noise decreases. As frequency offset decreases, phase noise decreases. 
        %A level greater than -55dB will cause huge noise changes in the output.
        phaseNoise = comm.PhaseNoise(Level=-55, FrequencyOffset=14E3, SampleRate=2*B);
    
        % Adding the effects of phase noise onto the thermally altered signal
        phaseSig = phaseNoise(therSig);
    
    
        %White Noise in the channel
        %As SNR increases noise decreases
        % awgnSig = awgn(phaseSig, SNR, "measured");
    
    
        %I/Q imbalance
        iqImbSig = iqimbal(phaseSig, amplitudeImb, phaseImb);
    
    
        % Frequency offset
        % samplerate = 1;
        freqOffSig = frequencyOffset(iqImbSig,2*B,offset);
    

        % Weather Noise
        if(weatherCount <=numSat)

            wD = weatherData(weatherCount, :);
        end

        weatherSNR = weatherAtten(wD);
    
        %Appling the weather noise onto the altered signal
        weatherNoise = awgn(freqOffSig, weatherSNR);
    
    
        %% Demodulate the received signal
        demodSig = qamdemod(weatherNoise, modOrd, OutputType="bit");
        
        linkData = demodSig;
    
        % Extract the data from the demodulated signal
        % rxData = de2bi(demodSig, 'left-msb');
    
        % outputString = char(bin2dec(reshape(char(rxData.'+'0'), 8*log2(modOrd),[]).')).';
    
        % disp(outputString);

        weatherCount = weatherCount+1;
    end
    
    deShaping = reshape(linkData, [], n);
    
    decoded = decode(deShaping,n,k,'hamming/binary');
    
    %% Results
    
    output = reshape(decoded, height(BW), width(BW));
    
    output = imresize(output, [height(img), width(img)], 'box');
    BW = imresize(BW, [height(img), width(img)], 'box');
    
    binaryOut = bin2dec(dec2bin(output))';
    
    % imageArray = [img BW output];
    
    % figure("Name","Images")
    % tiledlayout('horizontal')
    % 
    % nexttile
    % title("Name","Input Image")
    % imshow(img);
    % 
    % nexttile
    % title("Name","Input Binary Image")
    % imshow(img);
    % 
    % nexttile
    % title("Name","Output Image")
    % imshow(output);
    

    % titles = ["Image 1", "Image 2", "Image 3"];
    % 
    % figure("Name","Images");
    % tiledImage = imtile(images, 'GridSize', [3 1]);
    % imshow(tiledImage);
    
    size = 300;
    transSize = size/log2(modOrd);
    
    plotFig = figure("Name","Plots")
    tiledlayout('vertical')
    
    nexttile
    stem(1:size,BW(1:size))
    title('Input Data');
    xlim([0 size]);
    
    nexttile
    plot(1:transSize,txSig(1:transSize))
    title('Modulated Signal');
    xlim([0 transSize]);
    
    nexttile
    plot(1:transSize,therSig(1:transSize))
    title('Signal with Thermal Noise');
    xlim([0 transSize]);
    
    nexttile
    plot(1:transSize,phaseSig(1:transSize))
    title('Signal with Phase Noise');
    xlim([0 transSize]);
    
    % nexttile
    % %figure(2);
    % plot(1:size(awgnSig),awgnSig)
    % title('Signal with White Noise');
    
    nexttile
    %figure(2);
    plot(1:transSize,iqImbSig(1:transSize))
    title('Signal with IQ Imbalance'); 
    xlim([0 transSize]);
    
    nexttile
    %figure(2);
    plot(1:transSize,freqOffSig(1:transSize))
    title('Signal with Frequency Offset');
    xlim([0 transSize]);
    
    nexttile
    %figure(2);
    plot(1:transSize,weatherNoise(1:transSize))
    title('Signal with weather Noise'); 
    xlim([0 transSize]);
    
    nexttile
    % figure(5)
    stem(1:size,binaryOut(1:size))
    title('Output Data')
    xlim([0 size]);

    assignin('caller', 'plotFigure', plotFig);

    images = {img BW output};
end








