clc;
clear variables;
close all force;
addpath("./algos");

a=-5;
b=5;
eps = 10^(-7);
KMax=10^4;
meth_names={'uniform', 'dichotomy', 'golden_ratio'; 'coordinate_descent', 'gradient', 'newton'};
%------------------------------
nested_function = @f1;
data = cell(6,3);
shapes = ['x', 'o', 'd'];
figure(1);
t=(a:eps*2:b);
plot(t, nested_function(t));
grid on; grid minor;
hold on;
for i=1:1:3
   [data{i,:}] = optimal_sca(a,b,meth_names{1,i},KMax,eps);
   plot(data{i,1},data{i,2}, shapes(i));
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
    [data{3+i,:}]=optimal_vec(meth_names{2,i},KMax,eps);
%     data{3+i,:} = [x,fMin,k];
    plot3(data{3+i,1}(1),data{3+i,1}(2),data{3+i,2}, [shapes(i),'r']);
end
view([10,45]);

disp(array2table(data));

