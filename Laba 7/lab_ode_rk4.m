function X=lab_ode_rk4(t,f,x0)
    X=zeros(length(t),length(x0));
    X(1,:) = x0;
    for k=1:1:length(t)-1
       h  = t(k+1)-t(k);
       K1 = f(x0,t(k));
       K2 = f(X(k) + 0.5*h*K1, t(k)+0.5*h);
       K3 = f(X(k)+0.5*h*K2, t(k)+0.5*h);
       K4 = f(X(K)+H*k3, T(K)+H);
       X(k+1) = X(k) + (h/6)*(K1+2*K2+2*K3+K4); 
    end
end