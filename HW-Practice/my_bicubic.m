% function [F, C] = my_bicubic(F0,C0,C)
%     p = size(C0);
%     X0 = C0{1};
%     Y0 = C0{2};
%     X=C{1};
%     Y=C{2};
%     F = zeros(size(X));
%     for i=
%     
% end
function [F, C] = my_bicubic(F0,C0,C)
%     p = size(C0);
%     X0 = C0{1};
%     Y0 = C0{2};
%     X=C{1};
%     Y=C{2};
%     F = zeros(size(X));
    A = zeros(16);
%     temp=zeros(1,16);
%     nX=1;
%     nY=1;
        A(:,1)=p(0,0);
        A(:,2)=p(1,0);
        A(:,3)=p(0,1);
        A(:,4)=p(1,1);
        A(:,5)=px(0,0);
        A(:,6)=px(1,0);
        A(:,7)=px(0,1)
        A(:,8)=px(1,1);
        A(:,9)=py(0,0);
        A(:,10)=py(1,0);
        A(:,11)=py(0,1);
        A(:,12)=py(1,1);
        A(:,13)=pxy(0,0);
        A(:,14)=pxy(1,0);
        A(:,15)=pxy(0,1);
        A(:,16)=pxy(1,1);
        A=(A')^(-1)
end
function t=p(x,y)
    t = zeros(1,16);
    for i=0:1:3
        for j=0:1:3
            t(j*4+i+1) = (x.^i).*(y.^j);
%             fprintf('a%d-%d=%d\n',i,j,(x.^i).*(y.^j))
%             fprintf('t, %d\n',j*4+i+1)
        end
    end
end
function t = px(x,y)
    t = zeros(1,16);
    for i=1:1:3
        for j=0:1:3
            t(j*4+i+1) = i*(x.^(i-1)).*(y.^j);
            fprintf('a%d-%d=%d\n',i,j,i*(x.^(i-1)).*(y.^j))
            fprintf('t, %d\n',j*4+i+1)
        end
    end
end
function t = py(x,y)
    t = zeros(1,16);
    for i=0:1:3
        for j=1:1:3
            t(j*4+i+1) = (x.^i).*(y.^(j-1))*j;
            fprintf('a%d-%d=%d\n',i,j,(x.^i).*(y.^(j-1))*j)
            fprintf('t, %d\n',j*4+i+1)
        end
    end
end
function t = pxy(x,y)
    t = zeros(1,16);
    for i=1:1:3
        for j=1:1:3
            t(j*4+i+1) = i*(x.^(i-1)).*(y.^(j-1))*j;
            fprintf('a%d-%d=%d\n',i,j,i*(x.^(i-1)).*(y.^(j-1))*j)
            fprintf('t, %d\n',j*4+i+1)
        end
    end
end
function F = my_cubic_interpolate(p,x)
    F = p(2);
    F = F -((1/2)*p(1) + (1/2)*p(3)).*x;
    F = F + (p(1)-2.5*p(2)+2*p(3)-0.5*p(4)).*x.^2;
    F = F + (-0.5*p(1)+1.5*p(2)-1.5*p(3)+0.5*p(4)).*x.^2;
end