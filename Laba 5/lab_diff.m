clc;
clear variables;
close all force;



df=@lab_diff_df;
a = 0.2;
b = 0.7;
% n = 100;
figureNameCounter=1;
N=[20, 1000];
%------------2------------
accDeg = [1,2,4,6];
names = {'forward', 'backward', 'central'};
scalFuncDer = cell(length(accDeg)*length(names)-1, 2);
IE=zeros(length(accDeg),length(names), 2);
epoch=1;
for n=N
    rowCounter=1;
    %в каждой строке пара векторов - df и t(сетка разбиений)
    t=(a:(b-a)/(n-1):b);
    DF=df(t);
    %%2.4
    figure(figureNameCounter);
    for i=1:1:length(accDeg)
         subplot(2,2,i)
         plot(t,DF);
         hold on;
         grid on;
         grid minor;
         xlabel('t');
         ylabel('df');
         title("Порядок точности - "+num2str(accDeg(i)));
         
        for j=1:1:length(names)
            if i==1 && j==3
                break
            end
            [scalFuncDer{rowCounter,:}] = lab_diff_do(a,b,n,names{j}, accDeg(i), @lab_diff_f);
            plot(scalFuncDer{rowCounter,:});
            rowCounter = rowCounter + 1;
        end
        legend({'True derivative','Forward differences', 'Backward differences', 'Central differences'});
    end

    %% 2.5
    figure(figureNameCounter+1);
    rowCounter=1;
    for i=1:1:length(accDeg)
        for j=1:1:length(names)
            if i==1 && j==3
                break
            end
            dError = abs(scalFuncDer{rowCounter,2}-DF');
            temp = isnan(dError);
            dError(temp)=0;
            pointsCount=sum(temp==0);
            IE(i,j,epoch)=sum(dError)/pointsCount;
            rowCounter = rowCounter + 1;            
        end
    end
    
    bar(IE(:,:,epoch)');
    grid on;
    grid minor;
    legend('Degree 1','Degree 2','Degree 4','Degree 6');
    xticklabels({'Forward', 'Backward', 'Central'});
    xlabel('Finite differences');
    title('Integral relative error');
    ylabel('Error value');
    
    figureNameCounter = figureNameCounter+2;
    epoch = epoch+1;
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



