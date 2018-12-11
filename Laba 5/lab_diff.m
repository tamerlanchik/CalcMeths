clc;
clear variables;
close all force;



df=@lab_diff_df;
a = 0.2;
b = 0.7;
% n = 100;
k=1;
N=[10, 1000];
%------------2------------
accDeg = [1,2,4,6];
names = {'forward', 'backward', 'central'};
scalFuncDer = cell(length(accDeg)*length(names)-1, 2);
IE=zeros(length(accDeg),length(names), 2);
tt=1
for n=N
    temp=1;
    %в каждой строке пара векторов - df и t(сетка разбиений)
    t=(a:(b-a)/(n-1):b);
    DF=df(t);


    %%2.4
     figure(k);
    for i=1:1:length(accDeg)
         subplot(2,2,i)
         plot(t,DF);
         hold on;
         grid on;
         grid minor;
         xlabel('t');
         ylabel('df');
    %      legend({'True derivative','Forward differences', 'Backward differences', 'Central differences'},'Location','best');
    %      legend(["wded", "forward", "backward", "central"]);
        title("ѕор€док точности - "+num2str(accDeg(i)));
        for j=1:1:length(names)
            if i==1 && j==3
                break
            end
            [scalFuncDer{temp,:}] = lab_diff_do(a,b,n,names{j}, accDeg(i), @lab_diff_f);
    %         subplot(2,2,i);
            plot(scalFuncDer{temp,:});
            legend({'True derivative','Forward differences', 'Backward differences', 'Central differences'});
    %         hold on;
    %         title('ѕор€док точности - '+num2str(i));
            temp = temp + 1;
        end
    end
    %celldisp(scalFuncDer);
    % [y,u] = lab_diff_do(a,b,n,names{1}, 1, @lab_diff_f)

    %% 2.5
    figure(k+1);
    temp=1;
    for i=1:1:length(accDeg)
        for j=1:1:length(names)
            if i==1 && j==3
                break
            end
            switch j
                case 1
                    s=1;
                    fin=n-accDeg(i);
                case 2
                    s=accDeg(i)+1
                    fin=n
                case 3
                    s=accDeg(i)/2+1;
                    fin = n-accDeg(i)/2;
            end
            disp(size(scalFuncDer{temp,2}))
            disp(size(DF(s:fin)))
            IE(i,j,tt)=sum(abs(scalFuncDer{temp,2}-DF(s:fin)'));
            temp = temp + 1;
            
        end
    end
    IE(:,:,tt)=IE(:,:,tt)./n;
    bar(IE(:,:,tt)');
    grid on;
    grid minor;
    legend('Degree 1','Degree 2','Degree 4','Degree 6');
    xticklabels({'Forward', 'Backward', 'Central'});
    xlabel('Finite differences');
    title('Integral relative error');
    ylabel('Error value');
    k = k+2;
    tt = tt+1;
end


%---------3------------

h=0.01;
x0=[1,1];
J = cell(length(names));    %calculated Jacobi
derivs={@(x) F1(x), @(x) F2(x)};
for i=1:1:length(names)
    J{i} = jacobi(x0, h, @doubleArgFunc, names{i})
end
celldisp(J);

rJ = zeros(1,2);            %exact Jacobi
rJ(1,1) = derivs{1}(x0);
rJ(1,2) = derivs{2}(x0);
%disp(rJ);

dJ=zeros(1, length(names));  %delta
for i=1:1:length(names)
    dJ(i) = sum((abs(rJ-J{i})./rJ).^2)^0.5;
end
disp(dJ)

%%3.2
figure(5);
    bar(dJ);
    grid on;
    grid minor;
    legend('Degree 1');
    xticklabels({'Forward', 'Backward', 'Central'});
    xlabel('Finite differences');
    title('Integral relative error Jacobi');
    ylabel('Error value');
    k = k+2;



function f = doubleArgFunc(x)
    f = (x(1)+1)^2 + (x(2)+1)^2 + 2;
end
function f = F1(x)
    f = 2*(x(1)+1);
end

function f = F2(x)
    f = 2*(x(2)+1);
end



