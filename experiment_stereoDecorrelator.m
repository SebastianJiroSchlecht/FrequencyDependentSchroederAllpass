% Accompanying code for "Frequency-Dependent Schroeder Allpass Filters" in Applied Science
% Reproduction of Audio Example
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht,
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 1 December 2019; Last revision: 1 December 2019

clear; clc; close all;

% audio signal
guitar = audioread('guitar_mono.wav');
guitar = guitar(:,1);
len = length(guitar);

% decorrelator
[decorr,fs] = audioread('decorrelator.wav');

% corresponding delay
delay = decorr*0;
[~,ind] = max(decorr); 
delay(ind) = 1;


% apply decorrelation
decorrelatedGuitar = conv(guitar,delay);
decorrelatedGuitar = decorrelatedGuitar(1:len);
guitar = conv(guitar,decorr);
guitar = guitar(1:len);

% write files
audiowrite('guitar_decorr.wav',[guitar, decorrelatedGuitar],fs);
audiowrite('impulse_decorr.wav',[delay, decorr],fs);

% play audio
soundsc([guitar, decorrelatedGuitar],fs)


