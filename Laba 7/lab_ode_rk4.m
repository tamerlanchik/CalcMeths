function X=lab_ode_rk4(t,f,x0)
    X=zeros(length(x0),length(t));
    X(:,1) = x0;
    for k=1:1:length(t)-1
       h  = t(k+1)-t(k);
       K1 = f(t(k),X(:,k));
       K2 = f(t(k)+0.5*h,X(:,k) + 0.5*h*K1);
       K3 = f(t(k)+0.5*h, X(:,k)+0.5*h*K2);
       K4 = f(t(k)+h, X(:,k)+h*K3);
%        p=X(k,:)
       X(:,k+1) = X(:,k) + (h/6)*(K1+2*K2+2*K3+K4);
    end
    X=X';
end