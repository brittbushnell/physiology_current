clear
close all
clc
tic
%% To do
% heatmaps:
% 1) organize data so you have a 2-d matrix for each channel where
% each row is a different RF and orientation, and columns are
% modulations.
% 2) Those matrices need to be done for each location separately
% 3) normalize by response to a circle
% 4) Plot all channels, not just those that pass inclusion criteria
% 5) use blue-red colorscale so blue is suppression and red is
% excitation. Scale each channel separately.

% - make a plot that shows stimulus locations relative to receptive field
% locations.
%%

files = {
    %     'WU_RE_radFreqLoc1_nsp2_June2017_info';
    'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info.mat';
    
    %     'WU_RE_radFreqLoc1_nsp1_June2017_info';
    %     'WU_LE_RadFreqLoc1_nsp1_20170626_002_thresh35_info.mat';
    };
%%
nameEnd = 'goodRuns';
numPerm = 200;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
for fi = 1:length(files)
    %%
    %try
    filename = files{fi};
    fparts = strsplit(filename,'_');
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
    
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
    %% plot receptive fields relative to stimulus locations
    [stimLoc] = plotRadFreqLoc_relRFs(dataT);
    %% heatmaps
    [loc1Zs, loc2Zs, loc3Zs] = getRadFreq_zSbyParam(dataT,stimLoc);
    cmap = flipud(redblue(62));
    
    sfs = unique(dataT.spatialFrequency);
    rads = unique(dataT.radius);
    
    for lo = 1:3
        for rd = 1:2
            for sp = 1:2
                
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
                    
                    %sf1 rad1
                    if lo == 1 && rd == 1 && sp == 1
                        rfZs = loc1Zs{ch}.sf1Rad1(:,1:end-1);
                        cZ   = loc1Zs{ch}.sf1Rad1(:,end); 
                    elseif lo == 2 && rd == 1 && sp == 1
                        rfZs = loc2Zs{ch}.sf1Rad1(:,1:end-1);
                        cZ   = loc2Zs{ch}.sf1Rad1(:,end);
                    elseif lo == 3 && rd == 1 && sp == 1
                        cZ   = loc3Zs{ch}.sf1Rad1(:,end);
                        rfZs = loc3Zs{ch}.sf1Rad1(:,1:end-1); 
                     
                        %sf1 rad2
                    elseif lo == 1 && rd == 2 && sp == 1
                        rfZs = loc1Zs{ch}.sf1Rad2(:,1:end-1);
                        cZ   = loc1Zs{ch}.sf1Rad2(:,end); 
                    elseif lo == 2 && rd == 2 && sp == 1
                        rfZs = loc2Zs{ch}.sf1Rad2(:,1:end-1);
                        cZ   = loc2Zs{ch}.sf1Rad2(:,end);
                    elseif lo == 3 && rd == 2 && sp == 1
                        cZ   = loc3Zs{ch}.sf1Rad2(:,end);
                        rfZs = loc3Zs{ch}.sf1Rad2(:,1:end-1); 
                      
                        %sf2 rad1
                    elseif lo == 1 && rd == 1 && sp == 2
                        rfZs = loc1Zs{ch}.sf2Rad1(:,1:end-1);
                        cZ   = loc1Zs{ch}.sf2Rad1(:,end); 
                    elseif lo == 2 && rd == 1 && sp == 2
                        rfZs = loc2Zs{ch}.sf2Rad1(:,1:end-1);
                        cZ   = loc2Zs{ch}.sf2Rad1(:,end);
                    elseif lo == 3 && rd == 1 && sp == 2
                        cZ   = loc3Zs{ch}.sf2Rad1(:,end);
                        rfZs = loc3Zs{ch}.sf2Rad1(:,1:end-1); 
                     
                        %sf2 rad2
                    elseif lo == 1 && rd == 2 && sp == 2
                        rfZs = loc1Zs{ch}.sf2Rad2(:,1:end-1);
                        cZ   = loc1Zs{ch}.sf2Rad2(:,end); 
                    elseif lo == 2 && rd == 2 && sp == 2
                        rfZs = loc2Zs{ch}.sf2Rad2(:,1:end-1);
                        cZ   = loc2Zs{ch}.sf2Rad2(:,end);
                    elseif lo == 3 && rd == 2 && sp == 2
                        cZ   = loc3Zs{ch}.sf2Rad2(:,end);
                        rfZs = loc3Zs{ch}.sf2Rad2(:,1:end-1);      
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
        end
    end
end