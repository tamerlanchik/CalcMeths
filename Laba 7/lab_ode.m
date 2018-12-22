clc;
clear variables;
close all force;
addpath("./algos");

%%-----------------
m=1.1;
l=1;
g=9.81;
k=3;
u=1;

t=(0:0.01:10);
x0=[3.14/2,0];
f = @(t,y) -2*y+y^3;
X1 = lab_ode_rk4(t,@lab_ode_func, x0);
X2 = lab_ode_ab5(t,@lab_ode_func, x0);
[t,y] = ode45(@lab_ode_func, t, x0);
y=y;
figure(1);
% p=X1(:,1)
plot(t,X1(:,1));
hold on;
grid on;
grid minor;
plot(t,X2(:,1));
plot(t,y(1));