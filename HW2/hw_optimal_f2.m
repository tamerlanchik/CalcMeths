function x = hw_optimal_f2(f,t,y,x0,fctOpt)
    x=fmincon(@fnrm,x0,[],[],[],[],[],[],[],fctOpt);
    function res = fnrm(x)
        res=norm(f(x,t)-y);
    end
end