function [conDiffAll, radDiffAll] = diffPrefOriPrefStimOri(trData)
%% in stimulus
oris = trData.inStimOris;
ranks = trData.inStimRanks;
figure(2)
clf

subplot(2,2,1)
conOris = [];
conDiff = [];
radOris = [];
radDiff = [];
hold on
q2oris = rad2deg(oris.q2);
q2ranks = ranks.q2';

conOris = (q2oris(q2ranks == 1));
conDiff = (45 - conOris);

radOris = (q2oris(q2ranks == 2));
radDiff = (135 - radOris);

conDiffAll.q2 = mod(conDiff,90);
radDiffAll.q2 = mod(radDiff,90);

scatter(1:length(conDiff),mod(conDiff,90),80,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(1.25:length(radDiff)+0.25,mod(radDiff,90),80,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)

xMax = max([length(conDiff), length(radDiff)]);
ylim([-90,90])
xlim([0 xMax+1])

title('stimulus quadrant 4')
ylabel('dominant orientation - preferred')
set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YTick',-90:20:90,'FontSize',12,'FontAngle','italic','FontWeight','bold')
text(0.5,-90,sprintf('n = %d',length(conOris)),'color',[0.7 0 0.7],'FontWeight','bold')
text(0.5,-80,sprintf('n = %d',length (radOris)),'color',[0 0.6 0.2],'FontWeight','bold')

subplot(2,2,2)
conOris = [];
conDiff = [];
radOris = [];
radDiff = [];
hold on
q1oris = rad2deg(oris.q1);
q1ranks = ranks.q1';

conOris = (q1oris(q1ranks == 1));
conDiff = (45 - conOris);

radOris = (q1oris(q1ranks == 2));
radDiff = (135 - radOris);

conDiffAll.q1 = mod(conDiff,90);
radDiffAll.q1 = mod(radDiff,90);

scatter(1:length(conDiff),mod(conDiff,90),80,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(1.25:length(radDiff)+0.25,mod(radDiff,90),80,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)

xMax = max([length(conDiff), length(radDiff)]);
ylim([-90,90])
xlim([0 xMax+1])

title('stimulus quadrant 4')
% ylabel('dominant orientation - preferred')
set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YTick',-90:20:90,'FontSize',12,'FontAngle','italic','FontWeight','bold')
text(0.5,-90,sprintf('n = %d',length(conOris)),'color',[0.7 0 0.7],'FontWeight','bold')
text(0.5,-80,sprintf('n = %d',length (radOris)),'color',[0 0.6 0.2],'FontWeight','bold')

subplot(2,2,3)

hold on
q3oris = rad2deg(oris.q3);
q3ranks = ranks.q3';

conOris = (q3oris(q3ranks == 1));
conDiff = (45 - conOris);

radOris = (q3oris(q3ranks == 2));
radDiff = (135 - radOris);

conDiffAll.q3 = mod(conDiff,90);
radDiffAll.q3 = mod(radDiff,90);

scatter(1:length(conDiff),mod(conDiff,90),80,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(1.25:length(radDiff)+0.25,mod(radDiff,90),80,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)

xMax = max([length(conDiff), length(radDiff)]);
ylim([-90,90])
xlim([0 xMax+1])

title('stimulus quadrant 4')
ylabel('dominant orientation - preferred')
set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YTick',-90:20:90,'FontSize',12,'FontAngle','italic','FontWeight','bold')
text(0.5,-90,sprintf('n = %d',length(conOris)),'color',[0.7 0 0.7],'FontWeight','bold')
text(0.5,-80,sprintf('n = %d',length (radOris)),'color',[0 0.6 0.2],'FontWeight','bold')

subplot(2,2,4)
conOris = [];
conDiff = [];
radOris = [];
radDiff = [];
hold on
q4oris = rad2deg(oris.q4);
q4ranks = ranks.q4';

conOris = (q4oris(q4ranks == 1));
conDiff = (45 - conOris);

radOris = (q4oris(q4ranks == 2));
radDiff = (135 - radOris);

conDiffAll.q4 = mod(conDiff,90);
radDiffAll.q4 = mod(radDiff,90);

scatter(1:length(conDiff),mod(conDiff,90),80,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(1.25:length(radDiff)+0.25,mod(radDiff,90),80,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)

xMax = max([length(conDiff), length(radDiff)]);
ylim([-90,90])
xlim([0 xMax+1])

title('stimulus quadrant 4')
% ylabel('dominant orientation - preferred')
set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YTick',-90:20:90,'FontSize',12,'FontAngle','italic','FontWeight','bold')
text(0.5,-90,sprintf('n = %d',length(conOris)),'color',[0.7 0 0.7],'FontWeight','bold')
text(0.5,-80,sprintf('n = %d',length (radOris)),'color',[0 0.6 0.2],'FontWeight','bold')

s = suptitle({'Difference in dominant and preferred orientations';...
    sprintf('%s %s %s',trData.animal,trData.eye,trData.array)});
s.FontSize = 16;
s.FontWeight = 'Bold';

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriVSdomOri','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% highOSI
% 
% oris = trData.within2OrisHighSI;
% ranks = trData.within2RanksHighSI;
% figure(3)
% clf
% 
% subplot(2,2,1)
% conOris = [];
% conDiff = [];
% radOris = [];
% radDiff = [];
% hold on
% q2oris = rad2deg(oris.q2);
% q2ranks = ranks.q2';
% 
% conOris = (q2oris(q2ranks == 1));
% conDiff = (45 - conOris);
% 
% radOris = (q2oris(q2ranks == 2));
% radDiff = (135 - radOris);
% 
% scatter(1:length(conDiff),mod(conDiff,90),80,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
% scatter(1.25:length(radDiff)+0.25,mod(radDiff,90),80,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
% 
% xMax = max([length(conDiff), length(radDiff)]);
% ylim([-90,90])
% xlim([0 xMax+1])
% 
% title('stimulus quadrant 4')
% ylabel('dominant orientation - preferred')
% set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YTick',-90:20:90,'FontSize',12,'FontAngle','italic','FontWeight','bold')
% text(0.5,-90,sprintf('n = %d',length(conOris)),'color',[0.7 0 0.7],'FontWeight','bold')
% text(0.5,-80,sprintf('n = %d',length (radOris)),'color',[0 0.6 0.2],'FontWeight','bold')
% 
% subplot(2,2,2)
% conOris = [];
% conDiff = [];
% radOris = [];
% radDiff = [];
% hold on
% q1oris = rad2deg(oris.q1);
% q1ranks = ranks.q1';
% 
% conOris = (q1oris(q1ranks == 1));
% conDiff = (45 - conOris);
% 
% radOris = (q1oris(q1ranks == 2));
% radDiff = (135 - radOris);
% 
% scatter(1:length(conDiff),mod(conDiff,90),80,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
% scatter(1.25:length(radDiff)+0.25,mod(radDiff,90),80,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
% 
% xMax = max([length(conDiff), length(radDiff)]);
% ylim([-90,90])
% xlim([0 xMax+1])
% 
% title('stimulus quadrant 4')
% % ylabel('dominant orientation - preferred')
% set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YTick',-90:20:90,'FontSize',12,'FontAngle','italic','FontWeight','bold')
% text(0.5,-90,sprintf('n = %d',length(conOris)),'color',[0.7 0 0.7],'FontWeight','bold')
% text(0.5,-80,sprintf('n = %d',length (radOris)),'color',[0 0.6 0.2],'FontWeight','bold')
% 
% subplot(2,2,3)
% 
% hold on
% q3oris = rad2deg(oris.q3);
% q3ranks = ranks.q3';
% 
% conOris = (q3oris(q3ranks == 1));
% conDiff = (45 - conOris);
% 
% radOris = (q3oris(q3ranks == 2));
% radDiff = (135 - radOris);
% 
% scatter(1:length(conDiff),mod(conDiff,90),80,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
% scatter(1.25:length(radDiff)+0.25,mod(radDiff,90),80,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
% 
% xMax = max([length(conDiff), length(radDiff)]);
% ylim([-90,90])
% xlim([0 xMax+1])
% 
% title('stimulus quadrant 4')
% ylabel('dominant orientation - preferred')
% set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YTick',-90:20:90,'FontSize',12,'FontAngle','italic','FontWeight','bold')
% text(0.5,-90,sprintf('n = %d',length(conOris)),'color',[0.7 0 0.7],'FontWeight','bold')
% text(0.5,-80,sprintf('n = %d',length (radOris)),'color',[0 0.6 0.2],'FontWeight','bold')
% 
% subplot(2,2,4)
% conOris = [];
% conDiff = [];
% radOris = [];
% radDiff = [];
% hold on
% q4oris = rad2deg(oris.q4);
% q4ranks = ranks.q4';
% 
% conOris = (q4oris(q4ranks == 1));
% conDiff = (45 - conOris);
% 
% radOris = (q4oris(q4ranks == 2));
% radDiff = (135 - radOris);
% 
% scatter(1:length(conDiff),mod(conDiff,90),80,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
% scatter(1.25:length(radDiff)+0.25,mod(radDiff,90),80,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
% 
% xMax = max([length(conDiff), length(radDiff)]);
% ylim([-90,90])
% xlim([0 xMax+1])
% 
% title('stimulus quadrant 4')
% % ylabel('dominant orientation - preferred')
% set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YTick',-90:20:90,'FontSize',12,'FontAngle','italic','FontWeight','bold')
% text(0.5,-90,sprintf('n = %d',length(conOris)),'color',[0.7 0 0.7],'FontWeight','bold')
% text(0.5,-80,sprintf('n = %d',length (radOris)),'color',[0 0.6 0.2],'FontWeight','bold')
% 
% s = suptitle({'Difference in dominant and preferred orientations';...
%     sprintf('%s %s %s',trData.animal,trData.eye,trData.array)});
% s.FontSize = 16;
% s.FontWeight = 'Bold';
% 
% figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriVSdomOri_highOSI','.pdf'];
% print(gcf, figName,'-dpdf','-fillpage')