clc;
clear variables;
close all force;
addpath("./algos");
if ~exist("./data")
    mkdir("./data");
end
if exist("./data/hw_int_cmd1.txt")
    delete('./data/hw_int_cmd1.txt');
end
diary ./data/hw_int_cmd1.txt;
% -------------------

a = 0.2;
b = 0.7;
eps = 10^(-6);
names = {'riemann_left', 'riemann_mid', 'riemann_right', 'trapezoidal', 'simpson', 'gaussian_with_5_points'};

N=10;
d2n=ones(1, length(names));
D2n=[];
In = (b-a)*hw_int_func((a+b)/2)*ones(1, length(names));
teta=[1/3, 1/3, 1/3, 1/3, 1/15, 1/15];
while nnz(d2n>eps)~=0
   N=N*2;
   for j=(1:1:6)
       I2n = hw_int_analog(a,b,N, @hw_int_func, names{j});
       d2n(j)=teta(j)*abs(I2n-In(j));
       In(j)=I2n;
   end
   D2n = [D2n; d2n];
end

n=[10,100,1000,N];
S = zeros(length(n), length(names));
for i=(1:1:length(n))
   for j=(1:1:length(names))
       S(i,j) = hw_int_analog(a,b,n(i), @hw_int_func, names{j});
   end
end

disp(array2table(S, 'VariableNames', names));
fprintf('N = %d\n', n(length(n)));

diary off;
%-----------------------------------

clf;
figure(1);
set(gcf, 'Position', [50, 200, 1500, 600]);
hold on;

subplot(2,2,1);
t=(a:(b-a)/N:b)';
s1=hw_int_func(t);
plot(t, s1);
xlabel('X');
ylabel('Y');
grid on;
grid minor;

subplot(2,2,3);
bar(S, 'Hist');
ylim([0.214, 0.221]);
ylabel('Integral value');
xlabel('N');
Ns=cell(1,length(n));
for i=(1:1:length(n))
    Ns{i} = num2str(n(i));
end
xticklabels(Ns);
grid on;
grid minor;

subplot(2,2,[2,4]);
b=bar(D2n, 'FaceColor', 'flat');
ylim([0, 0.00001]);
for k = 1:size(D2n,2)
    b(k).CData = k;
end
xlabel('Number of iteration');
ylabel(texlabel('Delta2n'));
grid on;
grid minor;

legend(strrep(names, '_', ' '));
