function [] = radFreq_LocationResponses(data, endBin, saveFlag, location)
%% Get stimulus information
animal = data.animalID;
eye = data.eye;
program = data.program;
array = data.arrayID;
date = data.date;

rfs  = unique(data.rf);
amps = unique(data.amplitude);
phase = unique(data.orientation);
sfs = unique(data.spatialFrequency);
radius = unique(data.radius);

xpos = unique(data.pos_x);
ypos = unique(data.pos_y);
ypos = sort(ypos,'descend');

numRFs = length(rfs);
numAmps = length(amps);
numPhases = length(phase);
numSfs = length(sfs);
numRad = length(radius);
numXloc = length(xpos);
numYloc = length(ypos);

numCh = size(data.bins,3);
%% PSTHs by location for full array fig 1
muResps = nan(3,3);
locationDPrime = nan(3,3);
figure(1)
clf
ndx = 1;
for y = 1:numYloc
    for x = 1:numXloc
        stim = (nanmean(squeeze(data.bins(((data.rf < 32) & (data.pos_x == xpos(x)) & (data.pos_y == ypos(y))),1:35,:)),1)./.010);
        stim = nanmean(stim,3);
        
        circle = (nanmean(squeeze(data.bins(((data.rf == 32) & (data.pos_x == xpos(x)) & (data.pos_y == ypos(y))),1:35,:)),1)./.010);
        circle = nanmean(circle,3);
        
        blank = (nanmean(squeeze(data.bins(((data.rf > 32)),1:endBin,:)),1)./.010);
        blank = nanmean(blank,3);
        
        % determine mean responses to each stimulus from 0:300 ms for
        % locations that were actually used
        if ~isnan(circle)
            muStim = nanmean(stim(1:30));
            muCirc = nanmean(circle(1:30));
            muBlank = nanmean(blank(1:30));
            
            % see if there's a difference between responses to RF and
            % Circle by calculating d'.
            dpStimvBlank = getDPrime(muStim, muBlank);
            dpCircvBlank = getDPrime(muCirc, muBlank);
            dpStimvsRF = getDPrime(muStim, muCirc);
            
            locationDPrime(ndx) = dpStimvsRF;
            
            
            
        end
        
        % define y-limits
        maxStim = max(stim(:));
        maxCircle = max(circle(:));
        maxBlank = max(blank(:));
        maxs = [maxStim,maxCircle,maxBlank];
        ymax = max(maxs);
        ymax = ymax+ymax./.85;
        
        subplot(3,3,ndx)
        hold on
        if ~isnan(circle)
            plot(circle,'Color',[0.7 0.1 0.7],'LineWidth',2);
            plot(stim,'Color',[0 0.7 0.3],'LineWidth',2);
            plot(blank,'k:','LineWidth',2);
            
            set(gca,'Color','none','TickDir','out','Box','off',...
                'XTick',0:10:40,'XTickLabel',{'0','100','200','300','400'})
            title(sprintf('(%.1f, %.1f)', xpos(x), ypos(y)))
            xlabel('time(ms)')
            ylabel('spikes/sec')
            ylim([0 ymax])
            
        else
            axis off
            set(gca,'box', 'off','color', 'none','YTick',[],'XTick',[])
        end
        
        if ndx == 3
            text(0,.3,'Circle','Color',[0.7 0.1 0.7],'FontSize',12,'FontWeight','bold')
            text(0,.5,'RF','Color',[0 0.7 0.3],'FontSize',12,'FontWeight','bold')
            text(0,.1,'Blank','Color','k','FontSize',12,'FontWeight','bold')
        end
        
        suptitle(sprintf('%s %s %s %s location responses %s, full array',animal,eye,array,program,date))
        
        ndx = ndx+1;
    end
end
if saveFlag == 1
    if location == 0
        figDir = sprintf('/Users/bbushnell/Dropbox/Figures/%s/RadialFrequency/%s/Location/%s/%s',animal,array,eye,program);
    elseif location == 1
        figDir = sprintf('~/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/Location/%s/%s',animal,array,eye,program);
    else
        error('Need to define figure path for Zemina')
    end
    cd(figDir)
    figName = [data.arrayID,'_',eye,'_',data.animalID,program,'fullArray'];
    saveas(gcf,figName,'pdf')
end
%% PSTHs by location for each channel fig 2

for ch = 1:numCh
    figure(2)
    clf
    ndx = 1;
    
    stim = (nanmean(squeeze(data.bins(((data.rf < 32)),1:35,ch)),1)./.010);
    stim = nanmean(stim,3);
    
    circle = (nanmean(squeeze(data.bins(((data.rf == 32)),1:35,ch)),1)./.010);
    circle = nanmean(circle,3);
    
    blank = (nanmean(squeeze(data.bins(((data.rf > 32)),1:endBin,ch)),1)./.010);
    blank = nanmean(blank,3);
    
    maxStim = max(stim(:));
    maxCircle = max(circle(:));
    maxBlank = max(blank(:));
    maxs = [maxStim,maxCircle,maxBlank];
    ymax = max(maxs);
    ymax = ymax+ymax./.85;
    
    for y = 1:numYloc
        for x = 1:numXloc
            stim = (nanmean(squeeze(data.bins(((data.rf < 32) & (data.pos_x == xpos(x)) & (data.pos_y == ypos(y))),1:35,ch)),1)./.010);
            stim = nanmean(stim,3);
            
            circle = (nanmean(squeeze(data.bins(((data.rf == 32) & (data.pos_x == xpos(x)) & (data.pos_y == ypos(y))),1:35,ch)),1)./.010);
            circle = nanmean(circle,3);
            
            subplot(3,3,ndx)
            hold on
            
            if ~isnan(circle)
                plot(circle,'Color',[0.7 0.1 0.7],'LineWidth',2);
                plot(stim,'Color',[0 0.7 0.3],'LineWidth',2);
                plot(blank,'k:','LineWidth',2);
                
                set(gca,'Color','none','TickDir','out','Box','off',...
                    'XTick',0:10:40,'XTickLabel',{'0','100','200','300','400'})
                title(sprintf('(%.1f, %.1f)', xpos(x), ypos(y)))
                xlabel('time(ms)')
                ylabel('spikes/sec')
                ylim([0 ymax])
                
                
            else
                axis off
                set(gca,'box', 'off','color', 'none','YTick',[],'XTick',[])
            end
            
            if ndx == 1
                annotation('textbox',...
                    [0.2 0.96 0.85 0.05],...
                    'LineStyle','none',...
                    'String',sprintf('%s %s %s %s location reponses %s ch %d',data.animalID,eye,data.arrayID,program,date, ch),...
                    'Interpreter','none',...
                    'FontSize',14,...
                    'FontAngle','italic',...
                    'FontName','Helvetica Neue');
            end
            
            if ndx == 3
                text(0,.3,'Circle','Color',[0.7 0.1 0.7],'FontSize',12,'FontWeight','bold')
                text(0,.5,'RF','Color',[0 0.7 0.3],'FontSize',12,'FontWeight','bold')
                text(0,.1,'Blank','Color','k','FontSize',12,'FontWeight','bold')
            end
            
            
            ndx = ndx+1;
        end
    end
    
    pause(0.3)
    
    
    if saveFlag == 1
        figName = [data.animalID,'_',eye,'_',data.arrayID,program,num2str(ch)];
        saveas(gcf,figName,'pdf')
    end
end