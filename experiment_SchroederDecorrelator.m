% Accompanying code for "Frequency-Dependent Schroeder Allpass Filters" in Applied Science
% Reproduction of Figure 8
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht,
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 1 December 2019; Last revision: 1 December 2019

clear; clc; close all;

rng(6);
fs = 48000;
numStages = 5;
RT60 = [100 8]/1000; % ms -> seconds
Fc = 1100; % Hz
order = '1st';
fftSize = 2^15;

pp = primes(1000);
delayInSamples = pp(10+3*(1:numStages));

%% Allpass filters
ir = 1;
for it = 1:numStages
    [B,A] = RT602Shelving(RT60,order,Fc,delayInSamples(it),fs);
    
    [b,a] = IIR2Allpass(B,A,delayInSamples(it));
    
    poles{it} = roots(a);
    poles{it}(imag(poles{it})<0) = [];

    groupDelay{it} = grpdelay(b,a,fftSize);
    
    ir = conv(ir,impz(b,a));
end

% analyze
[h,w] = freqz(B,A,fftSize);

ir = ir / norm(ir);
audiowrite('decorrelator.wav',ir,fs);
% soundsc(ir,fs);

%% plot
plotHeight = '4.4cm';
plotWidth = '12.8cm';
plotConfig = {'type','standardSingleColumn','width',plotWidth,'height',plotHeight};

% Figure 8(a)
figure(1); hold on; grid on;
range = 1:3000;
stem(smp2ms(0:length(ir(range))-1,fs),ir(range),'filled','MarkerSize',2)
xlabel('Time [ms]')
ylabel('Amplitude [linear]')
axis([-0.1 30 -0.4 0.4])
matlab2tikz_sjs('./graphics/Decorrelator_IR.tikz',plotConfig{:})

% Figure 8(b)
figure(2); hold on; grid on;
plot(angle2freq(w,fs), slope2RT60( mag2db(abs(h)) / delayInSamples(end),fs)*1000)
for it = 1:numStages
    plot(angle2freq(angle(poles{it}),fs),slope2RT60(mag2db(abs(poles{it})),fs)*1000,'x')
end
set(gca,'XScale','log');
xlabel('Frequency [Hz]');
ylabel('Reverberation Time [ms]');
axis([100 fs/2 0 100])
matlab2tikz_sjs('./graphics/Decorrelator_Poles.tikz',plotConfig{:})

% Figure 8(c)
figure(3); hold on; grid on;
totalGroupDelay = w*0;
logx = logspace(log10(100),log10(fs/2),1000);
for it = 1:numStages
   xx = interp1( angle2freq(w,fs), smp2ms(groupDelay{it},fs), logx);
   plot(logx, xx,'--'); 
   totalGroupDelay = totalGroupDelay + groupDelay{it};
end
xx = interp1( angle2freq(w,fs), smp2ms(totalGroupDelay,fs), logx);
plot(logx, xx); 
set(gca,'XScale','log');
xlabel('Frequency [Hz]');
ylabel('Group Delay [ms]');
axis([100 fs/2 0 30])
matlab2tikz_sjs('./graphics/Decorrelator_GroupDelay.tikz',plotConfig{:})


