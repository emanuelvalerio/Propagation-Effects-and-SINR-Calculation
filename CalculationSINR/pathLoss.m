function loss = pathLoss(distance)
% distance is in km
[ilDis icDis] = size(distance);
for i = 1:ilDis
    for j = 1:icDis
        loss(i,j) = 128.1 + 36.7*log10(distance(i,j));
    end
end

