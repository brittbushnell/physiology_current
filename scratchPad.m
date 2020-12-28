% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%
in2d = trLE.within2Deg;
quad = trLE.rfQuadrant;
qOri = trLE.quadOris;

prefParams = trLE.prefParamsIndex;
for ch = 1:96
    if trLE.goodCh(ch) == 1
        chRanks(:,ch) = conRadLE.dPrimeRankBlank{prefParams(ch)}(:,ch);
    end
end

figure(13)
clf

subplot(2,2,1)
hold on

conNdxs = (in2d == 1) & (quad == 2) & (chRanks(1,:) == 1);
radNdxs = (in2d == 1) & (quad == 2) & (chRanks(1,:) == 2);
conOris = rad2deg(qOri(conNdxs));
conDiff = abs(conOris - 45);

radOris = rad2deg(qOri(radNdxs));
radDiff = abs(radOris - 135);

plot(conDiff,'o','color',[0.7 0 0.7])
plot(radDiff,'o','color',[0 0.6 0.2])
ylim([0, 180])
title('stimulus quadrant 2')
xlable('channel')


subplot(2,2,2)
hold on

conNdxs = (in2d == 1) & (quad == 1) & (chRanks(1,:) == 1);
radNdxs = (in2d == 1) & (quad == 1) & (chRanks(1,:) == 2);
conOris = rad2deg(qOri(conNdxs));
conDiff = abs(conOris - 135);

radOris = rad2deg(qOri(radNdxs));
radDiff = abs(radOris - 45);

plot(conDiff,'o','color',[0.7 0 0.7])
plot(radDiff,'o','color',[0 0.6 0.2])
ylim([0, 180])

subplot(2,2,3)
hold on

conNdxs = (in2d == 1) & (quad == 3) & (chRanks(1,:) == 1);
radNdxs = (in2d == 1) & (quad == 3) & (chRanks(1,:) == 2);
conOris = rad2deg(qOri(conNdxs));
conDiff = abs(conOris - 45);

radOris = rad2deg(qOri(radNdxs));
radDiff = abs(radOris - 135);

plot(conDiff,'o','color',[0.7 0 0.7])
plot(radDiff,'o','color',[0 0.6 0.2])
ylim([0, 180])

subplot(2,2,4)
hold on

conNdxs = (in2d == 1) & (quad == 4) & (chRanks(1,:) == 1);
radNdxs = (in2d == 1) & (quad == 4) & (chRanks(1,:) == 2);
conOris = rad2deg(qOri(conNdxs));
conDiff = abs(conOris - 135);

radOris = rad2deg(qOri(radNdxs));
radDiff = abs(radOris - 45);

plot(conDiff,'o','color',[0.7 0 0.7])
plot(radDiff,'o','color',[0 0.6 0.2])
ylim([0, 180])