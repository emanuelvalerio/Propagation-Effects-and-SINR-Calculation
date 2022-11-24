function gain = gainFastFadding(iNumBs,iTMS,mean,sd)
    for i = 1:iNumBs
        for k = 1:iTMS
            dx_ij =  mean + sd.*randn(1,1);
            dy_ij = mean + sd.*randn(1,1);
            gain(i,k) = (abs(dx_ij + j*dy_ij)).^2; % linear scale
        end
    end
