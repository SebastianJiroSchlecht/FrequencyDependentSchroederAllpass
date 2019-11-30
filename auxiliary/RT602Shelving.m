function [B,A] = RT602Shelving(RT60,order,Fc,delayInSamples,fs)
% Sebastian J. Schlecht, Sunday, 24 November 2019

targetMagnitude = RT602slope(RT60,fs) * delayInSamples;
gain = -diff(targetMagnitude); % dB

switch order
    case '2nd'        
        [B,A] = shelvingFilter(hertz2rad(Fc, fs),db2mag(gain),'low');
    case '1st'
        [B,A] = shelvingFilterFirstOrder(hertz2rad(Fc, fs),db2mag(gain));
    otherwise
        error('Undefined');
end
B = fliplr(B);
B = B * db2mag(targetMagnitude(2));

% normalize to A(1) == 1
B = B / A(1);
A = A / A(1);




