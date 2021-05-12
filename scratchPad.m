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
% for lo = 1:3
%     figure
%     clf
%     pos = get(gcf,'Position');
%     set(gcf,'Position',[pos(1), pos(2), 1200, 800])
%
%     s = suptitle(sprintf('%s %s %s mean zscores by stimulus sf %d mean radius %d at (%.1f, %.1f)',...
%         dataT.animal, dataT.eye, dataT.array, sfs(1), rads(1), stimLoc(lo,1), stimLoc(lo,2)));
%     s.FontSize = 14;
%     s.FontWeight = 'bold';
%
%     colormap(cmap)
%
%     for ch = 1:96
%         subplot(dataT.amap,10,10,ch)
%
%         hold on
%
%         if lo == 1
%             rfZs = round(loc1Zs{ch}.sf1Rad1(:,1:end-1),2);
%             cZ = loc1Zs{ch}.sf1Rad1(:,end);
%
%         elseif lo == 2
%             rfZs = round(loc1Zs{ch}.sf1Rad1(:,1:end-1),2);
%             cZ = loc2Zs{ch}.sf1Rad1(:,end);
%         else
%             cZ = loc3Zs{ch}.sf1Rad1(:,end);
%             rfZs = round(loc1Zs{ch}.sf1Rad1(:,1:end-1),2);
%
%         end
%
%         rfZs(end+1,:) = mean(rfZs(8:end,:)); % mean zscore
%         cZ(end+1) = mean(cZ(8:end));
%
%         normZs = rfZs(end,:)/cZ(end); % normalize by circle
%         normZs = flipud(reshape(normZs, 6, 6)');
%
%         meanZs = mean(rfZs(8:end,:));
%         meanZs = flipud(reshape(meanZs, 6, 6)');
%
%
%         imagesc(meanZs)
%         axis tight
%         set(gca,'YTick',1:6,'XTick',1:6,'YTickLabel',{'','16','','8','','4'},...
%             'XTickLabel',{'low','','','','','high'},...
%             'FontSize',9,'FontAngle','italic');
%         title(ch)
%
%     end
% end
%%
% colormap(cmap)
chs = [3, 8, 52, 96];

figure
clf
hold on

colormap(cmap)
ndx = 1;

for ch = 1:4
    for n = 1:4
        
        if n == 1
            rfSpikes = round(loc3Spikes{ch}.sf1Rad1(:,1:end-1),2);
            cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
        elseif n == 2
            rfSpikes = round(loc3Spikes{ch}.sf1Rad2(:,1:end-1),2);
            cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
        elseif n == 3
            rfSpikes = round(loc3Spikes{ch}.sf2Rad1(:,1:end-1),2);
            cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
        else
            rfSpikes = round(loc3Spikes{ch}.sf2Rad2(:,1:end-1),2);
            cSpike = loc3Spikes{ch}.sf1Rad1(:,end);
        end
        
        subplot(4,4,ndx)
        rfSpikes(end+1,:) = mean(rfSpikes(8:end,:)); % mean Spikecount
        cSpike(end+1) = mean(cSpike(8:end));
        circ =[cSpike(end);cSpike(end);cSpike(end);cSpike(end);cSpike(end);cSpike(end)];
        
        meanSpikes = reshape(rfSpikes(end,:),6,6)';
        spikes = [circ,meanSpikes];
        meanSpikes = flipud(spikes);
        
        clims = [min(meanSpikes,[],'all'), max(meanSpikes,[],'all')];
        title(ch)
        imagesc(meanSpikes,clims)
        colorbar
        axis tight
        axis square
        set(gca,'YTick',1:6,'XTick',1:7,'YTickLabel',{'','16','','8','','4'},...
            'XTickLabel',{'c',' low','','','','','high'},...
            'FontSize',9,'FontAngle','italic');
        ndx = ndx+1;
    end
end
% title(sprintf('mean spike counts ch %d',ch))

% colorbar

