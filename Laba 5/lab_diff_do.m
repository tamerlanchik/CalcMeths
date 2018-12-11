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
    
    rows = [1,2,0,3,0,4];
    %       1 2 3 4 5 6

    switch name
        case 'forward'
            for i=1:1:n-k
                df(i) = sum(f(t(i+k:-1:i)).*W{rows(k), 1})/(t(i+1)-t(i));
            end
            t = t(1:n-k);
            df = df(1:n-k);
        case 'backward'
            for i=k+1:1:n
                df(i) = sum(f(t(i-k:1:i)).*(-W{rows(k), 1}))/(t(i)-t(i-1));
            end
            t = t(k+1:end);
            df = df(k+1:end);
        case 'central'
            for i=k/2+1:1:n-k/2
                df(i) = sum(f(t(i+k/2:-1:i-k/2)).*W{rows(k), 2})/(t(i)-t(i-1));
            end
            t = t(k/2+1:n-k/2);
            df = df(k/2+1:n-k/2);
        otherwise
    end
end