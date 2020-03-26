% PSTH across days
%
%
clear all
%close all
clc
location = 1; % 1 = amfortas
%% Contrast Gratings
%files = ['WU_LE_GratingsCon_nsp1_20170811_003'; 'WU_LE_GratingsCon_nsp1_20170809_002'];
%files = ['WU_RE_GratingsCon_nsp1_20170809_003'; 'WU_RE_GratingsCon_nsp1_20170811_001';'WU_RE_GratingsCon_nsp1_20170811_002'];

%files = ['WU_LE_GratingsCon_nsp2_20170811_003'; 'WU_LE_GratingsCon_nsp2_20170809_002'];
%files = ['WU_RE_GratingsCon_nsp2_20170809_003'; 'WU_RE_GratingsCon_nsp2_20170811_001';'WU_RE_GratingsCon_nsp2_20170811_002'];
%% Standard gratings
files = ['WU_RE_Gratings_nsp2_20170705_001';
    'WU_RE_Gratings_nsp2_20170706_001';
    'WU_RE_Gratings_nsp2_20170707_003';
    'WU_RE_Gratings_nsp2_20170707_004';
    'WU_RE_Gratings_nsp2_20170628_001';
    'WU_RE_Gratings_nsp2_20170627_001';
    'WU_RE_Gratings_nsp2_20170626_004';
    'WU_RE_Gratings_nsp2_20170626_003'];
topTitle = 'V4 AE responses 6/26 to 07/05';

% files = ['WU_LE_Gratings_nsp2_20170626_001';
%          'WU_LE_Gratings_nsp2_20170628_003';
%          'WU_LE_Gratings_nsp2_20170703_001';
%          'WU_LE_Gratings_nsp2_20170705_003';
%          'WU_LE_Gratings_nsp2_20170706_003';
%          'WU_LE_Gratings_nsp2_20170707_001'];
% topTitle = 'V4 FE responses 6/26 to 07/05';

% files = ['WU_RE_Gratings_nsp1_20170705_001';
%         'WU_RE_Gratings_nsp1_20170706_001';
%         'WU_RE_Gratings_nsp1_20170707_004';
%         'WU_RE_Gratings_nsp1_20170628_001';
%         'WU_RE_Gratings_nsp1_20170627_001';
%         'WU_RE_Gratings_nsp1_20170626_004';
%         'WU_RE_Gratings_nsp1_20170626_003'];
% topTitle = 'V1/V2 AE responses 6/26 to 07/05';

% files = ['WU_LE_Gratings_nsp1_20170626_001';
%          'WU_LE_Gratings_nsp1_20170628_003';
%          'WU_LE_Gratings_nsp1_20170703_001';
%          'WU_LE_Gratings_nsp1_20170705_003';
%          'WU_LE_Gratings_nsp1_20170706_003';
%          'WU_LE_Gratings_nsp1_20170707_001'];
% topTitle = 'V1/V2 FE responses 6/26 to 07/05';

%%
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

if ~isempty(strfind(files(1,:),'Gratings'))
    cd Gratings/ConcatenatedMats/
elseif ~isempty(strfind(files(1,:),'Gratmap'))
    cd Gratmap/
elseif ~isempty(strfind(files(1,:),'GratingsMapRF'))
    cd GratMapRF/
else
    error('Error: cannot identify the program run, check file name')
end
%%
data = load(files(1,:));
stimOn  = unique(data.stimOn);
stimOff = unique(data.stimOff);

binStimOn  = stimOn/10;
binStimOff = stimOff/10;
numChannels = size(data.bins,3);

figure
for ch = 1:numChannels
%   figure
    for fi = 1:size(files, 1)
        filename = files(fi,:);
        data = load(filename);
        
        blankNdx(ch,:) = find(data.spatial_frequency == 0);
        stimNdx(ch,:)  = find(data.spatial_frequency > 0);
        blankNdx = blankNdx(ch,:);
        stimNdx = stimNdx(ch,:); % cannot be ~= 0 because the mask is set to -1.
        
        stimResps = data.bins(stimNdx,1:(binStimOn+binStimOff),ch);
        stimRespsMean = mean(stimResps,1)./0.010;
        
        blankResps = data.bins(blankNdx,1:(binStimOn+binStimOff),ch);
        blankRespsMean = mean(blankResps,1)./0.010;        
        
        baseSubRespsMean = stimRespsMean - blankRespsMean;
        
        xaxis = 1:10:stimOn+stimOff;
        
     subplot(aMap,10,10,ch)
        hold on
        plot(xaxis, baseSubRespsMean)
%        plot(xaxis, stimRespsMean)
%         title (sprintf('V4 FE responses 6/26 to 07/05 Channel %d',ch))
        title(ch)
        set(gca,'box', 'off','color', 'none', 'tickdir','out', 'XTickLabelRotation', 45)
        
        clear blankNdx
        clear stimNdx
        
        if ch == 1 && fi == 1
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