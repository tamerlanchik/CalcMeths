function ans = trapezoidal(a,b,n,f)
    ans = 0;
    h = (b-a)/(n);
    for i=(1:1:n-1)
       ans = ans + (f(a+(i-1)*h) + f(a+(i)*h))*h/2;
    end
end
