function [y] = db2lin(x)
y = 10.^(x./10);
end