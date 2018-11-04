function [y, x0] = my_cubic_spline(f1, x1, x0)
    n=length(x1);
    y=zeros(length(x0), 1);
    C=zeros(n+1);
    K=zeros(n);
    L=zeros(n);
    D=zeros(n);
    B=zeros(n);
    A=zeros(n);
    for k=(3:1:n)
       Hk = x1(k)-x1(k-1);
       Hkk = x1(k-1)-x1(k-2);
       Fk = 3 * ((f1(k)-f1(k-1))/Hk - (f1(k-1)-f1(k-2))/Hkk);
       Vk=2*(Hk+Hkk);
       K(k) = (Fk-Hkk*K(k-1)) / (Vk-Hkk*L(k-1));
       L(k) = Hk / (Vk-Hkk*L(k-1));
    end
    
    for k=(n:-1:2)
       C(k) = K(k) - L(k)*C(k+1);
       Hk = x1(k)-x1(k-1);
       D(k) = (C(k+1)-C(k))/(3*Hk);
       B(k) = (f1(k)-f1(k-1))/Hk - C(k)*Hk - D(k)*Hk^2;
       A(k) = f1(k-1);
    end
    
    k=2;
    for i=(1:1:length(y))
        if x0(i) > x1(k)
            k = k+1;
        end
        Hk = x0(i) - x1(k-1);
        y(i) = A(k) + B(k)*Hk + C(k)*Hk^2 + D(k)*Hk^3;
    end
end
