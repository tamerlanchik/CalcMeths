function [X,t]=lab_ode_rk45(tMin,tMax,f,x0)
    x0=x0';
    tMin=tMin
    h0 = 10^(-3);
    eps=10^(-3);
    
    X1=0; X2=1;
    A=zeros(6,6);
    A(2,1)=1/4;
    A(3,1:2)=[3/32, 9/32];
    A(4,1:3)=[1932/2197,-7200/2197,7296/2197];
    A(5,1:4)=[439/216,-8,3680/513,-845/4104];
    A(6,1:5)=[-8/27,2,-3544/2565,1859/4104,-11/40];
    c = [0,1/4,3/8,12/13,1,1/2];
    b1=[16/135,0,6656/12825,28561/56430,-9/50,2/55];
    b2=[25/216,0,1408/2565,2197/4104,-1/5,0];
    h=h0;
    x0=x0
    while(abs(X1-X2)>eps)
    %         K1 = f(tMin, x0);
    %         K2 = f(tMin+(1/4)*h, x0+(1/4)*K1);
    %         K3 = f(tMin+(3/8)*h, x0+(3/32)*K1+(9/32)*K2);
    %         K4 = f(tMin+(12/13)*h, x0+(1932/2197
            K=zeros(length(x0),6);
            for i=1:1:size(K,2)
               K(:,i) = f(tMin+h*c(i), x0 + (h*K*A(i,:)')); 
            end
            p=K*b1'
            X1 = x0 + (h*K*b1');
            X2 = x0 + (h*K*b2');
            h=h/2;
            h=h
    end
%     h=1
    X=zeros(length(x0),(tMax-tMin)/h+1);
    X(:,1) = x0;
    X(:,2)=X1;
    t=(tMin:h:tMax);
    for k=2:1:size(X,2)-1
        K=zeros(length(x0),6);
        for i=1:1:size(K,2)
           K(:,i) = f(tMin+h+h*c(i), X(:,k) + (h*K*A(i,:)')); 
        end
        X(:,k+1) = X(:,k) + (h*K*b1');
    end
    X=X';
end