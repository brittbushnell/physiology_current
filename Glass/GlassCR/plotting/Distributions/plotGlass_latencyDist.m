function [data] = plotGlass_latencyDist(data)
%%
location = determineComputer;
%% limit to binocular channels
REndx = (data.RE.goodCh == 1);
LEndx = (data.LE.goodCh == 1);
binocCh = (REndx & LEndx);
%%
figure(72)
clf

subplot(2,3,1)
hold on
histogram(data.LE.onsetLatencyAllStim(binocCh),50:25:200,'facecolor','b','Normalization','probability')
plot(nanmean(data.LE.onsetLatencyAllStim(binocCh)),0.55,'vb')
text(nanmean(data.LE.onsetLatencyAllStim(binocCh)),0.7,sprintf('%.2f',nanmean(data.LE.onsetLatencyAllStim(binocCh))))
set(gca,'Color','none','tickdir','out','XTick',50:25:200)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([40 225])
title('LE onset latencies')

subplot(2,3,2)
hold on
histogram(data.LE.offsetLatencyAllStim(binocCh),150:25:300,'facecolor','b','Normalization','probability')
plot(nanmean(data.LE.offsetLatencyAllStim(binocCh)),0.55,'vb')
text(nanmean(data.LE.offsetLatencyAllStim(binocCh)),0.7,sprintf('%.2f',nanmean(data.LE.offsetLatencyAllStim(binocCh))))
set(gca,'Color','none','tickdir','out','XTick',150:25:300)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([140 325])
title('LE offset latencies')

subplot(2,3,3)
hold on
LEoff = data.LE.offsetLatencyAllStim(binocCh);
LEon = data.LE.onsetLatencyAllStim(binocCh);
dur = LEoff - LEon;
histogram(dur,0:50:250,'facecolor','b','Normalization','probability')
plot(nanmean(dur),0.55,'vb')
text(nanmean(dur),0.7,sprintf('%.2f',nanmean(dur)))
set(gca,'Color','none','tickdir','out','XTick',0:50:250)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([0 300])
title('duration of LE response')

subplot(2,3,4)
hold on
histogram(data.RE.onsetLatencyAllStim(binocCh),50:25:200,'facecolor','r','Normalization','probability')
plot(nanmean(data.RE.onsetLatencyAllStim(binocCh)),0.55,'vr')
text(nanmean(data.RE.onsetLatencyAllStim(binocCh)),0.7,sprintf('%.2f',nanmean(data.RE.onsetLatencyAllStim(binocCh))))
set(gca,'Color','none','tickdir','out','XTick',50:25:200)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([40 225])
title('RE onset latencies')
xlabel('ms')

subplot(2,3,5)
hold on
histogram(data.RE.offsetLatencyAllStim(binocCh),150:25:300,'facecolor','r','Normalization','probability')
plot(nanmean(data.RE.offsetLatencyAllStim(binocCh)),0.55,'vr')
text(nanmean(data.RE.offsetLatencyAllStim(binocCh)),0.7,sprintf('%.2f',nanmean(data.RE.offsetLatencyAllStim(binocCh))))
set(gca,'Color','none','tickdir','out','XTick',150:25:300)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([140 325])
title('RE offset latenceis')
xlabel('ms')

subplot(2,3,6)
hold on
REoff = data.RE.offsetLatencyAllStim(binocCh);
REon = data.RE.onsetLatencyAllStim(binocCh);
dur = REoff - REon;
histogram(dur,0:50:250,'facecolor','r','Normalization','probability')
plot(nanmean(dur),0.55,'vr')
text(nanmean(dur),0.7,sprintf('%.2f',nanmean(dur)))
set(gca,'Color','none','tickdir','out','XTick',0:50:250)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([0 300])
title('duration of RE response')

suptitle(sprintf('%s %s latencies for binocular channels all stimuli combined',data.RE.animal, data.RE.array))
%% save figure
if contains(data.RE.animal,'WV')
    if contains(data.RE.programID,'Small')
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/4Deg/EyeComps/latency',data.RE.animal,data.RE.array);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/4Deg/EyeComps/latency',data.RE.animal,data.RE.array);
        end
    else
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/8Deg/EyeComps/latency',data.RE.animal,data.RE.array);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/8Deg/EyeComps/latency',data.RE.animal,data.RE.array);
        end
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/EyeComps/latency',data.RE.animal,data.RE.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/EyeComps/latency',data.RE.animal,data.RE.array);
    end
end
cd(figDir)

figName = [data.RE.animal,data.RE.array,'_',data.RE.programID,'_latencyHistosBinoc'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(73)
clf

subplot(2,3,1)
hold on
histogram(data.LE.onsetLatencyAllStim(~binocCh),50:25:200,'facecolor','b','Normalization','probability')
plot(nanmean(data.LE.onsetLatencyAllStim(~binocCh)),0.55,'vb')
text(nanmean(data.LE.onsetLatencyAllStim(~binocCh)),0.7,sprintf('%.2f',nanmean(data.LE.onsetLatencyAllStim(~binocCh))))
set(gca,'Color','none','tickdir','out','XTick',50:25:200)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([40 225])
title('LE onset latencies')

subplot(2,3,2)
hold on
histogram(data.LE.offsetLatencyAllStim(~binocCh),150:25:300,'facecolor','b','Normalization','probability')
plot(nanmean(data.LE.offsetLatencyAllStim(~binocCh)),0.55,'vb')
text(nanmean(data.LE.offsetLatencyAllStim(~binocCh)),0.7,sprintf('%.2f',nanmean(data.LE.offsetLatencyAllStim(~binocCh))))
set(gca,'Color','none','tickdir','out','XTick',150:25:300)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([140 325])
title('LE offset latencies')

subplot(2,3,3)
hold on
LEoff = data.LE.offsetLatencyAllStim(~binocCh);
LEon = data.LE.onsetLatencyAllStim(~binocCh);
dur = LEoff - LEon;
histogram(dur,0:50:250,'facecolor','b','Normalization','probability')
plot(nanmean(dur),0.55,'vb')
text(nanmean(dur),0.7,sprintf('%.2f',nanmean(dur)))
set(gca,'Color','none','tickdir','out','XTick',0:50:250)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([0 300])
title('duration of LE response')

subplot(2,3,4)
hold on
histogram(data.RE.onsetLatencyAllStim(~binocCh),50:25:200,'facecolor','r','Normalization','probability')
plot(nanmean(data.RE.onsetLatencyAllStim(~binocCh)),0.55,'vr')
text(nanmean(data.RE.onsetLatencyAllStim(~binocCh)),0.7,sprintf('%.2f',nanmean(data.RE.onsetLatencyAllStim(~binocCh))))
set(gca,'Color','none','tickdir','out','XTick',50:25:200)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([40 225])
title('RE onset latencies')
xlabel('ms')

subplot(2,3,5)
hold on
histogram(data.RE.offsetLatencyAllStim(~binocCh),150:25:300,'facecolor','r','Normalization','probability')
plot(nanmean(data.RE.offsetLatencyAllStim(~binocCh)),0.55,'vr')
text(nanmean(data.RE.offsetLatencyAllStim(~binocCh)),0.7,sprintf('%.2f',nanmean(data.RE.offsetLatencyAllStim(~binocCh))))
set(gca,'Color','none','tickdir','out','XTick',150:25:300)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([140 325])
title('RE offset latenceis')
xlabel('ms')

subplot(2,3,6)
hold on
REoff = data.RE.offsetLatencyAllStim(~binocCh);
REon = data.RE.onsetLatencyAllStim(~binocCh);
dur = REoff - REon;
histogram(dur,0:50:250,'facecolor','r','Normalization','probability')
plot(nanmean(dur),0.55,'vr')
text(nanmean(dur),0.7,sprintf('%.2f',nanmean(dur)))
set(gca,'Color','none','tickdir','out','XTick',0:50:250)%,'XTickLabel',{'50','70','90','110','130','150','170','190'})
box off
ylim([0 0.9])
xlim([0 300])
title('duration of RE response')

suptitle(sprintf('%s %s latencies for monocular channels all stimuli combined',data.RE.animal, data.RE.array))
figName = [data.RE.animal,data.RE.array,'_',data.RE.programID,'_latencyHistosMonoc'];
print(gcf, figName,'-dpdf','-fillpage')
%%  scatter plots 


onsets = [data.RE.onsetLatencyAllStim(binocCh);data.LE.onsetLatencyAllStim(binocCh)];
REfirstOn = sum(onsets(1,:)>onsets(2,:));
LEfirstOn = sum(onsets(1,:)<onsets(2,:));
onCorr = corr2(onsets(1,:),onsets(2,:));

figure (74)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 600 600])
set(gcf,'PaperOrientation','Landscape');
% plot onsets
subplot(2,2,1)
hold on
scatter(data.RE.onsetLatencyAllStim, data.LE.onsetLatencyAllStim,40,'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor',[0.7 0 0.7], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
plot([0 180], [0 180],'k')

text(190,190, sprintf('R %.2f',onCorr),'FontSize',12,'FontWeight','bold')
text(3,195, sprintf('n above %d',LEfirstOn),'FontWeight','bold')
text(130,10, sprintf('n below %d',REfirstOn),'FontWeight','bold')

set(gca,'Color','none','tickdir','out','XTick',0:50:200,'YTick',0:50:200)
xlabel('RE (ms)')
ylabel('LE (ms)')
xlim([0 200])
ylim([0 200])
title('onset latencies')
axis square
box off

% plot offsets
offsets = [data.RE.offsetLatencyAllStim(binocCh);data.LE.offsetLatencyAllStim(binocCh)];
REfirstOff = sum(offsets(1,:)>offsets(2,:));
LEfirstOff = sum(offsets(1,:)<offsets(2,:));
offCorr = corr2(offsets(1,:),offsets(2,:));

subplot(2,2,2)
hold on

plot([150 340], [150 340],'k')
scatter(data.RE.offsetLatencyAllStim,data.LE.offsetLatencyAllStim,40,'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);


text(350,350, sprintf('R %.2f',offCorr),'FontSize',12,'FontWeight','bold')
text(153,345, sprintf('n above %d',LEfirstOn),'FontWeight','bold')
text(250,160, sprintf('n below %d',REfirstOn),'FontWeight','bold')

set(gca,'Color','none','tickdir','out','XTick',150:50:350,'YTick',150:50:350)
xlabel('RE (ms)')
ylabel('LE (ms)')
xlim([150 350])
ylim([150 350])
title('offset latencies')
axis square
box off

% plot how long the response lasts
RE = [data.RE.onsetLatencyAllStim(binocCh);data.RE.offsetLatencyAllStim(binocCh)];
LE = [data.LE.onsetLatencyAllStim(binocCh);data.LE.offsetLatencyAllStim(binocCh)];
RErespLength = RE(2,:) - RE(1,:);
LErespLength = LE(2,:) - LE(1,:);

RElonger = sum(RErespLength>LErespLength);
LElonger = sum(RErespLength<LErespLength);

lengthCorr = corr2(RErespLength,LErespLength);

subplot(2,2,3)
hold on
scatter(RErespLength,LErespLength,40,'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor',[0.7 0 0.7], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
plot([0 280], [00 280],'k')
text(300,300, sprintf('R %.2f',lengthCorr),'FontSize',12,'FontWeight','bold')
text(5,295, sprintf('n above %d',LElonger),'FontWeight','bold')
text(180,20, sprintf('n below %d',RElonger),'FontWeight','bold')

set(gca,'Color','none','tickdir','out','XTick',0:50:300,'YTick',0:50:300)
xlabel('RE (ms)')
ylabel('LE (ms)')
title('offset - onset')
axis square
box off

subplot(2,2,4)
hold on
scatter(data.RE.onsetLatencyAllStim(binocCh),data.RE.allStimBlankDprime(binocCh),40,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
scatter(data.LE.onsetLatencyAllStim(binocCh),data.LE.allStimBlankDprime(binocCh),40,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1], 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);


REr = corr2(data.RE.onsetLatencyAllStim(binocCh),data.RE.allStimBlankDprime(binocCh));
LEr = corr2(data.LE.onsetLatencyAllStim(binocCh),data.LE.allStimBlankDprime(binocCh));
text(200,3.9, sprintf('Rright %.2f',REr),'FontSize',12,'FontWeight','bold')
text(200,3, sprintf('Rleft %.2f',LEr),'FontSize',12,'FontWeight','bold')

set(gca,'Color','none','tickdir','out','XTick',0:50:200)
xlabel('onset')
ylabel('dPrime')
xlim([0 250])
ylim([-1 4])
title('latency vs dPrime')
axis square
suptitle(sprintf('%s latencies for binocular channels all stimuli combined',data.RE.animal))
%%
figName = [data.RE.animal,data.RE.array,'_',data.RE.programID,'_latencyScatter_50to250'];
suptitle(sprintf('%s %s latencies across eyes',data.RE.animal, data.RE.array))
print(gcf, figName,'-dpdf','-fillpage')
%% save to data matrix
RE = [data.RE.onsetLatencyAllStim;data.RE.offsetLatencyAllStim];
LE = [data.LE.onsetLatencyAllStim;data.LE.offsetLatencyAllStim];
RErespLength = RE(2,:) - RE(1,:);
LErespLength = LE(2,:) - LE(1,:);

data.RE.respLength = RErespLength;
data.LE.respLength = LErespLength;
data.stimResplengthRval = lengthCorr;

data.RE.firstOff = REfirstOff;
data.LE.firstOff = LEfirstOff;
data.offsetLatencyRval = offCorr;

data.RE.firstOn = REfirstOn;
data.LE.firstOn = LEfirstOn;
data.onsetLatencyRval = onCorr;
