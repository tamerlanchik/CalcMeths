function res = coordinate_descent(kmax,e,f,df)
    x0=zeros(2,1);
    x=ones(2,1);
    k=0;
    l=0.1;
    while (norm(x-x0)>e)&&(k<kmax)
        x=x0;
        for i=1:1:length(x)
            pr=-df{i}(x0);
            x0(i)=x0(i)+l*pr;
        end
         k=k+1;
    end
    res = cell(2,1);
    res{1} = x0;
    res{2} = f(x0);
end
  
    
    