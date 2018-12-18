clc;
clear variables;
close all force;
addpath("./algos");

xMin = zeros(2,2);
fMin = zeros(2,1);

x0 = ones(2,1);

fctOpt

[xMin(1),fMin(1)] = fminsearch(@hw_optimal_f,x0,fctOpts