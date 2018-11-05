clc;
clear variables;
close all force;
addpath("./algos");
% -------------------

a = 0.2;
b = 0.7;
eps = 10^(-6);
names = {'riemann_left', 'riemann_mid', 'riemann_right', 'trapezoidal', 'simpson', 'gaussian_with_5_points'};

N=10;
d2n=ones(1, length(names));
D2n=[];
In = zeros(1, length(names));
I2n = zeros(1, length(names));
while nnz(d2n>eps)~=0
   for j=(1:1:6)
       I2n(j) = hw_int_analog(a,b,N*2, @hw_int_func, names{j});
   end
   d2n = abs(I2n-In);
   In(:)=I2n(:);
   d2n(1) = d2n(1)/3;
   d2n(2) = d2n(1)/3;
   d2n(3) = d2n(1)/3;
   d2n(4) = d2n(1)/3;
   d2n(5) = d2n(1)/15;
   d2n(6) = d2n(1)/15;
   D2n = [D2n; d2n];
   N=N*2;
end
n=[10,100,1000,N];
S = zeros(length(n), length(names));
for i=(1:1:length(n))
   for j=(1:1:length(names))
       ans = hw_int_analog(a,b,n(i), @hw_int_func, names{j});
       S(i,j) = ans;
   end
end

disp(array2table(S, 'VariableNames', names));
fprintf('N = %d\n', n(length(n)));

%-----------------------------------

clf;
figure(1);
set(gcf, 'Position', [50, 200, 1500, 600]);

subplot(2,2,1);
t=(a:(b-a)/N:b)';
s1=hw_int_func(t);
plot(t, s1);
grid on;
grid minor;
xlabel('X');
ylabel('Y\omega');
hold on;

subplot(2,2,3);
bar(S, 'Hist');
ylim([0.214, 0.221]);
ylabel('Value');
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
grid on;
grid minor;
ylim([0, 0.00001]);
for k = 1:size(D2n,2)
    b(k).CData = k;
end
ylim([0, 0.00001])

xlabel('Number of iteration');
ylabel(texlabel('Delta2n'));
legend(strrep(names, '_', ' '));
