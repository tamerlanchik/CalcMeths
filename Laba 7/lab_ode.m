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

t=(0:0.01:10)
x0=[1,1];
X1 = lab_ode_rk4(t,@lab_ode_func, x0);