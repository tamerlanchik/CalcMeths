function [x0, fMin, k] = optimal_vec(name, KMax, eps)
    f = @nested_function;
    k = 0;
    x0 = zeros(2,1);
    x = ones(2,1);
    df = { @(x) 2*(x(1)+1), @(x) 2*(x(2)+1) };
    
    switch name
        case 'coordinate_descent'
            while (norm(x-x0)>eps)&&(k<KMax)
                x=x0;
                for i=1:1:length(x)
                    l=lmin(eps,KMax,x0,f,df);
                    grad=-df{i}(x0);
                    x0(i)=x0(i)+l*grad;
                end
                 k=k+1;
            end
        case 'gradient'
            while (norm(x-x0)>eps)&&(k<KMax)
                x=x0;
                l=lmin(eps,KMax,x0,f,df);
                grad = (-1)*[df{1}(x0); df{2}(x0)];
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
function lmin = lmin(eps,KMax,x,f,dF)
    a=0;
    b=2;
    fi = (1+sqrt(5))/2;
    k = 0;
    x1 = b-(b-a)/fi;
    x2 = a+(b-a)/fi;
    lmin=a;
    grad = (-1)*[dF{1}(x); dF{2}(x)];
    F = @(lmin) f(x+lmin*grad);
    while (abs(b-a)>=eps)&&(k<KMax)
        k=k+1;
        y1 = F(x1);
        y2 = F(x2);
        if(y1>=y2)
            a = x1;
            x1 = x2;
            x2 = a+(b-a)/fi;
        else
            b = x2;
            x2 = x1;
            x1 = b-(b-a)/fi;
        end
        lmin = (a+b)/2;
    end
end