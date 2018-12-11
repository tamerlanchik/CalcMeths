function J = jacobi(x0, h, f, name)
    J = zeros(length(f), length(x0));
    for j=1:1:length(f)
            switch name
                case 'forward'
                    for d=1:1:length(x0)
                        tX=x0;
                        tX(d) = x0(d)+h;
                        J(j,d) = (f{j}(tX) - f{j}(x0))/h;
                    end
                case 'backward'
                    for d=1:1:length(x0)
                        tX=x0;
                        tX(d) = x0(d)-h;
                        J(j,d) = (f{j}(x0) - f{j}(tX))/h;
                    end
                case 'central'
                    for d=1:1:length(x0)
                        t1X=x0; t2X=x0;
                        t1X(d) = x0(d)-h;
                        t2X(d) = x0(d)+h;
                        J(j,d) = 0.5*(f{j}(t2X) - f{j}(t1X))/h;
                    end
            end
    end
end
