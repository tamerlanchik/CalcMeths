clc;
clear variables;
close all force;

Na = 30;
Nb = 5*Na;
a = [-1,-1];    %left bottom point
b = [1,1];      %right top point





%interpolated grid
T0 = zeros(Na, 2);
T0(:,1) = (a(1):(b(1)-a(1))/(Na-1):b(1))';
T0(:,2) = (a(2):(b(2)-a(2))/(Na-1):b(2))';

%interpolation grid
T = zeros(Nb, 2);
T(:,1) = (a(1):(b(1)-a(1))/(Nb-1):b(1))';
T(:,2) = (a(2):(b(2)-a(2))/(Nb-1):b(2))';

%interpolated function

% f = @(x,y) ((x+5).^2 + y.^2 + 10);
% f = @(x,y) (x.^2 - y.^2)/2;
% f = @(x,y) x.^2 + 2;
% f = @(x,y) (x.^2 + y.^2+2).^0.5;
% f = @(x,y) (5+x)./(5-x).*(x.^2) - y.^2;

%from https://www.emse.fr/enbis-emse2009/pdf/articles/Muehlenstaedt%20Kuhnt.pdf
fList = cell(6,1);
fNames=cell(6,1);
fZones = cell(6,2);
fXYLim=cell(6,1);
fZLim=cell(6,1);
%Hump function
fList{2} = @(x,y) 1.0316+4*x.^2-2.1*x.^4 + (1/3)*x.^6 + x.*y - 4*y.^2 + 4*y.^4;
fNames{2} = 'Hump';
fZones{2,1} = [-7;-7];
fZones{2,2} = [7;7];
%Peaks function
fList{3} = @(x,y) 3*((1-x).^2).*exp(-x.^2-(y+1).^2)-10*(x./5-x.^3-y.^5).*exp(-x.^2-y.^2)-(1/3)*exp(-(x+1).^2-y.^2);
fNames{3} = 'Peaks';
fZones{3,1} = [-5;-5];
fZones{3,2} = [5;5];
%Not smooth
fList{4} = @(x,y) abs(x.^2 + sin(0.5*pi*y) - y);
fNames{4} = 'Not smooth';
fZones{4,1} = [-1;-1];
fZones{4,2} = [1;1];
%Sibson
fList{5} = @(x,y) cos(4*pi*((x-0.25).^2 + (y-0.25).^2).^(1/2));
fNames{5} = 'Sibson';
fZones{5,1} = [0;0];
fZones{5,2} = [1;1];

fList{6}=@(x,y) ((100*x).^2 + (100*y).^2 + 10);
fNames{6}='Paraboloid';
fZones{6,1} = [-50;-50];
fZones{6,2} = [50;50];


[X0,Y0] = meshgrid((a(1):0.1:b(1))',(a(2):0.1:b(2))');
for fN=2:1:size(fList,1)
    figure(fN);
    surf(X0,Y0,fList{fN}(X0,Y0));
    shading interp;
end

%grid
[X0,Y0] = meshgrid(T0(:,1),T0(:,2));
[X,Y] = meshgrid(T(:,1),T(:,2));
methNames={'Bilinear', 'Bicubic', 'Bicubic Kramer'};
meths = { @(A,B,C) my_bilinear(A,B,C); @(A,B,C) my_bicubic(A,B,C); @(A,B,C) my_optimized_bicubic(A,B,C) };
Err=[];
Time=[];
for fN=2:1:size(fList,1)
% for fN=4:1:4
    a = fZones{fN,1};
    b = fZones{fN,2};
    a=a
    b=b
    %interpolated grid
    T0 = zeros(Na, 2);
    T0(:,1) = (a(1):(b(1)-a(1))/(Na-1):b(1))';
    T0(:,2) = (a(2):(b(2)-a(2))/(Na-1):b(2))';

    %interpolation grid
    T = zeros(Nb, 2);
    T(:,1) = (a(1):(b(1)-a(1))/(Nb-1):b(1))';
    T(:,2) = (a(2):(b(2)-a(2))/(Nb-1):b(2))';

    %grid
    [X0,Y0] = meshgrid(T0(:,1),T0(:,2));
    [X,Y] = meshgrid(T(:,1),T(:,2));
    
    F0 = fList{fN}(X,Y);    %true F value
    timeAverage = zeros(1,3);
    F=zeros(size(F0,1),size(F0,2),3);
    triesNumber=50;
    for j=1:1:triesNumber
        for m = 1:1:3
            tic;
            F(:,:,m) = meths{m}(fList{fN}(X0,Y0), {X0,Y0}, {X,Y});
            timeAverage(m) = timeAverage(m) + toc;
        end
    end
    timeAverage = timeAverage./triesNumber;
    Time=[Time; timeAverage];
    
  
%     figure(fN);
    figure('NumberTitle', 'off', 'Name', fNames{fN});
%     name("efe");
%     subplot(2,2,1);
%     surf(X0,Y0,fList{fN}(X0,Y0));
%     alpha 0.7;
    zL=-1;
    for j=1:1:size(meths,1)-1
        if j==1
            subplot(2,2,[1, 2]);
            
            FT=fList{fN}(X0,Y0);
            if sum(sum(isnan(F(:,:,j))))~=0
                FT(1,:)=nan;
                FT(end,:)=nan;
                FT(:,1)=nan;
                FT(:,end)=nan;
            end
            surf(X0,Y0,FT);
            title('Source');
            alpha 0.7;
            zL=zlim; 
           xL=xlim;
           yL=ylim;
           if abs(zL(1))<0.01
             zL(1) = -zL(2)/10;
           end
        end
%         if j==1
%            zL=zlim; 
%            xL=xlim;
%            yL=ylim;
%            if abs(zL(1))<0.01
%              zL(1) = -zL(2)/10;
%            end
%         end
        zlim(zL);
        xlim(xL);
        ylim(yL);
       subplot(2,2, 2+j);
       
       surf(X,Y,F(:,:,j));
       title(methNames{j});
       shading flat;
       
       zlim(zL);
       xlim(xL);
       ylim(yL);
    end
    F = abs(1-F./F0);
    temp=isnan(F);
    pointsCount=sum(sum(temp==0));
    F(temp)=0;
    Err = [Err, squeeze(sum(sum(F))./pointsCount)];
end
Err(1,:)=[];
Time(:,1)=[];

methNames={'Bilinear', 'Bicubic', 'Bicubic Kramer'};
figure('NumberTitle', 'off', 'Name', 'Conclusion: Na=30, Nb=150');
subplot(1,2,1);
bar(log10(Err'+1));
xticklabels(fNames);
xlabel('Function names');
ylabel('Relative error per point');
grid on;
grid minor;
legend(methNames);
% ylim([0,3]);

subplot(1,2,2);
bar(Time);
xticklabels(fNames);
xlabel('Function names');
ylabel("Work time, s");
grid on;
grid minor;
legend(methNames);

figure(30);
bar(Err(:,end)');
% ylim([0,0.0003]);
xticklabels(methNames);
ylabel('Relative error per point');

Na = 5;
Nb = 30*Na;

%interpolated grid
T0 = zeros(Na, 2);
T0(:,1) = (a(1):(b(1)-a(1))/(Na-1):b(1))';
T0(:,2) = (a(2):(b(2)-a(2))/(Na-1):b(2))';

%interpolation grid
T = zeros(Nb, 2);
T(:,1) = (a(1):(b(1)-a(1))/(Nb-1):b(1))';
T(:,2) = (a(2):(b(2)-a(2))/(Nb-1):b(2))';


%grid
[X0,Y0] = meshgrid(T0(:,1),T0(:,2));
[X,Y] = meshgrid(T(:,1),T(:,2));

Err=[];
Time=[];
for fN=2:1:size(fList,1)
    F0 = fList{fN}(X,Y);    %true F value
    timeAverage = zeros(1,3);
    F=zeros(size(F0,1),size(F0,2),3);
    triesNumber=50;
    for j=1:1:triesNumber
        for m = 1:1:3
            tic;
            F(:,:,m) = meths{m}(fList{fN}(X0,Y0), {X0,Y0}, {X,Y});
            timeAverage(m) = timeAverage(m) + toc;
        end
    end
    timeAverage = timeAverage./triesNumber;
    Time=[Time; timeAverage];
    
    F = abs(1-F./F0);
    temp=isnan(F);
    pointsCount=sum(sum(temp==0));
    F(temp)=0;
    Err = [Err, squeeze(sum(sum(F))./pointsCount)];
end
Err(1,:)=[];
Time(:,1)=[];
QQQ=log10(Err+1)
figure('NumberTitle', 'off', 'Name', 'Conclusion: Na=5, Nb=150');
subplot(1,2,1);
bar(Err');
xticklabels(fNames);
xlabel('Function names');
ylabel('Relative error per point');
grid on;
grid minor;
legend(methNames);
ylim([0,20]);

subplot(1,2,2);
bar(Time);
xticklabels(fNames);
xlabel('Function names');
ylabel("Work time, s");
grid on;
grid minor;
legend(methNames);

figure(40);
bar(Err(:,end)');
% ylim([0,0.0003]);
xticklabels(methNames);
ylabel('Relative error per point');