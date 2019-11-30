function slope = RT602slope(RT60, fs)
% Convert time (in seconds) of 60dB decay to energy decay slope
%
% Author:   Sebastian Schlecht
% Date:     Mon Feb 06 2012
% Version:  1.0

% converting from -60dB decay in sec to -1dB/sample
slope = -60./(RT60.*fs); 