function [t,df] = lab_diff_do(a,b,n,name,k,f)
    t = (a:(b-a)/(n-1):b)'; %n-1 ��� ��� ����� n �����, � �� �����������
    df = zeros(n, 1);
    switch name
        case 'forward'
            switch k
                case 1
                    for i=1:1:n-1
                        df(i) = (f(t(i+1)) - f(t(i)))/(t(i+1)-t(i));
                    end
                case 2
                    for i=1:1:n-2
                        df(i) = 0.5*(f(t(i+2))-f(t(i)))/(t(i+2)-t(i));
                    end
                case 4
                    for i=1:1:n-3
                        df(i) = (1/12) * (-f(t(i+2))+8*f(t(i+1))-8*f(t(i+3))+f(t(i)))/(t(i+1)-t(i));
                    end
                case 6
                    for i=1:1:n-2
                        df(i) = 0.5*(f(t(i+2))-f(t(i)))/(t(i+2)-t(i));
                    end
                otherwise
            end
            
        case 'backward'
            switch k
                case 1
                    for i=2:1:n
                        df(i) = (f(t(i)) - f(t(i-1)))/(t(i)-t(i-1));
                    end
                case 2
                    for i=3:1:n
                        df(i) = 0.5*(f(t(i))-f(t(i-2)))/(t(i)-t(i-2))
                    end
                case 4
                    for i=1:1:n-2
                        df(i) = 0.5*(f(t(i+2))-f(t(i)))/(t(i+2)-t(i));
                    end
                case 6
                    for i=1:1:n-2
                        df(i) = 0.5*(f(t(i+2))-f(t(i)))/(t(i+2)-t(i));
                    end
                otherwise
            end
        case 'central'
            switch k
                case 2
                    for i=2:1:n-1
                        df(i) = 0.5*(f(t(i+1)) - f(t(i-1)))/(t(i+1)-t(i-1));
                    end
                case 4
                    for i=3:1:n-2
                        df(i) = (1/12) * (-f(t(i+2))+8*f(t(i+1))-8*f(t(i-1))+f(t(i-2)))/(t(i+1)-t(i));
                    end
                case 6
                    for i=4:1:n-3
                       df(i)=(1/60) * (-f(t(i-3))+f(t(i+3)));
                       df(i) = df(i) + (3/20) * (f(t(i-2))-f(t(i+2)));
                       df(i) = df(i) + (3/4) * (-f(t(i-1))+f(t(i+1)));
                       df(i) = df(i)/(t(i+1)-t(i));
                    end
                otherwise
            end
        otherwise
    end
end