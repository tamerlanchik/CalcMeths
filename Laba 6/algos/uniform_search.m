function [Fmin, xmin] = uniform_search(a, b, kmax,eps,f)
    Fmin=f(a);
    xmin=a;
    h = abs((b-a))/(kmax+1);
    st=1; %сдвиг
    x=(a:h:b);
    
    k=0;
    for i=1:1:kmax-1
        k=k+1;
        if (f(x(i+st))<Fmin)&&(k<=kmax)
            Fmin=f(x(i+st));
            xmin=x(i+st);
        end
    end
end