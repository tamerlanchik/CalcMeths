function [t,df] = lab_diff_do(a,b,n,name,k,f)
    h = (b-a)/(n-1);
    t = (a:h:b)'; %n-1 так как нужно n точек, а не промежутков
    df = zeros(n, 1);
    %----------------------
    W = cell(4,2);
    
    W{1,1} = [1, -1]';
    W{2,1} = [-1/2, 2, -3/2]';
    W{3,1} = [ -1/4, 4/3, -3, 4, -25/12 ]';
    W{4,1} = [-1/6, 6/5, -15/4, 20/3, -15/2, 6, -49/20]';
    
    W{2,2} = [1/2, 0, -1/2]';
    W{3,2} = [-1/12, 2/3, 0, -2/3, 1/12]';
    W{4,2} = [1/60, -3/20, 3/4, 0, -3/4, 3/20, -1/60]';
    %-----------------------
%     keys = {1,2,4,6};
%     dict = containers.Map(keys, (1:1:4);
    rows = [1,2,0,3,0,4];
    %       1 2 3 4 5 6
%     switch name
%         case 'forward'
%             st=1;
%             fin = n-k;
%             h=1;
%         case 'backward'
%             st = k+1;
%             fin = n;
%             h=-1;
%         case 'central'
%             st = k/2+1;
%             fin = n - (st-1);
%             h=1;
%         otherwise
%     end
%     row = rows(k);
%     for i=st:1:fin
%         df(i) = sum(f(t(i+1:-1:i)).*w)/abs(t(i)-t(i+h));
%     end
    switch name
        case 'forward'
            for i=1:1:n-k
                df(i) = sum(f(t(i+k:-1:i)).*W{rows(k), 1})/(t(i+1)-t(i));
            end
        case 'backward'
            for i=k+1:1:n
                df(i) = sum(f(t(i:-1:i-k)).*W{rows(k), 1})/(t(i)-t(i-1));
            end
        case 'central'
            for i=k/2+1:1:n-k/2
                df(i) = sum(f(t(i+k/2:-1:i-k/2)).*W{rows(k), 2})/(t(i)-t(i-1));
            end
        otherwise
    end
%     switch name
%         case 'forward'
%             switch k
%                 case 1
%                     w = [1, -1]';
%                     for i=1:1:n-1
%                         df(i) = (f(t(i+1)) - f(t(i)))/(t(i+1)-t(i));
%                         D = sum(f(t(i+1:-1:i)).*w)/(t(i+1)-t(i));
%                         delta = D - df(i)
%                     end
%                 case 2
%                     w = [-1/2, 2, -3/2]';
%                     for i=1:1:n-2
%                         df(i) = sum(f(t(i+2:-1:i)).*w)/(t(i+1)-t(i));
%                     end
%                 case 4
%                     w = [ -1/4, 4/3, -3, 4, -25/12 ]';
%                     for i=1:1:n-4
%                         df(i) = sum(f(t(i+4:-1:i)).*w)/(t(i+1)-t(i));
%                     end
%                 case 6
%                     w = [-1/6, 6/5, -15/4, 20/3, -15/2, 6, -49/20]';
%                     for i=1:1:n-6
%                          df(i) = sum(f(t(i+6:-1:i)).*w)/(t(i+1)-t(i));
%                     end
%                 otherwise
%             end
%             
%         case 'backward'
%             switch k
%                 case 1
%                     w = [1, -1]';
%                     for i=2:1:n
%                         df(i) = (f(t(i)) - f(t(i-1)))/(t(i)-t(i-1));
%                         D = sum(f(t(i:-1:i-1)).*w)/(t(i)-t(i-1));
%                         delta = df(i)-D
%                     end
%                 case 2
%                     w = [-1/2, 2, -3/2]';
%                     for i=3:1:n
%                         df(i) = sum(f(t(i:-1:i-2)).*w)/(t(i)-t(i-1));
%                     end
%                 case 4
%                     w = [ -1/4, 4/3, -3, 4, -25/12 ]';
%                     for i=5:1:n
%                         df(i) = sum(f(t(i:-1:i-5)).*w)/(t(i)-t(i-1));
%                     end
%                 case 6
%                     w = [-1/6, 6/5, -15/4, 20/3, -15/2, 6, -49/20]';
%                     for i=7:1:n
%                         df(i) = sum(f(t(i:-1:i-6)).*w)/(t(i)-t(i-1));
%                     end
%                 otherwise
%             end
%         case 'central'
%             switch k
%                 case 2
%                     w = [1/2, 0, -1/2]';
%                     for i=2:1:n-1
%                         df(i) = sum(f(t(i+1:-1:i-1)).*w)/(t(i)-t(i-1));
%                     end
%                 case 4
%                     w = [-1/12, 2/3, 0, -2/3, 1/12]';
%                     for i=3:1:n-2
%                         df(i) = sum(f(t(i+2:-1:i-2)).*w)/(t(i+1)-t(i));
%                     end
%                 case 6
%                     w = [1/60, -3/20, 3/4, 0, -3/4, 3/20, -1/60]';
%                      for i=4:1:n-3
%                        df(i) = sum(f(t(i+3:-1:i-3)).*w)/(t(i+1)-t(i));
%                 otherwise
%             end
%         otherwise
%             
%     end
end