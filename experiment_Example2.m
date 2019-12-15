% Accompanying code for "Frequency-Dependent Schroeder Allpass Filters" in Applied Science
% Reproduction of Figure 7
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht,
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 1 December 2019; Last revision: 1 December 2019

clear; clc; close all;

omega = 1;
p = 0.9 * exp(1i*omega);
order = 9;
delayInSamples = 70;

% gain filter
p = [p, conj(p)];
gainPoles = ones(order,1).*p;
gainPoles = gainPoles(:);
gainZeros = 1./gainPoles;

[~,A] = zp2tf(gainZeros,gainPoles,1);
B = 0.9*fliplr(A);

% allpass filter
[b,a] = IIR2Allpass(B,A,delayInSamples);

% analyze
ir = impz(b,a);
[h,~] = freqz(B,A);
poles = roots(a);
[gd,w] = grpdelay(B,A);

% soundsc(ir,fs);

%% plot
plotWidth = '6.4cm';
plotConfig = {'type','standardSingleColumn','width',plotWidth,'extraAxisOptions',{'yticklabel style={/pgf/number format/fixed,/pgf/number format/precision=5},scaled y ticks=false'}};


% Figure not used
figure(1); hold on; grid on;
stem(ir,'filled','MarkerSize',2)
xlabel('Time [samples]')
ylabel('Amplitude [linear]')
axis([-10 400 -0.5 1])

% Figure 6(a)
verticalX = [angle(poles),angle(poles)].';
verticalY = [0*angle(poles),angle(poles)*0-0.03].';

figure(2); hold on; grid on;
plot(angle(poles)/pi,mag2db(abs(poles)),'x')
plot(w/pi,mag2db(abs(h)) / delayInSamples(end))
reduce_plot(verticalX/pi,verticalY,'k:')
xlabel('Normalized Frequency [$\pi$ rad/sample]');
ylabel('Magnitude [dB]');
axis([0 1 -0.015 0])
matlab2tikz_sjs('./graphics/Warp_Poles.tikz',plotConfig{:})

% % Figure 6(b)
figure(3); hold on; grid on;
plot(w/pi,gd);
xlabel('Normalized Frequency [$\pi$ rad/sample]');
ylabel('Group Delay [samples]');
axis([0 1 0 200])
matlab2tikz_sjs('./graphics/Warp_GroupDelay.tikz',plotConfig{:})


