function [x0, fMin, k] = optimal_vec(name, KMax, eps)
    f = @nested_function;
    k = 0;
    x0 = zeros(2,1);
    x = ones(2,1);
    
    switch name
        case 'coordinate_descent'
            while (norm(x-x0)>eps)&&(k<KMax)
                x=x0;
                for i=1:1:length(x)
                    grad = gradient(x0);
                    F = @(arg) f(x0 + arg*grad);
                    l=lmin(0,2,eps,KMax,F);
                    x0(i)=x0(i)+l*grad(i);
                end
                 k=k+1;
            end
        case 'gradient'
            while (norm(x-x0)>eps)&&(k<KMax)
                x=x0;
                grad = gradient(x0);
                F = @(arg) f(x0 + arg*grad);
                l=lmin(0,2,eps,KMax,F);
                x0 = x0 + l*grad;
                k = k+1;
            end
        case 'newton'
            while (norm(x-x0)>eps)&&(k<KMax)
               x=x0;
               x0 = x + H(x0)^(-1)*gradient(x0);
               k = k + 1;
            end
        otherwise
    end
    fMin=f(x0);
end

function f = nested_function(x,y)
    if nargin==2
        f = (x+1).^2 + (y+1).^2 + 2;
    else
        f = (x(1)+1).^2 + (x(2)+1).^2 + 2;
    end
end
function h = H(x)
    h = [2, 0; 0, 2];
end
function g = gradient(x)
    g = (-1)*[2*(x(1)+1); 2*(x(2)+1)];
end
function xMin = lmin(a,b,eps,KMax,f)
    fi = (1+sqrt(5))/2;
    x1 = b-(b-a)/fi;
    x2 = a+(b-a)/fi;
    k=0;
    while (abs(b-a)>=eps)&&(k<KMax)
        k  = k+1;
        y1 = f(x1);
        y2 = f(x2);
        if(y1 >= y2)
            a  = x1;
            x1 = x2;
            x2 = a+(b-a)/fi;
        else
            b  = x2;
            x2 = x1;
            x1 = b-(b-a)/fi;
        end
    end
    xMin = (a+b)/2;
end