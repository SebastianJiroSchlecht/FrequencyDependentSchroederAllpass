function [b,a] = IIR2Allpass(B,A,delayInSamples)
% Sebastian J. Schlecht, Sunday, 24 November 2019

a = [zeros(1,delayInSamples), B];
a(1:length(A)) = a(1:length(A)) + A;
b = fliplr(a);
