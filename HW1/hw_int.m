clc;
clear variables;
close all force;
addpath("./algos");
% -------------------

a = 0.2;
b = 0.7;
e = 10^(-6);
n = [10,100,1000];
names = {'riemann_left', 'riemann_mid', 'riemann_right', 'trapezoidal', 'simpson', 'gaussian with 5 points'};
S = zeros(length(n), length(names));
for i=(1:1:3)
   for j=(1:1:3)
       ans = hw_int_analog(a,b,n(i), @hw_int_func, names{j})
       S(i,j) = ans;
   end
end
