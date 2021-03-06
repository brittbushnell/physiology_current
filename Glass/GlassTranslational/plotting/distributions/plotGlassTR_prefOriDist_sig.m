function [] = plotGlassTR_prefOriDist_sig(data)

[numOris,numDots,numDxs,numCoh,numSamp,oris,dots,dxs,coherences,samples] = getGlassTRParameters(data.RE);
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/distributions/prefOri/',data.RE.animal, data.RE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/distributions/prefOri/',data.RE.animal, data.RE.array);
end

cd(figDir)
% go to date specific folder, if it doesn't exist, make it
folder = data.RE.date2;
mkdir(folder)
cd(sprintf('%s',folder))

folder = 'sigResps';
mkdir(folder)
cd(sprintf('%s',folder))
%%
binocCh = (data.RE.goodCh == 1 & data.LE.goodCh == 1);
%% RE 360 fig 7
figure%(7)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1200])
set(gcf,'PaperOrientation','Landscape');

tmp = squeeze(data.RE.prefOri2thetaNoise(end,:,:,data.RE.goodCh == 1));
SImax = max(tmp(:));
SImax = SImax+0.05;
SImin = -1*SImax;

if numDots == 3
    text(-0.1,0.89,'100 dots','FontSize',13,'FontWeight','bold');
    text(-0.1,0.5,'200 dots','FontSize',13,'FontWeight','bold');
    text(-0.1,0.1,'400 dots','FontSize',13,'FontWeight','bold');
    
    text(0.1,-0.06,'dx 0.01','FontSize',13,'FontWeight','bold');
    text(0.47,-0.06,'dx 0.02','FontSize',13,'FontWeight','bold');
    text(0.83,-0.06,'dx 0.03','FontSize',13,'FontWeight','bold');
else
    text(-0.12,0.82,'200 dots','FontSize',12,'FontWeight','bold');
    text(-0.12,0.22,'400 dots','FontSize',12,'FontWeight','bold');
    
    text(0.19,1.04,'dx 0.02','FontSize',12,'FontWeight','bold');
    text(0.76,1.04,'dx 0.03','FontSize',12,'FontWeight','bold');
end
axis off
ndx = 1;
for dt = 1:numDots
    for dx = 1:numDxs
        rOris = squeeze(data.RE.prefOri2thetaNoise(end,dt,dx,data.RE.goodCh == 1));
        rSigs = squeeze(data.RE.OSI2thetaNoiseSig(end,dt,dx,data.RE.goodCh == 1));
        
        SIR = deg2rad(rOris(rSigs == 1));
        
        cMean = circ_mean(SIR);
        if numDots == 2
            subplot(2,2,ndx,polaraxes);
        else
            subplot(3,3,ndx,polaraxes);
        end
        hold on
        
        polarhistogram(SIR,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
        polarplot(cMean,0.35,'<w','MarkerFaceColor','r','MarkerSize',8)
        polarplot([1.57 0 4.71],[1.5 0 1.5],'k-','LineWidth',.85)
        polarhistogram(SIR+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
        %         polarplot(nanmedian(SIR)+pi,0.35,'>w','MarkerFaceColor','r','MarkerSize',8)
        
        text(cMean+0.03,0.4,sprintf('circular mean %.2f',rad2deg(cMean)),'FontSize',12)
        %      text(pi+nanmedian(SIR)+0.03,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR))+pi),'FontSize',11)
        ax = gca;
        ax.RLim   = [0,0.5];
        ndx = ndx+1;
        
    end
end
suptitle({sprintf('%s %s %s distribution of preferred orientations by parameter 100%% coherence',data.RE.animal, data.RE.eye, data.RE.array);...
    sprintf('%s run %s',data.RE.date,data.RE.runNum)});

figName = [data.RE.animal,'_',data.RE.array,'_RE_prefOriDistribition_byParam_sigChs','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% LE 360 fig 8
figure(8)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1200])
set(gcf,'PaperOrientation','Landscape');

tmp = squeeze(data.LE.prefOri2thetaNoise(end,:,:,data.LE.goodCh == 1));
SImax = max(tmp(:));
SImax = SImax+0.05;
SImin = -1*SImax;

if numDots == 3
    text(-0.1,0.89,'100 dots','FontSize',13,'FontWeight','bold');
    text(-0.1,0.5,'200 dots','FontSize',13,'FontWeight','bold');
    text(-0.1,0.1,'400 dots','FontSize',13,'FontWeight','bold');
    
    text(0.1,-0.06,'dx 0.01','FontSize',13,'FontWeight','bold');
    text(0.47,-0.06,'dx 0.02','FontSize',13,'FontWeight','bold');
    text(0.83,-0.06,'dx 0.04','FontSize',13,'FontWeight','bold');
else
    text(-0.12,0.82,'200 dots','FontSize',12,'FontWeight','bold');
    text(-0.12,0.22,'400 dots','FontSize',12,'FontWeight','bold');
    
    text(0.19,1.04,'dx 0.02','FontSize',12,'FontWeight','bold');
    text(0.76,1.04,'dx 0.04','FontSize',12,'FontWeight','bold');
end
axis off
ndx = 1;
for dt = 1:numDots
    for dx = 1:numDxs
        lOris = squeeze(data.LE.prefOri2thetaNoise(end,dt,dx,data.LE.goodCh == 1));
        lSigs = squeeze(data.LE.OSI2thetaNoiseSig(end,dt,dx,data.LE.goodCh == 1));
        
        SIL = deg2rad(lOris(lSigs == 1));
        
        if numDots == 2
            subplot(2,2,ndx,polaraxes);
        else
            subplot(3,3,ndx,polaraxes);
        end
        hold on
        
        polarhistogram(SIL,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        polarhistogram(SIL+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        polarplot(nanmedian(SIL),0.35,'<w','MarkerFaceColor','b','MarkerSize',8)
        %         polarplot(nanmedian(SIR)+pi,0.35,'>w','MarkerFaceColor','b','MarkerSize',8)
        polarplot([1.57 0 4.71],[1.5 0 1.5],'k-','LineWidth',.85)
        
        text(nanmedian(SIL)+0.03,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIL))),'FontSize',11)
        %         text(pi+nanmedian(SIR)+0.03,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR)+pi)),'FontSize',11)
        %
        ax = gca;
        ax.RLim   = [0,0.5];
        ndx = ndx+1;
        
    end
end
suptitle({sprintf('%s %s %s distribution of preferred orientations by parameter 100%% coherence',data.LE.animal, data.LE.eye, data.LE.array);...
    sprintf('%s run %s',data.LE.date,data.LE.runNum)});

figName = [data.LE.animal,'_',data.LE.array,'_LE_prefOriDistribition_byParam_sigChs','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% BE 360 fig 9
% figure (9)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 800 500])
% set(gcf,'PaperOrientation','Landscape');
% 
% rOris = squeeze(data.RE.prefOri2thetaNoise(end,:,:,data.RE.goodCh == 1));
% rSigs = squeeze(data.RE.OSI2thetaNoiseSig(end,:,:,data.RE.goodCh == 1));
% 
% SIR = rOris(rSigs == 1);
% SIR2 = SIR;
% SIR2(SIR2<0) = SIR2(SIR2<0)+180;
% SIR2(isnan(SIR2)) = [];
% cirMuR = circ_mean(deg2rad(SIR(:)));
% cirMuR2 = cirMuR+pi;
% 
% lOris = squeeze(data.LE.prefOri2thetaNoise(end,:,:,data.LE.goodCh == 1));
% lSigs = squeeze(data.LE.OSI2thetaNoiseSig(end,:,:,data.LE.goodCh == 1));
% 
% SIL = lOris(lSigs == 1);
% SIL2 = SIL;
% SIL2(SIL2<0) = SIL2(SIL2<0)+180;
% SIL2(isnan(SIL2)) = [];
% cirMu = circ_mean(deg2rad(SIL(:)));
% cirMu2 = cirMu+pi;
%     
% subplot(1,2,1,polaraxes)
% hold on
% 
% [bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
% bins2 = sqrt(bins)./sum(sqrt(bins));
% polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
% 
% 
% [bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
% bins2 = sqrt(bins)./sum(sqrt(bins));
% polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
% polarplot([cirMu 0 cirMu2],[1.5 0 1.5],'b-','LineWidth',.85)
% polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])
% 
% ax = gca;
% ax.RLim   = [0,0.3];
% text(cirMu+0.2,0.25,sprintf('mean: %.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','center')
% text(cirMu2+0.2,0.25,sprintf('mean: %.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','center')
% 
% set(gca,'FontSize',12,'FontAngle','italic')
% if contains(data.LE.animal,'XT')
%     title(sprintf('%s LE',data.RE.animal))
% else
%     title(sprintf('%s FE',data.RE.animal))
% end
% 
% 
% 
% subplot(1,2,2,polaraxes)
% hold on
% 
% [bins,edges] = histcounts(deg2rad(SIR2),0:pi/6:pi);
% bins2 = sqrt(bins)./sum(sqrt(bins));
% polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
% 
% 
% [bins,edges] = histcounts(deg2rad(SIR2)+pi,[0:pi/6:pi]+pi);
% bins2 = sqrt(bins)./sum(sqrt(bins));
% polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
% polarplot([cirMuR 0 cirMuR2],[1.5 0 1.5],'r-','LineWidth',.85)
% polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])
% 
% ax = gca;
% ax.RLim   = [0,0.3];
% text(cirMuR+0.2,0.25,sprintf('mean: %.1f%c',rad2deg(cirMuR),char(176)),'FontSize',11,'HorizontalAlignment','center')
% text(cirMuR2+0.2,0.25,sprintf('mean: %.1f%c',rad2deg(cirMuR2),char(176)),'FontSize',11,'HorizontalAlignment','center')
% 
% set(gca,'FontSize',12,'FontAngle','italic')
% if contains(data.RE.animal,'XT')
%     title(sprintf('%s RE',data.RE.animal))
% else
%     title(sprintf('%s AE',data.RE.animal))
% end
% suptitle({sprintf('%s %s %s distribution of preferred orientations 100%% coherence',data.LE.animal, data.LE.eye, data.LE.array);...
%     'Channels with significant tuning only'});
% 
% figName = [data.RE.animal,'_',data.RE.array,'_BE_prefOriDistribition_sigChs_area','.pdf'];
% %print(gcf, figName,'-dpdf','-fillpage')
