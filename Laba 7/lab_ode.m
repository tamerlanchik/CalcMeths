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

A=[1,2,3,4];
b=[4,5,6,7;8,9,10,11]
i=(A*b')'
o= b*A'


t=(0:0.1:1);
x0=[1,1];
f = @(t,y) -2*y+y^3;
% X1 = lab_ode_rk4(t,@lab_ode_func, x0)
% X2 = lab_ode_ab5(t,@lab_ode_func, x0)
[X3,T] = lab_ode_rk45(0,10,@lab_ode_func,x0);
[t,y] = ode45(@lab_ode_func, t, x0);
y=y
figure(1);
p=size(X3)
o=size(T)
% p=X1(:,1)
plot(T,X3(:,1));
hold on;
grid on;
grid minor;
% plot(t,X2(:,1));
plot(t,y);