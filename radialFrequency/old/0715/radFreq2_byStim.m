% radFreq2_byStim
%
% Step 2 of the radial frequency analysis pipeline, this program takes the
% responses of either a single day or a combination of days and creates and
% adds the stimResp and blankResp matrices to the data structure. It also
% combines LE and RE data into one .mat file
%
% June 1, 2018 Brittany Bushnell
%%
clear all
close all
clc
tic
%%
% files = ['WU_RE_RadialFrequency_V4_3day_goodCh'; 'WU_LE_RadialFrequency_V4_3day_goodCh'];
% newName = 'WU_RadialFrequency_V4_3day_byStim';
files = ['WU_LE_RadFreqLoc2_nsp2_20170707_002_goodCh';'WU_RE_RadFreqLoc2_nsp2_20170707_005_goodCh'];
newName = 'WU_RadFreqLoc2_V4_20170707_byStim';

location = 1; %0 = laptop 1 = desktop 2 = zemina
startBin = 5;
endBin = 35;
reject = 0; % if 1, will run new version of stim parser to automatically reject trials with artifacts
%% load data and extract info
for fi = 1:size(files,1)
    filename = files(fi,:);
    load(filename);
%     textName = figTitleName(filename);
%     fprintf('\n analyzing file: %s',textName)
    
    numChannels = size(data.bins,3);

    if reject == 0
        [RFStimResp,blankResps] = parseRadFreqStimResp(data,startBin,endBin);
    else
        [RFStimResp,blankResps] = parseRadFreqStimResp2(data,startBin,endBin);
    end

    
    data.stimResps = RFStimResp;
    data.blankResps = blankResps;  
    
    if strfind(filename,'RE')
        REdata = data;
    elseif strfind(filename,'LE')
        LEdata = data;
    else
        error('File name does not have an eye')
    end
end
%%
if strfind(filename,'nsp1') | strfind(filename,'V1')
    if location == 2
        cd /home/bushnell/matFiles/V1/RadialFrequency/byStim
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/byStim
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/byStim
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/V4/RadialFrequency/byStim
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/byStim
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/byStim
    end
end
if size(files,1) > 1
    save(newName,'REdata','LEdata')
else
    if strfind(files,'RE')
        save(newName,'REdata')
    elseif strfind(files,'LE')
        save(newName,'LEdata')
    end
end

toc





