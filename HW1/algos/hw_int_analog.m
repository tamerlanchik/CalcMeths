function ans = hw_int_analog(a,b,N,f,name)
    ans = 0;
%     X = (a:(b-a)/n:b);
    v=1;
    switch name
        case 'riemann_left'
            X = (a:(b-a)/N:b)';
            for i=(0:1:N-1)
               ans = ans + f(X(i+v))*(X(i+1+v)-X(i+v));
            end
        case 'riemann_mid'
            X = (a:(b-a)/N:b)';
            for i=(1:1:N)
               ans = ans + f((X(i-1+v)+X(i+v))/2)*(X(i+v)-X(i-1+v));
            end
        case 'riemann_right'
            X = (a:(b-a)/N:b)';
            for i=(1:1:N)
               ans = ans + f(X(i+v))*(X(i+v)-X(i-1+v)); 
            end
        case 'trapezoidal'
            X = (a:(b-a)/N:b)';
            for i=(0:1:N-1)
                ans = ans + (f(X(i+v)) + f(X(i+1+v)))*(X(i+1+v)-X(i+v))/2;
            end
        case 'simpson'
            h = (b-a)/(2*N);
            ans = f(a) + f(b);
            X = (a:(b-a)/(2*N):b)';
            for i=(1:1:N-1)
               ans = ans + 2*f(X(2*i+v));
            end
            for i=(1:1:N)
               ans = ans + 4*f(X(2*i-1+v));
            end
            ans = ans * h / 3;
        case 'gaussian_with_5_points'
            ans = 0;
            x=[-0.90618, -0.538469, 0, 0.538469, 0.90618];
            w=[0.236927, 0.478629, 0.568889, 0.478629, 0.236927];
            n=length(x);
            X = (a:(b-a)/N:b)';
            for k=(0:1:N-1)
               temp=0;
               for j=(1:1:n)
                  temp = temp + w(j)*f( (X(k+1+v)-X(k+v))*x(j)/2 + (X(k+1+v)+X(k+v))/2 ); 
               end
               ans = ans + (X(k+1+v)-X(k+v))*temp/2;
            end
        otherwise
            int=-1;
    end
end
