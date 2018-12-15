clc;
clear variables;
close all force;
addpath("./algos");

a=-5;
b=5;
eps = 10^(-3);
KMax=10^3;

% mins = zeros(6, 2);
% mins(1,:) = uniform_search(a,b,KMax,@nested_function);
% mins(2,:) = dichotomy(a,b,KMax,eps,@nested_function);
% mins(3,:) = golden_ratio(a,b,KMax,eps,@nested_function);
mins = zeros(6,2);
mins(1,:) = uniform_search(a,b,KMax,@nested_function)
mins(2,:) = dichotomy(a,b,KMax,eps,@nested_function);
mins(3,:) = golden_ratio(a,b,KMax,eps,@nested_function);

figure(1);
t=(a:eps*2:b);
plot(t, nested_function(t));
grid on; grid minor;
hold on;
[y,x]= uniform_search(a,b,KMax,@nested_function)
plot(x, y, 'x');
[y,x]=dichotomy(a,b,KMax,eps,@nested_function);
plot(x, y, 'D', 'color', [146 127 255] / 255);
[y,x]=golden_ratio(a,b,KMax,eps,@nested_function);
plot(x, y, 'o', 'color', [255 198 43] / 255);