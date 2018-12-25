function [F, C] = my_bilinear(F0,C0,C)
    f = @(x,y) x.^2 + y.^2 + 2;
    p = size(C0);
    X0 = C0{1}
    Y0 = C0{2}
    F0=F0
    X=C{1};
    Y=C{2};
    F = zeros(size(X));
    nX = 2;
    nY = 2;
    for i=1:1:size(X,1)         %along Y
        if Y(i,1) > Y0(nY,1)
               nY = nY + 1; 
        end
        for j=1:1:size(X,2)        %along X
            if X(1,j) > X0(1,nX)
               nX = nX + 1; 
            end
%             Q11 = [Y0(nY-1),X0(nextN-1)];
%             Q12 = [Y0(nextN), X0(nextN-1)];
%             Q21 = [Y0(nextN), X0(nextN)];
%             Q22 = [Y0(nextN), X0(nextN)];
%             R1 = [Y0(nextN-1), X(i,j)];
%             R2 = [Y0(nextN), X(i,j)]
            fprintf('nY=%d,nX=%d,i=%d,j=%d\n',nY,nX,i,j);
            fprintf('X0=%d, Y0=%d, X(j)=%d, Y(i)=%d\n',X0(nY,nX),Y0(nY,nX),X(i,j),Y(i,j));
            f1 = (X0(nY,nX)-X(i,j))/(X0(nY,nX)-X0(nY,nX-1))*F0(nY-1,nX-1);
            f1 = f1 + (X(i,j)-X0(nY-1,nX-1))/(X0(nY,nX)-X0(nY,nX-1))*F0(nY-1,nX);
            f2 = (X0(nY,nX)-X(i,j))/(X0(nY,nX)-X0(nY,nX-1))*F0(nY,nX-1);
            f2 = f2 + (X(i,j)-X0(nY,nX-1))/(X0(nY,nX)-X0(nY,nX-1))*F0(nY,nX);
            
            F(i,j) = (Y0(nY,nX)-Y(i,j))/(Y0(nY,nX)-Y0(nY-1,nX))*f1;
            F(i,j) = F(i,j) + (Y(i,j)-Y0(nY-1,nX))/(Y0(nY,nX)-Y0(nY-1,nX))*f2;
            fprintf('F(i,j)=%d\n',F(i,j));
            fprintf('real f(i,j)=%d\n',f(X(i,j),Y(i,j)));
            fprintf('F0()=%d\n\n',F0(nY,nX));
        end
        nX=2;
    end
end