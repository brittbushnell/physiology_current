% gratMWks_goodCh
%
% Do day by day analyses of what channels are good to only use those for
% analysis
%
% March 25, 2018 Brittany Bushnell
%%
clear all
close all
clc
tic
%%
location = 0; % 0 = laptop 1 = Amfortas 2 = zemina
%%
% V4
% files = ['WU_RE_Gratings_nsp2_20170705_001';
%     'WU_RE_Gratings_nsp2_20170706_001';
%     'WU_RE_Gratings_nsp2_20170707_004';
%     'WU_RE_Gratings_nsp2_20170628_001';
%     'WU_RE_Gratings_nsp2_20170627_001';
%     'WU_RE_Gratings_nsp2_20170626_004';
%     'WU_RE_Gratings_nsp2_20170626_003'];

% files = ['WU_LE_Gratings_nsp2_20170626_001';
%          'WU_LE_Gratings_nsp2_20170628_003';
%          'WU_LE_Gratings_nsp2_20170703_001';
%          'WU_LE_Gratings_nsp2_20170705_003';
%          'WU_LE_Gratings_nsp2_20170706_003';
%          'WU_LE_Gratings_nsp2_20170707_001'];

% v1/v2 files
% files = ['WU_RE_Gratings_nsp1_20170705_001_uncut';
%         'WU_RE_Gratings_nsp1_20170706_001_uncut';
%         'WU_RE_Gratings_nsp1_20170707_004_recut';
%         'WU_RE_Gratings_nsp1_20170628_001_uncut';
%         'WU_RE_Gratings_nsp1_20170627_001_uncut';
%         'WU_RE_Gratings_nsp1_20170626_004_recut';
%         'WU_RE_Gratings_nsp1_20170626_003_recut'];

% files = ['WU_LE_Gratings_nsp1_20170626_001_recut';
%     'WU_LE_Gratings_nsp1_20170628_003_uncut';
%     'WU_LE_Gratings_nsp1_20170703_001_uncut';
%     'WU_LE_Gratings_nsp1_20170705_003_uncut';
%     'WU_LE_Gratings_nsp1_20170706_003_uncut';
%     'WU_LE_Gratings_nsp1_20170707_001_recut'];
%%
files = ['WU_RE_Gratings_nsp2_20170705_001_recut';
    'WU_RE_Gratings_nsp2_20170706_001_recut';
    'WU_RE_Gratings_nsp2_20170707_004_recut';
    'WU_RE_Gratings_nsp2_20170628_001_recut';
    'WU_RE_Gratings_nsp2_20170627_001_recut';
    'WU_RE_Gratings_nsp2_20170626_004_recut';
    'WU_RE_Gratings_nsp2_20170626_003_recut';
    
    'WU_LE_Gratings_nsp2_20170626_001_recut';
    'WU_LE_Gratings_nsp2_20170628_003_recut';
    'WU_LE_Gratings_nsp2_20170703_001_recut';
    'WU_LE_Gratings_nsp2_20170705_003_recut';
    'WU_LE_Gratings_nsp2_20170706_003_recut';
    'WU_LE_Gratings_nsp2_20170707_001_recut';
    
    'WU_RE_Gratings_nsp1_20170705_001_uncut';
    'WU_RE_Gratings_nsp1_20170706_001_uncut';
    'WU_RE_Gratings_nsp1_20170707_004_recut';
    'WU_RE_Gratings_nsp1_20170628_001_uncut';
    'WU_RE_Gratings_nsp1_20170627_001_uncut';
    'WU_RE_Gratings_nsp1_20170626_004_recut';
    'WU_RE_Gratings_nsp1_20170626_003_recut';
    
    'WU_LE_Gratings_nsp1_20170626_001_recut';
    'WU_LE_Gratings_nsp1_20170628_003_uncut';
    'WU_LE_Gratings_nsp1_20170703_001_uncut';
    'WU_LE_Gratings_nsp1_20170705_003_uncut';
    'WU_LE_Gratings_nsp1_20170706_003_uncut';
    'WU_LE_Gratings_nsp1_20170707_001_recut'];

%% Verify file and find array map
if location == 1
    % Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
elseif location == 0
    % laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
elseif location == 2
    cd /home/bushnell/ArrayAnalysis/ArrayMaps
end
if ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    
elseif ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    
else
    error('Error: array ID missing or wrong')
end
%%
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
    data.amap   = aMap;
    data.stimTime = [binStimOn,binStimOff];
    %% Define Good channels
    [goodChannels,badChannels] = MwksGetGoodCh(data,filename, 0); % 1 = ignore suppressive channels otherwise set to 0
    data.goodChannels = goodChannels;
    data.badChannels = badChannels;
    %%
    if strfind(filename,'nsp1')
        if location == 2
            cd  /home/bushnell/matFiles/V1/goodCh/
        elseif location == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Gratings/goodCh/
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V1/Gratings/goodCh/
        end
    else
        if location == 2
            cd  /home/bushnell/matFiles/V4/goodCh/
        elseif location  == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Gratings/goodCh/
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V4/Gratings/goodCh/
        end
    end 
    %% save new data matrix
        newName = ['WU','_',array,'_',program,'_',num2str(date),'_',eye,'_','goodCh'];
        save(newName,'data');
end

toc/60



