function [blankSpikeCount, stimSpikeCount, stimSpikeCountAllLoc, blankZscore, stimZscore,stimZscoreAllLoc] = getGratMapSpikeCount(dataT)

%%
xPos = unique(dataT.pos_x);
yPos = unique(dataT.pos_y);
% 
% if xPos(1)<0 || xPos(2)<0 || xPos(3)<0 
%     xPos =  sort(xPos,'descend');
% end

if yPos(1)<0 || yPos(2)<0 || yPos(3)<0 
    yPos =  sort(yPos,'descend');
end

numXs = length(xPos);
numYs = length(yPos);
%%
% need to be y,x to plot properly
%%
stimNdx  = dataT.spatial_frequency ~=0;
blankNdx = dataT.spatial_frequency == 0;
xNdx = dataT.pos_x == xPos(1);
yNdx = dataT.pos_y == xPos(1);

numStimTrialsKoc = sum(stimNdx & xNdx & yNdx)+5;
numBlankTrials = sum(blankNdx)+5;

stimSpikeCount = nan(numYs,numXs, 96, numStimTrialsKoc);
stimSpikeCountAllLoc = nan(96,sum(stimNdx)+5);
blankSpikeCount = nan(96,numBlankTrials);

stimZscore = nan(numYs,numXs, 96, numStimTrialsKoc);
stimZscoreAllLoc = nan(96,sum(stimNdx)+5);
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
    
    chSpikes = [chStimSpikes, chBlankSpikes];
    chMu = nanmean(chSpikes,'all');
    chStd = nanstd(chSpikes,0,'all');
    
    blankSpikeCount(ch,1:sum(blankNdx)) = chBlankSpikes;
    stimSpikeCountAllLoc(ch,1:sum(stimNdx)) = chStimSpikes;
    stimZscoreAllLoc(ch,:) = (chStimSpikes - chMu) / chStd;
    blankZscore(ch,:) = (chBlankSpikes - chMu) / chStd;
    
    nx = 1;
    for y = 1:numYs
        for x = 1:numXs
            if size(dataT.pos_x) == size(dataT.spatial_frequency)
                xNdx = dataT.pos_x == xPos(x);
                yNdx = dataT.pos_y == yPos(y);
            else
                xNdx = dataT.pos_x(1,1:size(dataT.spatial_frequency,2)) == xPos(x);
                yNdx = dataT.pos_y(1,1:size(dataT.spatial_frequency,2)) == yPos(y);
            end
            
            stimTrials  = stimNdx & yNdx & xNdx;
            spikes = nansum(dataT.bins(stimTrials, 5:25, ch),2);
            stimSpikeCount(y,x,ch,1:sum(stimTrials)) = spikes;
            stimZscore(y,x,ch,:) = (spikes -  chMu)/chStd;
            
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
    suptitle(sprintf('%s %s %s channel %d',dataT.animal, dataT.array, dataT.eye,ch))
    pause(0.75)
end
%%

