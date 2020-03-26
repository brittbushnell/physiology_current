function [dirPref,oriSel,dirSel] = DoubleVonMisesStats(P)

if nargin==0
    test;
    return
end

nX = 1000;
x = linspace(0,360,nX);
r = DoubleVonMises(x,P);

[dirPref,oriSel,dirSel] = GetOriTuneStats(x,r);