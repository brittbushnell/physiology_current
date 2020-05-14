function [] = plotGlassTR_OSIdist(data)

[numOris,numDots,numDxs,numCoh,numSamp,oris,dots,dxs,coherences,samples] = getGlassTRParameters(data.RE);
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/distributions/OSI/',data.RE.animal, data.RE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/distributions/OSI/',data.RE.animal, data.RE.array);
end

cd(figDir)
% go to date specific folder, if it doesn't exist, make it
folder = data.RE.date2;
mkdir(folder)
cd(sprintf('%s',folder))
%% RE
figure(3)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1200])
set(gcf,'PaperOrientation','Landscape');

tmp = squeeze(data.RE.OriSelectIndex2thetaNoise(end,:,:,data.RE.goodCh == 1));
SImax = max(tmp(:));
SImax = SImax+0.05;
SImin = -1*SImax;

ndx = 1;



for dt = 1:numDots
    for dx = 1:numDxs
        
        SIR = squeeze(data.RE.OriSelectIndex2thetaNoise(end,dt,dx,:));
        
        if numDots == 2
            subplot(2,2,ndx);
        else
            subplot(3,3,ndx);
        end
        hold on
        
        histogram(SIR,SImin:0.02:SImax,'normalization','probability','FaceColor','r','EdgeColor','w')
        plot(nanmean(SIR),0.4,'vw','MarkerFaceColor','r','MarkerSize',7.5)
        
        text(nanmean(SIR)+0.03,0.4,sprintf('mean %.2f',nanmean(SIR)),'FontSize',11)
        set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top')
        
        ylim([0 0.5])
        xlim([-0.05,SImax])
        
        if numDots == 3
            if ndx == 1
                ylabel({'100 dots'; 'probability'})
            elseif ndx == 4
                ylabel({'200 dots'; 'probability'})
            elseif ndx == 7
                ylabel({'400 dots'; 'probability'})
                xlabel({'OSI';'dx 0.01'})
            elseif ndx == 8
                xlabel({'OSI';'dx 0.02'})
            elseif ndx == 9
                xlabel({'OSI';'dx 0.03'})
            end
        end
        
        if numDots == 2
            if ndx == 1
                ylabel('probability','FontSize',12)
            elseif ndx == 3
                ylabel('probability','FontSize',12)
                xlabel('OSI','FontSize',12)
            elseif ndx == 4
                xlabel('OSI','FontSize',12)
            end
        end
        
        ndx = ndx+1;
        
    end
end
suptitle({sprintf('%s %s %s distribution of orientation selectivity indices by parameter 100%% coherence',data.RE.animal, data.RE.eye, data.RE.array);...
    sprintf('%s run %s',data.RE.date,data.RE.runNum)});

if numDots == 3
    text(-0.1,0.89,'100 dots','FontSize',13,'FontWeight','bold');
    text(-0.1,0.5,'200 dots','FontSize',13,'FontWeight','bold');
    text(-0.1,0.1,'400 dots','FontSize',13,'FontWeight','bold');
    
    text(0.1,-0.06,'dx 0.01','FontSize',13,'FontWeight','bold');
    text(0.47,-0.06,'dx 0.02','FontSize',13,'FontWeight','bold');
    text(0.83,-0.06,'dx 0.03','FontSize',13,'FontWeight','bold');
else
    text(-0.9,0.95,'200 dots','FontSize',13,'FontWeight','bold');
    text(-0.9,0.25,'400 dots','FontSize',13,'FontWeight','bold');
    
    text(-0.5,1.22,'dx 0.02','FontSize',13,'FontWeight','bold');
    text(0.17,1.22,'dx 0.03','FontSize',13,'FontWeight','bold');
end

figName = [data.RE.animal,'_',data.RE.array,'_RE_OSIdistribition_byParam','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% LE
figure(4)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1200])
set(gcf,'PaperOrientation','Landscape');

tmp = squeeze(data.LE.OriSelectIndex2thetaNoise(end,:,:,data.LE.goodCh == 1));
SImax = max(tmp(:));
SImax = SImax+0.05;
SImin = -1*SImax;

ndx = 1;

for dt = 1:numDots
    for dx = 1:numDxs
        
        SIR = squeeze(data.LE.OriSelectIndex2thetaNoise(end,dt,dx,:));
        
        if numDots == 2
            subplot(2,2,ndx);
        else
            subplot(3,3,ndx);
        end
        hold on
        
        histogram(SIR,SImin:0.02:SImax,'normalization','probability','FaceColor','b','EdgeColor','w')
        plot(nanmean(SIR),0.4,'vw','MarkerFaceColor','b','MarkerSize',7.5)
        
        text(nanmean(SIR)+0.03,0.4,sprintf('mean %.2f',nanmean(SIR)),'FontSize',11)
        set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top')
        
        ylim([0 0.5])
        xlim([-0.05,SImax])
        
        if numDots == 3
            if ndx == 1
                ylabel({'100 dots'; 'probability'})
            elseif ndx == 4
                ylabel({'200 dots'; 'probability'})
            elseif ndx == 7
                ylabel({'400 dots'; 'probability'})
                xlabel({'OSI';'dx 0.01'})
            elseif ndx == 8
                xlabel({'OSI';'dx 0.02'})
            elseif ndx == 9
                xlabel({'OSI';'dx 0.03'})
            end
        end
        
        if numDots == 2
            if ndx == 1
                ylabel('probability','FontSize',12)
            elseif ndx == 3
                ylabel('probability','FontSize',12)
                xlabel('OSI','FontSize',12)
            elseif ndx == 4
                xlabel('OSI','FontSize',12)
            end
        end
        
        ndx = ndx+1;
        
    end
end
suptitle({sprintf('%s %s %s distribution of orientation selectivity indices by parameter 100%% coherence',data.LE.animal, data.LE.eye, data.LE.array);...
    sprintf('%s run %s',data.LE.date,data.LE.runNum)});

if numDots == 3
    text(-0.1,0.89,'100 dots','FontSize',13,'FontWeight','bold');
    text(-0.1,0.5,'200 dots','FontSize',13,'FontWeight','bold');
    text(-0.1,0.1,'400 dots','FontSize',13,'FontWeight','bold');
    
    text(0.1,-0.06,'dx 0.01','FontSize',13,'FontWeight','bold');
    text(0.47,-0.06,'dx 0.02','FontSize',13,'FontWeight','bold');
    text(0.83,-0.06,'dx 0.03','FontSize',13,'FontWeight','bold');
else
    text(-0.77,0.95,'200 dots','FontSize',13,'FontWeight','bold');
    text(-0.77,0.25,'400 dots','FontSize',13,'FontWeight','bold');
    
    text(-0.5,1.22,'dx 0.02','FontSize',13,'FontWeight','bold');
    text(0.17,1.22,'dx 0.03','FontSize',13,'FontWeight','bold');
end

figName = [data.LE.animal,'_',data.LE.array,'_LE_OSIdistribition_byParam','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure (5)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 500])
set(gcf,'PaperOrientation','Landscape');

SIR = squeeze(data.RE.OriSelectIndex2thetaNoise(end,:,:,:));
SIR = reshape(SIR,[1,numel(SIR)]);
SIR(isnan(SIR)) = [];

SIL = squeeze(data.LE.OriSelectIndex2thetaNoise(end,:,:,:));
SIL = reshape(SIL,[1,numel(SIL)]);
SIL(isnan(SIL)) = [];

xmax = max([SIR, SIL])+0.05;
xmin = xmax*-1;

subplot(2,1,1)
hold on

histogram(SIL,xmin:.01:xmax,'normalization','probability','FaceColor','b','EdgeColor','w')
plot(nanmean(SIL),0.4,'vw','MarkerFaceColor','b','MarkerSize',7.5)

text(nanmean(SIL)+0.02,0.4,sprintf('mean %.2f',nanmean(SIL)),'FontSize',11)
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'box','off','Layer','top')
xlim([-0.05,xmax])
ylim([0 0.5])

ylabel('probability','FontSize',12)
title(sprintf('%s LE',data.LE.animal))

subplot(2,1,2)
hold on

histogram(SIR,xmin:.01:xmax,'normalization','probability','FaceColor','r','EdgeColor','w')
plot(nanmean(SIR),0.4,'vw','MarkerFaceColor','r','MarkerSize',7.5)

text(nanmean(SIR)+0.02,0.4,sprintf('mean %.2f',nanmean(SIR)),'FontSize',11)
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'box','off','Layer','top')
xlim([-0.05,xmax])
ylim([0 0.5])

ylabel('probability','FontSize',12)
xlabel('OSI','FontSize',12)
title(sprintf('%s RE',data.RE.animal))

suptitle({sprintf('%s %s distribtion of OSI across all stimuli',data.RE.animal, data.RE.array);...
    sprintf('%s run %s',data.RE.date,data.RE.runNum)});

figName = [data.RE.animal,'_',data.RE.array,'_BE_OSIdistribition','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')