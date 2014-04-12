function mood = analyse(~)
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
audio = miraudio('TestFiles/CommercialMusic/originaldon30.wav');

% Analyse for key mode (major or minor);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute mirkeystrength in order to retrieve key information;
keys = mirkeystrength(audio);

% Returns key mode (e.g. major or minor)
k = mirmode(keys);

% Retrieve data from MIRtoolbox and assign it to minormaj;
minormaj = mirgetdata(k);

% Decide whether it is a major key or a minor key
% This can be easily done as MIRtoolbox returns values ranging from -1 to 1:
% if the key is major it will be greater than 0;
% if the key is minor it will be less than 0.
if minormaj>0
    keymode = 0; %major
else minormaj<0
    keymode = 1; %minor
end

% The information is therefore stored into keymode, ready to be retrieved
% or displayed at any time.
disp('keymode');
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

if tempo<=100
    temporesult = 0; %slow
elseif tempo>100 && tempo<=140
    temporesult = 1; %fast
else
    temporesult = 2; %veryfast
end

disp('temporesult');
disp(temporesult);
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
    dynamics = 0; %constant
else
    dynamics = 1; %variable
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if lowenergy<0.5
    lowenergyresult = 0; %bright
else
    lowenergyresult = 1; %dark
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if rolloff<3
    rolloffresult = 0; %dark
else
    rolloffresult = 1; %bright
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare results in order to find the timbre.

if lowenergyresult == 1 & rolloffresult == 0
    timbre = 0; %dark
else lowenergyresult == 0 & rolloffresult == 1
    timbre = 1; %bright
end

disp('dynamics');
disp(dynamics);
disp('timbre');
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

% Find maximum frequency in array B (audio file);
pitch = max(max(B));

% Format Hz value so it can be displayed as a string;
%pitch = sprintf('%.1f',pitch);

% Split types of pitch (Hz) into low (<=200Hz), med (>200 and <=800Hz) and
% high (>800Hz).
if pitch<=200
    pitchresult = 0; %low
elseif pitch>200 && pitch<=800
    pitchresult = 1; %med
else
    pitchresult = 2; %high
end

disp('pitch');
disp(pitchresult);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time to compare the results and find out the mood of the audio file!

%if keymode == 0 && (temporesult == 1 || temporesult == 2) && timbre == 1 && dynamics == 0 && (pitchresult == 1 || pitchresult == 2)
%    mood = 'HAPPY';
%else
%    mood = 'orice altceva lol';
%end

%disp(pitch);

% Print out Hz value.
%disp(pitchresult);