function [y, x0] = my_forward_newton_polynomial(f1, x1, x0)
    y=zeros(length(x0), 1);
    d=zeros(length(x1));
    n=length(x1);
    d(:,1) = f1(:);
    for i=(2:1:n)
       for j=(1:1:length(x1)-i+1)
          d(j,i) = d(j+1, i-1)-d(j, i-1);
       end
    end
    
    for i=(1:1:length(y))
       q = (x0(i)-x1(1)) / (x1(2)-x1(1));
       Q=1;
       p = f1(1);
       fct=1;
       for k=(1:1:n-1)
           fct = fct*k;
           Q = Q * (q-k+1);
           p = p + Q*d(1, k+1)/fct;
       end
       y(i)=p;
    end
    
end
