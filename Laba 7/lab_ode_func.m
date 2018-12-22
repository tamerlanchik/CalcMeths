function dydt = lab_ode_func(t,y)
    m = 1.1; l=1; g=9.81; k=3; u=1;
    dydt = [y(2), (u-k*l^2-m*g*sin(y(1)))/(m*l^2)];
end