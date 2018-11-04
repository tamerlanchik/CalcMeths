function [y, x0] = my_backward_newton_polynomial(f1, x1, x0)
    y=zeros(length(x0), 1);
    d=zeros(length(x1));
    d(:,1) = f1(:);
    n=length(x1);
    for i=(2:1:n)
       for j=(i:1:length(x1))
          d(j,i) = d(j, i-1)-d(j-1, i-1);
       end
    end
    
    h=x1(n)-x1(n-1);
    q=(x0(i)-x1(n))/h;
    for i=(1:1:length(y))
       Q=1;
       fct=1;
       p = f1(n);
       for k=(1:1:n-1)
           fct = fct*k;
           Q = Q * (q+k-1);
           p = p + Q*d(n, k+1)/fct;
       end
       y(i)=p;
    end

end
