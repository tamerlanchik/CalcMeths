function [t,df] = lab_diff_do(a,b,n,name,k,f)
    h = (b-a)/(n-1);
    t = (a:h:b)';
%     df = zeros(n, 1);
    df = nan(n,1);
	
    W = my_generator_weights(k,name);

    switch name
        case 'forward'
            for i=1:1:n-k
                df(i) = sum(f(t(i:1:i+k)).*W)/(t(i+1)-t(i));
            end
        case 'backward'
            for i=k+1:1:n
                df(i) = sum(f(t(i-k:1:i)).*W)/(t(i)-t(i-1));
            end
        case 'central'
            for i=k/2+1:1:n-k/2
                df(i) = sum(f(t(i+k/2:-1:i-k/2)).*W)/(t(i)-t(i-1));
            end
        otherwise
    end
end

function W = my_generator_weights(k, name)
    A = zeros(k+1);
    A(1,:)=ones(1,k+1);
    b=zeros(k+1, 1);
    b(2)=1;
    switch name
        case 'forward'
            x=(0:1:k);
        case 'backward'
            x=(-k:1:0);
        case 'central'
            x=(k/2:-1:-k/2);
    end
    fct=1;
    for j=2:1:k+1
        A(j,:) = x.^(j-1)/fct;
        fct = fct*j;
    end
    [W,ok] = my_kramer(A, b);
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
