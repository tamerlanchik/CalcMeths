clc;
clear variables;
close all force;
%%
xMin = zeros(2,2);
fMin = zeros(2,1);

x0 = ones(2,1);

fctOptSearch =optimset('MaxIter',2000,'MaxFunEvals',10^3,'TolX',10^(-10),'TolFun',10^(-10),'FinDiffRelStep',10^(-10),'FinDiffType','central','Display','iter-detailed');
fctOptCon = optimoptions('fmincon','MaxIter',2000,'MaxFunEvals',10^3,'TolX',10^(-10),'TolFun',10^(-10),'FiniteDifferenceStepSize',10^(-10),'FiniteDifferenceType','central','Display','iter-detailed');
[xMin(:,1),fMin(1)]=fminsearch(@hw_optimal_f,x0,fctOptSearch);
[xMin(:,2),fMin(2)]=fmincon(@hw_optimal_f,x0,[],[],[],[],[],[],[],fctOptCon);
disp(table([xMin(1,1);xMin(1,2)],[xMin(2,1);xMin(2,2)],[fMin(1);fMin(2)],'RowNames',{'fMinSearch','fMinCon'}, 'VariableNames', {'xMin1','xMin2','fMin'}));

%%
f = @(x,t) x(1).*exp(x(2).*t);
t=(0:0.01:2);
x=[5;-10];
y1 = f([5;-10],t);
w=randn(1,length(t));
y2 = y1 + 0.3*w;
fctOptLSQ = optimoptions('lsqcurvefit',fctOptCon);
xMin=zeros(3,2);
xMin(1,:)=lsqcurvefit(f,x0,t,y1,[-100,-100],[100,100],fctOptLSQ);
xMin(2,:)=lsqcurvefit(f,x0,t,y2,[-100,-100],[100,100],fctOptLSQ);
xMin(3,:) = hw_optimal_f2(f,t,y2,x0,fctOptCon);

figure(1);
subplot(3,1,1);
scatter(t, y1);
hold on;
grid on;
grid minor;
plot(t, f(xMin(1,:),t), 'LineWidth',1);
ylim([-2,6]);
title('First experiment data & lsqcurvefit()');
legend('Experimental data y1', 'F(x,t) with the best X');
xlabel('X');
ylabel('Y');

subplot(3,1,2);
scatter(t, y2);
hold on;
grid on;
grid minor;
plot(t, f(xMin(2,:),t),'LineWidth',1);
title('Second experiment data & lsqcurvefit()');
legend('Experimental data y2 (with noise)', 'F(x,t) with the best X');
xlabel('X');
ylabel('Y');

subplot(3,1,3);
scatter(t, y2);
hold on;
grid on;
grid minor;
plot(t, f(xMin(3,:),t),'LineWidth',1);
title('Second experiment data & fmincon()');
legend('Experimental data y2 (with noise)', 'F(x,t) with the best X');
xlabel('X');
ylabel('Y');