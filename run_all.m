% Accompanying code for "Frequency-Dependent Schroeder Allpass Filters" in Applied Science
% Reproduction of Everything
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht,
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 1 December 2019; Last revision: 1 December 2019

clear; clc; close all;

restoredefaultpath;
addpath('./auxiliary');
addpath(genpath('./../matlab2tikz_wrapper'))

experiment_Example1
experiment_Example2 % removed from published version
experiment_ExampleDahl
experiment_SchroederDecorrelator

experiment_stereoDecorrelator