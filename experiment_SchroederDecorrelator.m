% Accompanying code for "Frequency-Dependent Schroeder Allpass Filters" in Applied Science
% Reproduction of Figure 8
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht,
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 1 December 2019; Last revision: 1 December 2019

clear; clc; close all;

rng(11);
fs = 48000;
numStages = 5;
RT60 = [100 8]/1000; % ms -> seconds
Fc = 1100; % Hz
order = '1st';
fftSize = 2^13; 

pp = primes(1000);
delayInSamples = randi([40,150],[1,numStages]);   pp(10+3*(1:numStages));
delayInSamples2 = randi([40,150],[1,numStages]); pp(9+3*(1:numStages))+1;
%% Allpass filters
[ir, poles, groupDelay, B, A] = SchroederDecorrelator(RT60,order,Fc,delayInSamples,fs,fftSize);
[ir2] = SchroederDecorrelator(RT60,order,Fc,delayInSamples2,fs,fftSize);
len = min(length(ir),length(ir2));
ir = ir(1:len);
ir2 = ir2((1:len));

% analyze
[h,w] = freqz(B,A,fftSize);

ir = ir / norm(ir);
ir2 = ir2 / norm(ir2);
audiowrite('decorrelator.wav',ir,fs);
soundsc([ir ir2],fs);



[coh,coh_f,X1,X2] = coherence(ir, ir2, fs);

% figure(11); hold on; grid on;
% plot(X1 + (1:30));
% plot(X2 + (1:30));

%% plot
plotHeight = '2.4cm';
plotWidth = '12.8cm';
plotConfig = {'type','standardSingleColumn','width',plotWidth,'height',plotHeight};


% Figure 8(a)
figure(1); hold on; grid on;
range = 1:3000;
stem(smp2ms(0:length(ir(range))-1,fs),ir(range),'filled','MarkerSize',2)
% stem(smp2ms(0:length(ir(range))-1,fs),ir2(range),'filled','MarkerSize',2)
xlabel('Time [ms]')
ylabel('Amplitude [linear]')
axis([-0.1 30 -0.5 0.4])
matlab2tikz_sjs('./graphics/Decorrelator_IR.tikz',plotConfig{:})

% Figure 8(b)
figure(2); hold on; grid on;
ind = angle2freq(w,fs) > 50;
plot(angle2freq(w(ind),fs), slope2RT60( mag2db(abs(h(ind))) / delayInSamples(end),fs)*1000)
for it = 1:numStages
    p = poles{it};
    p = p(angle2freq(angle(p),fs) > 50);
    plot(angle2freq(angle(p),fs),slope2RT60(mag2db(abs(p)),fs)*1000,'x')
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
axis([100 fs/2 0 26])
matlab2tikz_sjs('./graphics/Decorrelator_GroupDelay.tikz',plotConfig{:})

% Figure 8(d)
figure(4); hold on; grid on;
plot(coh_f,coh);
set(gca,'XScale','log')
xlabel('Frequency [Hz]');
ylabel('Correlation [-1,1]');
axis([100 fs/2 -1 1])
matlab2tikz_sjs('./graphics/Decorrelator_Correlation.tikz',plotConfig{:})

