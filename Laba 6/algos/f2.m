function f = f2(x,y)
    if nargin==2
        f = (x+1).^2 + (y+1).^2 + 2;
    else
        f = (x(1)+1).^2 + (x(2)+1).^2 + 2;
    end