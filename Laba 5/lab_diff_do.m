function [t,df] = lab_diff_do(a,b,n,name,k,f)
    t = (a:(b-a)/(n-1):b)'; %n-1 ��� ��� ����� n �����, � �� �����������
    df = zeros(n, 1);
    switch name
        case 'forward'
            switch k
                case 1
                    w = [1, -1]';
                    for i=1:1:n-1
                        df(i) = (f(t(i+1)) - f(t(i)))/(t(i+1)-t(i));
                        D = sum(f(t(i+1:-1:i)).*w)/(t(i+1)-t(i));
                        delta = D - df(i)
                    end
                case 2
                    w = [-1/2, 2, -3/2]';
                    for i=1:1:n-2
                        df(i) = sum(f(t(i+2:-1:i)).*w)/(t(i+1)-t(i));
                    end
                case 4
                    w = [ -1/4, 4/3, -3, 4, -25/12 ]';
                    for i=1:1:n-4
                        df(i) = sum(f(t(i+4:-1:i)).*w)/(t(i+1)-t(i));
                    end
                case 6
                    w = [-1/6, 6/5, -15/4, 20/3, -15/2, 6, -49/20]';
                    for i=1:1:n-6
                         df(i) = sum(f(t(i+6:-1:i)).*w)/(t(i+1)-t(i));
                    end
                otherwise
            end
            
        case 'backward'
            switch k
                case 1
                    w = [1, -1]';
                    for i=2:1:n
                        df(i) = (f(t(i)) - f(t(i-1)))/(t(i)-t(i-1));
                        D = sum(f(t(i:-1:i-1)).*w)/(t(i)-t(i-1));
                        delta = df(i)-D
                    end
                case 2
                    w = [-1/2, 2, -3/2]';
                    for i=3:1:n
                        df(i) = sum(f(t(i:-1:i-2)).*w)/(t(i)-t(i-1));
                    end
                case 4
                    w = [ -1/4, 4/3, -3, 4, -25/12 ]';
                    for i=5:1:n
                        df(i) = sum(f(t(i:-1:i-5)).*w)/(t(i)-t(i-1));
                    end
                case 6
                    w = [-1/6, 6/5, -15/4, 20/3, -15/2, 6, -49/20]';
                    for i=7:1:n
                        df(i) = sum(f(t(i:-1:i-6)).*w)/(t(i)-t(i-1));
                    end
                otherwise
            end
        case 'central'
            switch k
                case 2
                    w = [1/2, 0, -1/2]';
                    for i=2:1:n-1
                        df(i) = sum(f(t(i+1:-1:i-1)).*w)/(t(i)-t(i-1));
                    end
                case 4
                    w = [-1/12, 2/3, 0, -2/3, 1/12]';
                    for i=3:1:n-2
                        df(i) = sum(f(t(i+2:-1:i-2)).*w)/(t(i+1)-t(i));
                    end
                case 6
                    w = [1/60, -3/20, 3/4, 0, -3/4, 3/20, -1/60]';
                     for i=4:1:n-3
                       df(i) = sum(f(t(i+3:-1:i-3)).*w)/(t(i+1)-t(i));
                otherwise
            end
        otherwise
            
    end
end