function [] = plotGlassTR_prefOriDist(data)

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
%% RE fig 6
figure(6)
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
        
        SIR = deg2rad(squeeze(data.RE.prefOri2thetaNoise(end,dt,dx,:)));
        
        if numDots == 2
            subplot(2,2,ndx,polaraxes);
        else
            subplot(3,3,ndx,polaraxes);
        end
        hold on
        
        polarhistogram(SIR,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
        polarplot(nanmedian(SIR),0.35,'<w','MarkerFaceColor','r','MarkerSize',8)
        
        text(nanmedian(SIR)+0.03,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR))),'FontSize',11)

        ax = gca;
        ax.RLim   = [0,0.5];
        ndx = ndx+1;
        
    end
end
suptitle({sprintf('%s %s %s distribution of preferred orientations by parameter 100%% coherence',data.RE.animal, data.RE.eye, data.RE.array);...
    sprintf('%s run %s',data.RE.date,data.RE.runNum)});

figName = [data.RE.animal,'_',data.RE.array,'_RE_prefOriDistribition_byParam','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% RE 360 fig 7
figure(7)
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
        
        SIR = deg2rad(squeeze(data.RE.prefOri2thetaNoise(end,dt,dx,:)));
        
        if numDots == 2
            subplot(2,2,ndx,polaraxes);
        else
            subplot(3,3,ndx,polaraxes);
        end
        hold on
        
        polarhistogram(SIR,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
        polarplot(nanmedian(SIR),0.35,'<w','MarkerFaceColor','r','MarkerSize',8)
        polarplot([1.57 0 4.71],[1.5 0 1.5],'k-','LineWidth',.75)
        polarhistogram(SIR+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
        polarplot(nanmedian(SIR)+pi,0.35,'>w','MarkerFaceColor','r','MarkerSize',8)
        
        text(nanmedian(SIR)+0.03,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR))),'FontSize',11)
        text(pi+nanmedian(SIR)+0.03,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR))+pi),'FontSize',11)
        ax = gca;
        ax.RLim   = [0,0.5];
        ndx = ndx+1;
        
    end
end
suptitle({sprintf('%s %s %s distribution of preferred orientations by parameter 100%% coherence',data.RE.animal, data.RE.eye, data.RE.array);...
    sprintf('%s run %s',data.RE.date,data.RE.runNum)});

figName = [data.RE.animal,'_',data.RE.array,'_RE_prefOriDistribition_byParam360','.pdf'];
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
        SIR = deg2rad(squeeze(data.LE.prefOri2thetaNoise(end,dt,dx,:)));
        
        if numDots == 2
            subplot(2,2,ndx,polaraxes);
        else
            subplot(3,3,ndx,polaraxes);
        end
        hold on
        
        polarhistogram(SIR,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        polarhistogram(SIR+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        polarplot(nanmedian(SIR),0.35,'<w','MarkerFaceColor','b','MarkerSize',8)
        polarplot(nanmedian(SIR)+pi,0.35,'>w','MarkerFaceColor','b','MarkerSize',8)
        polarplot([1.57 0 4.71],[1.5 0 1.5],'k-','LineWidth',.75)
        
        text(nanmedian(SIR)+0.03,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR))),'FontSize',11)
        text(pi+nanmedian(SIR)+0.03,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR)+pi)),'FontSize',11)
        
        ax = gca;
        ax.RLim   = [0,0.5];
        ndx = ndx+1;
        
    end
end
suptitle({sprintf('%s %s %s distribution of preferred orientations by parameter 100%% coherence',data.LE.animal, data.LE.eye, data.LE.array);...
    sprintf('%s run %s',data.LE.date,data.LE.runNum)});

figName = [data.LE.animal,'_',data.LE.array,'_LE_prefOriDistribition_byParam360','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% LE fig 9
figure(9)
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
        SIR = deg2rad(squeeze(data.LE.prefOri2thetaNoise(end,dt,dx,:)));
        
        if numDots == 2
            subplot(2,2,ndx,polaraxes);
        else
            subplot(3,3,ndx,polaraxes);
        end
        hold on
        
        polarhistogram(SIR,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        polarplot(nanmedian(SIR),0.35,'<w','MarkerFaceColor','b','MarkerSize',8)
        
        text(nanmedian(SIR)+0.03,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR))),'FontSize',11)

        ax = gca;
        ax.RLim   = [0,0.5];
        ndx = ndx+1;
        
    end
end
suptitle({sprintf('%s %s %s distribution of preferred orientations by parameter 100%% coherence',data.LE.animal, data.LE.eye, data.LE.array);...
    sprintf('%s run %s',data.LE.date,data.LE.runNum)});

figName = [data.LE.animal,'_',data.LE.array,'_LE_prefOriDistribition_byParam','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% BE fig 10
figure (10)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 500])
set(gcf,'PaperOrientation','Landscape');

SIR = deg2rad(squeeze(data.RE.prefOri2thetaNoise(end,:,:,:)));
SIR = reshape(SIR,[1,numel(SIR)]);
SIR(isnan(SIR)) = [];

SIL = deg2rad(squeeze(data.LE.prefOri2thetaNoise(end,:,:,:)));
SIL = reshape(SIL,[1,numel(SIL)]);
SIL(isnan(SIL)) = [];

subplot(1,2,1,polaraxes)
hold on

polarhistogram(SIL,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot(nanmedian(SIL),0.35,'<w','MarkerFaceColor','b','MarkerSize',8)
ax = gca;
ax.RLim   = [0,0.5];
text(nanmedian(SIL)+0.02,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIL))),'FontSize',11)

title(sprintf('%s LE',data.LE.animal))

subplot(1,2,2,polaraxes)
hold on

polarhistogram(SIR,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot(nanmedian(SIR),0.35,'<w','MarkerFaceColor','r','MarkerSize',8)
ax = gca;
ax.RLim   = [0,0.5];
text(nanmedian(SIR)+0.02,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR))),'FontSize',11)

title(sprintf('%s RE',data.RE.animal))

suptitle({sprintf('%s %s distribtion of preferred orientations across all stimuli',data.RE.animal, data.RE.array);...
    sprintf('%s run %s',data.RE.date,data.RE.runNum)});

figName = [data.RE.animal,'_',data.RE.array,'_BE_prefOriDistribition','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% BE 360 fig 11
figure (11)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 500])
set(gcf,'PaperOrientation','Landscape');

SIR = deg2rad(squeeze(data.RE.prefOri2thetaNoise(end,:,:,:)));
SIR = reshape(SIR,[1,numel(SIR)]);
SIR(isnan(SIR)) = [];

SIL = deg2rad(squeeze(data.LE.prefOri2thetaNoise(end,:,:,:)));
SIL = reshape(SIL,[1,numel(SIL)]);
SIL(isnan(SIL)) = [];

subplot(1,2,1,polaraxes)
hold on

polarhistogram(SIL,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot(nanmedian(SIL),0.35,'<w','MarkerFaceColor','b','MarkerSize',8)
polarhistogram(SIL+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot(nanmedian(SIL)+pi,0.35,'>w','MarkerFaceColor','b','MarkerSize',8)
polarplot([1.57 0 4.71],[1.5 0 1.5],'k-','LineWidth',.75)

ax = gca;
ax.RLim   = [0,0.5];
text(nanmedian(SIL)+0.02,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIL))),'FontSize',11)
text(pi+nanmedian(SIL)-0.05,0.43,sprintf('median %.2f',rad2deg(nanmedian(SIL)+pi)),'FontSize',11)
title(sprintf('%s LE',data.LE.animal))

subplot(1,2,2,polaraxes)
hold on

polarhistogram(SIR,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot(nanmedian(SIR),0.35,'<w','MarkerFaceColor','r','MarkerSize',8)

polarhistogram(SIR+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot(nanmedian(SIR)+pi,0.35,'>w','MarkerFaceColor','r','MarkerSize',8)
polarplot([1.57 0 4.71],[1.5 0 1.5],'k-','LineWidth',.75)

ax = gca;
ax.RLim   = [0,0.5];
text(nanmedian(SIR)+0.02,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR))),'FontSize',11)
text(pi+nanmedian(SIR)+0.02,0.4,sprintf('median %.2f',rad2deg(nanmedian(SIR)+pi)),'FontSize',11)

title(sprintf('%s RE',data.RE.animal))

suptitle({sprintf('%s %s distribtion of preferred orientations across all stimuli',data.RE.animal, data.RE.array);...
    sprintf('%s run %s',data.RE.date,data.RE.runNum)});

figName = [data.RE.animal,'_',data.RE.array,'_BE_prefOriDistribition360','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')