function [Fmin, xmin] = golden_ratio(a, b, kmax,e,f)
fi = (1+sqrt(5))/2;
k = 0;
x1 = b-(b-a)/fi;
x2 = a+(b-a)/fi;
while (abs(b-a)>=e)&&(k<kmax)
    k=k+1;
    y1 = f(x1);
    y2 = f(x2);
    if(y1>=y2)
        a = x1;
        x1 = x2;
        x2 = a+(b-a)/fi;
    else
        b = x2;
        x2 = x1;
        x1 = b-(b-a)/fi;
    end
    xmin = (a+b)/2;
    Fmin=f(xmin);
end
        