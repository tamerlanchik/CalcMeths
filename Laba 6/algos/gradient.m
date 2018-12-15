% function [Fmin, xmin] = gradient(kmax,e,f,df)
% x=[];
% x0=zeros();
% k=0;
% while (norm(x-x0)>e)&&(k<kmax)
% %     for i=1:1:length(x)
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

function res = gradient(kmax,e,f,df)
    x0=zeros(2,1);
    x=ones(2,1);
    k=0;
    l=0.1;
    p=2;
    while (norm(x-x0)>e)&&(k<kmax)
        x=x0;
%         pr=-df{:}(x0);
        pr = (-1)*[df{1}(x0), df{2}(x0)];
        x0 = x0 + l*pr;
%         l=l/2;
        k = k+1;
        
    end
    res = cell(2,1);
    res{1} = x0;
    res{2} = f(x0);
end