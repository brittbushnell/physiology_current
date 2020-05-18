function [] = plotGlassTR_OSIdist_binoc(data)

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

folder = 'binocChs';
mkdir(folder)
cd(sprintf('%s',folder))
%% find all channels that respond to both eyes
binocCh = (data.RE.goodCh == 1 & data.LE.goodCh == 1);
%% RE
figure(13)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1200])
set(gcf,'PaperOrientation','Landscape');

tmp = squeeze(data.RE.OriSelectIndex2thetaNoise(end,:,:,binocCh));
SImax = max(tmp(:));
SImax = SImax+0.05;
SImin = -1*SImax;

ndx = 1;

for dt = 1:numDots
    for dx = 1:numDxs
        sig = squeeze(data.RE.OSI2thetaNoiseSig(end,dt,dx,:));
        SIR = squeeze(data.RE.OriSelectIndex2thetaNoise(end,dt,dx,(sig' & binocCh)));
        
        if numDots == 2
            subplot(2,2,ndx);
        else
            subplot(3,3,ndx);
        end
        hold on
        
        histogram(SIR,SImin:0.02:SImax,'normalization','probability','FaceColor','r','EdgeColor','w')
        plot(nanmean(SIR),0.4,'vw','MarkerFaceColor','r','MarkerSize',7.5)
        
        text(nanmean(SIR)+0.03,0.4,sprintf('mean %.2f',nanmean(SIR)),'FontSize',11)
        text(SImax-0.1,0.45,sprintf('n: %d',sum(sig == 1)))
        
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
suptitle({sprintf('%s %s %s distribution of orientation selectivity indices for binocular channels by parameter 100%% coherence',data.RE.animal, data.RE.eye, data.RE.array);...
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

figName = [data.RE.animal,'_',data.RE.array,'_RE_OSIdistribition_byParam_binocChs','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% LE
figure(14)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1200])
set(gcf,'PaperOrientation','Landscape');

tmp = squeeze(data.LE.OriSelectIndex2thetaNoise(end,:,:,binocCh));
SImax = max(tmp(:));
SImax = SImax+0.05;
SImin = -1*SImax;

ndx = 1;

for dt = 1:numDots
    for dx = 1:numDxs
        sig = squeeze(data.LE.OSI2thetaNoiseSig(end,dt,dx,:));
        SIL = squeeze(data.LE.OriSelectIndex2thetaNoise(end,dt,dx,(sig' & binocCh)));
        
        if numDots == 2
            subplot(2,2,ndx);
        else
            subplot(3,3,ndx);
        end
        hold on
        
        histogram(SIL,SImin:0.02:SImax,'normalization','probability','FaceColor','b','EdgeColor','w')
        plot(nanmean(SIL),0.4,'vw','MarkerFaceColor','b','MarkerSize',7.5)
        
        text(nanmean(SIL)+0.03,0.4,sprintf('mean %.2f',nanmean(SIL)),'FontSize',11)
        text(SImax-0.1,0.45,sprintf('n: %d',sum(sig == 1)))
        
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
suptitle({sprintf('%s %s %s distribution of orientation selectivity indices for binocular channels by parameter 100%% coherence',data.LE.animal, data.LE.eye, data.LE.array);...
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

figName = [data.LE.animal,'_',data.LE.array,'_LE_OSIdistribition_byParam_binocChs','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
for i = 1:4
    numGood = i-1;
    
    figure
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 500])
    set(gcf,'PaperOrientation','Landscape');
    
    % SIR = squeeze(data.RE.OriSelectIndex2thetaNoise(end,:,:,data.RE.goodCh == 1));
    % SIR = reshape(SIR,[1,numel(SIR)]);
    % SIR(isnan(SIR)) = [];
    %
    % SIL = squeeze(data.LE.OriSelectIndex2thetaNoise(end,:,:,data.LE.goodCh == 1));
    % SIL = reshape(SIL,[1,numel(SIL)]);
    % SIL(isnan(SIL)) = [];
    
    SIGood = squeeze(data.RE.OSI2thetaNoiseSig(end,:,:,:));
    sirA = sum(SIGood,1);
    sirA = squeeze(sum(sirA,2));
    
    SIR = squeeze(data.RE.OriSelectIndex2thetaNoise(end,:,:,sirA>numGood & binocCh')); % with each iteration through the loop, will require one more configuration to be significant.
    SIR = reshape(SIR,[1,numel(SIR)]);
    SIR(isnan(SIR)) = [];
    
    SIGood = squeeze(data.LE.OSI2thetaNoiseSig(end,:,:,:));
    silA = sum(SIGood,1);
    silA = squeeze(sum(silA,2));
    
    SIL = squeeze(data.LE.OriSelectIndex2thetaNoise(end,:,:,silA>numGood & binocCh')); % with each iteration through the loop, will require one more configuration to be significant.
    SIL = reshape(SIL,[1,numel(SIL)]);
    SIL(isnan(SIL)) = [];
    
    xmax = max([SIR, SIL])+0.05;
    xmin = xmax*-1;
    
    subplot(2,1,1)
    hold on
    
    histogram(SIL,xmin:.01:xmax,'normalization','probability','FaceColor','b','EdgeColor','w')
    plot(nanmean(SIL),0.4,'vw','MarkerFaceColor','b','MarkerSize',7.5)
    
    text(nanmean(SIL)+0.02,0.4,sprintf('mean %.2f',nanmean(SIL)),'FontSize',11)
    text(xmax-0.1,0.45,sprintf('n: %d',sum(silA>numGood & binocCh')));
    
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
    text(xmax-0.1,0.45,sprintf('n: %d',sum(sirA>numGood & binocCh')));
    
    set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'box','off','Layer','top')
    xlim([-0.05,xmax])
    ylim([0 0.5])
    
    ylabel('probability','FontSize',12)
    xlabel('OSI','FontSize',12)
    title(sprintf('%s RE',data.RE.animal))
    
    suptitle({sprintf('%s %s distribtion of OSIs across all stimuli at least %d significant parameter(s) on binocular channels',data.RE.animal, data.RE.array, numGood+1);...
        sprintf('%s run %s',data.RE.date,data.RE.runNum)});
    
    figName = [data.RE.animal,'_',data.RE.array,'_BE_OSIdistribition_binoc_',num2str(i),'GoodParams','.pdf'];
    print(gcf, figName,'-dpdf','-fillpage')
end