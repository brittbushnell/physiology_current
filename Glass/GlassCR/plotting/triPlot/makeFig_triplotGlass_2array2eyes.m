function [] = makeFig_triplotGlass_2array2eyes(V1LE,V1RE,V4LE,V4RE,sortDps)



%
s = subplot(2,2,1);
hold on

rcd = V1LE(:,1:3);
cmp = V1LE(:,6:8);

triplotter_Glass(rcd,cmp,sortDps(1,4))
title(sprintf('n: %d',length(V1LE)))

s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;

%
s = subplot(2,2,2);
hold on

rcd = V1RE(:,1:3);
cmp = V1RE(:,6:8);

triplotter_Glass(rcd,cmp,sortDps(1,4))
title(sprintf('n: %d',length(V1RE)))
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;
%
s = subplot(2,2,3);
hold on
rcd = V4LE(:,1:3);
cmp = V4LE(:,6:8);

triplotter_Glass(rcd,cmp,sortDps(1,4))

title(sprintf('n: %d',length(V4LE)))
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;

s = subplot(2,2,4);
hold on
rcd = V4RE(:,1:3);
cmp = V4RE(:,6:8);

triplotter_Glass(rcd,cmp,sortDps(1,4))
title(sprintf('n: %d',length(V4RE)))
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
