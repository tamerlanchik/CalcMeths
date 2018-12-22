function X=lab_ode_ab5(t,f,x0)
    X=zeros(length(x0),length(t));
    X(:,1) = x0;
    for k=1:1:4
       h  = t(k+1)-t(k);
       K1 = f(t(k),X(:,k));
       K2 = f(t(k)+0.5*h,X(:,k) + 0.5*h*K1);
       K3 = f(t(k)+0.5*h, X(:,k)+0.5*h*K2);
       K4 = f(t(k)+h, X(:,k)+h*K3);
%        p=X(k,:)
       X(:,k+1) = X(:,k) + (h/6)*(K1+2*K2+2*K3+K4);
    end
    
    for k=1:1:length(t)-5
       K1 = (1901/720)*f(t(k+4),X(:,k+4));
       K2 = (-1387/360)*f(t(k+3), X(:,k+3));
       K3 = (109/30)*f(t(k+2),X(:,k+2));
       K4 = (-637/360)*f(t(k+1), X(:,k+1));
       K5 = (251/720)*f(t(k), X(:,k));
       
       h  = t(k+1)-t(k);
       X(:,k+5) = X(:,k+4) + h*(K1+K2+K3+K4+K5);
    end
    X=X';
end