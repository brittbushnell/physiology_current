function [] = plotGlassPSTHs_visualResponses(data)
% Plot PSTHs for concentric vs radial glass pattern stimuli
% [~,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(data);
REdata = data.RE;
LEdata = data.LE;
location = determineComputer;
%% stim vs blank - all chs
for ch = 1:96
    REcoh = (REdata.coh == 1);
    REnoiseCoh = (REdata.coh == 0);
    REcohNdx = logical(REcoh + REnoiseCoh);
    
    LEcoh = (LEdata.coh == 1);
    LEnoiseCoh = (LEdata.coh == 0);
    LEcohNdx = logical(LEcoh + LEnoiseCoh);
    if REdata.goodCh(ch) == 1
        REblankResp = nanmean(smoothdata(REdata.bins((REdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
        REstimResp = nanmean(smoothdata(REdata.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
        REmx(ch) = max([REblankResp,REstimResp]);
    end
    
    if LEdata.goodCh(ch) == 1
        LEblankResp = nanmean(smoothdata(LEdata.bins((LEdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
        LEstimResp = nanmean(smoothdata(LEdata.bins((LEcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
        LEmx(ch) = max([LEblankResp,LEstimResp]);
    end
end

yMax = round(max([REmx,LEmx]));

%%
figure(5);
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 800])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    
    subplot(REdata.amap,10,10,ch)
    hold on;
    REdata.goodCh(ch);
    LEdata.goodCh(ch);
    tmp(1,ch) = (REdata.goodCh(ch)+ LEdata.goodCh(ch));
    
    REcoh = (REdata.coh == 1);
    REnoiseCoh = (REdata.coh == 0);
    REcohNdx = logical(REcoh + REnoiseCoh);
    
    LEcoh = (LEdata.coh == 1);
    LEnoiseCoh = (LEdata.coh == 0);
    LEcohNdx = logical(LEcoh + LEnoiseCoh);
    % REdata.numDots>0 &
    if (tmp(1,ch) == 0)
        axis off
    else
        if REdata.goodCh(ch) == 1
            if contains(REdata.animal,'XT')
                blankResp = nanmean(smoothdata(REdata.bins((REdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
                stimResp = nanmean(smoothdata(REdata.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
                plot(1:35,blankResp,'color',[0.14 0.63 0.42 0.7],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0.14 0.63 0.42 0.8],'LineWidth',2);
            else
                blankResp = nanmean(smoothdata(REdata.bins((REdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
                stimResp = nanmean(smoothdata(REdata.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
                plot(1:35,blankResp,'color',[1 0 0 0.7],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[1 0 0 0.8],'LineWidth',2);
                
            end
        end
        
        if LEdata.goodCh(ch) == 1
            if contains(REdata.animal,'XT')
                blankResp = nanmean(smoothdata(LEdata.bins((LEdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
                stimResp = nanmean(smoothdata(LEdata.bins((LEcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
                plot(1:35,blankResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',2);
            else
                blankResp = nanmean(smoothdata(LEdata.bins((LEdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
                stimResp = nanmean(smoothdata(LEdata.bins((LEcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
                plot(1:35,blankResp,'color',[0 0 1 0.7],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0 0 1 0.8],'LineWidth',2);
            end
        end
        title(ch);
        
        set(gca,'Color','none','tickdir','out','XTickLabel',[],'YTick',[0,yMax],'FontAngle','italic');
        ylim([0 yMax])
        %ylim([0 inf])
    end
end

suptitle((sprintf('%s %s %s stim vs blank', REdata.animal, REdata.array, REdata.programID)))

%% save figure
if length(dataT.inStim) > 96 % running on a single session rather than merged data
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%/%s/PSTH/singleSession/',REdata.animal,REdata.programID,REdata.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%/%s/PSTH/singleSession/',REdata.animal,REdata.programID,REdata.array);
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%/%s/PSTH/',REdata.animal,REdata.programID,REdata.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%/%s/PSTH/',REdata.animal,REdata.programID,REdata.array);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [REdata.animal,'_BE_',REdata.array,'_',REdata.programID,'_PSTHstimVBlank'];
print(gcf, figName,'-dpdf','-fillpage')
%% plot LE
figure(6);
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 800])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    
    subplot(LEdata.amap,10,10,ch)
    hold on;
    LEdata.goodCh(ch);
    
    LEcoh = (LEdata.coh == 1);
    LEnoiseCoh = (LEdata.coh == 0);
    LEcohNdx = logical(LEcoh + LEnoiseCoh);
    
    if LEdata.goodCh(ch) == 1
        if contains(LEdata.animal,'XT')
            blankResp = nanmean(smoothdata(LEdata.bins((LEdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(LEdata.bins((LEcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',0.5);
            plot(1:35,stimResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',2);
        else
            blankResp = nanmean(smoothdata(LEdata.bins((LEdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(LEdata.bins((LEcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'color',[0 0 1 0.7],'LineWidth',0.5);
            plot(1:35,stimResp,'color',[0 0 1 0.8],'LineWidth',2);
        end
        title(ch)
    else
        axis off
    end  
  
    set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');    
    ylim([0 inf])
end

suptitle(sprintf('%s %s %s LE stim vs blank', LEdata.animal, LEdata.array, LEdata.programID));

figName = [LEdata.animal,'_LE_',LEdata.array,'_',LEdata.programID,'_PSTHstimVBlank'];
print(gcf, figName,'-dpdf','-fillpage')
%% plot RE
figure(7);
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 800])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
  
    subplot(REdata.amap,10,10,ch)
    hold on;
    REdata.goodCh(ch);
    
    REcoh = (REdata.coh == 1);
    REnoiseCoh = (REdata.coh == 0);
    REcohNdx = logical(REcoh + REnoiseCoh);
    
    if REdata.goodCh(ch) == 1
        if contains(REdata.animal,'XT')
            blankResp = nanmean(smoothdata(REdata.bins((REdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(REdata.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'color',[0.14 0.63 0.42 0.7],'LineWidth',0.5);
            plot(1:35,stimResp,'color',[0.14 0.63 0.42 0.8],'LineWidth',2);
        else
            blankResp = nanmean(smoothdata(REdata.bins((REdata.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(REdata.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'color',[1 0 0 0.7],'LineWidth',0.5);
            plot(1:35,stimResp,'color',[1 0 0 0.8],'LineWidth',2);
        end
        title(ch)
    else
        axis off
    end  
  
    set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');    
    ylim([0 inf])
end

suptitle(sprintf('%s %s %s RE stim vs blank', REdata.animal, REdata.array, REdata.programID));

figName = [REdata.animal,'_RE_',REdata.array,'_',REdata.programID,'_PSTHstimVBlank'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(8)
clf
hold on

LEblankResp = squeeze(nanmean(smoothdata(LEdata.bins((LEdata.numDots == 0), 1:35 ,:),'gaussian',3))./0.01);
LEstimResp = squeeze(nanmean(smoothdata(LEdata.bins((LEcohNdx), 1:35 ,:),'gaussian',3))./0.01);
LEblankResp = sum(LEblankResp,2);
LEstimResp = sum(LEstimResp,2);

REblankResp = squeeze(nanmean(smoothdata(REdata.bins((REdata.numDots == 0), 1:35 ,:),'gaussian',3))./0.01);
REstimResp = squeeze(nanmean(smoothdata(REdata.bins((REcohNdx), 1:35 ,:),'gaussian',3))./0.01);
REblankResp = sum(REblankResp,2);
REstimResp = sum(REstimResp,2);

if contains(REdata.animal,'XT')
    
    plot(1:35,squeeze(REstimResp),'color',[0.14 0.63 0.42 0.8],'LineWidth',2);
    plot(1:35,squeeze(LEstimResp),'color',[0.3 0.3 0.3 0.9],'LineWidth',2);
    plot(1:35,squeeze(LEblankResp),'color',[0.3 0.3 0.3 0.9],'LineWidth',0.5);
    plot(1:35,squeeze(REblankResp),'color',[0.14 0.63 0.42 0.7],'LineWidth',0.5);
else
    
    plot(1:35,squeeze(REstimResp),'color',[1 0 0 0.8],'LineWidth',2);
    plot(1:35,squeeze(LEstimResp),'color',[0 0 1 0.8],'LineWidth',2);
    plot(1:35,squeeze(LEblankResp),'color',[0 0 1 0.7],'LineWidth',0.5);
    plot(1:35,squeeze(REblankResp),'color',[1 0 0 0.7],'LineWidth',0.5);
end

title((sprintf('%s %s %s sum of each channels mean responses to stim vs blank, whole array', REdata.animal, REdata.array, REdata.programID)))
ylabel('spikes/s')
xlabel('time 10 ms bins')
set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',12);
legend('RE/AE','LE/FE')

figName = [REdata.animal,'_BE_',REdata.array,'_',REdata.programID,'_PSTHstimVBlankMean'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(9)
clf
hold on

REblankResp = squeeze(sum(smoothdata(REdata.bins((REdata.numDots == 0), 1:35 ,:),'gaussian',3))./0.01);
REstimResp = squeeze(sum(smoothdata(REdata.bins((REcohNdx), 1:35 ,:),'gaussian',3))./0.01);
REblankResp = sum(REblankResp,2);
REstimResp = sum(REstimResp,2);

LEblankResp = squeeze(sum(smoothdata(LEdata.bins((LEdata.numDots == 0), 1:35 ,:),'gaussian',3))./0.01);
LEstimResp = squeeze(sum(smoothdata(LEdata.bins((LEcohNdx), 1:35 ,:),'gaussian',3))./0.01);
LEblankResp = sum(LEblankResp,2);
LEstimResp = sum(LEstimResp,2);

if contains(REdata.animal,'XT')
    
    plot(1:35,squeeze(REstimResp),'color',[0.14 0.63 0.42 0.8],'LineWidth',2);
    plot(1:35,squeeze(LEstimResp),'color',[0.3 0.3 0.3 0.9],'LineWidth',2);
    plot(1:35,squeeze(LEblankResp),'color',[0.3 0.3 0.3 0.9],'LineWidth',0.5);
    plot(1:35,squeeze(REblankResp),'color',[0.14 0.63 0.42 0.7],'LineWidth',0.5);
else
    
    plot(1:35,squeeze(REstimResp),'color',[1 0 0 0.8],'LineWidth',2);
    plot(1:35,squeeze(LEstimResp),'color',[0 0 1 0.8],'LineWidth',2);
    plot(1:35,squeeze(LEblankResp),'color',[0 0 1 0.7],'LineWidth',0.5);
    plot(1:35,squeeze(REblankResp),'color',[1 0 0 0.7],'LineWidth',0.5);
end

title((sprintf('%s %s %s summed responses to stim vs blank, whole array', REdata.animal, REdata.array, REdata.programID)))
ylabel('spikes/s')
xlabel('time 10 ms bins')
set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',12);
legend('RE/AE','LE/FE')

figName = [REdata.animal,'_BE_',REdata.array,'_',REdata.programID,'_PSTHstimVBlankSum'];
print(gcf, figName,'-dpdf','-fillpage')
