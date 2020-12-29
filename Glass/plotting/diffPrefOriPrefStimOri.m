function [] = diffPrefOriPrefStimOri(trData,conRadData)

in2d = trData.within2Deg;
quad = trData.rfQuadrant;
qOri = trData.quadOris';

prefParams = trData.prefParamsIndex; % preferred dot,dx
for ch = 1:96
    if trData.goodCh(ch) == 1
        chRanks(:,ch) = conRadData.dPrimeRankBlank{prefParams(ch)}(:,ch);
    end
end
%%
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/',trData.animal,trData.programID, trData.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/',trData.animal, trData.programID, trData.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
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
xlabel('channel')
ylabel('|preferred ori - dominant ori|')
set(gca,'tickdir','out')

clear conNdxs; clear radNdxs; clear conOris; clear radOris; clear conDiff; clear radDiff;

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
title('stimulus quadrant 1')
xlabel('channel')
ylabel('|preferred ori - dominant ori|')
set(gca,'tickdir','out')
clear conNdxs; clear radNdxs; clear conOris; clear radOris; clear conDiff; clear radDiff;

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
title('stimulus quadrant 3')
xlabel('channel')
ylabel('|preferred ori - dominant ori|')
set(gca,'tickdir','out')
clear conNdxs; clear radNdxs; clear conOris; clear radOris; clear conDiff; clear radDiff;

subplot(2,2,4)
hold on
useNdx = (in2d == 1) & (quad == 4);
conNdxs = (chRanks(1,useNdx) == 1);
radNdxs = (in2d == 1) & (quad == 4) & (chRanks(1,:) == 2);
conOris = rad2deg(qOri(conNdxs));

conDiff = abs(conOris - 135);

radOris = rad2deg(qOri(radNdxs));
radDiff = abs(radOris - 45);

plot(conDiff,'o','color',[0.7 0 0.7])
plot(radDiff,'o','color',[0 0.6 0.2])

%ylim([0, 180])
title('stimulus quadrant 4')
xlabel('channel')
ylabel('|preferred ori - dominant ori|')
set(gca,'tickdir','out')
clear conNdxs; clear radNdxs; clear conOris; clear radOris; clear conDiff; clear radDiff;

suptitle({'difference in preferred orientation and dominant orienation in preferred Glass pattern';...
    sprintf('%s %s %s',trData.animal,trData.eye,trData.array)})

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriVSdomOri','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
