clc% ContIntMwks
% Note, for contour integration programs, all stimuli were run so the field
% of gabors extended across the entire screen, and the line segment was
% centered at (-3,0).

%  Written August 23, 2017 Brittany Bushnell

clear all
close all
clc
tic
%% TO SAVE FIGURES AS SEEN ON THE SCREEN:
% img = getframe(gcf);
% imwrite(img.cdata, ['V4_PSTH_ContInt', '.tiff']);
%%
files = ['WU_LE_ContourIntegration_nsp2_July2017';'WU_RE_ContourIntegration_nsp2_July2017'];
location = 0;
%% load array map file and cd to directory
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

if ~isempty(strfind(files(1,:),'Contour'))
    cd ContourIntegration/ConcatenatedMats
elseif ~isempty(strfind(files(1,:),'Ph_'))
    cd ContourIntegration/phase
else
    error('Error: cannot identify the program run, check file name')
end
%% load data and define variables
for fi = 1:size(files,1)
    filename = files(fi,:);
    data = load(filename);
    
    ndx = 1;
    for i = 1:length(data.filename)
        [numEl, ori, sample, modifier] = parseCIName(data.filename(i,:));
        % Modifier meanings:
        %    0: Standard line in noise
        %    1: Line only
        %    2: Line only, wide spacing (applicable only to 3 and 4 element lines)
        %    3: Wide spaced line in noise
        %    4: blank screen
        %    200: everything 200 means it was a noise stimulus
        data.numEl(1,ndx)      = numEl;
        data.orientation(1,ndx)= ori;
        data.sample(1,ndx)     = sample;
        data.modifier(1,ndx)   = modifier;
        ndx = ndx+1;
    end
    elements = unique(data.numEl);
    oris = unique(data.orientation);
    mods = unique(data.modifier);
    
    stimOn = unique(data.stimOn);
    stimOff = unique(data.stimOff);
    binStimOn  = stimOn/10;
    binStimOff = stimOff/10;
    numChannels = size(data.bins,3);
    data.amap = aMap;
    %% PSTH that shiz
    
    blankNdx = find(data.modifier == 4);
    stimNdx  = find(data.modifier ~= 4); %any stimulus on screen
    
    lineNdx = find(data.modifier == 1 | data.modifier == 2); %just a line
    busyNdx = find(data.modifier == 0 | data.modifier == 3 & data.numEl > 1); % stim embedded in noise
    noiseNdx = find(data.modifier == 200); %just noise
    %% PSTH across all stimuli
    for ch = 1:numChannels
        blankResps = data.bins(blankNdx,1:(binStimOn+binStimOff),ch);
        blankRespsMean = mean(blankResps,1)./0.010;
        
        stimResps = data.bins(stimNdx,1:(binStimOn+binStimOff),ch);
        stimRespsMean = mean(stimResps,1)./0.010;
        
        xaxis = 1:10:stimOn+stimOff;
        
        if strfind(filename, 'LE')
            figure(1)
        else
            figure(2)
        end
        
        subplot(aMap,10,10,ch)
        %figure
        hold on
        plot(xaxis, blankRespsMean,'r')
        plot(xaxis, stimRespsMean,'b')
        title (sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out', 'XTickLabelRotation', 45)
        
        if strfind (filename, 'nsp1')
            if strfind(filename,'LE')
                topTitle = sprintf('V1/V2 Fellow eye PSTH CI(blue) blank(red)');
            else
                topTitle = sprintf('V1/V2 Amblyopic eye PSTH CI(blue) blank(red)');
            end
        else
            if strfind(filename,'LE')
                topTitle = sprintf('V4 FE PSTH CI(blue) blank(red)');
            else
                topTitle = sprintf('V4 AE PSTH CI(blue) blank(red)');
            end
        end
        
        if ch == 1
            annotation('textbox',...
                [0.4 0.94 0.35 0.05],...
                'LineStyle','none',...
                'String',topTitle,...
                'Interpreter','none',...
                'FontSize',16,...
                'FontAngle','italic',...
                'FontName','Helvetica Neue');
        end
    end
    %% PSTH line only vs line in noise
    for ch = 1:numChannels
        blankResps = data.bins(blankNdx,1:(binStimOn+binStimOff),ch);
        blankRespsMean = mean(blankResps,1)./0.010;
        
        lineResps = data.bins(lineNdx,1:(binStimOn+binStimOff),ch);
        lineRespsMean = mean(lineResps,1)./0.010;
        
        busyResps = data.bins(busyNdx,1:(binStimOn+binStimOff),ch);
        busyRespsMean = mean(busyResps,1)./0.010;
        xaxis = 1:10:stimOn+stimOff;
        
        if strfind(filename, 'LE')
            figure(3)
        else
            figure(4)
        end
        
        subplot(aMap,10,10,ch)
        %figure
        hold on
        plot(xaxis, blankRespsMean,'r')
        plot(xaxis, lineRespsMean,'b')
        plot(xaxis, busyRespsMean,'k')
        title (sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out', 'XTickLabelRotation', 45)
        
        if strfind (filename, 'nsp1')
            if strfind(filename,'LE')
                topTitle = sprintf('V1/V2 Fellow eye PSTH CI line(blue) busyCI(black) blank(red)');
            else
                topTitle = sprintf('V1/V2 Amblyopic eye PSTH CI line(blue) busyCI(black) blank(red)');
            end
        else
            if strfind(filename,'LE')
                topTitle = sprintf('V4 FE PSTH CI line(blue) busyCI(black) blank(red)');
            else
                topTitle = sprintf('V4 AE PSTH CI line(blue) busyCI(black) blank(red)');
            end
        end
        
        if ch == 1
            annotation('textbox',...
                [0.4 0.94 0.35 0.05],...
                'LineStyle','none',...
                'String',topTitle,...
                'Interpreter','none',...
                'FontSize',16,...
                'FontAngle','italic',...
                'FontName','Helvetica Neue');
        end
    end
    %% PSTH noise vs embedded line
    for ch = 1:numChannels
        blankResps = data.bins(blankNdx,1:(binStimOn+binStimOff),ch);
        blankRespsMean = mean(blankResps,1)./0.010;
        
        noiseResps = data.bins(noiseNdx,1:(binStimOn+binStimOff),ch);
        noiseRespsMean = mean(noiseResps,1)./0.010;
        
        busyResps = data.bins(busyNdx,1:(binStimOn+binStimOff),ch);
        busyRespsMean = mean(busyResps,1)./0.010;
        xaxis = 1:10:stimOn+stimOff;
        
        if strfind(filename, 'LE')
            figure(5)
        else
            figure(6)
        end
        
        subplot(aMap,10,10,ch)
        %figure
        hold on
        plot(xaxis, blankRespsMean,'r')
        plot(xaxis, noiseRespsMean,'b')
        plot(xaxis, busyRespsMean,'k')
        title (sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out', 'XTickLabelRotation', 45)
        
        if strfind (filename, 'nsp1')
            if strfind(filename,'LE')
                topTitle = sprintf('V1/V2 Fellow eye PSTH noise(blue) embedded CI(black) blank(red)');
            else
                topTitle = sprintf('V1/V2 Amblyopic eye PSTH  noise(blue) embedded CI(black) blank(red)');
            end
        else
            if strfind(filename,'LE')
                topTitle = sprintf('V4 FE PSTH  noise(blue) embedded CI(black) blank(red)');
            else
                topTitle = sprintf('V4 AE PSTH  noise(blue) embedded CI(black) blank(red)');
            end
        end
        
        if ch == 1
            annotation('textbox',...
                [0.4 0.94 0.35 0.05],...
                'LineStyle','none',...
                'String',topTitle,...
                'Interpreter','none',...
                'FontSize',16,...
                'FontAngle','italic',...
                'FontName','Helvetica Neue');
        end
    end
end



%%
toc