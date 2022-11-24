function [y] = lin2dbm(x)
    y = 10*log10(x./1e-3);
end