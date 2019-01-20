clc;
clear variables;
close all force;

Na = 10;
Nb = 5*Na;
a = [-10,-10];    %left bottom point
b = [10,10];      %right top point

%interpolated grid
T0 = zeros(Na, 2);
T0(:,1) = (a(1):(b(1)-a(1))/(Na-1):b(1))';
T0(:,2) = (a(2):(b(2)-a(2))/(Na-1):b(2))';

%interpolation grid
T = zeros(Nb, 2);
T(:,1) = (a(1):(b(1)-a(1))/(Nb-1):b(1))';
T(:,2) = (a(2):(b(2)-a(2))/(Nb-1):b(2))';

%interpolated function
f = @(x,y) x.^2 + y.^2 + 2;
%F'x = 2x
%F'y = 2y
%F''xy=0

%grid
[X0,Y0] = meshgrid(T0(:,1),T0(:,2));
[X,Y] = meshgrid(T(:,1),T(:,2));

F1 = my_bilinear(f(X0,Y0), {X0,Y0}, {X,Y});
F2 = my_bicubic(f(X0,Y0), {X0,Y0}, {X,Y});


figure(1);

subplot(2,2,1);
F0 = f(X0,Y0);
surf(X0,Y0,F0);
alpha 0.7;
grid on;
grid minor;

subplot(2,2,2);
surf(X,Y,F1);
alpha 0.7;
grid on;
grid minor;

subplot(2,2,3);
surf(X0,Y0,F0);
alpha 0.7;
grid on;
grid minor;

subplot(2,2,4);
surf(X,Y,F2);
% shading interp;
alpha 0.7;
grid on;
grid minor;
view([45,45]);