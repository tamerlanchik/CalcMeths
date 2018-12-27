function [F, C] = my_bilinear(F0,C0,C)
    p = size(C0);
    X0 = C0{1};
    Y0 = C0{2};
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
            f1 = (X0(nY,nX)-X(i,j))/(X0(nY,nX)-X0(nY,nX-1))*F0(nY-1,nX-1);
            f1 = f1 + (X(i,j)-X0(nY-1,nX-1))/(X0(nY,nX)-X0(nY,nX-1))*F0(nY-1,nX);
            f2 = (X0(nY,nX)-X(i,j))/(X0(nY,nX)-X0(nY,nX-1))*F0(nY,nX-1);
            f2 = f2 + (X(i,j)-X0(nY,nX-1))/(X0(nY,nX)-X0(nY,nX-1))*F0(nY,nX);
            
            F(i,j) = (Y0(nY,nX)-Y(i,j))/(Y0(nY,nX)-Y0(nY-1,nX))*f1;
            F(i,j) = F(i,j) + (Y(i,j)-Y0(nY-1,nX))/(Y0(nY,nX)-Y0(nY-1,nX))*f2;
        end
        nX=2;
    end
end