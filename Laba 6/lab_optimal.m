clc;
clear variables;
close all force;
addpath("./algos");

a=-5;
b=5;
eps = 10^(-6);
KMax=10^6;
meth_names={'uniform', 'dichotomy', 'golden_ratio'; 'coordinate_descent', 'gradient', 'newton'};
%------------------------------
nested_function = @f1;
mins = cell(6,2);
shapes = ['x', 'o', 'd'];
figure(1);
t=(a:eps*2:b);
plot(t, nested_function(t));
grid on; grid minor;
hold on;
for i=1:1:3
   [mins{i,1},mins{i,2},k] = optimal_sca(a,b,meth_names{1,i},KMax,eps);
   plot(mins{i,:}, shapes(i));
end

nested_function = @f2;
figure(2);
t=(-2:0.1:0);
[X,Y] = meshgrid(t,t);

surf(X,Y, nested_function(X,Y));
shading interp
alpha 0.5;
grid on; grid minor;
hold on;
for i=1:1:3
    [x,fMin,k]=optimal_vec(meth_names{2,i},KMax,eps)
    plot3(x(1),x(2), fMin, [shapes(i),'r']);
end
view([10,45]);

% 
% figure(1);
% t=(a:eps*2:b);
% plot(t, nested_function(t));
% grid on; grid minor;
% hold on;
% % [y,x]= uniform_search(a,b,KMax,@nested_function)
% plot(mins{1,end:-1:1}, 'x');
% % [y,x]=dichotomy(a,b,KMax,eps,@nested_function);
% % plot(x, y, 'D', 'color', [146 127 255] / 255);
% % [y,x]=golden_ratio(a,b,KMax,eps,@nested_function);
% % plot(x, y, 'o', 'color', [255 198 43] / 255);

