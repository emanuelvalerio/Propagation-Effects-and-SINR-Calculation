function dis = distancef(dERB,dTM)
% dERB=dERB';
[ilERB icERB] = size(dERB);
[ilTM icTM] = size(dTM);
% where dERB is a input with these parameters dERB = [rho,theta], and dTM =
% [rho,theta];
dis = zeros(1,4);
for i = 1:ilERB
    for j = 1:ilTM
            [xERB, yERB] = pol2cart(dERB(i,1),dERB(i,2));
            [xTM , yTM] = pol2cart(dTM(j,1),dTM(j,2));
            dis(i,j) = sqrt((xERB-xTM).^2 + (yERB-yTM).^2)/1000; % converted to km
    end
end

