%radFreq_plot_stimPSTH

%%
clear all
close all
clc
%format shortG

file = 'XT_radFreqLowSF_V4_Oct2018_RFxAmp';

location = 1; %0 = laptop 1 = desktop 2 = zemina
eye = 'LE';
program = 'RadFreqLowSF';
startBin = 1;
endBin = 35;

load(file);
%% Get stimulus information
rfs  = unique(LEcleanData.rfResps(1,:,:));
amps = unique(LEcleanData.rfResps(2,:,:));
phase = unique(LEcleanData.rfResps(3,:,:));
sfs = unique(LEcleanData.rfResps(4,:,:));
radius = unique(LEcleanData.rfResps(5,:,:));

xpos = unique(LEcleanData.rfResps(6,:,:));
ypos = unique(LEcleanData.rfResps(7,:,:));
ypos = sort(ypos,'descend');

numRFs = length(rfs);
numAmps = length(amps);
numPhases = length(phase);
numSfs = length(sfs);
numRad = length(radius);
numXloc = length(xpos);
numYloc = length(ypos);

numCh = size(LEdata.bins,3);
%% PSTHs by location for LE full array fig 1
figure(1)
clf
ndx = 1;
for y = 1:numYloc
    for x = 1:numXloc
        stim = (mean(squeeze(LEcleanData.bins(((LEcleanData.rf < 32) & (LEcleanData.pos_x == xpos(x)) & (LEcleanData.pos_y == ypos(y))),1:35,:)),1)./.010);
        stim = mean(stim,3);
        
        circle = (mean(squeeze(LEcleanData.bins(((LEcleanData.rf == 32) & (LEcleanData.pos_x == xpos(x)) & (LEcleanData.pos_y == ypos(y))),1:35,:)),1)./.010);
        circle = mean(circle,3);
        
        blank = (mean(squeeze(LEcleanData.bins(((LEcleanData.rf > 32)),1:endBin,:)),1)./.010);
        blank = mean(blank,3);
        
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
            ylim([0 20])
            
        else
            axis off
            set(gca,'box', 'off','color', 'none','YTick',[],'XTick',[])
        end
        
        if ndx == 3
            text(0,.3,'Circle','Color',[0.7 0.1 0.7],'FontSize',12,'FontWeight','bold')
            text(0,.5,'RF','Color',[0 0.7 0.3],'FontSize',12,'FontWeight','bold')
            text(0,.1,'Blank','Color','k','FontSize',12,'FontWeight','bold')
        end
        
        if ndx == 1
            annotation('textbox',...
                [0.2 0.96 0.85 0.05],...
                'LineStyle','none',...
                'String',sprintf('%s %s %s radial frequency response by locaiton, full array',animal,eye, array),...
                'Interpreter','none',...
                'FontSize',14,...
                'FontAngle','italic',...
                'FontName','Helvetica Neue');
        end
        
        ndx = ndx+1;
    end
end

if location == 0
    figDir = sprintf('/Users/bbushnell/Dropbox/Figures/%s/RadialFrequency/%s/Location/%s/%s',animal,array,eye,programRun);
elseif location == 1
    figDir = sprintf('~/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/Location/%s/%s',animal,array,eye,programRun);
else
    error('Need to define figure path for Zemina')
end
figName = [animal,'_',eye,'_',array,program,'fullArray'];
saveas(gcf,figName,'pdf')
%% PSTHs by location for each channel fig 2

for ch = 1:numCh
    figure(2)
    clf
    ndx = 1;
    
    stim = (mean(squeeze(LEcleanData.bins(((LEcleanData.rf < 32)),1:35,ch)),1)./.010);
    stim = mean(stim,3);
    
    circle = (mean(squeeze(LEcleanData.bins(((LEcleanData.rf == 32)),1:35,ch)),1)./.010);
    circle = mean(circle,3);
    
    blank = (mean(squeeze(LEcleanData.bins(((LEcleanData.rf > 32)),1:endBin,ch)),1)./.010);
    blank = mean(blank,3);
    
    maxStim = max(stim(:));
    maxCircle = max(circle(:));
    maxBlank = max(blank(:));
    maxs = [maxStim,maxCircle,maxBlank];
    ymax = max(maxs);
    ymax = ymax+ymax./.85;
    
    for y = 1:numYloc
        for x = 1:numXloc
            stim = (mean(squeeze(LEcleanData.bins(((LEcleanData.rf < 32) & (LEcleanData.pos_x == xpos(x)) & (LEcleanData.pos_y == ypos(y))),1:35,ch)),1)./.010);
            stim = mean(stim,3);
            
            circle = (mean(squeeze(LEcleanData.bins(((LEcleanData.rf == 32) & (LEcleanData.pos_x == xpos(x)) & (LEcleanData.pos_y == ypos(y))),1:35,ch)),1)./.010);
            circle = mean(circle,3);
            
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
                    'String',sprintf('%s %s %s radial frequency response by locaiton ch %d',data.animalID,eye,data.arrayID,ch),...
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
    
    figName = [animal,'_',eye,'_',array,program,num2str(ch)];
    saveas(gcf,figName,'pdf')
end
