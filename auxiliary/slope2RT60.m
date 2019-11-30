function RT60 = slope2RT60(slope, fs)
% Convert Energy decay slope to time in seconds of 60dB decay
%
% Author:   Sebastian Schlecht
% Date:     Mon Feb 06 2012
% Version:  1.0

% converting from -1dB/sample to -60dB decay in sec 
RT60 = (-60./ clip(slope, [-Inf, -eps]) )./fs;

