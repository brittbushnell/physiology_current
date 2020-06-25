function [] = plotGlassTR_tuningCurvesPolarArray(dataT)
location = determineComputer;
[numOris,numDots,numDxs,~,~,oris,dots,dxs,~,~] = getGlassTRParameters(dataT);
%% plot data computed with 2theta
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
%% get responses
linNdx = dataT.type == 3;
noiseNdx = dataT.type == 0;
blankNdx = dataT.numDots == 0;
for ch = 1:96
    if dataT.goodCh(ch) == 1
        blankMean(1,ch) = mean(mean(squeeze(dataT.bins((blankNdx),5:25,ch))))./0.01;
        for or = 1:numOris
            for dt = 1:numDots
                for dx = 1:numDxs
                    dtNdx = dataT.numDots == dots(dt);
                    dxNdx = dataT.dx == dxs(dx);
                    coNdx = dataT.coh == 1;
                    orNdx = dataT.rotation == oris(or);
                    
                    stimMean(or,dt,dx,ch) = mean(mean(squeeze(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,ch))))./0.01;
                    noiseMean(dt,dx,ch) = mean(mean(squeeze(dataT.bins((noiseNdx & dtNdx & dxNdx),5:25,ch))))./0.01;
                    stimMeanBaseSub(or,dt,dx,ch) = stimMean(or,dt,dx,ch) - noiseMean(dt,dx,ch);
                    
                end
            end
        end
    end
end

%%
oris = 0:45:315;
oris(end+1) = 0;
oris = deg2rad(oris);

for dt = 1:numDots
    for dx = 1:numDxs
        figure(14)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1000 800])
        set(gcf,'PaperOrientation','Landscape');
        
        for ch = 1:96
            if dataT.goodCh(ch) == 1
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
                
                linResps = repmat(squeeze(stimMean(:,dt,dx,ch)),[2,1]);
                linResps(end+1) = linResps(1);
                noiseResp = (squeeze(noiseMean(dt,dx,ch)));
                noiseVect = repmat(noiseResp,[1,length(oris)]);
                blankResp = (squeeze(blankMean(ch)));
                blankVect = repmat(blankResp,[1,length(oris)]);
                
                subplot(dataT.amap,10,10,ch)                
                hold on
                l = polarplot(oris',linResps,'-o');
                l.LineWidth = 1.2;
                
                if contains(dataT.eye,'LE')
                    l.Color = [0 0 1 0.8];
                else
                    l.Color = [1 0 0 0.8];
                end
                
                pOri = (dataT.prefOri2thetaNoise(end,dt,dx,ch));
                pOriRad = deg2rad(dataT.prefOri2thetaNoise(end,dt,dx,ch));
                pOri180 = (pOri+180);
                pOriRad180 = deg2rad(pOri+180);
                
                polarplot([pOriRad 0 pOriRad180],[max10 0 max10],'k--','LineWidth',1)
                
                %                if dataT.prefOri2thetaNoiseSig(end,dt,dx,ch) == 1
                %                    text(pOriRad,max10+2,sprintf('%.1f *',pOri),'FontWeight','bold','FontAngle','italic','FontSize',11)
                %                 else
                text(pOriRad,max10+2,sprintf('%.1f',pOri),'FontSize',10)
                text(pOriRad180,max10+2,sprintf('%.1f',pOri180),'FontSize',10)
                %                 end
                
                n = polarplot(oris,noiseVect,'-o');
                n.Color = [1 0.5 0.1 0.8];
                n.LineWidth = 1.2;
                
                b = polarplot(oris,blankVect,'-o');
                b.Color = [0.5 0.5 0.5 0.8];
                b.LineWidth = 1.2;
                set(gca,'color','none')
                
                ax = gca;
                ax.RLim   = [0,maxLim];
                ax.RTick = [0,maxLim/2,maxLim];
                set(gca,'ThetaTick',0:45:315)
                
                if dataT.OSI2thetaNoiseSig(end,dt,dx,ch) == 1
                    title(sprintf('ch %d OSI: %.3f *',ch,dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)))
                else
                    title(sprintf('ch %d OSI: %.3f',ch,dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)))
                end
                
            end
        end
        
        ttl = suptitle({sprintf('%s %s %s Glass orientation tuning curves',dataT.animal, dataT.eye, dataT.array);...
            sprintf('%s run %s',dataT.date,dataT.runNum)});
        ttl.Position = [0.5,-0.025,0];
        
        figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_oriRespsPolar_noise_allCh','.pdf'];
        print(gcf, figName,'-dpdf','-fillpage')
    end
end
