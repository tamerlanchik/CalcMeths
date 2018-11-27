clc;
clear variables;
close all force;



a = 0.2;
b = 0.7;
n = 100;
accDeg = [1,2,4,6];
names = {'forward', 'backward', 'central'};
u=length(names)
scalFuncDer = cell(length(accDeg)*length(names), 2);
temp=1;
clf;
%в каждой строке пара векторов - df и t(сетка разбиений)
for i=1:1:length(accDeg)
    for j=1:1:length(names)
        [scalFuncDer{temp,:}] = lab_diff_do(a,b,n,names{j}, accDeg(i), @lab_diff_f);
        temp = temp + 1;
        figure(temp-1);
        plot(scalFuncDer{temp-1,:});
        title(num2str(i)+" " + num2str(j));
    end
end
celldisp(scalFuncDer);

clf;

% figure(0);
% t = (a:(b-a)/(n-1):b);
% plot(t, lab_diff_df(t));