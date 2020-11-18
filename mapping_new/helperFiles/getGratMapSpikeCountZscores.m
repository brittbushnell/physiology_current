function [blankSpikeCount, stimSpikeCount, stimSpikeCountAllLoc, blankZscore, stimZscore,stimZscoreAllLoc] = getGratMapSpikeCountZscores(dataT,filename)

%%
location = determineComputer;
fname = strrep(filename,'.mat','');
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Mapping/%s/PSTH/',dataT.animal,dataT.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/Mapping/%s/PSTH/',dataT.animal,dataT.array);
end
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
xPos = unique(dataT.pos_x);
yPos = unique(dataT.pos_y);

if yPos(1)<0 || yPos(2)<0 || yPos(3)<0
    yPos =  sort(yPos,'descend');
end

numXs = length(xPos);
numYs = length(yPos);
%%
% need to be y,x to plot properly
%%
if contains(dataT.programID,'grat','IgnoreCase',true)
    stimNdx  = dataT.spatial_frequency ~=0;
    blankNdx = dataT.spatial_frequency == 0;
else
    stimNdx  = dataT.stimulus ~=0;
    blankNdx = dataT.stimulus == 0;
end

xNdx = dataT.pos_x == xPos(2);
yNdx = dataT.pos_y == yPos(2);
stimTrials = stimNdx & yNdx & xNdx;

numStimTrialsLoc = sum(stimTrials)+10;

numBlankTrials = sum(blankNdx)+10;

stimSpikeCount = nan(numYs,numXs, 96, numStimTrialsLoc);
stimSpikeCountAllLoc = nan(96,sum(stimNdx)+10);
blankSpikeCount = nan(96,numBlankTrials);

stimZscore = nan(numYs,numXs, 96, numStimTrialsLoc);
stimZscoreAllLoc = nan(96,sum(stimNdx)+10);
blankZscore = nan(96,numBlankTrials);
%%
for ch = 1:96
    figure(1)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 800])
    set(gcf,'PaperOrientation','Landscape');
    
    chBlankSpikes = sum(dataT.bins(blankNdx, 5:25, ch),2);
    chStimSpikes = sum(dataT.bins(stimNdx,(5:25) ,ch),2);
    
    chSpikes = [chStimSpikes; chBlankSpikes];
    chMu = nanmean(chSpikes,'all');
    chStd = nanstd(chSpikes,0,'all');
    
    blankSpikeCount(ch,1:sum(blankNdx)) = chBlankSpikes;
    stimSpikeCountAllLoc(ch,1:sum(stimNdx)) = chStimSpikes;
    stimZscoreAllLoc(ch,1:sum(stimNdx)) = (chStimSpikes - chMu) / chStd;
    blankZscore(ch,1:sum(blankNdx)) = (chBlankSpikes - chMu) / chStd;
    
    if sum(isnan(chBlankSpikes)) == numel(chStimSpikes)
        keyboard
    end
    
    nx = 1;
    for y = 1:numYs
        for x = 1:numXs
            xNdx = dataT.pos_x == xPos(x);
            yNdx = dataT.pos_y == yPos(y);
            
            stimTrials  = stimNdx & yNdx & xNdx;
            
            if sum(stimTrials) > 0
                spikes = sum(dataT.bins(stimTrials, 5:25, ch),2); % do not want the nans converted to zeros - zero is meaningful but nans are not.
                stimSpikeCount(y,x,ch,1:sum(stimTrials)) = spikes;
                stimZscore(y,x,ch,1:sum(stimTrials)) = (spikes -  chMu)/chStd;
            end
        
            %%
            subplot(numYs, numXs, nx)
            hold on
            bK = nanmean(smoothdata(dataT.bins(blankNdx, 1:35 ,ch),'gaussian',3))./0.01;
            sK = nanmean(smoothdata(dataT.bins(stimNdx & xNdx & yNdx, 1:35 ,ch),'gaussian',3))./0.01;
            
            plot(bK,'-','color',[0.2 0.2 0.2],'LineWidth',0.5)
            plot(sK,'-k','LineWidth',1.5)
            title(sprintf('(%.1f,%.1f)',xPos(x),yPos(y)))
            nx = nx+1;
        end
    end
    suptitle({sprintf('%s %s %s %s channel %d',dataT.animal, dataT.array, dataT.eye,dataT.programID, ch);...
        sprintf('%s run %s',dataT.date,dataT.runNum)})
    figName = [fname,'_PSTHbyLocationCh',num2str(ch),'.pdf'];
%     print(gcf, figName,'-dpdf','-fillpage')
end

if sum(isnan(stimZscore)) == numel(stimZscore)
    keyboard
end
%%
% if location == 1
%     figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Mapping/%s/zScore/',dataT.animal,dataT.array);
% elseif location == 0
%     figDir =  sprintf('~/Dropbox/Figures/%s/Mapping/%s/zScore/',dataT.animal,dataT.array);
% end
% if ~exist(figDir,'dir')
%     mkdir(figDir)
% end
% cd(figDir)
% 
% for ch = 1:96
%     figure(2)
%     clf
%     pos = get(gcf,'Position');
%     set(gcf,'Position',[pos(1) pos(2) 800 800])
%     set(gcf,'PaperOrientation','Landscape');
%     
%     nx = 1;
%     for y = 1:numYs
%         for x = 1:numXs
%             
%             subplot(numYs, numXs, nx)
%             hold on
%             
%             zS = squeeze(stimZscore(y,x,ch,:));
%             histogram(zS,'BinWidth',0.25,'Normalization','probability')
%             title(sprintf('(%.1f,%.1f)',xPos(x),yPos(y)))
%             ylim([0 0.5])
%             xlim([-2 5])
%             nx = nx+1;
%         end
%     end
%     suptitle({sprintf('%s %s %s %s channel %d',dataT.animal, dataT.array, dataT.eye,dataT.programID, ch);...
%         sprintf('%s run %s',dataT.date,dataT.runNum)})
%     figName = [fname,'_zScoresByLocationCh',num2str(ch),'.pdf'];
% %     print(gcf, figName,'-dpdf','-fillpage')
% end