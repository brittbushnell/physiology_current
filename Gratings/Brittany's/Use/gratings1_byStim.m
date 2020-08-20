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
% file = 'XT_RE_gratings_nsp1_20181028_003';
% newName = 'XT_RE_gratings_V1_20181028_means';

%% 
%file = 'WV_LE_Gratings_nsp2_20190205_003';
%file = 'WV_RE_Gratings_nsp2_20190205_002';

%newName = 'WV_RE_Gratings_V4_20190205_means';

% file = 'WV_LE_Gratings_nsp1_20190205_003';
% newName = 'WV_LE_Gratings_V1_20190205_means';

file = 'WV_RE_Gratings_nsp1_20190205_002';
newName = 'WV_RE_Gratings_V1_20190205_means';

%%
location = 1; %0 = laptop 1 = desktop 2 = zemina
startBin = 5;
endBin = 35;
%% Check file, get array map
aMap = getBlackrockArrayMap(file);
%% load data and extract info
data = load(file);
textName = figTitleName(file);
disp(sprintf('\n analyzing file: %s',textName))
data.amap = aMap;

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