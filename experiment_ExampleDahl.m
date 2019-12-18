% Accompanying code for "Frequency-Dependent Schroeder Allpass Filters" in Applied Science
% Reproduction of Figure 
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht,
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 1 December 2019; Last revision: 1 December 2019

clear; clc; close all;

fs = 48000;
RT60 = [260 60]/1000; % ms -> seconds
order = '2nd'; % shelving filter order
Fc = 3500; % 0.5kHz
delayInSamples = 50;
fftSize = 2^12;
allpassGain = 0.7;

% compute
[gainB,gainA] = RT602Shelving(RT60,order,Fc,delayInSamples,fs);

allpassA = [zeros(1,delayInSamples), allpassGain * gainB];
allpassA(1:length(gainA)) = allpassA(1:length(gainA)) + gainA;

allpassB = [zeros(1,delayInSamples), gainB];
allpassB(1:length(gainA)) = allpassB(1:length(gainA)) + allpassGain*gainA;

% analyze
ir = impz(allpassB,allpassA);
[gainH,~] = freqz(gainB,gainA,fftSize);
[responseAP,w] = freqz(allpassB,allpassA,fftSize);

allpassPoles = roots(allpassA);
apPoles = roots(allpassA);
apZeros = roots(allpassB);

% soundsc(ir,fs);

%% plot
plotWidth = '6.4cm';
plotConfig = {'type','standardSingleColumn','width',plotWidth,'extraAxisOptions',{'yticklabel style={/pgf/number format/fixed,/pgf/number format/precision=5},scaled y ticks=false'}};

%% Figure ~
figure(1); hold on; grid on;
stem(ir(1:500),'filled','MarkerSize',2)
xlabel('Time [samples]')
ylabel('Amplitude [linear]')
axis([-10 400 -0.5 1])

% matlab2tikz_sjs('./graphics/Example_IR.tikz',plotConfig{:})

%% Figure 
figure(2); hold on; grid on;
plot(w/pi,mag2db(abs(responseAP)));
xlabel('Normalized Frequency [$\pi$ rad/sample]');
ylabel('Magnitude [dB]');
% axis([0 1 -0.03 0.03])

matlab2tikz_sjs('./graphics/Dahl_FrequencyResponse.tikz',plotConfig{:})

%% Figure 
figure(4); hold on; grid on;
plot( angle(apPoles)/pi, mag2db(abs(apPoles)), 'x' )
ax = gca; ax.ColorOrderIndex = 1;
plot( angle(apZeros)/pi, mag2db(abs(apZeros)), 'o' )
plot( w / pi, mag2db(abs(gainH )) / delayInSamples )
xlabel('Normalized Frequency [$\pi$ rad/sample]');
ylabel('Magnitude [dB]');
axis([0 1 -0.1 0.1])
matlab2tikz_sjs('./graphics/Dahl_FilterZPlane.tikz',plotConfig{:})