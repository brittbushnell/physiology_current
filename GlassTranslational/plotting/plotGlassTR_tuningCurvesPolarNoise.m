function [] = plotGlassTR_tuningCurvesPolarNoise(dataT)
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

folder2 = 'withNoise';
mkdir(folder2)
cd(sprintf('%s',folder2))
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
                    
                    %for nb = 1:numBoot
                    stimMean(or,dt,dx,ch) = mean(mean(squeeze(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,ch))))./0.01;
                    noiseMean(dt,dx,ch) = mean(mean(squeeze(dataT.bins((noiseNdx & dtNdx & dxNdx),5:25,ch))))./0.01;
                    stimMeanBaseSub(or,dt,dx,ch) = stimMean(or,dt,dx,ch) - noiseMean(dt,dx,ch);
                    % noiseMeanBaseSub(dt,dx,ch) = noiseMean(dt,dx,ch) - blankMean(1,ch);
                    
                end
            end
        end
    end
end
%% figure 13 plot with noise
oris = 0:45:315;
oris(end+1) = 0;
oris = deg2rad(oris);

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
        
        figure(13)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1000 800])
        set(gcf,'PaperOrientation','Landscape');
        
        if contains(dataT.eye,'LE')
            text(-0.14,1.1,'Translational Glass','color',[0 0 1],'FontSize',12,'FontWeight','bold');
        else
            text(-0.14,1.1,'Translational Glass','color',[1 0 0],'FontSize',12,'FontWeight','bold');
        end
        text(-0.14,1.08,'Random dipole','color',[1 0.5 0.1],'FontSize',12,'FontWeight','bold');
        text(-0.14,1.06,'Blank','color',[0.5 0.5 0.5],'FontSize',12,'FontWeight','bold');
        
        if numDots == 3
            text(-0.1,0.89,'100 dots','FontSize',12,'FontWeight','bold');
            text(-0.1,0.5,'200 dots','FontSize',12,'FontWeight','bold');
            text(-0.1,0.1,'400 dots','FontSize',12,'FontWeight','bold');
            
            text(0.1,-0.06,'dx 0.01','FontSize',12,'FontWeight','bold');
            text(0.47,-0.06,'dx 0.02','FontSize',12,'FontWeight','bold');
            text(0.83,-0.06,'dx 0.04','FontSize',12,'FontWeight','bold');
        else
            text(-0.1,0.83,'200 dots','FontSize',12,'FontWeight','bold');
            text(-0.1,0.23,'400 dots','FontSize',12,'FontWeight','bold');
            
            text(0.19,-0.06,'dx 0.02','FontSize',12,'FontWeight','bold');
            text(0.76,-0.06,'dx 0.04','FontSize',12,'FontWeight','bold');
        end
        axis off
        
        ndx = 1;
        for dt = 1:numDots
            for dx = 1:numDxs
                
                linResps = repmat(squeeze(stimMean(:,dt,dx,ch)),[2,1]);
                linResps(end+1) = linResps(1);
                noiseResp = (squeeze(noiseMean(dt,dx,ch)));
                noiseVect = repmat(noiseResp,[1,length(oris)]);
                blankResp = (squeeze(blankMean(ch)));
                blankVect = repmat(blankResp,[1,length(oris)]);
                
                if numDots == 2
                    subplot(2,2,ndx,polaraxes);
                else
                    subplot(3,3,ndx,polaraxes);
                end
                hold on
                l = polarplot(oris',linResps,'-o');
                l.LineWidth = 1.2;
                if contains(dataT.eye,'LE')
                    l.Color = [0 0 1 0.8];
                else
                    l.Color = [1 0 0 0.8];
                end
                pOri = (dataT.prefOri2thetaNoise(end,dt,dx,ch)); %mod(rad2deg(dataT.prefOri2thetaNoise(end,dt,dx,ch)),180);
                pOriRad = rad2deg(dataT.prefOri2thetaNoise(end,dt,dx,ch));%mod(dataT.prefOri2thetaNoise(end,dt,dx,ch),180);
                polarplot(pOriRad,max10,'.k','MarkerSize',15);
                text(pOriRad,max10+2,sprintf('%.1f',pOri),'FontWeight','bold','FontAngle','italic','FontSize',11)
                
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
                    title(sprintf('OSI: %.3f *',dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)))
                else
                    title(sprintf('OSI: %.3f',dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)))
                end
                ndx = ndx+1;
            end
        end
        
        ttl = suptitle({sprintf('%s %s %s Glass orientation tuning curves ch %d',dataT.animal, dataT.eye, dataT.array,ch);...
            sprintf('%s run %s',dataT.date,dataT.runNum)});
        ttl.Position = [0.5,-0.025,0];
        
        figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_oriRespsPolar_noise_',num2str(ch),'.pdf'];
        print(gcf, figName,'-dpdf','-fillpage')
    end
end
%%
% cd ../
% folder2 = 'noNoise';
% mkdir(folder2)
% cd(sprintf('%s',folder2))
% %% figure 14 plot without noise
% oris = 0:45:315;
% oris(end+1) = 0;
% oris = deg2rad(oris);
% 
% for ch = 1:96
%     if dataT.goodCh(ch) == 1
%         lin = (squeeze(dataT.linStimMeans(:,end,:,:,ch)));
%         noise = (squeeze(dataT.noiseMeans(:,:,ch))); % keep this here so the scales are the same across figures
%         blank = (squeeze(dataT.blankMeans(ch)));
%         
%         linMax = max(lin(:));
%         noiseMax = max(noise(:));
%         maxData = max([linMax,noiseMax,blank]);
%         minData = min([linMax,noiseMax,blank]);
%         extremes = max([abs(minData),maxData]);
%         extremes = extremes+(extremes/2);
%         
%         minLim = round(extremes*-1);
%         maxLim = round(extremes);
%         max10 = max(lin(:))+(max(lin(:))/10);
%         
%         figure(14)
%         clf
%         pos = get(gcf,'Position');
%         set(gcf,'Position',[pos(1) pos(2) 1000 800])
%         set(gcf,'PaperOrientation','Landscape');
%         if contains(dataT.eye,'LE')
%             text(-0.14,1.1,'Translational Glass','color',[0 0 1],'FontSize',12,'FontWeight','bold');
%         else
%             text(-0.14,1.1,'Translational Glass','color',[1 0 0],'FontSize',12,'FontWeight','bold');
%         end
%         text(-0.14,1.06,'Blank','color',[0.5 0.5 0.5],'FontSize',12,'FontWeight','bold');
%         
%         if numDots == 3
%             text(-0.1,0.89,'100 dots','FontSize',12,'FontWeight','bold');
%             text(-0.1,0.5,'200 dots','FontSize',12,'FontWeight','bold');
%             text(-0.1,0.1,'400 dots','FontSize',12,'FontWeight','bold');
%             
%             text(0.1,-0.06,'dx 0.01','FontSize',12,'FontWeight','bold');
%             text(0.47,-0.06,'dx 0.02','FontSize',12,'FontWeight','bold');
%             text(0.83,-0.06,'dx 0.04','FontSize',12,'FontWeight','bold');
%         else
%             text(-0.1,0.83,'200 dots','FontSize',12,'FontWeight','bold');
%             text(-0.1,0.23,'400 dots','FontSize',12,'FontWeight','bold');
%             
%             text(0.19,-0.06,'dx 0.02','FontSize',12,'FontWeight','bold');
%             text(0.76,-0.06,'dx 0.04','FontSize',12,'FontWeight','bold');
%         end
%         
%         axis off
%         
%         ndx = 1;
%         for dt = 1:numDots
%             for dx = 1:numDxs
%                 linResps = repmat(squeeze(stimMean(:,dt,dx,ch)),[2,1]);
%                 linResps(end+1) = linResps(1);
%                 blankResp = (squeeze(blankMean(ch)));
%                 blankVect = repmat(blankResp,[1,length(oris)]);
%                 
%                 
%                 if numDots == 2
%                     subplot(2,2,ndx,polaraxes);
%                 else
%                     subplot(3,3,ndx,polaraxes);
%                 end
%                 hold on
%                 
%                 l = polarplot(oris',linResps,'-o');
%                 l.LineWidth = 1.2;
%                 if contains(dataT.eye,'LE')
%                     l.Color = [0 0 1 0.8];
%                 else
%                     l.Color = [1 0 0 0.8];
%                 end
%                 
%                 if dataT.prefOri2thetaNoiseSig(end,dt,dx,ch) == 1
%                     polarplot(dataT.prefOri2thetaNoise(end,dt,dx,ch),max10,'*k');
%                     pOri = mod(rad2deg(dataT.prefOri2thetaNoise(end,dt,dx,ch)),360);
%                     text(dataT.prefOri2thetaNoise(end,dt,dx,ch),max10+3,sprintf('%.1f',pOri),'FontWeight','bold','FontAngle','italic','FontSize',11)
%                 end
%                 
%                 b = polarplot(oris,blankVect,'-og');
%                 b.Color = [0.5 0.5 0.5 0.8];
%                 b.LineWidth = 1.2;
%                 set(gca,'color','none')
%                 
%                 ax = gca;
%                 ax.RLim   = [0,maxLim];
%                 ax.RTick = [0,maxLim/2,maxLim];
%                 set(gca,'ThetaTick',0:45:315)
%                 
%                 if dataT.OSI2thetaNoiseSig(end,dt,dx,ch) == 1
%                     title(sprintf('OSI: %.3f *',dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)))
%                 else
%                     title(sprintf('OSI: %.3f',dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)))
%                 end
%                 ndx = ndx+1;
%             end
%         end
%         
%         ttl = suptitle({sprintf('%s %s %s Glass orientation tuning curves ch %d',dataT.animal, dataT.eye, dataT.array,ch);...
%             sprintf('%s run %s',dataT.date,dataT.runNum)});
%         ttl.Position = [0.5,-0.025,0];
%         
%         figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_oriRespsPolar_',num2str(ch),'.pdf'];
%         print(gcf, figName,'-dpdf','-fillpage')
%     end
% end
%%
cd ../
folder2 = 'baseSub';
mkdir(folder2)
cd(sprintf('%s',folder2))
%% figure 15 plot noise subtracted stim and noise
oris = 0:45:315;
oris(end+1) = 0;
oris = deg2rad(oris);
clear lin
clear noise

for ch = 1:96
    if dataT.goodCh(ch) == 1
        lin = (squeeze(stimMeanBaseSub(:,:,:,ch)));
        noise = (squeeze(noiseMean(:,:,ch)));
        blank = (squeeze(blankMean(ch)));
        
        linMax = max(lin(:));
        noiseMax = max(noise(:));
        maxData = max([linMax,noiseMax,blank]);
        minData = min([linMax,noiseMax,blank]);
        extremes = max([abs(minData),maxData]);
        extremes = extremes+(extremes/2);
        
        
        maxLim = round(extremes);
        max10 = max(lin(:))+(max(lin(:))/20);
        
        figure(15)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1000 800])
        set(gcf,'PaperOrientation','Landscape');
        
        if contains(dataT.eye,'LE')
            text(-0.14,1.1,'Translational Glass','color',[0 0 1],'FontSize',12,'FontWeight','bold');
        else
            text(-0.14,1.1,'Translational Glass','color',[1 0 0],'FontSize',12,'FontWeight','bold');
        end
        text(-0.14,1.08,'Random dipole','color',[1 0.5 0.1],'FontSize',12,'FontWeight','bold');
        text(-0.14,1.06,'Blank','color',[0.5 0.5 0.5],'FontSize',12,'FontWeight','bold');
        
        if numDots == 3
            text(-0.1,0.89,'100 dots','FontSize',12,'FontWeight','bold');
            text(-0.1,0.5,'200 dots','FontSize',12,'FontWeight','bold');
            text(-0.1,0.1,'400 dots','FontSize',12,'FontWeight','bold');
            
            text(0.1,-0.06,'dx 0.01','FontSize',12,'FontWeight','bold');
            text(0.47,-0.06,'dx 0.02','FontSize',12,'FontWeight','bold');
            text(0.83,-0.06,'dx 0.04','FontSize',12,'FontWeight','bold');
        else
            text(-0.1,0.83,'200 dots','FontSize',12,'FontWeight','bold');
            text(-0.1,0.23,'400 dots','FontSize',12,'FontWeight','bold');
            
            text(0.19,-0.06,'dx 0.02','FontSize',12,'FontWeight','bold');
            text(0.76,-0.06,'dx 0.04','FontSize',12,'FontWeight','bold');
        end
        axis off
        
        ndx = 1;
        for dt = 1:numDots
            for dx = 1:numDxs
                
                linResps = repmat(squeeze(stimMeanBaseSub(:,dt,dx,ch)),[2,1]);
                linResps(end+1) = linResps(1);
                
                noiseResp = (squeeze(noiseMean(dt,dx,ch)));
                noiseVect = repmat(noiseResp,[1,length(oris)]);
                blankResp = (squeeze(blankMean(ch)));
                blankVect = repmat(blankResp,[1,length(oris)]);
                
                if numDots == 2
                    subplot(2,2,ndx,polaraxes);
                else
                    subplot(3,3,ndx,polaraxes);
                end
                hold on
                l = polarplot(oris',linResps,'-o');
                l.LineWidth = 1.2;
                if contains(dataT.eye,'LE')
                    l.Color = [0 0 1 0.8];
                else
                    l.Color = [1 0 0 0.8];
                end
                pOri = mod(rad2deg(dataT.prefOri2thetaNoise(end,dt,dx,ch)),180);
                polarplot(pOri,max10,'.k','MarkerSize',15);
                text(pOri,max10+2,sprintf('%.1f',pOri),'FontWeight','bold','FontAngle','italic','FontSize',11)
                
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
                set(gca,'ThetaTick',0:45:315,'color','none')
                
                if dataT.OSI2thetaNoiseSig(end,dt,dx,ch) == 1
                    title(sprintf('OSI: %.3f *',dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)))
                else
                    title(sprintf('OSI: %.3f',dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch)))
                end
                ndx = ndx+1;
            end
        end
        
        ttl = suptitle({sprintf('%s %s %s noise subtracted Glass orientation tuning curves ch %d',dataT.animal, dataT.eye, dataT.array,ch);...
            sprintf('%s run %s',dataT.date,dataT.runNum)});
        ttl.Position = [0.5,-0.025,0];
        
        figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_oriRespsPolar_baseSub_',num2str(ch),'.pdf'];
        print(gcf, figName,'-dpdf','-fillpage')
    end
end