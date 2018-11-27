clc;
clear variables;
close all force;

% ws = {1,2,3};
% defs = {4,5,6};
% dict = containers.Map(ws, defs);
% disp(dict(2));
% dd = {8,9,10,11};
% W = cell(4,1);
% 
% W{1} = [1, -1]';
% W{2} = [-1/2, 2, -3/2]';
% W{3} = [ -1/4, 4/3, -3, 4, -25/12 ]';
% W{4} = [-1/6, 6/5, -15/4, 20/3, -15/2, 6, -49/20]';
% A=cell(3,1);
% A{1} = [1/2, 0, -1/2]';
% A{2} = [-1/12, 2/3, 0, -2/3, 1/12]';
% A{3} = [1/60, -3/20, 3/4, 0, -3/4, 3/20, -1/60]';
% 
% defs = {1,2,4,6};
% M = containers.Map(defs, W);
% E=containers.Map(defs(2:end), A);
% disp(M(4))
% disp(E(6))

a = 0.2;
b = 0.7;
n = 100;
%------------2------------
accDeg = [1,2,4,6];
names = {'forward', 'backward', 'central'};
u=length(names)
scalFuncDer = cell(length(accDeg)*length(names), 2);
temp=1;
clf;
%в каждой строке пара векторов - df и t(сетка разбиений)
for i=1:1:length(accDeg)
    for j=1:1:length(names)
        if i==1 && j==3
            break
        end
        [scalFuncDer{temp,:}] = lab_diff_do(a,b,n,names{j}, accDeg(i), @lab_diff_f);
        temp = temp + 1;
        figure(temp-1);
        plot(scalFuncDer{temp-1,:});
        title(num2str(i)+" " + num2str(j));
    end
end
celldisp(scalFuncDer);
% [y,u] = lab_diff_do(a,b,n,names{1}, 1, @lab_diff_f)

%---------3------------

h=0.01;
x0=[1,1];
J = cell(length(names));    %calculated Jacobi
derivs={@(x) F1(x), @(x) F2(x)};
for i=1:1:length(names)
    J{i} = jacobi(x0, h, @doubleArgFunc, names{i});
end
%celldisp(J);

rJ = zeros(1,2);            %exact Jacobi
rJ(1,1) = derivs{1}(x0);
rJ(1,2) = derivs{2}(x0);
%disp(rJ);

dJ=zeros(1, length(names));  %delta
for i=1:1:length(names)
    dJ(i) = sum((abs(rJ-J{i})./rJ).^2);
end
disp(dJ)


function f = doubleArgFunc(x)
    f = (x(1)+1)^2 + (x(2)+1)^2 + 2;
end
function f = F1(x)
    f = 2*(x(1)+1);
end

function f = F2(x)
    f = 2*(x(2)+1);
end
