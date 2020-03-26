function v = ExplanVar(y,yHat)

y = y(:);
yHat = yHat(:);

d0 = nanvar(y,1);
d = nanmean( (y-yHat).^2 );
v = 1 - d./d0;
