%Sebastian J. Schlecht, Sunday, 15 December 2019
clear; clc; close all;

syms z

N = 2;
delays = [5 7];
gain = 0.5;

A = hadamard(N)/sqrt(N) * diag( gain.^delays )
D = diag(z.^(delays))
I = eye(N);

p = expand(det( I + D*A))
revp = expand(subs(p,z^-1) * z^(sum(delays)))
adjP = adjoint( I + D*A)

% c = [1, z^delays(1)];
% b = [1; z^-delays(1)];

c = sym('c',[1,2]);
b = sym('b',[2,1]);

expand(c*adjP*b)

