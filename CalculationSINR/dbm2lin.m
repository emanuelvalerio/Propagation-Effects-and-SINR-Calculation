function [y] = dbm2lin(x)
    y = 10.^(x./10 - 3);
end