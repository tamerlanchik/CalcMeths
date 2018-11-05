function ans = gaussian_5_points(a,b,N,f)
    ans = 0;
    x=[-0.90618, -0.538469, 0, 0.538469, 0.90618];
    w=[0.236927, 0.478629, 0.568889, 0.478629, 0.236927];
    n=5;
    h = (b-a)/(N);
    for k=(1:1:N)
       temp=0;
       Xk = a+(k-1)*h;
       Xkk = a+k*h;
       for j=(1:1:n)
          temp = temp + w(j)*f( (Xkk-Xk)*x(j)/2 + (Xk+Xkk)/2 ); 
       end
       ans = ans + (Xkk-Xk)*temp/2;
    end
end
