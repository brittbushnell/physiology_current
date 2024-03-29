function [] = makeRadfreqHeatmaps(dataT,stimLoc)

%%
[~,~,~, loc1Spikes, loc2Spikes, loc3Spikes] = getRadFreq_zSbyParam(dataT,stimLoc);
cmap = (redblue(36));
sfs = unique(dataT.spatialFrequency);
rads = unique(dataT.radius);
%% figure directories
location = determineComputer;
if location == 1
    if contains(dataT.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/%s/heatmaps/',dataT.animal,dataT.array,dataT.eye);
    elseif contains(dataT.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/%s/heatmaps/',dataT.animal,dataT.array,dataT.eye);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/%s/heatmaps/',dataT.animal,dataT.array,dataT.eye);
    end
elseif location == 0
    if contains(dataT.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/%s/heatmaps/',dataT.animal,dataT.array,dataT.eye);
    elseif contains(dataT.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/%s/heatmaps/',dataT.animal,dataT.array,dataT.eye);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/%s/heatmaps/',dataT.animal,dataT.array,dataT.eye);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)
%% heatmaps by spikecounts
for lo = 1:3
    for rd = 1:2
        for sp = 1:2

            figure(1)
            clf
            pos = get(gcf,'Position');
            set(gcf,'Position',[pos(1), pos(2), 1200, 800],'PaperOrientation','landscape')

            if contains(dataT.animal,'WU')
                s = suptitle(sprintf('%s %s %s spikecount by stimulus sf %d mean radius %d at (%.1f, %.1f)',...
                    dataT.animal, dataT.eye, dataT.array, sfs(sp), rads(rd), stimLoc(lo,1), stimLoc(lo,2)));
            elseif contains(dataT.programID,'High')
                s = suptitle(sprintf('%s %s %s spikecount by stimulus sf 2 mean radius %d at (%.1f, %.1f)',...
                    dataT.animal, dataT.eye, dataT.array, rads(rd), stimLoc(lo,1), stimLoc(lo,2)));
            else
                s = suptitle(sprintf('%s %s %s spikecount by stimulus sf 1 mean radius %d at (%.1f, %.1f)',...
                    dataT.animal, dataT.eye, dataT.array, rads(rd), stimLoc(lo,1), stimLoc(lo,2)));
            end

            s.FontSize = 14;
            s.FontWeight = 'bold';

            colormap(cmap)

            for ch = 1:96
                subplot(dataT.amap,10,10,ch)
                hold on

                if contains(dataT.animal,'WU')
                    %sf1 rad1
                    if lo == 1 && rd == 1 && sp == 1
                        rfSpikes = loc1Spikes{ch}.sf1Rad1(:,1:end-1);
                        cSpike   = loc1Spikes{ch}.sf1Rad1(:,end);
                    elseif lo == 2 && rd == 1 && sp == 1
                        rfSpikes = loc2Spikes{ch}.sf1Rad1(:,1:end-1);
                        cSpike   = loc2Spikes{ch}.sf1Rad1(:,end);
                    elseif lo == 3 && rd == 1 && sp == 1
                        cSpike   = loc3Spikes{ch}.sf1Rad1(:,end);
                        rfSpikes = loc3Spikes{ch}.sf1Rad1(:,1:end-1);

                        %sf1 rad2
                    elseif lo == 1 && rd == 2 && sp == 1
                        rfSpikes = loc1Spikes{ch}.sf1Rad2(:,1:end-1);
                        cSpike   = loc1Spikes{ch}.sf1Rad2(:,end);
                    elseif lo == 2 && rd == 2 && sp == 1
                        rfSpikes = loc2Spikes{ch}.sf1Rad2(:,1:end-1);
                        cSpike   = loc2Spikes{ch}.sf1Rad2(:,end);
                    elseif lo == 3 && rd == 2 && sp == 1
                        cSpike   = loc3Spikes{ch}.sf1Rad2(:,end);
                        rfSpikes = loc3Spikes{ch}.sf1Rad2(:,1:end-1);

                        %sf2 rad1
                    elseif lo == 1 && rd == 1 && sp == 2
                        rfSpikes = loc1Spikes{ch}.sf2Rad1(:,1:end-1);
                        cSpike   = loc1Spikes{ch}.sf2Rad1(:,end);
                    elseif lo == 2 && rd == 1 && sp == 2
                        rfSpikes = loc2Spikes{ch}.sf2Rad1(:,1:end-1);
                        cSpike   = loc2Spikes{ch}.sf2Rad1(:,end);
                    elseif lo == 3 && rd == 1 && sp == 2
                        cSpike   = loc3Spikes{ch}.sf2Rad1(:,end);
                        rfSpikes = loc3Spikes{ch}.sf2Rad1(:,1:end-1);

                        %sf2 rad2
                    elseif lo == 1 && rd == 2 && sp == 2
                        rfSpikes = loc1Spikes{ch}.sf2Rad2(:,1:end-1);
                        cSpike   = loc1Spikes{ch}.sf2Rad2(:,end);
                    elseif lo == 2 && rd == 2 && sp == 2
                        rfSpikes = loc2Spikes{ch}.sf2Rad2(:,1:end-1);
                        cSpike   = loc2Spikes{ch}.sf2Rad2(:,end);
                    elseif lo == 3 && rd == 2 && sp == 2
                        cSpike   = loc3Spikes{ch}.sf2Rad2(:,end);
                        rfSpikes = loc3Spikes{ch}.sf2Rad2(:,1:end-1);
                    end

                elseif contains(dataT.programID,'High')
                    %sf2 rad1
                    if lo == 1 && rd == 1
                        rfSpikes = loc1Spikes{ch}.sf2Rad1(:,1:end-1);
                        cSpike   = loc1Spikes{ch}.sf2Rad1(:,end);
                    elseif lo == 2 && rd == 1
                        rfSpikes = loc2Spikes{ch}.sf2Rad1(:,1:end-1);
                        cSpike   = loc2Spikes{ch}.sf2Rad1(:,end);
                    elseif lo == 3 && rd == 1
                        cSpike   = loc3Spikes{ch}.sf2Rad1(:,end);
                        rfSpikes = loc3Spikes{ch}.sf2Rad1(:,1:end-1);

                        %sf2 rad2
                    elseif lo == 1 && rd == 2
                        rfSpikes = loc1Spikes{ch}.sf2Rad2(:,1:end-1);
                        cSpike   = loc1Spikes{ch}.sf2Rad2(:,end);
                    elseif lo == 2 && rd == 2
                        rfSpikes = loc2Spikes{ch}.sf2Rad2(:,1:end-1);
                        cSpike   = loc2Spikes{ch}.sf2Rad2(:,end);
                    elseif lo == 3 && rd == 2
                        cSpike   = loc3Spikes{ch}.sf2Rad2(:,end);
                        rfSpikes = loc3Spikes{ch}.sf2Rad2(:,1:end-1);
                    end
                else
                    %sf1 rad1
                    if lo == 1 && rd == 1
                        rfSpikes = loc1Spikes{ch}.sf1Rad1(:,1:end-1);
                        cSpike   = loc1Spikes{ch}.sf1Rad1(:,end);
                    elseif lo == 2 && rd == 1
                        rfSpikes = loc2Spikes{ch}.sf1Rad1(:,1:end-1);
                        cSpike   = loc2Spikes{ch}.sf1Rad1(:,end);
                    elseif lo == 3 && rd == 1
                        cSpike   = loc3Spikes{ch}.sf1Rad1(:,end);
                        rfSpikes = loc3Spikes{ch}.sf1Rad1(:,1:end-1);

                        %sf1 rad2
                    elseif lo == 1 && rd == 2
                        rfSpikes = loc1Spikes{ch}.sf1Rad2(:,1:end-1);
                        cSpike   = loc1Spikes{ch}.sf1Rad2(:,end);
                    elseif lo == 2 && rd == 2
                        rfSpikes = loc2Spikes{ch}.sf1Rad2(:,1:end-1);
                        cSpike   = loc2Spikes{ch}.sf1Rad2(:,end);
                    elseif lo == 3 && rd == 2
                        cSpike   = loc3Spikes{ch}.sf1Rad2(:,end);
                        rfSpikes = loc3Spikes{ch}.sf1Rad2(:,1:end-1);
                    end
                end

                bResp = cell2mat(dataT.blankSpikeCount(ch));
                blankSpikes = nanmean(bResp(8:end,:));

                rfSpikes(end+1,:) = nanmean(rfSpikes(8:end,:)); % mean Spikecount
                rfSpikes = rfSpikes - blankSpikes;
                cSpike(end+1) = nanmean(cSpike(8:end));
                cSpike = cSpike - blankSpikes;
                circ =[cSpike(end);cSpike(end);cSpike(end);cSpike(end);cSpike(end);cSpike(end)];

                meanSpikes = reshape(rfSpikes(end,:),6,6)';
                spikes = [circ,meanSpikes];
                meanSpikes = flipud(spikes);
                meanSpikes = meanSpikes/max(meanSpikes,[],'all');

                clims = [-1, 1];
                imagesc(meanSpikes,clims)
                axis tight

                set(gca,'YTick',1:6,'XTick',1:7,'YTickLabel',{'','16','','8','','4'},...
                    'XTickLabel',[],...
                    'FontSize',8,'FontAngle','italic');
                title(ch,'FontSize',9)

                clear meanSpikes; clear cSpike; clear rfSpikes; clear circ;
            end
            if contains(dataT.animal,'WU')
                figName = [dataT.animal,'_',dataT.eye, '_',dataT.array,'_sf',num2str(sp),'_rad',num2str(rd),'_loc',num2str(lo),'.pdf'];
            elseif contains(dataT.programID,'High')
                figName = [dataT.animal,'_',dataT.eye, '_',dataT.array,'_sf2_rad',num2str(rd),'_loc',num2str(lo),'.pdf'];
            else
                figName = [dataT.animal,'_',dataT.eye, '_',dataT.array,'_sf1_rad',num2str(rd),'_loc',num2str(lo),'.pdf'];
            end

            print(gcf, figName,'-dpdf','-fillpage')
        end
    end
end
