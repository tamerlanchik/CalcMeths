function [xMin, fMin, k] = optimal_sca(a,b,name,kmax,e)
    k=0;
    f = @nested_function;
    xMin=a;
    fMin=f(xMin);
    
    switch name
        case 'uniform'
            h = abs((b-a))/(kmax+1);
            st=1; %сдвиг
            x=(a:h:b);
            for i=1:1:kmax-1
                k=k+1;
                if (f(x(i+st))<fMin)&&(k<=kmax)
                    xMin=x(i+st);
                    fMin=f(xMin);
                end
            end
        case 'dichotomy'
            while (abs(b-a)>=e)&&(k<kmax)
                k=k+1;
                xMin=(a+b)/2;
                d=(b-a)/4;
                x1=xMin-d;
                x2=xMin+d;
                if(f(x1)>=f(x2))
                    a=xMin;
                else
                    b=xMin;
                end
            end
            fMin=f(xMin);
        case 'golden_ratio'
            fi = (1+sqrt(5))/2;
            x1 = b-(b-a)/fi;
            x2 = a+(b-a)/fi;
            while (abs(b-a)>=e)&&(k<kmax)
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
            fMin = f(xMin);
        otherwise
    end
end

function f = nested_function(x)
    f=(x+1).^2+2;
end