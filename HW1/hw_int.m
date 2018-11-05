clc;
clear variables;
close all force;
addpath("./algos");
% -------------------

a = 0.2;
b = 0.7;
eps = 10^(-6);
n = [10,100,1000];
names = {'riemann_left', 'riemann_mid', 'riemann_right', 'trapezoidal', 'simpson', 'gaussian with 5 points'};
S = zeros(length(n), length(names));

N=10;
d2n=ones(1, length(names));
In = zeros(1, length(names));
I2n = zeros(1, length(names));
while nnz(d2n>eps)~=0
   for j=(1:1:6)
       I2n(j) = hw_int_analog(a,b,N*2, @hw_int_func, names{j});
   end
   d2n = abs(I2n-In);
   In(:)=I2n(:);
   d2n(1) = d2n(1)/3;
   d2n(2) = d2n(1)/3;
   d2n(3) = d2n(1)/3;
   d2n(4) = d2n(1)/3;
   d2n(5) = d2n(1)/15;
   d2n(6) = d2n(1)/15;
   N=N*2;
end
n=[10,100,1000,N];
for i=(1:1:3)
   for j=(1:1:6)
       ans = hw_int_analog(a,b,n(i), @hw_int_func, names{j});
       S(i,j) = ans;
   end
end
