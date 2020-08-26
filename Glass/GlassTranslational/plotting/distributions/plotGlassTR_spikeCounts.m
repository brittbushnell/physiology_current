function plotGlassTR_spikeCounts(dataT)
figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/GlassTR/%s/distributions/',dataT.animal, dataT.array);
cd(figDir)

folder = 'spikeCounts';
mkdir(folder)
cd(sprintf('%s',folder))

folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))

folder = dataT.eye;
mkdir(folder)
cd(sprintf('%s',folder))

if isempty(dataT.reThreshold)
    folder = 'raw';
    mkdir(folder)
    cd(sprintf('%s',folder))
else
    folder = 'reThreshold';
    mkdir(folder)
    cd(sprintf('%s',folder))
end
%%
[numOris,numDots,numDxs,numCoh,~,orisDeg,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
% (numOris,numCoh,numDots,numDxs,96,bins)
for ch = 1:96
    for coh = numCoh %1:numCoh
        figure(1)
        clf
        ndx = 1;
        
        % histogram limits
        tp = (dataT.GlassTRSpikeCount(:,coh,:,:,ch,:));
        tp(isnan(tp)) = [];
        tp = squeeze(tp);
        maxSpikesCh = max(tp(:))+1;
        
        for dt = 1:numDots
            for dx = 1:numDxs
                for or = 1:numOris
                    
                    spikes = squeeze(dataT.GlassTRSpikeCount(or,coh,dt,dx,ch,:));
                    
                    subplot(4,4,ndx)
                    hold on
                    h = histogram(spikes,'binWidth',1,'FaceColor','k','EdgeColor','w');
                    
                    xlim([-1 maxSpikesCh])
                    ylim([0 20])
                    
                    set(gca,'tickdir','out','Layer','top')
                    
                    histBins = [h.Values;h.BinEdges(2:end)];
                    a = find(histBins(1,:) == 0);
                    
                    if length(a)>10 % if there are more than 5 channels with bins that equal zero, then break the x axis
                        breakStart = a(2);
                        breakEnd = a(end-1);
                        breakxaxis2([breakStart breakEnd]);
                    end
                    
                    if ndx <=4
                        title(orisDeg(or))
                    end
                    
                    if ndx == 1 || ndx == 5 || ndx == 9 || ndx == 13
                        ylabel(sprintf('%d dots %.2f dx',dots(dt),dxs(dx)))
                    end
                    
                    if ndx >= 13
                        xlabel('spike count')
                    end
                    
                    ndx = ndx+1;
                end
            end
        end
        if isempty(dataT.reThreshold)
            suptitle({sprintf('%s %s %s spike counts for each stimulus ch %s',dataT.animal, dataT.eye, dataT.array,num2str(ch));...
                sprintf('%d%% coherence recorded %s run # %s',coherences(coh)*100,dataT.date, dataT.runNum)});
            figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_glassTR_',num2str(dataT.date2),'_spikeCountRaw',num2str(ch),'.pdf'];
            print(gcf, figName,'-dpdf','-fillpage')
        else
            suptitle({sprintf('%s %s %s spike counts for each stimulus ch %s',dataT.animal, dataT.eye, dataT.array,num2str(ch));...
                sprintf('%d%% coherence recorded %s run # %s cleaned and rethresholded data',coherences(coh)*100,dataT.date, dataT.runNum)});
            figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_glassTR_',num2str(dataT.date2),'_spikeCountClean',num2str(ch),'.pdf'];
            print(gcf, figName,'-dpdf','-fillpage')
        end
    end
end
