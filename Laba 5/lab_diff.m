clc;
clear variables;
close all force;

% w = [1,2,3,4,5];
% t=(1:1:10)
% d = f(t(1:5)).*w
% 
% function y = f(x)
%     y=x^2;
% end

a = 0.2;
b = 0.7;
n = 10;
%------------2------------
accDeg = [1,2,4,6];
names = {'forward', 'backward', 'central'};
u=length(names)
scalFuncDer = cell(length(accDeg)*length(names), 2);
temp=1;
clf;
%� ������ ������ ���� �������� - df � t(����� ���������)
% for i=1:1:length(accDeg)
%     for j=1:1:length(names)
%         [scalFuncDer{temp,:}] = lab_diff_do(a,b,n,names{j}, accDeg(i), @lab_diff_f);
%         temp = temp + 1;
% %         figure(temp-1);
% %         plot(scalFuncDer{temp-1,:});
% %         title(num2str(i)+" " + num2str(j));
%     end
% end
% celldisp(scalFuncDer);
[y,u] = lab_diff_do(a,b,n,names{1}, 1, @lab_diff_f)

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
