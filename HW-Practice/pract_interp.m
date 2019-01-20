clc;
clear variables;
close all force;

Na = 10;
Nb = 5*Na;
a = [-30,-30];    %left bottom point
b = [30,30];      %right top point

%interpolated grid
T0 = zeros(Na, 2);
T0(:,1) = (a(1):(b(1)-a(1))/(Na-1):b(1))';
T0(:,2) = (a(2):(b(2)-a(2))/(Na-1):b(2))';

%interpolation grid
T = zeros(Nb, 2);
T(:,1) = (a(1):(b(1)-a(1))/(Nb-1):b(1))';
T(:,2) = (a(2):(b(2)-a(2))/(Nb-1):b(2))';

%interpolated function
% f = @(x,y) ((x+50).^2 + y.^2 + 10)*100;
% f = @(x,y) (x.^2 - y.^2)/2;
f = @(x,y) x.^2 + 2;
%F'x = 2x
%F'y = 2y
%F''xy=0

%grid
[X0,Y0] = meshgrid(T0(:,1),T0(:,2));
[X,Y] = meshgrid(T(:,1),T(:,2));

F1 = my_bilinear(f(X0,Y0), {X0,Y0}, {X,Y});
F2 = my_bicubic(f(X0,Y0), {X0,Y0}, {X,Y});


figure(1);

subplot(2,2,1);
F0 = f(X0,Y0);
surf(X0,Y0,F0);
alpha 0.7;
grid on;
grid minor;

subplot(2,2,2);
surf(X,Y,F1);
alpha 0.7;
grid on;
grid minor;

subplot(2,2,3);
surf(X0,Y0,F0);
alpha 0.7;
grid on;
grid minor;

subplot(2,2,4);
surf(X,Y,F2);
% shading interp;
alpha 0.7;
grid on;
grid minor;
% view([45,45]);

maxM=10;
Err1=zeros(maxM-1,1);
Err2=zeros(maxM-1,1);
Time1=zeros(maxM-1,1);
Time2=zeros(maxM-1,1);
CGrid=(2:1:maxM);

i=1;
for c=CGrid
   Nb = c*Na; 
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
    
    temp1=0;
    temp2=0;
    for j=1:1:5
        tic;
        F1 = my_bilinear(f(X0,Y0), {X0,Y0}, {X,Y});
        temp1 = temp1 + toc;
        
        tic;
        F2 = my_bicubic(f(X0,Y0), {X0,Y0}, {X,Y});
        temp2 = temp2 + toc;
    end
    Time1(i)=temp1/5;
    Time2(i)=temp2/5;
%     tic;
%     F2 = my_bicubic(f(X0,Y0), {X0,Y0}, {X,Y});
%     Time2(c)=toc;
    err=0;
    FTrue = f(X,Y);
    err1 = sum(sum(abs(FTrue-F1)));
    err2 = abs(FTrue-F2);
    temp = isnan(err2);
    err2(temp)=0;
    err2 = sum(sum(err2));
    err1 = err1/(size(FTrue,1)*size(FTrue,2));
    err2 = err2/(size(FTrue,1)*size(FTrue,2));
%     fprintf('Normalized: Err1 = %d\nErr2 = %d\n',err1,err2);
    Err1(i)=err1;
    Err2(i)=err2;
    i=i+1
end
CGrid=CGrid;
q=size(Err1)
q=size(Err2)
q=size(Time1)
q=size(Time2)
q=size(CGrid)
figure(3);
subplot(2,3,[1,4]);
plot(CGrid,Err1, "LineWidth",2);
hold on;
plot(CGrid,Err2, "LineWidth",2,"Color",'r');
legend("Bilinear", "Bicubic");
xlabel('Number of division');
ylabel('Error per point');

subplot(2,3,[2,5]);
plot(CGrid, Time1,"LineWidth",2);
hold on;
plot(CGrid, Time2,"LineWidth",2,"Color",'r');
legend("Bilinear", "Bicubic");
xlabel('Number of division');
ylabel('Average time, s');

subplot(2,3,3);
plot(Time1,Err1,"LineWidth",2);
legend("Bilinear");
ylabel('Error per point');
xlabel('Average time, s');
Err1=Err1
subplot(2,3,6);
plot(Time2,Err2,"LineWidth",2,"Color",'r');
legend("Bicubic");
ylabel('Error per point');
xlabel('Average time, s');
