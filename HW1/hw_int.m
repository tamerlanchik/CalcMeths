clc;
clear variables;
close all force;
addpath("./algos");
if ~exist("./data")
    mkdir("./data");
end
if exist("./data/hw_int_cmd.txt")
    delete('./data/hw_int_cmd.txt');
end
diary ./data/hw_int_cmd.txt;
% -------Нач знач------------

a = 0.2;
b = 0.7;
eps = 10^(-6);
names = {'riemann_left', 'riemann_mid', 'riemann_right', 'trapezoidal', 'simpson', 'gaussian_with_5_points'};

%--------������ N---------------
N=10;
d2n=ones(1, length(names));
D2n=[];
In = zeros(1, length(names));
I2n = zeros(1, length(names));
for j=1:1:6
   In(j)= hw_int_analog(a,b,N, @hw_int_func, names{j});
end
teta=[1/3, 1/3, 1/3, 1/3, 1/15, 1];

while nnz(d2n>eps)~=0
   N=N*2;
   for j=(1:1:6)
       I2n(j) = hw_int_analog(a,b,N, @hw_int_func, names{j});
   end
   d2n = teta.*abs(I2n-In);
   In(:)=I2n(:);
   D2n = [D2n; d2n];
end
N=N/2;
D2n(size(D2n,1),:) = [];

%-------------��������� S-----------------------------

n=[10,100,1000,N];
S = zeros(length(n), length(names));
for i=(1:1:length(n))
   for j=(1:1:length(names))
       S(i,j) = hw_int_analog(a,b,n(i), @hw_int_func, names{j});
   end
end


%-----------------------------------
%������� Ns � ������
Ns=cell(1,length(n));
for i=(1:1:length(n))
    Ns{i} = num2str(n(i));
end

%�������
clf;
figure(1);
set(gcf, 'Position', [50, 200, 1500, 600]);
hold on;

subplot(2,2,1);
hold on;
for i=(1:1:4)
    t=(a:(b-a)/n(i):b)';
    s1=hw_int_func(t);
    plot(t, s1);
end

title("F(x) with several N-s");
xlabel('X');
ylabel('Y');
grid on;
grid minor;
legend(Ns);

subplot(2,2,3);
b=bar(S, 'Hist');
colors=['m', 'b', 'c', 'g', 'k', 'y'];
for i=1:1:6
   b(i).FaceColor=colors(i); 
end
% ylim([0.210, 0.221]);
ylabel('Integral value');
xlabel('N');
xticklabels(Ns);
title("Plot integral analog");
grid on;
grid minor;
legend(strrep(names, '_', ' '), 'Location', 'eastoutside');

subplot(2,2,[2,4]);
hold on;
for i=(1:1:6)
   plot(D2n(:,i), 'Color', colors(i)); 
end
%ylim([0, 0.0001]);
xlabel('Number of iteration');
ylabel(texlabel('Delta2n'));
title("Plot integral analog");
grid on;
grid minor;
title("Delta 2n for all methods");
legend(strrep(names, '_', ' '));

%--------------------------------------------

%���������� S, ������ �������
S=[n', S];
names=['N', names];
disp(array2table(S, 'VariableNames', names));

diary off;
