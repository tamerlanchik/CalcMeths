function J = my_jacobi(x0, h, f, name)
    J = zeros(length(f), length(x0));
    switch name
                case 'forward'
                    for j=1:1:length(f)
                        for d=1:1:length(x0)
                            tX=x0;
                            tX(d) = x0(d)+h;
                            J(j,d) = (f{j}(tX) - f{j}(x0))/h;
                        end
                    end
                case 'backward'
                    for j=1:1:length(f)
                        for d=1:1:length(x0)
                            tX=x0;
                            tX(d) = x0(d)-h;
                            J(j,d) = (f{j}(x0) - f{j}(tX))/h;
                        end
                    end
                case 'central'
                    for j=1:1:length(f)
                        for d=1:1:length(x0)
                            t1X=x0; t2X=x0;
                            t1X(d) = x0(d)-h;
                            t2X(d) = x0(d)+h;
                            J(j,d) = 0.5*(f{j}(t2X) - f{j}(t1X))/h;
                        end
                    end
    end
end
