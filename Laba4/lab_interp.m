clc;
clear variables;
close all force;
addpath("./algos");
% -------------------
Na = 8;
Nb = 10*Na;
a=0; b=1;
x1 = (a:(b-a)/(Na-1):b)'
x0 = (a:(b-a)/(Nb-1):b)';
N0 = length(x0);
N1 = length(x1);
f0 = f(x0);
f1 = f(x1);

[f2, tempX] = my_nearest_neighbour(f1, x1, x0);
[f3, tempX] = my_linear_interpolation(f1, x1, x0);
[f4, tempX] = my_lagrange_polynomial_meth(f1, x1, x0);
[f5, tempX] = my_forward_newton_polynomial(f1, x1, x0);
[f6, tempX] = my_backward_newton_polynomial(f1, x1, x0);
[f7, tempX] = my_cubic_spline(f1, x1, x0);

figure(1);
clf;
subplot(1,2,1);
hold on;
plot(x0, f0, 'b');
plot(x1, f1, 'g');
plot(x0, f2, 'r');
plot(x0, f3, 'm');
plot(x0, f4, 'y');
subplot(1,2,2);
hold on;
plot(x0, f0, 'b');
plot(x1, f1, 'g');
plot(x0, f5, 'r');
plot(x0, f6, 'm');
plot(x0, f7, 'y');
