function [F1, C] = my_bicubic(F0,C0,C)
    %https://en.wikipedia.org/wiki/Bicubic_interpolation#Computation
    %�������� � ��������� 4�4 ����������� �����
    %��������������� �����, X0(i,j) - ���������� �� x
    tic;
    X0 = C0{1};
    Y0 = C0{2};
    %���������������� �����
    X1=C{1};
    Y1=C{2};
    
    F1 = nan(size(X1));
    A = zeros(16);
    
    %minSize = 6
    if size(X0,1) < 4 || size(X0,2) < 4
        ME = MException('MyComponent:noEnougthSize', ...
        'Size must be at least 6x6!');
        throw(ME);
    end
    p=1; q=1;   %������� ��������������� ����� �� ���������������� �����
    
    %i,j - ���������� ������� ����� ����� �������� ����������������
    %�������� �� ���������������� �����
    
    %��� ���������� �������� ����������� ����� ������� ������� �� ���������
    %����� � 1 ���.
    for i=2:1:size(X0,1)-2
        p=1;
        for j=2:1:size(Y0,2)-2            
            tic;
            %���� ��������� ����� �� ���������������� �����
            while(X1(p,p)<X0(i,j))
                p = p + 1;
            end
            while(Y1(q,q)<Y0(i,j))
                q = q + 1;
            end
            
            %������������ alpha={a(i,j)} � ���� ������ [a11,a21,...]            
            %��������� � �� ������ �� 4
            temp=1;     %temp - ����� � ������
            for m=[0,1]
                for n=[0,1]
                    pointX = X0(j+m,i+n);   %current Work Point
                    pointY = Y0(j+m,i+n);
                    A(:,temp)    = P(pointX,pointY);
                    A(:,temp+4)  = px(pointX,pointY);
                    A(:,temp+8)  = py(pointX,pointY);
                    A(:,temp+12) = pxy(pointX,pointY);
                    temp = temp+1;
                end
            end
                     
            %X=[f(0,0),f(1,0),f(0,1),f(1,1),fx(0,0), ... ,fy(0,0), ...,fxy(0,0), ...]'
            X=zeros(16,1);
            X(1:4)=[F0(j,i),F0(j,i+1),F0(j+1,i),F0(j+1,i+1)];
            %0-------> x, j, p
            %|
            %|
            %V y, i, q

            % Fx(0,0), Fx(1,0), Fx(0,1), Fx(1,1)
            % Fy(0,0), Fy(1,0), Fy(0,1), Fy(1,1)
            % Fxy(0,0), Fxy(1,0), Fxy(0,1), Fxy(1,1)
            %A(y,x)
            
            start=5;
            for m=[0,1]
                for n=[0,1]
                    X(start) = (F0(j+m,i+n+1)-F0(j+m,i-1+n))/(X0(j+m,i+n+1)-X0(j+m,i-1+n));   %dF/dx
                    X(start+4) = (F0(j+m+1,i+n)-F0(j+m-1,i+n))/(Y0(j+m+1,i+n)-Y0(j+m-1,i+n)); %dF/dy
                    start = start + 1;
                end
            end
            
            %second derivatives
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
            
            temp=13;
            for m=[0,1]
                for n=[0,1]
                    X(temp) = (ders(2*(2+m)+n)-ders((1+m)+n))/(Y0(j+m+1,i+n)-Y0(j+m-1,i+n));
                    temp = temp + 1;
                end
            end
                       
            A = A';
            A = A^(-1);
            alpha = A*X;
            
            p0 = p;
            q0 = q;
            while Y1(q,q)<Y0(i+1,j+1)
                while X1(p,p)<X0(i+1,j+1)
                    value=0;
                    for k=0:1:3
                        for l=0:1:3
                            value = value + alpha(k*4+l+1)*(X1(q,p)^k)*(Y1(q,p)^l);
                        end
                    end
                    F1(p,q) = value;
                    p = p + 1;
                end
                p=p0;
                q = q + 1;
            end
            q = q0;
        end
    end
end
function [x,ok] = my_kramer(A,b)
    [n,m] = size(A);
    d=det(A);
    x = zeros(n,1);
    if (n ~= m || d==0)
        ok=false;
    else
        for i=(1:1:n)
            T = A;
            T(:,i)=b;
            x(i) = det(T)/d;
        end
        ok=true;
    end
end
function t=P(x,y)
    t = zeros(1,16);
    for i=0:1:3
        for j=0:1:3
            t(j*4+i+1) = (x.^i).*(y.^j);
        end
    end
end
function t = px(x,y)
    t = zeros(1,16);
    for i=1:1:3
        for j=0:1:3
            t(j*4+i+1) = i*(x.^(i-1)).*(y.^j);
        end
    end
end
function t = py(x,y)
    t = zeros(1,16);
    for i=0:1:3
        for j=1:1:3
            t(j*4+i+1) = (x.^i).*(y.^(j-1))*j;
        end
    end
end
function t = pxy(x,y)
    t = zeros(1,16);
    for i=1:1:3
        for j=1:1:3
            t(j*4+i+1) = i*(x.^(i-1)).*(y.^(j-1))*j;
        end
    end
end