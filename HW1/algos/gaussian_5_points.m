function ans = gaussian_5_points(a,b,N,f)
    ans = 0;
    x=[-0.90618, -0.538469, 0, 0.538469, 0.90618];
    w=[0.236927, 0.478629, 0.568889, 0.478629, 0.236927];
    n=length(x);
    X = (a:(b-a)/N:b);
    v=1;
    for k=(0:1:N-1)
       temp=0;
       for j=(1:1:n)
          temp = temp + w(j)*f( (X(k+1+v)-X(k+v))*x(j)/2 + (X(k+1+v)+X(k+v))/2 ); 
       end
       ans = ans + (X(k+1+v)-X(k+v))*temp/2;
    end
end
