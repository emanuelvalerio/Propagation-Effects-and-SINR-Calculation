function gain = gainPath(loss)
  [ilLos icLos] = size(loss);
  for i = 1:ilLos
      for j = 1:icLos
          linearLoss = db2lin(loss(i,j));
          gain(i,j) = 1./linearLoss;
      end
  end
  