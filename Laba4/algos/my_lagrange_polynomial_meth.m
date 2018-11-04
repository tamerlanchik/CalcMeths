function [y, x0] = my_lagrange_polynomial_meth(f1, x1, x0)
    y=zeros(length(x0), 1);
    for i=(1:1:length(y))
        L=0;
        for k=(1:1:length(x1))
            temp=1;
            for j=(1:1:length(x1))
               if j~=k
                    temp = temp*(x0(i)-x1(j))/(x1(k)-x1(j));
               end
            end
            L = L + f1(k)*temp;
        end
        y(i)=L;
    end
end
