%
%% Comment out when running as a function
clear all
close all
clc
tic
%% WU Run by day
% file = 'WU_LE_Gratings_nsp2_20170626_001';
% newName = 'WU_LE_Gratings_nsp2_20170626_mean1';

% file = 'WU_LE_Gratings_nsp2_20170628_003';
% newName = 'WU_LE_Gratings_nsp2_20170628_mean1';
% 
% file = 'WU_LE_Gratings_nsp2_20170703_001';
% newName = 'WU_LE_Gratings_nsp2_20170703_mean1';
% 
% file = 'WU_LE_Gratings_nsp2_20170705_003';
% newName = 'WU_LE_Gratings_nsp2_20170705_mean1';
%
% file = 'WU_LE_Gratings_nsp2_20170706_003';
% newName = 'WU_LE_Gratings_nsp2_20170706_mean1';
% 
% file = 'WU_LE_Gratings_nsp2_20170707_001';
% newName = 'WU_LE_Gratings_nsp2_20170707_mean1';
% 
%
%
% file = 'WU_RE_Gratings_nsp2_20170626_003';
% newName = 'WU_RE_Gratings_nsp2_20170626_mean1';
% 
% file = 'WU_RE_Gratings_nsp2_20170626_004';
% newName = 'WU_RE_Gratings_nsp2_20170626_mean2';
%
% file = 'WU_RE_Gratings_nsp2_20170627_001';
% newName = 'WU_RE_Gratings_nsp2_20170627_mean1';
%
% file = 'WU_RE_Gratings_nsp2_20170628_001';
% newName = 'WU_RE_Gratings_nsp2_20170628_mean1';
%
% file = 'WU_RE_Gratings_nsp2_20170705_001';
% newName = 'WU_RE_Gratings_nsp2_20170705_mean1';
%
% file = 'WU_RE_Gratings_nsp2_20170706_001';
% newName = 'WU_RE_Gratings_nsp2_20170706_mean1';
%
% file = 'WU_RE_Gratings_nsp2_20170707_004';
% newName =  'WU_RE_Gratings_nsp2_20170707_mean1';
%% XT

cd '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/V4/Gratings/fittedMats'
%%
location = 2; %0 = laptop 1 = desktop 2 = zemina
startBin = 5;
endBin = 35;
%% Check file, get array map
if location == 1
    % Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
elseif location == 0
    % laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
elseif location == 2
    % Zemina
    cd /home/bushnell/ArrayAnalysis/ArrayMaps
end
if ~isempty(strfind(file(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    
elseif ~isempty(strfind(file(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    
else
    error('Error: array ID missing or wrong')
end
%% load data and extract info
data = load(file);
textName = figTitleName(file);
disp(sprintf('\n analyzing file: %s',textName))

if strfind(file, 'Con')
    [sfs, oris, width, xloc, yloc, numOris, stimOn, stimOff, con] = getMwksGratParameters(data);
else
    [sfs, oris, width, xloc, yloc, numOris, stimOn, stimOff] = getMwksGratParameters(data);
end

binStimOn  = stimOn/10;
binStimOff = stimOff/10;

numChannels = size(data.bins,3);
data.stimTime = [binStimOn,binStimOff];
%% Find responses to each stimulus
    GratStimResp = parseGratStimResp(data,startBin,endBin);
    
    data.stimResps = GratStimResp;

if strfind(file,'nsp1')
    if location == 2
        cd /home/bushnell/matFiles/V1/Gratings/FittedMats/daily
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/daily
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/daily
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/V4/Gratings/FittedMats/daily
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/daily
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/Gratings/FittedMats/daily
    end
end

save(newName,'data');

toc