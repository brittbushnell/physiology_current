%
% Analysis code for MWorks grat_map program using .mat files that have been
% merged using .py code from Darren. This version collapses across all
% visually responive channels to give the receptive field of the entire
% array.
%
% Created Feb 8, 2017
% Edited Jan 2, 2018
% Brittany Bushnell
%
clear all
close all
tic;
clc
%%
files = ['WU_RE_GratingsMapRF_nsp2_Aug2017';'WU_LE_GratingsMapRF_nsp2_Aug2017'];
%files = ['WU_RE_GratingsMapRF_nsp1_Aug2017';'WU_LE_GratingsMapRF_nsp1_Aug2017'];
%%
dispPSTH = 0;
location = 1; % 1 = amfortas
%% Verify file and find array map
if location == 1
    % Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
else
    % laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
end
if ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    cd ../matFiles/V4
    
elseif ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    cd ../matFiles/V1
    
else
    error('Error: array ID missing or wrong')
end

if ~isempty(strfind(files(1,:),'GratingsMapRF'))
    cd GratMapRF/ConcatenatedMats
elseif ~isempty(strfind(files(1,:),'Gratmap'))
    cd Gratmap/ConcatenatedMats
elseif ~isempty(strfind(files(1,:),'Gratings'))
    cd Gratings/ConcatenatedMats
else
    error('Error: cannot identify the program run, check file name')
end
%%
structKey = makeGratMwksStructKey;
for fi = 1:size(files,1)
    filename = files(fi,:);
    data = load(filename);
    textName = figTitleName(filename);
    disp(sprintf('\n analyzing file: %s',textName))
    [animal,eye, program, array, date] = parseFileName(filename);
    %% Extract stim information
    if strfind(filename, 'Con')
        [sfs, oris, width, xloc, yloc, numOris, stimOn, stimOff, con] = getMwksGratParameters(data);
    else
        [sfs, oris, width, xloc, yloc, numOris, stimOn, stimOff] = getMwksGratParameters(data);
    end
    
    binStimOn  = stimOn/10;
    binStimOff = stimOff/10;
    
    numChannels = size(data.bins,3);
    data.amap = aMap;
    data.stimTime = [binStimOn,binStimOff];
    %% PSTH
    if dispPSTH == 1
        for ch = 1:numChannels
            blankNdx(ch,:) = find(data.spatial_frequency == 0);
            stimNdx(ch,:)  = find(data.spatial_frequency > 0);
        end
        psthFigMwksArray(data, textName, blankNdx, stimNdx)
        clear blankNdx
        clear stimNdx
    end
    %% Define Good channels
    %     goodChannels = MwksGetGoodCh(data,filename);
    %     data.goodChannels = goodChannels;
    %     %% Make version of data.bins with only responisve channels
    %     goodBins = nan((size(data.bins,1)),(size(data.bins,2)),length(goodChannels));
    %     for gch = 1:length(goodChannels)
    %         goodBins(:,:,gch) = data.bins(:,:,goodChannels(gch));
    %     end
    %     data.goodBins = goodBins;
    %% get responses
    for ch = 1:numChannels
        %        if ~isempty(intersect(ch,goodChannels)) % only run on channels that are visually responsive
        %         data.latency(1,ch) = getLatencyMwks(data.bins, binStimOn*2, 10, ch); % the first value out of data.latency is the bin with the latency, the second is the latency in ms
        %         data.latency(2,ch) = data.latency(1,ch) +binStimOn;
        startBin = ones(1,96).* 5;
        endBin   = ones(1,96).* 15;
        data.latency = [startBin; endBin];
        
        [sfs] = getMwksSFResponses(data,sfs,ch);
        data.spatialFrequencyResp{ch} = sfs;
        
        [prefStim, prefStimB] = getPrefGrating(data,ch);
        blank = data.spatialFrequencyResp{ch}(3,1);
        
        for xs = 1:size(xloc,2)
            for ys = 1:size(yloc,2)
                tmpNdx      = find((data.xoffset == xloc(1,xs)) .* (data.yoffset == yloc(1,ys)) .* (data.spatial_frequency == prefStim(1)) .* (data.rotation == prefStim(2)));
                useRuns     = double(data.bins(tmpNdx,data.latency(1,ch):data.latency(2,ch),ch));
                locs(xs,ys) =  mean(useRuns(:))./0.010; %dividing the mean by binStimOn/.010 puts the results into spikes/sec
                locsBaseSub(xs,ys) =   locs(xs,ys) - blank;
            end
            %            end
            data.locs{ch} = locs;
            data.locsBaseSub{ch} = locsBaseSub;
        end
    end
    %% Create eye specific data structures
    if strfind(filename,'RE')
        REdata = data;
    elseif strfind(filename,'BE')
        BEdata = data;
    else
        LEdata = data;
    end
end
%% Save data
foo = pwd;
if strfind(foo,'ConcatenatedMats')
    cd ../fittedMats
else
    cd fittedMats
end
if strfind(filename, 'recut')
    newName = ['fitData','_',animal,'_',program,'_',array,'_','recuts'];
else
    newName = ['fitData','_',animal,'_',program,'_',array,'_',date];
end

if strfind(filename,'BE')
    save(newName,'BEdata');
else
    save(newName,'LEdata','REdata','structKey');
end
%% Plot responses AE
% all on one figure - this helps visualize similarities across the array by
% location.
f = figure;
f.PaperOrientation = 'landscape';

for ch = 1:numChannels
    % if ~isempty(intersect(ch,REdata.goodChannels))
    subplot(aMap,10,10,ch)
    imagesc(REdata.locsBaseSub{ch})
    %colorbar
    colormap(1-gray(255))
    set(gca, 'tickdir','out','color','none','box','off','XTick',[],'YTick',[]);%,...
    %             'XTick',1:3, 'XTickLabel',{'-1.5', '-3', '-4.5'},...   % Note: change the tick labels to populate according to matrix values so not hardcoded.
    %             'YTick',1:3, 'YTickLabel',{'-4.5', '-3', '-1.5'})
    axis square xy
    title(ch)
    
    %         subplot(10,10,1)
    %         xlabel('x (deg)')
    %         ylabel('y (deg)')
    %         set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0),'FontSize',7)
    %         h = colorbar;
    %         ylabel(h,'sp/s','FontSize',12)
    %         set(h,'YTick',zeros(1,0))
    %         set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    
    if ch == 1
        if strfind(filename,'nsp2')
            topTitle = 'V4 AE baseline subtracted response to preferred grating by location';
        else
            topTitle = 'V1 AE baseline subtracted response to preferred grating by location';
        end
        
        annotation('textbox',...
            [0.1 0.94 0.85 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',14,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end
figName = ['WU','_',array,'_',program,'_','AE','_','allCh'];
%saveas(gcf,figName,'pdf')
%% FE
% all on one figure - this helps visualize similarities across the array by
% location.
f = figure;
% setup figure properties so it will display properly

f.PaperOrientation = 'landscape';
for ch = 1:numChannels
    %  if ~isempty(intersect(ch,LEdata.goodChannels))
    subplot(aMap,10,10,ch)
    imagesc(LEdata.locsBaseSub{ch})
    % colorbar
    colormap(1-gray(255))
    set(gca, 'tickdir','out','color','none','box','off','XTick',[],'YTick',[]);%,...
    %             'XTick',1:3, 'XTickLabel',{'-1.5', '-3', '-4.5'},...   % Note: change the tick labels to populate according to matrix values so not hardcoded.
    %             'YTick',1:3, 'YTickLabel',{'-4.5', '-3', '-1.5'})
    axis square xy
    title(ch)
    
    %         subplot(10,10,1)
    %         xlabel('x (deg)')
    %         ylabel('y (deg)')
    %         set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0),'FontSize',7)
    %         h = colorbar;
    %         ylabel(h,'sp/s','FontSize',12)
    %         set(h,'YTick',zeros(1,0))
    %         set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    
    if ch == 1
        if strfind(filename,'nsp2')
            topTitle = 'V4 FE baseline subtracted response to preferred grating by location';
        else
            topTitle = 'V1 FE baseline subtracted response to preferred grating by location';
        end
        
        annotation('textbox',...
            [0.1 0.94 0.85 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',14,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end
% if strfind(filename,'nsp1')
%     cd /users/bushnell/Desktop/gratMap/V1
% else
%     cd /users/bushnell/Desktop/gratMap/V4
% end
figName = ['WU','_',array,'_',program,'_','FE','_','allCh'];
%saveas(gcf,figName,'pdf')
%% one fig per channel AE
for ch = 1:numChannels
    %if ~isempty(intersect(ch,REdata.goodChannels))
    figure
    imagesc(REdata.locsBaseSub{ch})
    colormap(1-gray(255))
    set(gca, 'tickdir','out','color','none','box','off',...
        'XTick',1:3, 'XTickLabel',{'-4.5', '-3', '-1.5'},...   % Note: change the tick labels to populate according to matrix values so not hardcoded.
        'YTick',1:3, 'YTickLabel',{'-1.5', '0', '1.5'})
    axis square xy
    colorbar
    title(sprintf('%s ch %d AE baseline subtracted responses to preferred grating for locations', array, ch))
    xlabel('x coordinate (deg)')
    ylabel('y coordinate (deg)')
    
    h = colorbar;
    ylabel(h,'sp/s','FontSize',12)
    text(0.6, 0.6, sprintf('%.2f',REdata.spatialFrequencyResp{ch}(3,1)),'Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
    
    if strfind(filename,'nsp1')
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/MapRF
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1/MapRF
        elseif location == 2
            cd ~/Figures/V1/Gratings/MapRF
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/MapRF
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4/MapRF
        elseif location == 2
            cd ~/Figures/V4/Gratings/MapRF
        end
    end
    figName = ['WU','_',array,'_AE_gratMap_',num2str(ch)];
    saveas(gcf,figName,'pdf')
end
close all
%%
for ch = 1:numChannels
    %if ~isempty(intersect(ch,REdata.goodChannels))
    figure
    imagesc(LEdata.locsBaseSub{ch})
    colormap(1-gray(255))
    set(gca, 'tickdir','out','color','none','box','off',...
        'XTick',1:3, 'XTickLabel',{'-4.5', '-3', '-1.5'},...   % Note: change the tick labels to populate according to matrix values so not hardcoded.
        'YTick',1:3, 'YTickLabel',{'-1.5', '0', '1.5'})
    axis square xy
    colorbar
    title(sprintf('%s ch %d FE baseline subtracted responses to preferred grating for locations', array, ch))
    xlabel('x coordinate (deg)')
    ylabel('y coordinate (deg)')
    
    h = colorbar;
    ylabel(h,'sp/s','FontSize',12)
    text(0.6, 0.6, sprintf('%.2f',REdata.spatialFrequencyResp{ch}(3,1)),'Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
    
    if strfind(filename,'nsp1')
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/MapRF
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1/MapRF
        elseif location == 2
            cd ~/Figures/V1/Gratings/MapRF
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/MapRF
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4/MapRF
        elseif location == 2
            cd ~/Figures/V4/Gratings/MapRF
        end
    end
    figName = ['WU','_',array,'_FE_gratMap_',num2str(ch)];
    saveas(gcf,figName,'pdf')
end
%%
close all
toc/60