function [X,t]=lab_ode_rk45(T,f,x0)
    x0=x0';
    h0 = 10^(-3);
    eps=10^(-5);
    [A,c,b1,b2] = getButcher();
    h=h0;
%     while(abs(X1-X2)>eps)
%             K=zeros(length(x0),6);
%             for i=1:1:size(K,2)
%                K(:,i) = f(tMin+h*c(i), x0 + (h*K*A(i,:)')); 
%             end
%             p=K*b1'
%             X1 = x0 + (h*K*b1');
%             X2 = x0 + (h*K*b2');
%             h=h/2;
%             h=h
%     end
%     X=zeros(length(x0),(tMax-tMin)/h+1);
%     X(:,1) = x0;
%     X(:,2)=X1;
%     t=(tMin:h:tMax);
%     for k=2:1:size(X,2)-1
%         K=zeros(length(x0),6);
%         for i=1:1:size(K,2)
%            K(:,i) = f(tMin+h+h*c(i), X(:,k) + (h*K*A(i,:)')); 
%         end
%         X(:,k+1) = X(:,k) + (h*K*b1');
%     end
    t=[T(1)];
    X=[x0];
    X1=0; X2=1;
    while t(end)<=T(2)
        while(1)
            K=zeros(length(x0),6);
            for i=1:1:size(K,2)
               K(:,i) = f(t(end)+h*c(i), X(:,end) + (h*K*A(i,:)')); 
            end
            X1 = X(:,end) + (h*K*b1');
            X2 = X(:,end) + (h*K*b2');
            if abs(X1-X2) >= 4*eps
                h=h/2;
            elseif abs(X1-X2)<=eps/4
                h = h*2;
            else
                break;
            end
%             q = (rand()+2);
            
        end
        t = [t,t(end)+h];
        X=[X, X1];
    end
    X=X';
end

function [A,c,b1,b2] = getButcher()
    A=zeros(6,6);
    A(2,1)=1/4;
    A(3,1:2)=[3/32, 9/32];
    A(4,1:3)=[1932/2197,-7200/2197,7296/2197];
    A(5,1:4)=[439/216,-8,3680/513,-845/4104];
    A(6,1:5)=[-8/27,2,-3544/2565,1859/4104,-11/40];
    c = [0,1/4,3/8,12/13,1,1/2];
    b1=[16/135,0,6656/12825,28561/56430,-9/50,2/55];
    b2=[25/216,0,1408/2565,2197/4104,-1/5,0];
end