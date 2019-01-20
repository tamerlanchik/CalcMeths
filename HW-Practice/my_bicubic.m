function [F1, C] = my_bicubic(F0,C0,C)
    %https://en.wikipedia.org/wiki/Bicubic_interpolation#Computation
    %Работаем с квадратом 4х4 изначальной сетки
    %исходная сетка, X0(i,j) - координата по x
    X0 = C0{1};
    Y0 = C0{2};
    %интерполяционная сетка
    X1=C{1};
    Y1=C{2};
    F1 = nan(size(X1));
    
    A = zeros(16);
    p=1; q=1;   %индексы интерполируемой точки
    %i,j - координаты верхней левой точки квадрата, в котором интерполируем
    %для нахождения значения производных нужны боковые границы на начальной
    %сетке в 1 шаг.
    %minSize = 6
    if size(X0,1) < 4 || size(X0,2) < 4
        ME = MException('MyComponent:noEnougthSize', ...
        'Size must be at least 6x6!');
        throw(ME);
    end
%     (y,x)
%     (i,j)
    %считаются только на первой и последней итерациях    (2,2), (3,3)
    for i=2:1:size(X0,1)-2
%      for i=3:1:3
        p=1;
        for j=2:1:size(Y0,2)-2
%         for j=3:1:3
            fprintf("New iter\n");
            %ищем начальную 
            while(X1(p,p)<X0(i,j))
                p = p + 1;
%                 fprintf("p\n");
            end
%             if X1(p+1,p+1)>X0(i,j)
%                 p=p+1;
%             end
            while(Y1(q,q)<Y0(i,j))
                q = q + 1;
%                 fprintf("q\n");
            end
%             if Y1(q+1,q+1)>Y0(i,j)
%                 q=q+1;
%             end
%             fprintf('i=%d, j=%d\n',i,j)
%             fprintf('p=%d, q=%d\n',p,q)
%             fprintf('X=%d, Y=%d\n', X0(i,j),Y0(i,j));
            %ищем alpha={a(i,j)} в виде строки [a11,a21,...]
            %X = [f(0,0),f(1,0),f(0,1),f(1,1),fx(0,0), ... ,fy(0,0), ..., fxy(0,0), ...]
            %приходим к уравнению A^(-1)*X=alpha
            %искомое F(x1,y1) = sum(sum(a(i,j)*X^i*Y^j))
            %----------------
            temp=1;
            for m=[0,1]
                for n=[0,1]
                    pX=X0(j+m,i+n);
                    pY = Y0(j+m,i+n);
                    A(:,temp) = P(pX,pY);
                    A(:,temp+4) = px(pX,pY);
                    A(:,temp+8) = py(pX,pY);
                    A(:,temp+12) = pxy(pX,pY);
                    
%                     fprintf('X=%d,Y=%d,temp=%d\n',X0(j+m,i+n),Y0(j+m,i+n),temp);
                    temp=temp+1;
                end
            end
            A=A';
            A=A^(-1);
            %----------------------
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
            temp=5;
            for m=[0,1]
                for n=[0,1]
%                     fprintf('str68: n=%d, m=%d; temp=%d\n',m,n,temp);
                    X(temp) = (F0(j+m,i+n+1)-F0(j+m,i-1+n))/(X0(j+m,i+n+1)-X0(j+m,i-1+n));
                    X(temp+4) = (F0(j+m+1,i+n)-F0(j+m-1,i+n))/(Y0(j+m+1,i+n)-Y0(j+m-1,i+n));
                    temp = temp + 1;
                end
            end
            ders = zeros(1,2*4);
            temp=1;
            %производные по Х для узлов квадрата, а также для узлов на 1
            %выше и ниже него
            %заполняем по строкам
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
            q0=q;
            alpha=alpha
%             fprintf("Start: p=%d, q=%d\n",p,q);
            while Y1(q,p)<Y0(i+1,j+1)
%                 fprintf("X1=%d, Y1=%d\n",X1(q,p),Y1(q,p));
%                 fprintf("X0=%d, Y0=%d\n",X0(i+1,j+1),Y0(i+1,j+1));
                while X1(q,p)<X0(i+1,j+1)
%                     fprintf("p=%d, q=%d\n",p,q);
                    Px=0;
                    for k=0:1:3
                        for l=0:1:3
                            Px = Px+alpha(k*4+l+1)*(X1(q,p)^k)*(Y1(q,p)^l);
                        end
                    end
                    F1(q,p) = Px;
                    p=p+1;
                end
                p=p0;
                q = q+1;
            end
            q=q0;
        end
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