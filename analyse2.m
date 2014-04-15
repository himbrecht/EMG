function mood = analyse2(a)
% *Syntax: analyse(a) where argument 'a' is relative path to audio file;*
% This is the main function of the program;
% It retrieves musical information using MIRtoolbox, analyses the results
% and returns the mood of the audio file;
% This file contains tests for five features: key mode, tempo, timbre,
% dynamics and pitch.
% NOTE: Semicolons are used to suppress the output of functions.

% MIRtoolbox displays a progress bar by default, we are going to disable
% it in order to keep the output of the program to a minimum.
mirwaitbar(0);

% First we need to load an audio file into MIRtoolbox, using the miraudio
% function;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
audio = a;

% Analyse for key mode (major or minor);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute mirkeystrength in order to retrieve key information;
keys = mirkeystrength(audio);

% Returns key mode (e.g. major or minor)
k = mirmode(keys);

% Retrieve data from MIRtoolbox and assign it to minormaj;
MinorMaj = mirgetdata(k);

% Decide whether it is a major key or a minor key
% This can be easily done as MIRtoolbox returns values ranging from -1 to 1:
% if the key is major it will be greater than 0;
% if the key is minor it will be less than 0.
if MinorMaj>0
    keymode = 1; %major
else MinorMaj<0
    keymode = 2; %minor
end

% The information is therefore stored into keymode, ready to be retrieved
% or displayed at any time.
disp('keymode (1 - major, 2 - minor)');
disp(keymode);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Analyse for tempo;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tempo estimation from audio using the MIR Toolbox;
 
%mirenvelope(audio);

% Decompose the audio file with a filter bank;
f = mirfilterbank(audio);

% Calculate also a half-wave rectified differentiated envelope;
ee = mirenvelope(f,'HalfwaveDiff');

% Sum the frequency channels;
s = mirsum(ee,'Centered'); 

% Calculate the autocorrelation function;
ac = mirautocor(s); 
 
% Apply the resonance model to the autocorrelation function;
ac = mirautocor(s,'Resonance'); 
 
% Find peaks in the autocorrelation function;
p = mirpeaks(ac); 
mirgetdata(p);

% Get the period of the peaks/tempo.
t = mirtempo(p,'Total',1);
tempo = mirgetdata(t);

% Split types of tempo (BPM) into slow (<=100), fast (>100 and <=140) and veryfast (>140) in order to
% simplify mood categorization.

if tempo<=60
    tempoResult = 1; % very slow
elseif tempo>60 && tempo<=90
    tempoResult = 2; % med slow
elseif tempo>90 && tempo<=100
    tempoResult = 3; % faster slow
elseif tempo>100 && tempo<=110
    tempoResult = 4; % medium
elseif tempo>110 && tempo<=120
    tempoResult = 5; % medium fast
elseif tempo>120 && tempo<=130
    tempoResult = 6; % fast
elseif tempo>130 && tempo<=140
    tempoResult = 7; % faster
elseif tempo>140 && tempo<=160
    tempoResult = 8; % quite fast
elseif tempo>160 && tempo<=180
    tempoResult = 9; % very fast
else
    tempoResult = 10; % really fast
end

disp('temporesult');
disp(tempoResult);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Analyse for timbre and dynamics;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Perform zero cross analysis: it counts how many times the signal passes
% through 0 (X-axis);
z = mirzerocross(audio);
zero = mirgetdata(z);

% Finds low frequency energy;
l = mirlowenergy(audio);
lowenergy = mirgetdata(l);

% Find rolloff/high frequency energy - the lower - the sadder (?)
r = mirrolloff(audio);
rolloff = mirgetdata(r);

% Split timbre and dynamics depending on zero-crossing (waveform
% sign-change) rate, low energy (the amount of low frequencies) and high
% energy (the amount of high energy);
% STATES:
% ZERO CROSSING: constant - low dynamics, variable - highdynamics;
% LOW FREQ ENERGY: lowenergy, high energy;
% HIGH FREQ ENERGY: lowenergy, high energy;

if zero<600
    dynamics = 1; %constant
else
    dynamics = 2; %variable
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if lowenergy<0.5
    lowEnergyResult = 1; %bright
else
    lowEnergyResult = 2; %dark
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if rolloff<3
    rolloffResult = 1; %dark
else
    rolloffResult = 2; %bright
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare results in order to find the timbre.

if lowEnergyResult == 2 && rolloffResult == 1
    timbre = 1; %dark
else lowEnergyResult == 1 && rolloffResult == 2
    timbre = 2; %bright
end

disp('dynamics (1 - constant, 2 - variable)');
disp(dynamics);
disp('timbre (1 - dark, 2 - bright)');
disp(timbre);

% TO DO Find irregularity among successive peaks in order to determine changes
% in signal;
%i = mirregularity(audio);
%irreg = mirgetdata(i);

% Display results (used during testing).
%disp(zero);
%disp(lowenergy);
%disp(rolloff);
%disp(irreg);

%e = mirentropy(a)
%disp(e);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Analyse for pitch;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Crop audio file into segments by detecting attacks;
o = mironsets(audio,'Attacks','Contrast',.1);

% Segment the audio file with respect to the attacks previously detected;
sg = mirsegment(audio,o);

% Find frequencies in each segment;
p = mirpitch(sg);

% Store data into array B in order to simplify our work;
B = mirgetdata(p);

% Find mean frequency (pitch) in array B (audio file);
% NOTE: nanmean avoids NaN (not a number) values;
pitch = nanmean(nanmean(B));

% Format Hz value so it can be displayed as a string;
% NOTE: Used during tests;
% pitch = sprintf('%.1f',pitch);

% Split types of pitch (Hz) into low (<=200Hz), med (>200 and <=800Hz) and
% high (>800Hz).
if pitch<=200
    pitchresult = 1; %low
elseif pitch>200 && pitch<=800
    pitchresult = 2; %med
else
    pitchresult = 3; %high
end

disp('pitch (1 - low, 2 - med, 3 - high)');
disp(pitchresult);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In order to get an accurate result we need to add the weight of each
% parameter (equal values will return a wrong mood);
% During research and testing I've found the following percentages to give
% the most accurate results (in the order of their importance):
% 1. Dynamics - 40%
% 2. Tempo - 25%
% 3. Pitch - 15%
% 4. Key mode - 10%
% 5. Timbre - 10%
% Therefore...

R = [0.40, 0.25, 0.15, 0.10, 0.10];
    
moodExpected = [dynamics, tempoResult, pitchresult, keymode, timbre];
moodDetected = sum(R.*moodExpected);
            
% NOTE: Used during tests to monitor output;
disp ('mood detected');
disp (moodDetected);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cycle through all possible happy values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pp is a counter for adding matrices together;

pp = 1;
for i = 1
    for j = 4:10
        for k = 2:3
            for l = 1:2
                for m = 1:2
happy1(pp,1:5) = [i j k l m];
pp = pp + 1;
                end
            end
        end
    end
end

% Find out the mean value of each feature and multiply it by its rank.
happy = sum(R.*(mean(happy1)));

% NOTE: Used during tests to monitor output;
disp ('happy');
disp (happy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cycle through all possible sad values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pp is a counter for adding matrices together;

pp = 1;
for i = 2
    for j = 1:5
        for k = 1:2
            for l = 1:2
                for m = 1:2
sad1(pp,1:5) = [i j k l m];
pp = pp + 1;
                end
            end
        end
    end
end

% Find out the mean value of each feature and multiply it by its rank.
sad = sum(R.*(mean(sad1)));

% NOTE: Used during tests to monitor output;
disp ('sad');
disp (sad);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cycle through all possible angry values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pp is a counter for adding matrices together;

pp = 1;
for i = 1
    for j = 7:10
        for k = 2:3
            for l = 2
                for m = 2
angry1(pp,1:5) = [i j k l m];
pp = pp + 1;
                end
            end
        end
    end
end

% Find out the mean value of each feature and multiply it by its rank.
angry = sum(R.*(mean(angry1)));

% NOTE: Used during tests to monitor output;
disp ('angry');
disp (angry);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cycle through all possible calm values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pp is a counter for adding matrices together;

pp = 1;
for i = 1:2
    for j = 1:3
        for k = 1:3
            for l = 1:2
                for m = 1:2
calm1(pp,1:5) = [i j k l m];
pp = pp + 1;
                end
            end
        end
    end
end

% Find out the mean value of each feature and multiply it by its rank.
calm = sum(R.*(mean(calm1)));

% NOTE: Used during tests to monitor output;
disp('calm');
disp(calm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time to compare the results and find out the mood of the audio file!

if (moodDetected >=2.5 || moodDetected < 3)
    mood = 'HAPPY';
elseif (moodDetected >=2 || moodDetected < 2.5)
    mood = 'SAD';
elseif moodDetected >=3
    mood = 'ANGRY';
elseif moodDetected <2
    mood = 'CALM';
else
    mood = 'NEUTRAL/ERROR';
end
 
disp (mood);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end % End of function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%