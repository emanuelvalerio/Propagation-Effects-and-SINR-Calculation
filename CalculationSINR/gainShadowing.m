function gain = gainShadowing(iNumBs,iTMS,mean,sd)
   dNum = 0;
    for i = 1:iNumBs
        for j = 1:iTMS
            dNum =  mean + sd.*randn(); % in dB
            gain(i,j) = db2lin(dNum);
        end
    end
