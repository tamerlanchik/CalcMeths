clc;
clear variables;
close all force;
%my_bicubic(1,2,3);
Na = 4;
Nb = 10*Na;
a = [-1,-1];
b = [2,2];

T0 = zeros(Na, 2);
T0(:,1) = (a(1):(b(1)-a(1))/(Na-1):b(1))';
T0(:,2) = (a(2):(b(2)-a(2))/(Na-1):b(2))';

T = zeros(Nb, 2);
T(:,1) = (a(1):(b(1)-a(1))/(Nb-1):b(1))';
T(:,2) = (a(2):(b(2)-a(2))/(Nb-1):b(2))';

f = @(x,y) x.^2 + y.^2 + 2;

[X0,Y0] = meshgrid(T0(:,1),T0(:,2))
[X,Y] = meshgrid(T(:,1),T(:,2));
F = my_bicubic(f(X0,Y0), {X0,Y0}, {X,Y});
figure(1);
x=size(X)
y=size(Y)
p=size(F)
% surf(X,Y,f(X,Y));
surf(X,Y,F);
hold on;
% surf(X0,Y0,f(X0,Y0));
alpha 0.5;
% shading interp
view([30,10]);
