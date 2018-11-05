function ans = simpson(a,b,n,f,type)
    h = (b-a)/(n);
    ans = f(a) + f(b);
    for i=(1:1:n-1)
       ans = ans + 2*f(a+(i)*h);
       p=a+(i)*h;
    end
    for i=(1:1:n)
       ans = ans + 4*f(a+(2*i-1)*h/2);
       p=a+(2*i-1)*h/2;
    end
    ans = ans * h / 6;
end
