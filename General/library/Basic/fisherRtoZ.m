function zVal = fisherRtoZ(rVal)
% takes R correlation values and transforms them to z' scores.

zVal = 0.5.*(log(1+rVal) - log(1-rVal));