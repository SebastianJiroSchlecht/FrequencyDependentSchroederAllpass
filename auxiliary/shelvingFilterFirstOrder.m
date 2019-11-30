function [B,A] = shelvingFilterFirstOrder(omegaC, G)
% Sebastian J. Schlecht, Sunday, 1 December 2019
%
% see Välimäki, V., Reiss, J. (2016). All About Audio Equalization:
% Solutions and Frontiers Applied Sciences  6(5), 129.
% https://dx.doi.org/10.3390/app6050129

t = tan(omegaC/2);
sG = sqrt(G);

B(1) = G * t + sG;
B(2) = G*t - sG;
A(1) = t + sG;
A(2) = t - sG;