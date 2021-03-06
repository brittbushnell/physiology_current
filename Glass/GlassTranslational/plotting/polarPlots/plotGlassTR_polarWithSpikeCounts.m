function [dataT] = plotGlassTR_polarWithSpikeCounts(dataT)
% Makes one figure per channel. Each row is a unique combination of the dot
% density and dx. On the left are the polar plots with responses to translational,
% dipoles, and blank screens. To the right are histograms of the spike
% counts for each orientation.
%
% returns data structure with the added spike count matrix.
%
% April 28, 2020 Brittany Bushnell
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/tuningCurves/%s/polar/',dataT.animal, dataT.array,dataT.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/tuningCurves/%s/polar/',dataT.animal, dataT.array,dataT.eye);
end

cd(figDir)
% go to date specific folder, if it doesn't exist, make it
folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))

folder2 = 'spikeCounts';
mkdir(folder2)
cd(sprintf('%s',folder2))
%% plot prep
[numOris,numDots,numDxs,numCoh,~,orisDeg,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
radOri = deg2rad(orisDeg);

if contains(dataT.animal,'XT')
    dtdxStart =2;
else
    dtdxStart = 1;
end
linNdx = dataT.type == 3;
noiseNdx = dataT.type == 0;
blankNdx = dataT.numDots == 0;
numReps = nan(numDots,numDxs,numOris,96);
% if there were an unequal number of repeats run on different stimuli, take
% them down to the lowest non zero number of repeats - that way there will
% be the same number of repeats for everything.

for ch = 1:96
    for dt = dtdxStart:numDots
        for dx = dtdxStart:numDxs
            for or = 1:numOris
                dtNdx = dataT.numDots == dots(dt);
                dxNdx = dataT.dx == dxs(dx);
                coNdx = dataT.coh == 1;
                orNdx = dataT.rotation == orisDeg(or);
                numReps(dt,dx,or,ch) = size(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,ch),1);
            end
        end
    end
end

numReps(numReps == 0) = [];
spikeCountPerTrial = nan(numDots,numDxs,numOris,96,min(numReps(:)));
%%
for ch = 1:96
    if dataT.goodCh(ch) == 1
        blankMean(1,ch) = mean(mean(squeeze(dataT.bins((blankNdx),5:25,ch))))./0.01;
        
        for dt = dtdxStart:numDots
            for dx = dtdxStart:numDxs
                for or = 1:numOris
                    
                    dtNdx = dataT.numDots == dots(dt);
                    dxNdx = dataT.dx == dxs(dx);
                    coNdx = dataT.coh == 1;
                    orNdx = dataT.rotation == orisDeg(or);
                    
                    stimMean(or,dt,dx,ch) = mean(mean(squeeze(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,ch))))./0.01;
                    noiseMean(dt,dx,ch) = mean(mean(squeeze(dataT.bins((noiseNdx & dtNdx & dxNdx),5:25,ch))))./0.01;
                    stimMeanBaseSub(or,dt,dx,ch) = stimMean(or,dt,dx,ch) - noiseMean(dt,dx,ch);
                    spt = sum(squeeze(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,ch)),2);
                    spikeCountPerTrial(dt,dx,or,ch,:) = spt(1:min(numReps(:)),1); %
                end
            end
        end
        
        % polar plot limits
        orisRad = 0:45:315;
        orisRad(end+1) = 0;
        orisRad = deg2rad(orisRad);
        
        lin = (squeeze(stimMean(:,:,:,ch)));
        noise = (squeeze(noiseMean(:,:,ch)));
        blank = (squeeze(blankMean(ch)));
        
        linMax = max(lin(:));
        noiseMax = max(noise(:));
        maxData = max([linMax,noiseMax,blank]);
        minData = min([linMax,noiseMax,blank]);
        extremes = max([abs(minData),maxData]);
        extremes = extremes+(extremes/2);
        
        minLim = round(extremes*-1);
        maxLim = round(extremes);
        max10 = max(lin(:))+(max(lin(:))/10);
        
        % histogram limits
        tp = (spikeCountPerTrial(:,:,:,ch,:));
        tp(isnan(tp)) = [];
        tp = squeeze(tp);
        maxSpikesCh = max(tp(:))+1;
        
        %% polar plot
        figure(13)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1200 1200])
        set(gcf,'PaperOrientation','Landscape');
        ttl = suptitle({sprintf('%s %s %s Glass orientation tuning curves ch %d',dataT.animal, dataT.eye, dataT.array,ch)});
        ttl.Position = [0.5,-0.025,0];
        axis off
        if contains(dataT.animal,'XT')
            dtdxStart =2;
        else
            dtdxStart = 1;
        end
        rowNdx = 1;
        for dt = dtdxStart:numDots
            for dx = dtdxStart:numDxs
                %axis off
                
                linResps = repmat(squeeze(stimMean(:,dt,dx,ch)),[2,1]);
                linResps(end+1) = linResps(1);
                noiseResp = (squeeze(noiseMean(dt,dx,ch)));
                noiseVect = repmat(noiseResp,[1,length(orisRad)]);
                blankResp = (squeeze(blankMean(ch)));
                blankVect = repmat(blankResp,[1,length(orisRad)]);
                %         ylabel(sprintf('dt %d dx %.2f',dots(dt),dxs(dx)))
                
                
                %%
                sp = subplot(4,5,rowNdx,polaraxes); %position = [left bottom width height]
                sp.Position(1) = sp.Position(1)-0.02;
                %sp.Position(2) = sp.Position(2)-0.01;
                sp.Position(3) = sp.Position(3)-0.02;
                sp.Position(4) = sp.Position(4)-0.02;
                
                hold on
                l = polarplot(orisRad',linResps,'-o','MarkerSize',4);
                l.LineWidth = 1;
                
                if contains(dataT.eye,'LE')
                    l.Color = [0 0 1 0.8];
                else
                    l.Color = [1 0 0 0.8];
                end
                
                pOri = (dataT.prefOri2thetaNoise(end,dt,dx,ch));
                pOriRad = deg2rad(dataT.prefOri2thetaNoise(end,dt,dx,ch));
                pOri180 = (dataT.prefOri2thetaNoise(end,dt,dx,ch)+180);
                pOriRad180 = deg2rad(dataT.prefOri2thetaNoise(end,dt,dx,ch)+180);
                
                polarplot(pOriRad,max10,'.k','MarkerSize',13);
                polarplot(pOriRad180,max10,'.k','MarkerSize',13);
                
                text(pOriRad-0.1,max10+2,sprintf('%.1f',pOri),'FontSize',9)
                text(pOriRad180-0.1,max10+2,sprintf('%.1f',pOri180),'FontSize',9)
                
                n = polarplot(orisRad,noiseVect,'-o','MarkerSize',4);
                n.Color = [1 0.5 0.1 0.8];
                n.LineWidth = 1;
                
                b = polarplot(orisRad,blankVect,'-o','MarkerSize',4);
                b.Color = [0.5 0.5 0.5 0.8];
                b.LineWidth = 1;
                set(gca,'color','none')
                
                ax = gca;
                if maxLim >0
                ax.RLim  = [0,maxLim];
                ax.RTick = [0,maxLim/2,maxLim];
                end
                set(gca,'ThetaTick',0:45:315)
                
                if dataT.OSI2thetaNoiseSig(end,dt,dx,ch) == 1
                    tO = title(sprintf('OSI: %.3f*',dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)));
                    tO.FontSize = 10;
                else
                    tO = title(sprintf('OSI: %.3f',dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)));
                    tO.FontSize = 9;
                end
                tO.Position(2) = tO.Position(2)-0.01;
                
                
                dtString = sprintf('%d dots',dots(dt));
                text(2*pi-.15,-(max10*3),dtString,'FontSize',12,'FontWeight','Bold','HorizontalAlignment','center'); % because it's on a polar axis, needs to be theta,rho
                dxString = sprintf('dx %.2f',dxs(dx));
                text((2*pi),-(max10*3),dxString,'FontSize',12,'FontWeight','Bold','HorizontalAlignment','center');
                %%
                orisDeg = unique(dataT.rotation);
                ndx = rowNdx + 1;
                for or = 1:numOris
                    orNdx = (dataT.rotation == orisDeg(or));
                    dtNdx = dataT.numDots == dots(dt);
                    dxNdx = dataT.dx == dxs(dx);
                    
                    hp = subplot(4,5,ndx);
                    hp.Position(4) = hp.Position(4)-0.02; % position = [left bottom width height]
                    hp.Position(3) = hp.Position(3)+0.015;
                    hp.Position(2) = hp.Position(2)+0.015;
                    hp.Position(1) = hp.Position(1)+0.02;
                    
                    hold on
                    h = histogram(spikeCountPerTrial(dt,dx,or,ch,:),'binWidth',1,'FaceColor','k','EdgeColor','w');
                    ylim([0 20])
                    xlim([-1 maxSpikesCh])
                    histBins = [h.Values;h.BinEdges(2:end)];
                    a = find(histBins(1,:) == 0); % find the number of bins in the histogram that = 0
                    
                    set(gca,'tickdir','out','Layer','top')
                    
                    if rowNdx == 1
                        title(orisDeg(or))
                    end
                    
                    if ndx>16
                        xlabel('spike count')
                    end
                    
                    if ndx == 2 || ndx == 7 || ndx == 12 || ndx == 17
                        ylabel('# trials')
                    end
                    
                    if length(a)>10 % if there are more than 5 channels with bins that equal zero, then break the x axis
                        breakStart = a(2);
                        breakEnd = a(end-1);
                        breakxaxis2([breakStart breakEnd]);
                    end
                    
                    if max(h.BinEdges)< maxSpikesCh/2
                        breakStart = h.BinEdges(end)+1;
                        breakEnd = maxSpikesCh-1;
                        breakxaxis2([breakStart breakEnd]);
                    end
                    ndx = ndx+1;
                end
                rowNdx = rowNdx+5;
            end
        end
        %%
        
        figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_oriRespsPolar_spikeCount',num2str(ch),'.pdf'];
        print(gcf, figName,'-dpdf','-fillpage')
    end
end
dataT.spikeCountPerTrial = spikeCountPerTrial;