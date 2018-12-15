% function [Fmin, xmin] = gradient(a, b, kmax,e)
% x=[];
% x0=zeros();
% k=0;
% while (norm(x-x0)>e)&&(k<kmax)
%     for i=1:1:length(x)
% %     x(i)=x0(i);
%         fmin0=f(x);
%         pr=df(x0);
%         l=argmin(x0);
%         x=x0-l*pr;
%         fmin=f(x);
%         x0=x;
%           if(abs(fmin-fmin0)<e)
%               fmin=f(x);
%               xmin0=x;
%           end
%     end
%     k=k+1;
%     Fmin=fmin;
%     xmin=xmin0;
% end

function [Fmin, x0] = gradient(kmax,e)
    x0=zeros(2,1);
    k=0;
    l=2;
    p=2;
    while (norm(x-x0)>e)&&(k<kmax)
        pr=-df(x0);
        x0 = x0 + l*pr;
        l=l/2;
    end
    Fmin=f(x0)
end