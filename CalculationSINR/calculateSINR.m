function sinr = calculateSINR(iNumBS,iTMs,mtReceivedPower,dpn)
    k = 0;
    for i = 1:iNumBS
        dSum = 0;
        for j = 1:iTMs
            if(j~=i)
                dSum = dSum + mtReceivedPower(i,j);
            end
            if(i==j) k = i ; end 
        end
            aux = mtReceivedPower(k,k)/(dSum+dpn);
            sinr(k) = lin2db(aux);
    end
end

