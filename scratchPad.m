%        1)   Radial Frequency
%        2)   Amplitude (Weber fraction)
%        3)   Phase (Orientation)
%        4)   Spatial frequency
%        5)   Size (mean radius)
%        6)   X position
%        7)   Y position

clear
close all
clc
%%
filename = 'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info.mat';
fparts = strsplit(filename,'_');

if length(fparts) < 7
    dataT = load(filename);
else
    load(filename);
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
end
%%
[stimLoc] = plotRadFreqLoc_relRFs(dataT);
[loc1Zs, loc2Zs, loc3Zs, loc1Spikes, loc2Spikes, loc3Spikes] = getRadFreq_zSbyParam(dataT,stimLoc);
cmap = (redblue(36));

sfs = unique(dataT.spatialFrequency);
rads = unique(dataT.radius);
%%
% colormap(cmap)
%ch = 48;%[3, 8, 52, 96];

DO A ZSCORE VERSION OF THIS TOO

for ch = 10%:10
    figure
    clf
    hold on
    
    colormap(cmap)
    
    suptitle(sprintf('ch %d mean spike counts',ch))
    for cond = 1:4
        for loc = 2%1:3
            if loc == 1
                if cond == 1
                    subplot(3,4,1)
                    hold on
                    rfSpikes = loc1Spikes{ch}.sf1Rad1(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title(sprintf('(%.1f, %.1f) SF %d radius %d',stimLoc(1,1), stimLoc(1,2),sfs(1),rads(1)))
                    
                elseif cond == 2
                    subplot(3,4,2)
                    hold on
                    rfSpikes = loc1Spikes{ch}.sf1Rad2(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title('SF 1 radius 2')
                elseif cond == 3
                    subplot(3,4,3)
                    hold on
                    rfSpikes = loc1Spikes{ch}.sf2Rad1(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title('SF 2 radius 1')
                else
                    subplot(3,4,4)
                    hold on
                    rfSpikes = loc1Spikes{ch}.sf2Rad2(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title('SF 2 radius 2')
                end
            elseif loc == 2
                if cond == 1
                    subplot(3,4,5)
                    hold on
                    rfSpikes = loc2Spikes{ch}.sf1Rad1(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title(sprintf('(%.1f, %.1f) SF %d radius %d',stimLoc(2,1), stimLoc(2,2),sfs(1),rads(1)))
                elseif cond == 2
                    subplot(3,4,6)
                    hold on
                    rfSpikes = loc2Spikes{ch}.sf1Rad2(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title('SF 1 radius 2')
                elseif cond == 3
                    subplot(3,4,7)
                    hold on
                    rfSpikes = loc2Spikes{ch}.sf2Rad1(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title('SF 2 radius 1')
                else
                    subplot(3,4,8)
                    hold on
                    rfSpikes = loc2Spikes{ch}.sf2Rad2(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title('SF 2 radius 2')
                end
            else
                if cond == 1
                    subplot(3,4,9)
                    hold on
                    rfSpikes = loc3Spikes{ch}.sf1Rad1(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title(sprintf('(%.1f, %.1f) SF %d radius %d',stimLoc(3,1), stimLoc(3,2),sfs(1),rads(1)))
                elseif cond == 2
                    subplot(3,4,10)
                    hold on
                    rfSpikes = loc3Spikes{ch}.sf1Rad2(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title('SF 1 radius 2')
                elseif cond == 3
                    subplot(3,4,11)
                    hold on
                    rfSpikes = loc3Spikes{ch}.sf2Rad1(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title('SF 2 radius 1')
                else
                    subplot(3,4,12)
                    hold on
                    rfSpikes = loc3Spikes{ch}.sf2Rad2(:,1:end-1);
                    cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
                    title('SF 2 radius 2')
                end
            end
            
            rfSpikes(end+1,:) = median(rfSpikes(8:end,:)); % mean Spikecount
            cSpike(end+1) = median(cSpike(8:end));
            circ =[cSpike(end);cSpike(end);cSpike(end);cSpike(end);cSpike(end);cSpike(end)];
            
            meanSpikes = reshape(rfSpikes(end,:),6,6)';
            spikes = [circ,meanSpikes];
            meanSpikes = flipud(spikes)
            
            clims = [min(meanSpikes,[],'all'), max(meanSpikes,[],'all')];
            imagesc(meanSpikes,clims)
            colorbar
            axis tight
            axis square
            set(gca,'YTick',1:6,'XTick',1:7,'YTickLabel',{'','16','','8','','4'},...
                'XTickLabel',{'c',' low','','','','','high'},...
                'FontSize',9,'FontAngle','italic');
            
%             clear meanSpikes; clear cSpike; clear rfSpikes; clear circ;
        end
    end
end
%%
ch = 10;% 4, 8;



circRF = dataT.rf == 32;
xLoc = dataT.pos_x == stimLoc(2,1);
yLoc = dataT.pos_y == stimLoc(2,2);

blankNdx = dataT.rf == 10000;
blankResp = nanmean(dataT.bins((blankNdx),1:35,ch));

oris4 =[0, 45];     oris8 = [0, 22.5];    oris16 = [0, 11.25];
amps48 = [6.25, 12.5, 25, 50, 100, 200];   amps16 = [3.12, 6.25, 12.5, 25, 50, 100];

for spf = 1:2
    for ra = 1:2
        sfNdx = dataT.spatialFrequency == sfs(spf);
        radNdx = dataT.radius == rads(ra);
        circResp = nanmean(dataT.bins((circRF & xLoc & yLoc & sfNdx & radNdx),1:35,ch));
        figure
        clf
        
        suptitle(sprintf('Channel %d PSTH spike counts sf %d radius %d',ch,sfs(spf),rads(ra)))
        ndx = 1;
        
        for r = 1:4
            for or = 1:2
                for amp = 1:length(amps48)
                    if ndx < 43
                    if ndx == 1 || ndx == 8 || ndx == 15 || ndx == 22 || ndx == 29 || ndx == 36
                        subplot(6,7,ndx)
                        hold on
                        ylim([0 1.5])
                        plot(circResp,'b','LineWidth',0.5)
                        plot(blankResp,'k','LineWidth',0.5)
                    elseif ndx > 1 && ndx < 15
                        stim4Ndx = dataT.rf == 4;
                        orNdx = dataT.orientation == oris4(or);
                        ampNdx  = dataT.amplitude == amps48(amp);
                        stimResp = nanmean(dataT.bins((stim4Ndx & orNdx & ampNdx & xLoc & yLoc & sfNdx & radNdx),1:35,ch));
                        
                        subplot(6,7,ndx)
                        hold on
                        ylim([0 2.25])
                        plot(stimResp,'r','LineWidth',0.5)
                        plot(blankResp,'k','LineWidth',0.5)
                        
                    elseif ndx > 15 && ndx < 29
                        stim8Ndx = dataT.rf == 8;
                        orNdx = dataT.orientation == oris8(or);
                        ampNdx  = dataT.amplitude == amps48(amp);
                        stimResp = nanmean(dataT.bins((stim8Ndx & orNdx & ampNdx & xLoc & yLoc & sfNdx & radNdx),1:35,ch));
                        
                        subplot(6,7,ndx)
                        hold on
                        ylim([0 2.25])
                        plot(stimResp,'r','LineWidth',0.5)
                        plot(blankResp,'k','LineWidth',0.5)
                    else
                        stim16Ndx = dataT.rf == 16;
                        orNdx = dataT.orientation == oris16(or);
                        ampNdx  = dataT.amplitude == amps16(amp);
                        stimResp = nanmean(dataT.bins((stim16Ndx & orNdx & ampNdx & xLoc & yLoc & sfNdx & radNdx),1:35,ch));
                        
                        subplot(6,7,ndx)
                        hold on
                        ylim([0 2.25])
                        plot(stimResp,'r','LineWidth',0.5)
                        plot(blankResp,'k','LineWidth',0.5)
                    end
                    ndx = ndx+1;
                    end
                end
            end
        end
        clear ndx;
    end
end