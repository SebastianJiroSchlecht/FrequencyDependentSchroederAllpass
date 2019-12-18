function [c,F0,X1,X2] = coherence(x1,x2,Fs)
% Sebastian J. Schlecht, Friday, 29 November 2019

[X1,F0] = thirdOctaveFilter(x1,Fs);
[X2,F0] = thirdOctaveFilter(x2,Fs);

for it = 1:length(F0)
    r = xcorr(X1(:,it),X2(:,it),0,'normalized');
    c(it) = r; max(abs(r)); 
end
% c = F0;



function [X,F0] = thirdOctaveFilter(x,Fs)
BW = '1/3 octave';
N = 8;
F0 = 1000;
oneThirdOctaveFilter = octaveFilter('FilterOrder', N, ...
    'CenterFrequency', F0, 'Bandwidth', BW, 'SampleRate', Fs);
F0 = getANSICenterFrequencies(oneThirdOctaveFilter);
F0(F0<20) = [];
F0(F0>20e3) = [];
Nfc = length(F0);
for i=1:Nfc
    oneThirdOctaveFilterBank{i} = octaveFilter('FilterOrder', N, ...
        'CenterFrequency', F0(i), 'Bandwidth', BW, 'SampleRate', Fs); %#ok
    
    oneThirdOctaveFilter = oneThirdOctaveFilterBank{i};
    X(:,i) = oneThirdOctaveFilter(x);
end



