function [Fmin, x0] = coordinate_descent(kmax,e)
    x0=zeros(2,1);
    % x=zeros(2,1);
    k=0;
    l=2;
    p=2;
    while (norm(x-x0)>e)&&(k<kmax)
        for i=1:1:length(x)
    %     x(i)=x0(i);
    %         fmin0=f(x);
            pr=-df(x0)(i);
    %         l=argmin(x0);

            x0(i)=x0(i)+l*pr;
            l=l/p;
    %         fmin=f(x);
    %         x0(i)=x(i);
    %           if(abs(fmin-fmin0)<e)
    %               fmin=f(x);
    %               xmin0=x;
    %           end
        end
         k=k+1;
    %     Fmin=fmin;
    %     xmin=xmin0;
    end
    Fmin=f(x0)
end
  
    
    