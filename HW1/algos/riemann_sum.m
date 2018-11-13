function ans = riemann_sum(a,b,n,f,type)
    ans = 0;
    X = (a:(b-a)/n:b);
    v=1;
    switch type
        case -1
            for i=(0:1:n-1)
               ans = ans + f(X(i+v))*(X(i+1+v)-X(i+v));
            end
        case 0
            for i=(1:1:n)
               ans = ans + f((X(i-1+v)+X(i+v))/2)*(X(i+v)-X(i-1+v));
            end
        case 1
            for i=(1:1:n)
               ans = ans + f(X(i+v))*(X(i+v)-X(i-1+v)); 
            end
        otherwise
            ans=0;
end
