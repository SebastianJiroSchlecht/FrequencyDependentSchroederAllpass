% Accompanying code for "Frequency-Dependent Schroeder Allpass Filters" in Applied Science
% Reproduction of Figure 6
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
delayInSamples = 100;
fftSize = 2^12;
% compute
[gainB,gainA] = RT602Shelving(RT60,order,Fc,delayInSamples,fs);
[allpassB,allpassA] = IIR2Allpass(gainB,gainA,delayInSamples);

% analyze
ir = impz(allpassB,allpassA);
[gainH,~] = freqz(gainB,gainA,fftSize);
[gd,w] = grpdelay(allpassB,allpassA,2^12);

allpassPoles = roots(allpassA);
gainPoles = roots(gainA);
gainZeros = roots(gainB);

% soundsc(ir,fs);

%% plot
plotWidth = '6.4cm';
plotConfig = {'type','standardSingleColumn','width',plotWidth,'extraAxisOptions',{'yticklabel style={/pgf/number format/fixed,/pgf/number format/precision=5},scaled y ticks=false'}};

%% Figure 6(a)
figure(1); hold on; grid on;
stem(ir(1:500),'filled','MarkerSize',2)
xlabel('Time [samples]')
ylabel('Amplitude [linear]')
axis([-10 400 -0.5 1])

matlab2tikz_sjs('./graphics/Example_IR.tikz',plotConfig{:})

%% Figure 6(b)
figure(2); hold on; grid on;
plot((angle(allpassPoles))/pi,mag2db(abs(allpassPoles)),'x'); 
ax = gca; ax.ColorOrderIndex = 1;
plot(-angle(1./allpassPoles)/pi,mag2db(abs(1./allpassPoles)),'o');
plot(w/pi,mag2db(abs(gainH)) / delayInSamples(end));
xlabel('Normalized Frequency [$\pi$ rad/sample]');
ylabel('Magnitude [dB]');
axis([0 1 -0.03 0.03])

matlab2tikz_sjs('./graphics/Example_Poles.tikz',plotConfig{:})

%% Figure 6(c)
figure(3); hold on; grid on;
plot(w/pi,gd);
xlabel('Normalized Frequency [$\pi$ rad/sample]');
ylabel('Group Delay [samples]');
axis([0 1 0 4000])

matlab2tikz_sjs('./graphics/Example_GroupDelay.tikz',plotConfig{:})

%% %% Figure 6(d)
figure(4); hold on; grid on;

plot(angle(gainPoles)/pi,mag2db(abs(gainPoles)),'x');
ax = gca; ax.ColorOrderIndex = 1;
plot(angle(gainZeros)/pi,mag2db(abs(gainZeros)),'o');
plot(w/pi,mag2db(abs(gainH)))
xlabel('Normalized Frequency [$\pi$ rad/sample]');
ylabel('Magnitude [dB]');
axis([0 1 -3 3.3])

matlab2tikz_sjs('./graphics/Example_FilterZPlane.tikz',plotConfig{:})