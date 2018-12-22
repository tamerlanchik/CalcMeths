function X=lab_ode_rk4(t,f,x0)
    X=zeros(length(x0),length(t));
    X(:,1) = x0;
    A=zeros(4,4);
    A(2,1)=1/2;
    A(3,1:2)=[0, 1/2];
    A(4,1:3)=[0,0,1];
    c = [0,1/2,1/2,1];
    b=[1/6,1/3,1/3,1/6];
    for k=1:1:length(t)-1
       h  = t(k+1)-t(k);
       K=zeros(2,4);
       for i=1:1:4
          K(:,i) = f(t(k)+h*c(i), X(:,k) + (h*K*A(i,:)'));
       end
        X(:,k+1) = X(:,k) + (h*K*b');
    end
    X=X';
end