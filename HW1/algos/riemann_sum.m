function ans = riemann_sum(a,b,n,f,type)
    ans = 0;
    h = (b-a)/(n-1);
    switch type
        case -1
            for i=(1:1:n-1)
               ans = ans + f(a+(i-1)*h)*h;
            end
        case 0
            for i=(2:1:n)
               ans = ans + f(a + (h*(2*i-3))/2)*h;
            end
        case 1
            for i=(2:1:n)
               ans = ans + f(a+(i-1)*h)*h; 
            end
        otherwise
            ans=0;
end
