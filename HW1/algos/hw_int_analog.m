function int = hw_int_analog(a,b,n,f,name)
    switch name
        case 'riemann_left'
            int = riemann_sum(a,b,n,f,-1);
        case 'riemann_mid'
            int = riemann_sum(a,b,n,f,0);
        case 'riemann_right'
            int = riemann_sum(a,b,n,f,1);
        case 'trapezoidal'
            int = trapezoidal(a,b,n,f);
        case 'simpson'
            int = simpson(a,b,n,f);
        case 'gaussian with 5 points'
            int = gaussian_5_points(a,b,n,f);
        otherwise
            int=-1;
    end
end
