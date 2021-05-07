%        1)   Radial Frequency
%        2)   Amplitude (Weber fraction)
%        3)   Phase (Orientation)
%        4)   Spatial frequency
%        5)   Size (mean radius)
%        6)   X position
%        7)   Y position

[loc1Zs, loc2Zs, loc3Zs] = getRadFreq_zSbyParam(dataT,stimLoc);
cmap = flipud(redblue(36));

sfs = unique(dataT.spatialFrequency);
rads = unique(dataT.radius);

for lo = 1:3
    figure
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2), 1200, 800])
    
    s = suptitle(sprintf('%s %s %s mean zscores by stimulus sf %d mean radius %d at (%.1f, %.1f)',...
        dataT.animal, dataT.eye, dataT.array, sfs(1), rads(1), stimLoc(lo,1), stimLoc(lo,2)));
    s.FontSize = 14;
    s.FontWeight = 'bold';
    
    colormap(cmap)
    
    for ch = 1:96
        subplot(dataT.amap,10,10,ch)
        
        hold on
        
        if lo == 1
            rfZs = round(loc1Zs{ch}.sf1Rad1(:,1:end-1),2);
            cZ = loc1Zs{ch}.sf1Rad1(:,end);
            
        elseif lo == 2
            rfZs = round(loc1Zs{ch}.sf1Rad1(:,1:end-1),2);
            cZ = loc2Zs{ch}.sf1Rad1(:,end);
        else
            cZ = loc3Zs{ch}.sf1Rad1(:,end);
            rfZs = round(loc1Zs{ch}.sf1Rad1(:,1:end-1),2);
            
        end
        
        rfZs(end+1,:) = mean(rfZs(8:end,:)); % mean zscore
        cZ(end+1) = mean(cZ(8:end));
        
        normZs = rfZs(end,:)/cZ(end); % normalize by circle
        normZs = flipud(reshape(normZs, 6, 6)');
        
        meanZs = mean(rfZs(8:end,:));
        meanZs = flipud(reshape(meanZs, 6, 6)');
        
        
        imagesc(meanZs)
        axis tight
        set(gca,'YTick',1:6,'XTick',1:6,'YTickLabel',{'','16','','8','','4'},...
            'XTickLabel',{'low','','','','','high'},...
            'FontSize',9,'FontAngle','italic');
        title(ch)
        
    end
end
%%
%
% figure(2)
% hold on
% ch = 40;
% rfZs = round(loc1Zs{ch}.sf1Rad1(:,1:end-1),2);
% cZ = loc1Zs{ch}.sf1Rad1(:,end);
% rfZs(end+1,:) = mean(rfZs(8:end,:)); % mean zscore
% cZ(end+1) = mean(cZ(8:end));
%
% normZs = rfZs(end,:)/cZ(end); % normalize by circle
% normZs = flipud(reshape(normZs, 6, 6)')
%
% imagesc(normZs)
% axis tight
% set(gca,'YTick',1:6,'XTick',1:6,'YTickLabel',{'','16','','8','','4'},...
%     'XTickLabel',{'low','','','','','high'},...
%     'FontSize',9,'FontAngle','italic');
% title(ch)
% colormap = cmap;
% colorbar

