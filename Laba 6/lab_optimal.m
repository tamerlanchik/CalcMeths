clc;
clear variables;
close all force;
addpath("./algos");

a=-5;
b=5;
eps = 10^(-4);
KMax=10^6;
meths1 = cell(6,1);
meths2 = cell(6,1);
meths1{1} = @(a,b,KMax,eps,f) uniform_search(a,b,KMax,eps,f);
meths1{2} = @(a,b,KMax, eps,f) dichotomy(a,b,KMax,eps,f);
meths1{3} = @(a,b,KMax,eps,f) golden_ratio(a,b,KMax,eps,f);
meths2{1} = @(KMax,eps,f,df) coordinate_descent(KMax,eps,f,df);
meths2{2} = @(a,b,KMax,eps,f) gradient(KMax,eps);
meths2{3} = @(a,b,KMax,eps,f) uniform_search(a,b,KMax,eps,f);
%------------------------------
nested_function = @f1;
mins = cell(6,2);
shapes = ['x', 'o', 'd'];
% figure(1);
% t=(a:eps*2:b);
% plot(t, nested_function(t));
% grid on; grid minor;
% hold on;
% for i=1:1:3
%    [mins{i,:}] = meths1{i}(a,b,KMax,eps,nested_function);
%    plot(mins{i,end:-1:1}, shapes(i));
% end

df2 = { @(x) 2*(x(1)+1), @(x) 2*(x(2)+1) };
nested_function = @f2;
figure(2);
t=(-5:1:5);
[X,Y] = meshgrid(t,t);

surf(X,Y, nested_function(X,Y));
shading interp
alpha 0.5;
grid on; grid minor;
hold on;
% alpha 1
for i=1:1:1
%    [mins{i,:}] = meths2{i}(KMax,eps,nested_function, df2);
%    p=mins{i,:}
    p=meths2{i}(KMax,eps,nested_function, df2)
    plot3(p{1}(1),p{1}(2), p{2}, [shapes(i),'r']);
end
view([10,45]);
o=mins{1,:}

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

