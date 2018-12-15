function [Fmin, xmin] = dichotomy(a, b, kmax,e,f)
    k=0;
    xmin=0;
    while (abs(b-a)>=e)&&(k<kmax)
        k=k+1;
        xmin=(a+b)/2;
        d=(b-a)/4;
        x1=xmin-d;
        x2=xmin+d;
        if(f(x1)>=f(x2));
            a=xmin;
        else
            b=xmin;
        end
    end
    Fmin=f(xmin);
end
    
