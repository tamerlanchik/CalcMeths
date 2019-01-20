function [F1, C] = my_optimized_bicubic(F0,C0,C)
    %https://en.wikipedia.org/wiki/Bicubic_interpolation#Computation
    %Работаем с квадратом 4х4 изначальной сетки
    %интерполируемая сетка, X0(i,j) - координата по x
    X0 = C0{1};
    Y0 = C0{2};
    %интерполяционная сетка
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
    p=1; q=1;   %индексы интерполируемой точки на интерполяционной сетке
    
    %i,j - координаты верхней левой точки квадрата интерполируемого
    %квадрата на интерполяционной сетке
    
    %для нахождения значения производных нужны боковые границы на начальной
    %сетке в 1 шаг.
    for i=2:1:size(X0,1)-2
        p=1;
        for j=2:1:size(Y0,2)-2            
            %ищем начальную точку на интерполяционной сетке
            while(X1(p,p)<X0(i,j))
                p = p + 1;
            end
            while(Y1(q,q)<Y0(i,j))
                q = q + 1;
            end
            
            %представляем alpha={a(i,j)} в виде строки [a11,a21,...]            
            %разбиваем А на группы по 4
            temp=1;     %temp - номер в группе
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
                       
            
            A = A';
%             A = A^(-1);
            %A*alpha=X
%             alpha = A*X;
%             alpha = my_kramer(A',X);
%             [L,U]=lu(A);
%             A = U^(-1)*L^(-1);
%             alpha = A*X;
%             beta = L\X;
%             alpha = U\beta;
            alpha=linsolve(A,X);
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
                    F1(p,q) = value;    %костыль: меняем значение p и q. Надо найти источник проблемы
                    p = p + 1;
                end
                p=p0;
                q = q + 1;
            end
            q = q0;
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
function [l,u] = my_lu(x)
    if x(1,1)==0
        fprintf('Cannot calc LU');
        l = 0;
        u = 0;
    else
        l = zeros(size(x));
        u = zeros(size(x));

        for j=1:1:size(x,2)
            u(1,j) = x(1, j);
            l(j, 1) = x(j, 1)/u(1,1);
        end

        for i=2:1:size(x,1)
            for j=i:1:size(x,2)
                temp = 0;
                for k=1:1:(i-1)
                   temp = temp + l(i,k)*u(k,j); 
                end
                u(i,j) = x(i,j) - temp;

                temp = 0;
                for k=1:1:(i-1)
                    temp = temp + l(j,k)*u(k,i);
                end
                l(j,i) = (x(j,i)-temp)/u(i,i);
            end
        end
    end
end
function [Q,R]=my_qr(X)
    B=zeros(size(X));
    Q=zeros(size(X));

    for k=1:1:size(X,2)
        x = X(:,k);
        temp=0;
        for j=1:1:(k-1)
            temp=temp+proj(x,B(:,j));
        end
        B(:,k)=x-temp;
        Q(:,k)=B(:,k)./norm(B(:,k),'fro');
    end
    R=(Q')*X;
    function p=proj(y,z)
        %p=dot(y,z)/norm(z,'fro');
        p = dot(y,z)*z/dot(z,z);
    end
end