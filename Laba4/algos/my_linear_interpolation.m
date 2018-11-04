function [y, x0] = my_linear_interpolation(f1, x1, x0)
    y=zeros(length(x0), 1);
    k=1;
    for i=(1:1:length(x0)-1)
       if x0(i) >= x1(k+1)
           k = k + 1;
       end
       y(i) = f1(k) + ( f1(k+1)-f1(k))/(x1(k+1)-x1(k) ) * (x0(i)-x1(k));
    end
    y(length(y)) = f1(k+1);

end
