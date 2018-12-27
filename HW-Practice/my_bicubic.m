% function [F, C] = my_bicubic(F0,C0,C)
%     p = size(C0);
%     X0 = C0{1};
%     Y0 = C0{2};
%     X=C{1};
%     Y=C{2};
%     F = zeros(size(X));
%     for i=
%     
% end
function [F1, C] = my_bicubic(F0,C0,C)
    %https://en.wikipedia.org/wiki/Bicubic_interpolation#Computation
    %�������� �����, X0(i,j) - ���������� �� x
    X0 = C0{1};
    Y0 = C0{2};
    %���������������� �����
    X1=C{1};
    Y1=C{2};
    F1 = zeros(size(X1));
    
    A = zeros(16);
    p=1; q=1;   %������� ��������������� �����
    while(X1(p,p)<=X0(2,2))
        p = p + 1;
    end
    while(Y1(q,q)<=Y0(2,2))
        q = q + 1;
    end
    %i,j - ���������� ������� ����� ����� ��������, � ������� �������������
    for i=2:1:size(X0,1)-2
        for j=2:1:size(Y0,2)-2
            fprintf('i=%d, j=%d\n',i,j)
            fprintf('X=%d, Y=%d\n', X0(i,j),Y0(i,j));
            %���� alpha={a(i,j)} � ���� ������ [a11,a21,...]
            %X = [f(0,0),f(1,0),f(0,1),f(1,1),fx(0,0), ... ,fy(0,0), ..., fxy(0,0), ...]
            %�������� � ��������� A^(-1)*X=alpha
            %������� F(x1,y1) = sum(sum(a(i,j)*X^i*Y^j))
            %----------------
            temp=1;
            for m=[0,1]
                for n=[0,1]
                    A(:,temp) = P(X0(j+m,i+n),Y0(j+m,i+n));
                    A(:,temp+4) = px(X0(j+m,i+n),Y0(j+m,i+n));
                    A(:,temp+8) = py(X0(j+m,i+n),Y0(j+m,i+n));
                    A(:,temp+12) = pxy(X0(j+m,i+n),Y0(j+m,i+n));
                    
                    fprintf('X=%d,Y=%d,temp=%d\n',X0(j+m,i+n),Y0(j+m,i+n),temp);
                    temp=temp+1;
                end
            end
            A=A'
            
%             ooo=P(1,0)
%             i=0;j=0;
%             A(1,:)=P(i,j);
%             A(2,:)=P(i+1,j);
%             A(3,:)=P(i,j+1);
%             A(4,:)=P(i+1,j+1);
%             A(5,:)=px(i,j);
%             A(6,:)=px(i+1,j);
%             A(7,:)=px(i,j+1);
%             A(8,:)=px(i+1,j+1);
%             A(9,:)=py(i,j);
%             A(10,:)=py(i+1,j);
%             A(11,:)=py(i,j+1);
%             A(12,:)=py(i+1,j+1);
%             A(13,:)=pxy(i,j);
%             A(14,:)=pxy(i+1,j);
%             A(15,:)=pxy(i,j+1);
%             A(16,:)=pxy(i+1,j+1);
%             A=A
            A=A^(-1)
            %----------------------
            X=zeros(16,1);
            X(1:4)=[F0(i,j),F0(i+1,j),F0(i,j+1),F0(i+1,j+1)];
            %0------->x
            %|
            %|
            %Vy

            % Fx(0,0), Fx(1,0), Fx(0,1), Fx(1,1)
            % Fy(0,0), Fy(1,0), Fy(0,1), Fy(1,1)
            % Fxy(0,0), Fxy(1,0), Fxy(0,1), Fxy(1,1)
            %A(y,x)
            temp=5;
            for m=[0,1]
                for n=[0,1]
                    fprintf('str68: n=%d, m=%d; temp=%d\n',m,n,temp);
                    X(temp) = (F0(j+m,i+n+1)-F0(j+m,i-1+n))/(X0(j+m,i+n+1)-X0(j+m,i-1+n));
                    X(temp+4) = (F0(j+m+1,i+n)-F0(j+m-1,i+n))/(Y0(j+m+1,i+n)-Y0(j+m-1,i+n));
                    temp = temp + 1;
                end
            end

            ders = zeros(1,2*4);
            temp=1;
            %����������� �� � ��� ����� ��������, � ����� ��� ����� �� 1
            %���� � ���� ����
            %��������� �� �������
            for m=(-1:1:2)
                for n=[0,1]
                    %current point: x=i+n, y=j+m
                    ders(temp) = (F0(j+m,i+n+1)-F0(j+m,i+n-1))/(X0(j+m,i+n+1)-X0(j+m,i-1+n));
                    temp = temp+1;
                end
            end
            
            % Fxy(0,0), Fxy(1,0), Fxy(0,1), Fxy(1,1)
            %Fxy(0,0) = (Fx(0,1)-Fx(0,-1))/(Y0(0,1)-Y0(0,-1))
            %Fxy(i,j) = (Fx(i,j+1)-Fx(i,j-1))/(Y0(i,j+1)-Y0(i,j-1))
            temp=13;
            for m=[0,1]
                for n=[0,1]
                    X(temp) = (ders(2*(2+m)+n)-ders((1+m)+n))/(Y0(j+m+1,i+n)-Y0(j+m-1,i+n));
                    temp = temp + 1;
                end
            end
            
            alpha = A*X;
            p0=p;
            while X1(p,q)<X0(i,j)
                while Y1(p,q)<Y0(i,j)
                    Px=0;
                    for k=0:1:3
                        for l=0:0:3
                            Px = Px+alpha(k*4+j)*(X1(p,q)^k)*(Y1(p,q)^l);
                        end
                    end
                    F1(p,q) = Px;
                    p=p+1;
                end
                p=p0;
                q = q+1;
            end
        end
    end
end
function t=P(x,y)
    t = zeros(1,16);
    for i=0:1:3
        for j=0:1:3
            t(j*4+i+1) = (x.^i).*(y.^j);
%             fprintf('a%d-%d=%d\n',i,j,(x.^i).*(y.^j))
%             fprintf('t, %d\n',j*4+i+1)
        end
    end
%     fprintf('\n');
end
function t = px(x,y)
    t = zeros(1,16);
    for i=1:1:3
        for j=0:1:3
            t(j*4+i+1) = i*(x.^(i-1)).*(y.^j);
%             fprintf('a%d-%d=%d\n',i,j,i*(x.^(i-1)).*(y.^j))
%             fprintf('t, %d\n',j*4+i+1)
        end
    end
%     fprintf('\n');
end
function t = py(x,y)
    t = zeros(1,16);
    for i=0:1:3
        for j=1:1:3
            t(j*4+i+1) = (x.^i).*(y.^(j-1))*j;
%             fprintf('a%d-%d=%d\n',i,j,(x.^i).*(y.^(j-1))*j)
%             fprintf('t, %d\n',j*4+i+1)
        end
    end
%     fprintf('\n');
end
function t = pxy(x,y)
    t = zeros(1,16);
    for i=1:1:3
        for j=1:1:3
            t(j*4+i+1) = i*(x.^(i-1)).*(y.^(j-1))*j;
%             fprintf('a%d-%d=%d\n',i,j,i*(x.^(i-1)).*(y.^(j-1))*j)
%             fprintf('t, %d\n',j*4+i+1)
        end
    end
%     fprintf('\n');
end
function F = my_cubic_interpolate(p,x)
    F = p(2);
    F = F -((1/2)*p(1) + (1/2)*p(3)).*x;
    F = F + (p(1)-2.5*p(2)+2*p(3)-0.5*p(4)).*x.^2;
    F = F + (-0.5*p(1)+1.5*p(2)-1.5*p(3)+0.5*p(4)).*x.^2;
end