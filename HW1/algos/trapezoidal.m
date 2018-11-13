function ans = trapezoidal(a,b,n,f)
    ans = 0;
    X = (a:(b-a)/n:b);
    v=1;
    for i=(0:1:n-1)
       ans = ans + (f(X(i+v)) + f(X(i+1+v)))*(X(i+1+v)-X(i+v))/2;
    end
end
