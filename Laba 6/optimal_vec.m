function [x0, fMin, k] = optimal_vec(name, KMax, eps)
    f = @nested_function;
    df = { @(x) 2*(x(1)+1), @(x) 2*(x(2)+1) };
    k = 0;
    x0 = zeros(2,1);
    x = ones(2,1);
    
    switch name
        case 'coordinate_descent'
            l=0.1;
            while (norm(x-x0)>eps)&&(k<KMax)
                x=x0;
                for i=1:1:length(x)
                    l=my_argmin(0,2,eps,KMax,x0,f,df{i})
                    pr=-df{i}(x0);
                    x0(i)=x0(i)+l*pr;
                end
                 k=k+1;
            end
        case 'gradient'
            l=0.1;
            while (norm(x-x0)>eps)&&(k<KMax)
                x=x0;
                l=my_argmin(0,2,eps,KMax,x0,f,df)
                pr = (-1)*[df{1}(x0); df{2}(x0)];
                x0 = x0 + l*pr;
                k = k+1;
            end
        case 'newton'
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
    h = [2, 0; 2, 0];
end
function lmin = my_argmin(a,b,eps,KMax,x,f,dF)
    fi = (1+sqrt(5))/2;
    k = 0;
    x1 = b-(b-a)/fi;
    x2 = a+(b-a)/fi;
    lmin=a;
    if length(dF)==1
        grad = (-1)*dF(x); 
    else
        grad = (-1)*[dF{1}(x); dF{2}(x)];
    end
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