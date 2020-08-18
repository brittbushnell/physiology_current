function [] = plotGlass_latencyDprimeCrossEyes_marginals(data1,data2)
location = determineComputer;

if contains(data1.eye,'RE')
    REdata = data1;
    LEdata = data2;
else
    REdata = data2;
    LEdata = data1;
end    
%% 
if contains(REdata.animal,'WV')
    if location == 1
        if contains(REdata.programID,'Small')
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/4Deg/EyeComps/latency',REdata.animal, REdata.array);
        else
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/8Deg/EyeComps/latency',REdata.animal, REdata.array);
        end
    elseif location == 0
        if contains(REdata.programID,'Small')
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/4Deg/EyeComps/latency',REdata.animal, REdata.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/8Deg/EyeComps/latency',REdata.animal, REdata.array);
        end
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/EyeComps/latency/',REdata.animal, REdata.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/EyeComps/latency/',REdata.animal, REdata.array);
    end
end
cd(figDir)
%% limit to binocular channels, get animal corRElations
REndx = (REdata.goodCh == 1);
LEndx = (LEdata.goodCh == 1);
binocCh = (REndx & LEndx);
%% d' histcounts
dPedges = linspace(-2,4.25,10);
REdPrimeBinoc = histcounts(REdata.allStimBlankDprime(binocCh),dPedges,'Normalization', 'probability');
REdPrimeMonoc = histcounts(REdata.allStimBlankDprime(~binocCh & REndx),dPedges,'Normalization', 'probability');

LEdPrimeBinoc = histcounts(LEdata.allStimBlankDprime(binocCh),dPedges,'Normalization', 'probability');
LEdPrimeMonoc = histcounts(LEdata.allStimBlankDprime(~binocCh & LEndx),dPedges,'Normalization', 'probability');

dPMid = dPedges(1:end-1) + mean(diff(dPedges))/2;
%% onset latency histcounts
latOnEdge = linspace(0,250,10);
REonsetBinoc = histcounts(REdata.onsetLatencyAllStim(binocCh),latOnEdge,'Normalization', 'probability');
REonsetMonoc = histcounts(REdata.onsetLatencyAllStim(~binocCh & REndx),latOnEdge,'Normalization', 'probability');

LEonsetBinoc = histcounts(LEdata.onsetLatencyAllStim(binocCh),latOnEdge,'Normalization', 'probability');
LEonsetMonoc = histcounts(LEdata.onsetLatencyAllStim(~binocCh & LEndx),latOnEdge,'Normalization', 'probability');

latOnMid = latOnEdge(1:end-1) + mean(diff(latOnEdge))/2;
%% offset latency histcounts
latOffEdge = linspace(175,325,10);
REoffsetBinoc = histcounts(REdata.offsetLatencyAllStim(binocCh),latOffEdge,'Normalization', 'probability');
REoffsetMonoc = histcounts(REdata.offsetLatencyAllStim(~binocCh & REndx),latOffEdge,'Normalization', 'probability');

LEoffsetBinoc = histcounts(LEdata.offsetLatencyAllStim(binocCh),latOffEdge,'Normalization', 'probability');
LEoffsetMonoc = histcounts(LEdata.offsetLatencyAllStim(~binocCh & LEndx),latOffEdge,'Normalization', 'probability');

latOffMid = latOffEdge(1:end-1) + mean(diff(latOffEdge))/2;
%% REsponse duration histcounts
respLengthEdge = linspace(0,325,10);
RErespLengthBinoc = histcounts(REdata.respLength(binocCh),respLengthEdge ,'Normalization', 'probability');
RErespLengthMonoc = histcounts(REdata.respLength(~binocCh & REndx),respLengthEdge ,'Normalization', 'probability');

LErespLengthBinoc = histcounts(LEdata.respLength(binocCh),respLengthEdge ,'Normalization', 'probability');
LErespLengthMonoc = histcounts(LEdata.respLength(~binocCh & LEndx),respLengthEdge ,'Normalization', 'probability');

respLengthMid = respLengthEdge(1:end-1) + mean(diff(respLengthEdge))/2;
%% binocular
figure (1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 400])
set(gcf,'PaperOrientation','Landscape');
%% d' vs onset - binoc
clf
subplot(3,9,2)
hold on

REs = [REdPrimeBinoc; LEdPrimeBinoc];
h = barh(dPMid,REs');

h(1).FaceColor = [1 0 0];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [0 0 1];
h(2).EdgeColor = [0 0 1]; 

view(-180,-90)

set(gca,'Color','none','tickdir','out','yaxislocation','right','YTickLabel',[],'layer','top','Position',[0.08 0.59 0.03 0.56])%[0.2185 0.7343 0.0672 0.1907]
xlim([0 1])
ylim([-2 4.25])
b = gca;
x = xlabel('probability');
x.Position = [1.13 -3.1193 -1];
title('binoc')

subplot(3,9,3)
hold on
scatter(LEdata.onsetLatencyAllStim(binocCh),LEdata.allStimBlankDprime(binocCh),40,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.15);
scatter(REdata.onsetLatencyAllStim(binocCh),REdata.allStimBlankDprime(binocCh),40,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.15);

REr = corr2(REdata.onsetLatencyAllStim(binocCh),REdata.allStimBlankDprime(binocCh));
text(200,4, sprintf('R %.2f',REr),'FontSize',11,'FontWeight','bold','Color',[1 0 0])

LEr = corr2(LEdata.onsetLatencyAllStim(binocCh),LEdata.allStimBlankDprime(binocCh));
text(200,3.1, sprintf('R %.2f',LEr),'FontSize',11,'FontWeight','bold','Color',[0 0 1])

set(gca,'Color','none','tickdir','out','layer','top','Position',[0.145 0.57 0.12 0.6]) %[left bottom width height]
xlabel('onset')
y = ylabel('dPrime');
y.Position = [-30 1.120   -1.0000];
xlim([0 250])
ylim([-2 4.25])
title('dPrime v onset')
axis square
c = gca;
 
subplot(3,9,12)
hold on
REs = [REonsetBinoc;LEonsetBinoc;];
h = bar(latOnMid,REs');
h(1).FaceColor = [1 0 0];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [0 0 1];
h(2).EdgeColor = [0 0 1]; 

set(gca,'Color','none','tickdir','out','xaxislocation','top','XDir','reverse','XTickLabel',[],'layer','top','Position',[0.145 0.27 0.12 0.15])

ylim([0 0.8])
xlim([0 250])
view(-180, -270)
y = ylabel('probability');
y.Position = [-47 0.7 -1.0000];
c = gca;
 %% d' vs offset - binoc
subplot(3,9,5)
hold on

REs = [REdPrimeBinoc; LEdPrimeBinoc];
h = barh(dPMid,REs');

h(1).FaceColor = [1 0 0];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [0 0 1];
h(2).EdgeColor = [0 0 1]; 

view(-180,-90)

set(gca,'Color','none','tickdir','out','yaxislocation','right','YTickLabel',[],'layer','top','Position',[0.365 0.605 0.03 0.52])%[0.2185 0.7343 0.0672 0.1907]
xlim([0 1])
ylim([-2 4.25])
b = gca;
% x = xlabel('probability');
% x.Position = [1.13 -3.1193 -1];
 
subplot(3,9,6)
hold on
scatter(LEdata.offsetLatencyAllStim(binocCh),LEdata.allStimBlankDprime(binocCh),40,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.15);
scatter(REdata.offsetLatencyAllStim(binocCh),REdata.allStimBlankDprime(binocCh),40,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.15);

REr = corr2(REdata.offsetLatencyAllStim(binocCh),REdata.allStimBlankDprime(binocCh));
text(310,4, sprintf('R %.2f',REr),'FontSize',11,'FontWeight','bold','Color',[1 0 0])

LEr = corr2(LEdata.offsetLatencyAllStim(binocCh),LEdata.allStimBlankDprime(binocCh));
text(310,3.1, sprintf('R %.2f',LEr),'FontSize',11,'FontWeight','bold','Color',[0 0 1])

set(gca,'Color','none','tickdir','out','layer','top','Position',[0.43 0.57 0.12 0.6]) %[left bottom width height]
xlabel('offset')
y = ylabel('dPrime');
y.Position = [155  1.120   -1.0000];
xlim([175 325])
ylim([-2 4.25])
title('dPrime v offset')
axis square
c = gca;
 
subplot(3,9,15)
hold on
REs = [REoffsetBinoc;LEoffsetBinoc];
h = bar(latOffMid,REs');
h(1).FaceColor = [1 0 0];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [0 0 1];
h(2).EdgeColor = [0 0 1]; 

set(gca,'Color','none','tickdir','out','xaxislocation','top','XDir','reverse','XTickLabel',[],'layer','top','Position',[0.43 0.27 0.12 0.15])

ylim([0 0.8])
xlim([175 325])
view(-180, -270)
% y = ylabel('probability');
% y.Position = [155 0.7 -1.0000];
c = gca;
 %% d' vs duration -binoc
subplot(3,9,8)
hold on

REs = [REdPrimeBinoc; LEdPrimeBinoc];
h = barh(dPMid,REs');
h(1).FaceColor = [1 0 0];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [0 0 1];
h(2).EdgeColor = [0 0 1]; 

view(-180,-90)

set(gca,'Color','none','tickdir','out','yaxislocation','right','YTickLabel',[],'layer','top','Position',[0.645 0.605 0.03 0.52])%[0.2185 0.7343 0.0672 0.1907]
xlim([0 1])
ylim([-2 4.25])
b = gca;
% x = xlabel('probability');
% x.Position = [1.13 -3.1193 -1];
 
subplot(3,9,9)
hold on
scatter(LEdata.respLength(binocCh),LEdata.allStimBlankDprime(binocCh),40,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.15);
scatter(REdata.respLength(binocCh),REdata.allStimBlankDprime(binocCh),40,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.15);

REr = corr2(REdata.respLength(binocCh),REdata.allStimBlankDprime(binocCh));
text(300,4, sprintf('R %.2f',REr),'FontSize',11,'FontWeight','bold','Color',[1 0 0])

LEr = corr2(LEdata.respLength(binocCh),LEdata.allStimBlankDprime(binocCh));
text(300,3.1, sprintf('R %.2f',LEr),'FontSize',11,'FontWeight','bold','Color',[0 0 1])

set(gca,'Color','none','tickdir','out','layer','top','Position',[0.71 0.57 0.12 0.6]) %[left bottom width height]
xlabel('duration')
y = ylabel('dPrime');
y.Position = [-45  1.120   -1.0000];
xlim([0 325])
ylim([-2 4.25])
title('dPrime v duration')
axis square
c = gca;
 
subplot(3,9,18)
hold on
REs = [RErespLengthBinoc;LErespLengthBinoc];
h = bar(respLengthMid,REs');
h(1).FaceColor = [1 0 0];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [0 0 1];
h(2).EdgeColor = [0 0 1]; 

set(gca,'Color','none','tickdir','out','xaxislocation','top','XDir','reverse','XTickLabel',[],'layer','top','Position',[0.71 0.27 0.12 0.15])

ylim([0 0.8])
xlim([0 325])
view(-180, -270)
% y = ylabel('probability');
% y.Position = [-45 0.7 -1.0000];
c = gca;

suptitle({sprintf('%s %s Glass pattern comparisons across eyes',REdata.animal, REdata.array);'RE red LE blue'})
%%
figName = [REdata.animal,'_',REdata.array,'_',REdata.programID,'_dPrimeVlatencyBinocular'];
print(gcf, figName,'-dpdf','-bestfit')
%% monocular
figure (2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 400])
set(gcf,'PaperOrientation','Landscape');
%% d' vs onset - monoc
clf
subplot(3,9,2)
hold on

REs = [REdPrimeMonoc; LEdPrimeMonoc];
h = barh(dPMid,REs');

h(1).FaceColor = [1 1 1];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [1 1 1];
h(2).EdgeColor = [0 0 1]; 

view(-180,-90)

set(gca,'Color','none','tickdir','out','yaxislocation','right','YTickLabel',[],'layer','top','Position',[0.08 0.58 0.03 0.57])%[0.2185 0.7343 0.0672 0.1907]
xlim([0 1])
ylim([-2 4.25])
b = gca;
x = xlabel('probability');
x.Position = [1.13 -3.1193 -1];
title('monocular')

subplot(3,9,3)
hold on
scatter(LEdata.onsetLatencyAllStim(~binocCh & LEndx),LEdata.allStimBlankDprime(~binocCh & LEndx),40,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 1], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2,'LineWidth',2);
scatter(REdata.onsetLatencyAllStim(~binocCh & REndx),REdata.allStimBlankDprime(~binocCh & REndx),40,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 0 0], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2,'LineWidth',2);

REr = corr2(REdata.onsetLatencyAllStim(~binocCh & REndx),REdata.allStimBlankDprime(~binocCh & REndx));
text(200,4, sprintf('R %.2f',REr),'FontSize',11,'FontWeight','bold','Color',[1 0 0])

LEr = corr2(LEdata.onsetLatencyAllStim(~binocCh & LEndx),LEdata.allStimBlankDprime(~binocCh & LEndx));
text(200,3.1, sprintf('R %.2f',LEr),'FontSize',11,'FontWeight','bold','Color',[0 0 1])

set(gca,'Color','none','tickdir','out','layer','top','Position',[0.145 0.57 0.12 0.6]) %[left bottom width height]
xlabel('onset')
y = ylabel('dPrime');
y.Position = [-30 1.120   -1.0000];
xlim([0 250])
ylim([-2 4.25])
title('dPrime v onset')
axis square
c = gca;
 
subplot(3,9,12)
hold on
REs = [REonsetMonoc;LEonsetMonoc;];
h = bar(latOnMid,REs');
h(1).FaceColor = [1 1 1];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [1 1 1];
h(2).EdgeColor = [0 0 1]; 

set(gca,'Color','none','tickdir','out','xaxislocation','top','XDir','reverse','XTickLabel',[],'layer','top','Position',[0.145 0.28 0.12 0.15])

ylim([0 0.8])
xlim([0 250])
view(-180, -270)
y = ylabel('probability');
y.Position = [-47 0.7 -1.0000];
c = gca;
 %% d' vs offset - monoc
subplot(3,9,5)
hold on

REs = [REdPrimeMonoc; LEdPrimeMonoc];
h = barh(dPMid,REs');

h(1).FaceColor = [1 1 1];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [1 1 1];
h(2).EdgeColor = [0 0 1]; 

view(-180,-90)

set(gca,'Color','none','tickdir','out','yaxislocation','right','YTickLabel',[],'layer','top','Position',[0.365 0.6 0.03 0.55])%[0.2185 0.7343 0.0672 0.1907]
xlim([0 1])
ylim([-2 4.25])
b = gca;
% x = xlabel('probability');
% x.Position = [1.13 -3.1193 -1];
 
subplot(3,9,6)
hold on
scatter(LEdata.offsetLatencyAllStim(~binocCh & LEndx),LEdata.allStimBlankDprime(~binocCh & LEndx),40,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 1], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2,'LineWidth',2);
scatter(REdata.offsetLatencyAllStim(~binocCh & REndx),REdata.allStimBlankDprime(~binocCh & REndx),40,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 0 0], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2,'LineWidth',2);

REr = corr2(REdata.offsetLatencyAllStim(~binocCh & REndx),REdata.allStimBlankDprime(~binocCh & REndx));
text(310,4, sprintf('R %.2f',REr),'FontSize',11,'FontWeight','bold','Color',[1 0 0])

LEr = corr2(LEdata.offsetLatencyAllStim(~binocCh & LEndx),LEdata.allStimBlankDprime(~binocCh & LEndx));
text(310,3.1, sprintf('R %.2f',LEr),'FontSize',11,'FontWeight','bold','Color',[0 0 1])

set(gca,'Color','none','tickdir','out','layer','top','Position',[0.43 0.57 0.12 0.6]) %[left bottom width height]
xlabel('offset')
y = ylabel('dPrime');
y.Position = [155  1.120   -1.0000];
xlim([175 325])
ylim([-2 4.25])
title('dPrime v offset')
axis square
c = gca;
 
subplot(3,9,15)
hold on
REs = [REoffsetMonoc;LEoffsetMonoc];
h = bar(latOffMid,REs');
h(1).FaceColor = [1 1 1];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [1 1 1];
h(2).EdgeColor = [0 0 1]; 

set(gca,'Color','none','tickdir','out','xaxislocation','top','XDir','reverse','XTickLabel',[],'layer','top','Position',[0.43 0.28 0.12 0.15])

ylim([0 0.8])
xlim([175 325])
view(-180, -270)
% y = ylabel('probability');
% y.Position = [155 0.7 -1.0000];
c = gca;
 %% d' vs duration - RE
subplot(3,9,8)
hold on

REs = [REdPrimeMonoc; LEdPrimeMonoc];
h = barh(dPMid,REs');
h(1).FaceColor = [1 1 1];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [1 1 1];
h(2).EdgeColor = [0 0 1]; 

view(-180,-90)

set(gca,'Color','none','tickdir','out','yaxislocation','right','YTickLabel',[],'layer','top','Position',[0.645 0.605 0.03 0.55])%[0.2185 0.7343 0.0672 0.1907]
xlim([0 1])
ylim([-2 4.25])
b = gca;
% x = xlabel('probability');
% x.Position = [1.13 -3.1193 -1];
 
subplot(3,9,9)
hold on
scatter(LEdata.respLength(~binocCh & LEndx),LEdata.allStimBlankDprime(~binocCh & LEndx),40,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 1], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2,'LineWidth',2);
scatter(REdata.respLength(~binocCh & REndx),REdata.allStimBlankDprime(~binocCh & REndx),40,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 0 0], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2,'LineWidth',2);

REr = corr2(REdata.respLength(~binocCh & REndx),REdata.allStimBlankDprime(~binocCh & REndx));
text(300,4, sprintf('R %.2f',REr),'FontSize',11,'FontWeight','bold','Color',[0 0 1])

LEr = corr2(LEdata.respLength(~binocCh & LEndx),LEdata.allStimBlankDprime(~binocCh & LEndx));
text(300,3.1, sprintf('R %.2f',LEr),'FontSize',11,'FontWeight','bold','Color',[1 0 0])

set(gca,'Color','none','tickdir','out','layer','top','Position',[0.71 0.57 0.12 0.6]) %[left bottom width height]
xlabel('duration')
y = ylabel('dPrime');
y.Position = [-45  1.120   -1.0000];
xlim([0 325])
ylim([-2 4.25])
title('dPrime v duration')
axis square
c = gca;
 
subplot(3,9,18)
hold on
REs = [RErespLengthMonoc;LErespLengthMonoc];
h = bar(respLengthMid,REs');
h(1).FaceColor = [1 1 1];
h(1).EdgeColor = [1 0 0];

h(2).FaceColor = [1 1 1];
h(2).EdgeColor = [0 0 1]; 

set(gca,'Color','none','tickdir','out','xaxislocation','top','XDir','reverse','XTickLabel',[],'layer','top','Position',[0.71 0.28 0.12 0.15])

ylim([0 0.8])
xlim([0 325])
view(-180, -270)
% y = ylabel('probability');
% y.Position = [-45 0.7 -1.0000];
c = gca;

suptitle({sprintf('%s %s Glass pattern comparisons across eyes monocular',REdata.animal, REdata.array);'RE red LE blue'})
%%
figName = [REdata.animal,'_',REdata.array,'_',REdata.programID,'_dPrimeVlatencyMonocular'];
print(gcf, figName,'-dpdf','-bestfit')