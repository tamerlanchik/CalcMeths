function [y, x0] = my_nearest_neighbour(y1, x1, x0)
    y=zeros(length(x0), 1);
    k=1;
    kMax=length(x1);
    for i=(1:1:length(x0))
        if  k~=kMax && (abs(x0(i)-x1(k)) >= abs(x0(i)-x1(k+1)))
            k = k + 1;
        end
        y(i) = y1(k);
    end
end
