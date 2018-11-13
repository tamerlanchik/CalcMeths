function ans = simpson(a,b,n,f)
    h = (b-a)/(2*n);
    ans = f(a) + f(b);
    X = (a:(b-a)/(2*n):b);
    v=1;
    for i=(1:1:n-1)
       ans = ans + 2*f(X(2*i+v));
    end
    for i=(1:1:n)
       ans = ans + 4*f(X(2*i-1+v));
    end
    ans = ans * h / 3;
end
