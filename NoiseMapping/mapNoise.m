%% mapNoise

clear all
%close all
clc

plotPSTH = 1;
%% XT
%
%files = 'XT_LE_mapNoise_nsp1_20181023_001';

% filename = 'XT_RE_mapNoiseRight_nsp2_20181119_001';
%files = 'XT_LE_mapNoiseRight_nsp2_20181120_001';

%files = 'XT_RE_mapNoiseRight_nsp1_20181119_001';

% files = 'XT_RE_mapNoiseRight_nsp2_20181026_001';
% files = 'XT_RE_mapNoiseRight_nsp2_20181026_003';
% files = 'XT_RE_mapNoiseRight_nsp2_20181119_001';
%
% files = 'XT_LE_mapNoise_nsp2_Oct2018';
% files = 'XT_LE_mapNoiseRight_nsp2_Nov2018';
%files = 'XT_LE_mapNoiseRight_nsp1_Nov2018';
%
%files = 'XT_RE_mapNoise_nsp2_EarlyOct2018';
%files = 'XT_RE_mapNoiseRight_nsp2_LateOct2018';

%files = 'XT_RE_mapNoiseRight_nsp2_20181119_001';
%% WV
% filename = 'WV_RE_MapNoise_nsp1_Feb2019';
% filename = 'WV_LE_MapNoise_nsp1_Feb2019';

% filename = 'WV_RE_MapNoise_nsp2_Feb2019';
% files = 'WV_LE_MapNoise_nsp2_Feb2019';

% files = ['WV_LE_MapNoise_nsp2_Feb2019';...
%     'WV_RE_MapNoise_nsp2_Feb2019'];

%files = 'WV_RE_MapNoise_nsp2_20190205_001';
%files = 'WV_LE_MapNoise_nsp2_20190204_002';

%files = 'WV_RE_MapNoise_nsp1_20190205_001';
%files = 'WV_LE_MapNoise_nsp1_20190204_002';
files = 'WV_LE_MapNoise_nsp2_20190204_all_raw';
%%
location = determineComputer;
startMean = 10;
endMean = 20;
numBoot = 100;
%%
for fi = 1:size(files,1)
    filename = files(fi,:);
    %data = load(filename);
    load(filename); data = data.LE;
    %% load array map
    data.amap = getBlackrockArrayMap(filename);
    startBin = 5;
    endBin = 25;
    %%
    tmp = strsplit(filename,'_');
    [animal, eye, programID, array, date,p,t] = deal(tmp{:});
    
    if strcmp(array,'nsp1')
        array = 'V1';
    else
        array = 'V4';
    end   
    
    textName = figTitleName(filename);
    disp(sprintf('\n analyzing file: %s',textName))
    %%
    xpos = unique(data.pos_x);
    ypos = unique(data.pos_y);
    ypos = sort(ypos,'descend');
    
    if contains(filename,'XT')
        xfix = -3;
        yfix = 3;
    else
        xfix = double(unique(data.fix_x));
        yfix = double(unique(data.fix_y));
    end
    
    xpos_rel = xpos - xfix;
    ypos_rel = ypos - yfix;
    
    [data.stimType] = parseMapNoiseStim(data.filename);  % stimType 0 for blank 1 for noise stimulus
    %%
    binStimOn  = data.stimOn(1)/10;
    binStimOff = data.stimOff(1)/10;
    %% define good channels
    goodCh = getGoodCh_mapping(data,numBoot,startMean,endMean);
    %% plot PSTH fig1
    if location == 1
        goDir = sprintf('/Local/Users/bushnell/Dropbox/Figures/%s/Mapping/%s/FullArray/%s/',animal, array, eye);
    elseif location == 0
        goDir = sprintf('~/Dropbox/Figures/%s/Mapping/%s/FullArray/%s/',animal, array, eye);
    end
    % cd(goDir)
    
    figure%(1)
    
    for ch = 1:96
        subplot(data.amap,10,10,ch);
        hold on;
        plot((mean(squeeze(data.bins((data.stimType == 0),1:35,ch)),1)./.010),'k','LineWidth',2);
        plot((mean(squeeze(data.bins((data.stimType == 1),1:35,ch)),1)./.010),'r','LineWidth',2);
        
        title(ch)
        set(gca,'Color','none','XColor','none')
        ylim([0 inf])
    end
    suptitle(sprintf('%s %s %s PSTH raw data',eye,animal,array))
    %% mean responses by location
    blankNdx = find(data.stimType == 0);
    stimNdx  = find(data.stimType ~= 0);
    
    
    for ch = 1:96
        for ys = 1:length(ypos)
            for xs = 1:length(xpos)
                
                useBlank = double(data.bins(blankNdx,binStimOn:binStimOff,ch))./0.01;
                blank = nanmean(useBlank(:));
                
                tmpNdx      = find((data.pos_x == xpos(1,xs)) .* (data.pos_y == ypos(1,ys)) .* (data.stimType == 1));
                useRuns     = double(data.bins(tmpNdx,binStimOn:binStimOff,ch));
                locs{ch}(ys,xs) =  nanmean(useRuns(:))./0.010; %dividing the mean by binStimOn/.010 puts the results into spikes/sec
                locsBaseSub{ch}(ys,xs) =   locs{ch}(ys,xs) - blank;
                
                maxResp = max(locsBaseSub{ch}(:));
                if goodCh(ch) == 1
                    normResps{ch} = locsBaseSub{ch}./maxResp;
                else
                    normResps{ch} = nan(length(ypos),length(xpos));
                end
            end
        end
    end
    clear ys
    clear xs
    % responses across all channels
    for ys = 1:length(ypos)
        for xs = 1:length(xpos)
            useBlank = double(data.bins(blankNdx,binStimOn:binStimOff,:))./0.01;
            blank = nanmean(useBlank(:));
            
            tmpNdx = find((data.pos_x == xpos(xs)) & (data.pos_y == ypos(ys)) & (data.stimType == 1));
            xLocMtx(ys,xs) = xpos(xs);
            yLocMtx(ys,xs) = ypos(ys);
            
            useRuns = double(data.bins(tmpNdx,binStimOn:binStimOff,:));
            locs2(ys,xs) = nanmean(useRuns(:))./0.010; %dividing the mean by binStimOn/.010 puts the results into spikes/sec
            locsBaseSub2(ys,xs) = locs2(ys,xs) - blank;
            
            maxResp = max(locsBaseSub2(:));
            normResps2 = locsBaseSub2./maxResp;
        end
    end
    
    %%
    figure%(2)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 900 900])
    for ch = 1:96
        subplot(data.amap,10,10,ch)
        hold on
        flipud(locsBaseSub{ch});
        imagesc(locsBaseSub{ch})
        title(ch,'FontSize',9)
        colormap(flipud(gray))
        axis off; axis tight; axis square
        set(gca, 'tickdir','out','color','none','box','off',...
            'XTick',1:5, 'XTickLabel',{'','', '','', ''},...   % Note: change the tick labels to populate according to matrix values so not hardcoded.
            'YTick',1:5, 'YTickLabel',{'','', '','', ''});
        if ch == 1
            suptitle({sprintf('%s %s %s receptive field mapping',animal, eye, array);date})
        end
    end
    figName = [animal,'_', eye,'_',array,'_RFmappingbyCh',date];
    %print(gcf,figName,'-dpdf','-fillpage')
    %% mapping of entire array fig3
    % limiting to visually responsive channels and normalizing by max
    % response
    figure%(3)
    clf
    cla reset;
    
    hold on
    imagesc(normResps2);
    axis ij;
    colormap(flipud(gray))
    colorbar
    %axis off;
    axis tight; axis square
    if contains(files,'WV')
        set(gca, 'tickdir','out','color','none','box','off',...
            'XTick',(1:1:length(xpos_rel)),'XTickLabel',({'-2', '-1', '0', '1', '2'}),...   % Note: change the tick labels to populate according to matrix values so not hardcoded.
            'YTick',(1:1:length(ypos_rel)),'YTickLabel',({'2', '1', '0', '-1', '-2'}))
    else
        set(gca, 'tickdir','out','color','none','box','off',...
            'XTick',(1:1:length(xpos_rel)),'XTickLabel',({'-2', '-1', '0', '1', '2'}),...   % Note: change the tick labels to populate according to matrix values so not hardcoded.
            'YTick',(1:1:length(ypos_rel)),'YTickLabel',({'2', '1', '0', '-1', '-2'}))
    end
    title({sprintf('%s %s %s normalized mapping responses',animal,eye,array),date})
    
    figName = [animal,'_', eye,'_',array,'_mappingNormResp',date];
    %saveas(gcf,figName,'pdf')
    %% plotting normalized responses for each channel
    figure%(4)
    clf
    for ch = 1:96
        hold on
        imagesc(normResps{ch})
        axis ij;
        title(ch,'FontSize',7)
        colormap(flipud(gray))
        axis off; axis tight; axis square
        set(gca, 'tickdir','out','color','none','box','off')
        
    end
    suptitle({sprintf('%s %s %s receptive feild mapping',animal, eye, array),date})
    figName = [animal,'_', eye,'_',array,'_mappingPSTHArray',date];
    %saveas(gcf,figName,'pdf')
    %% PSTh by location full array
    figure%(13)
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 700 700])
    clf
    ndx = 1;
    for y = 1:length(ypos)
        for x = 1:length(xpos)
            
            stim = (mean(squeeze(data.bins(((data.stimType == 1) & (data.pos_x == xpos(x)) & (data.pos_y == ypos(y))),1:35,:)),1)./.010);
            stim = mean(stim,3);
            
            blank = (mean(squeeze(data.bins((data.stimType == 0),1:35,:)),1)./.010);
            blank = mean(blank,3);
            
            subplot(5,5,ndx)
            hold on
            plot(stim,'r','LineWidth',2);
            plot(blank,'k','LineWidth',2);
            title(sprintf('(%d,%d)',xpos_rel(1,x),ypos_rel(1,y)))
            
            set(gca,'Color','none')
            ylim([0 25])
            
            ndx = ndx +1;
            clear stim
            clear blank
            
            
        end
    end
    suptitle({sprintf('%s %s %s response by location full array',animal,eye,array),date})
    
    figName = [animal,'_', eye,'_',array,'_mapping',date];
   % print(gcf,figName,'-dpdf','-fillpage')
    %% PSTH by location all chs
    %     if location == 1
    %         goDir = sprintf('/Local/Users/bushnell/Dropbox/Figures/%s/Mapping/%s/Ch/%s/',animal,array,eye);
    %     elseif location == 0
    %         goDir = sprintf('~/Dropbox/Figures/%s/Mapping/%s/Ch/%s/',animal,array,eye);
    %     end
    %     cd(goDir)
    %     useChs = [69 80 45 51 50 19 60 61 26];
    %
    %
    %     for ch = 1:96%length(useChs)
    %         figure(5)
    %         clf
    %         ndx = 1;
    %         max00 = max(mean(squeeze(data.bins((data.stimType == 1) &(data.pos_x == 0) & (data.pos_y == 0),1:35,ch)),1)./.010);
    %         max11 = max(mean(squeeze(data.bins((data.stimType == 1) &(data.pos_x == 1) & (data.pos_y == -1),1:35,ch)),1)./.010);
    %         ymax = max(max00, max11);
    %         ymax = ymax+ymax.*0.8;
    %
    %         if ymax <= 0
    %             ymax = 5;
    %         end
    %         suptitle(sprintf('%s %s %s pink noise responses ch %d',animal,eye,array,ch))
    %
    %         for x = 1:length(xpos)
    %             for y = 1:length(ypos)
    %                 subplot(5,5,ndx)
    %                 hold on
    %                 plot((mean(squeeze(data.bins(((data.stimType == 1) & (data.pos_x == xpos(x)) & (data.pos_y == ypos(y))),1:35,ch)),1)./.010),'r','LineWidth',2);
    %                 plot((mean(squeeze(data.bins((data.stimType == 0),1:35,ch)),1)./.010),'k','LineWidth',2);
    %
    %                 title(sprintf('(%d,%d)',xpos_rel(1,x),ypos_rel(1,y)))
    %
    %                 set(gca,'Color','none')
    %                 if ~isnan(ymax)
    %                     ylim([0 ymax])
    %                 end
    %
    %                 ndx = ndx +1;
    %             end
    %         end
    %         pause(0.1)
    %         figName = [animal,'_', eye,'_',array,'_mapping_ch',num2str(ch)];
    %         saveas(gcf,figName,'pdf')
    %     end
end
