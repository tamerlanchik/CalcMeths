function J = jacobi(x0, h, f, name)
    J = zeros(1, length(x0));
    for i=1:1:length(x0)
        switch name
            case 'forward'
                for d=1:1:length(x0)
                    tX=x0;
                    tX(d) = x0(d)+h;
                    J(d) = (f(tX) - f(x0))/h;
                end
            case 'backward'
                for d=1:1:length(x0)
                    tX=x0;
                    tX(d) = x0(d)-h;
                    J(d) = (f(x0) - f(tX))/h;
                end
            case 'central'
                for d=1:1:length(x0)
                    t1X=x0; t2X=x0;
                    t1X(d) = x0(d)-h;
                    t2X(d) = x0(d)+h;
                    J(d) = 0.5*(f(t2X) - f(t1X))/h;
                end
        end
    end
end
