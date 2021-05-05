
%%
clear
close all
clc
tic

location = 0; %0 = laptop 1 = Desktop 2 = zemina
%%
% WU LE radFreqLoc1 is one file.
% Hopefully radFreqLoc1 is best in terms of locations - that was the set
% where V1/V2 and V4 were collected simultaneously. 

files = {'WU_RE_RadFreqLoc1_nsp2_20170627_002_thresh35_info.mat';
    'WU_RE_RadFreqLoc1_nsp2_20170628_002_thresh35_info.mat'};
newName = 'WU_RE_radFreqLoc1_nsp2_June2017_info';

% files = {    'WU_RE_RadFreqLoc1_nsp1_20170627_002_thresh35_info.mat';              
%     'WU_RE_RadFreqLoc1_nsp1_20170628_002_thresh35_info.mat'};
% newName = 'WU_RE_radFreqLoc1_nsp1_June2017_info';
% 
% files = {    'WU_LE_RadFreqLoc2_nsp2_20170703_003_thresh35_info.mat';              
%     'WU_LE_RadFreqLoc2_nsp2_20170704_005_thresh35_info.mat';              
%     'WU_LE_RadFreqLoc2_nsp2_20170705_005_thresh35_info.mat';              
%     'WU_LE_RadFreqLoc2_nsp2_20170706_004_thresh35_info.mat';              
%     'WU_LE_RadFreqLoc2_nsp2_20170707_002_thresh35_info.mat'};
% newName ='WU_LE_RadFreqLoc2_nsp2_July2017_info';
% 
% files = {'WU_LE_RadFreqLoc2_nsp1_20170703_003_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170705_005_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170706_004_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170707_002_thresh35_info.mat'};
% newName = 'WU_LE_RadFreqLoc2_nsp1_July2017_info';
% 
% files = { 'WU_RE_RadFreqLoc2_nsp2_20170704_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170704_003_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170705_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170706_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170707_005_thresh35_info.mat'};
% newName = 'WU_RE_RadFreqLoc2_nsp2_July2017_info';
% 
% files = {'WU_RE_RadFreqLoc2_nsp1_20170705_002_thresh35_info.mat';              
%     'WU_RE_RadFreqLoc2_nsp1_20170706_002_thresh35_info.mat';              
%     'WU_RE_RadFreqLoc2_nsp1_20170707_005_thresh35_info.mat'};
% newName = 'WU_RE_RadFreqLoc2_nsp1_July2017_info';
%% Extract stimulus information

for fi = 1:size(files,1)
    filename = files{fi};
    load(filename);
   
    if contains(filename,'RE') == 1
        dataT = data.RE;
    elseif contains(filename,'LE') == 1
        dataT = data.LE;
    end
     
    dataComp{fi} = dataT;
end
%% sanity check histograms
stimSpikesCh = [];
blankSpikesCh = [];

% stimSpikes = {};
% blankSpikes = {};

figure(1)
clf
for ses = 1:length(dataComp)
    for ch = 1:96
        s = dataComp{ses}.RFspikeCount{ch}(8:end-3,:);
        stimSpikesCh = vertcat(stimSpikesCh, s);
        
        b = dataComp{ses}.blankSpikeCount{ch}(8:end-3,:);
        blankSpikesCh = vertcat(blankSpikesCh, b);
    end
    stimSpikes = reshape(stimSpikesCh,1,numel(stimSpikesCh));
    blankSpikes = reshape(blankSpikesCh,1,numel(blankSpikesCh));
    
    subplot(2,1,1)
    hold on
    histogram(stimSpikes,'binWidth',2,'normalization','probability','FaceAlpha',0.3)
    title('stimulus reponses')
    ylabel( 'probability')
    xlim([-2 60])
    set(gca,'box','off','tickdir','out','YTick',0:0.1:0.4)
    
    subplot(2,1,2)
    hold on
    histogram(blankSpikes,'binWidth',2,'normalization','probability','FaceAlpha',0.3)
    title('blank spike count')
    ylabel( 'probability')
    xlim([-2 60])
    set(gca,'box','off','tickdir','out','YTick',0:0.1:0.4)
end
%% setup all of the matrices to concatenate the data
bins =     [];
stimOn =   [];
stimOff =  [];
t_stim =   [];
filename = [];

pos_x =    [];
pos_y =    [];
rf =        [];
amplitude = [];
orientation = [];
spatialFrequency = [];
radius = [];
name = [];

RFStimResps = cell(1,96);
RFspikeCount = cell(1,96);
RFzScore = cell(1,96);

blankResps = cell(1,96);
blankSpikeCount = cell(1,96);
blankZscore = cell(1,96);

%%
for i = 1:length(dataComp)
    bT     = dataComp{i}.bins;
    stmOn  = dataComp{i}.stimOn;
    stmOff = dataComp{i}.stimOff;
    tStim  = dataComp{i}.t_stim;
    fName  = dataComp{i}.filename;
    
    xPos = dataComp{i}.pos_x;
    yPos = dataComp{i}.pos_y;
    radF = dataComp{i}.rf;
    amp = dataComp{i}.amplitude;
    ori = dataComp{i}.orientation;
    sf = dataComp{i}.spatialFrequency;
    rad = dataComp{i}.radius;
    nom = dataComp{i}.name;
    
    rfResp = dataComp{i}.RFStimResps;
    bResp = dataComp{i}.blankResps;
    sResp = dataComp{i}.stimResps;
    
    Rsc = dataComp{i}.RFspikeCount;
    bsc = dataComp{i}.blankSpikeCount;
    rz = dataComp{i}.RFzScore;
    bz = dataComp{i}.blankZscore;
    
    bins = cat(1, bins, bT);
    stimOn = [stimOn, stmOn];
    stimOff = [stimOff, stmOff];
    t_stim = [t_stim, tStim];
    filename = cat(1, filename, fName);
    
    pos_x = [pos_x, xPos];
    pos_y = [pos_y, yPos];
    rf = [rf; radF];
    amplitude = [amplitude; amp];
    orientation = [orientation; ori];
    spatialFrequency = [spatialFrequency; sf];
    radius = [radius; rad];
    name = cat(1, name, nom);
    
    rfResp = dataComp{i}.RFStimResps;
    rfSpikes = dataComp{i}.RFspikeCount;
    rfzs = dataComp{i}.RFzScore;
    
    blankR = dataComp{i}.blankResps;
    blankSpikes = dataComp{i}.blankSpikeCount;
    blankzs = dataComp{i}.blankZscore;
    
    for ch = 1:96
        if i == 1
            RFStimResps{ch}(1:7,:) = rfResp{1}(1:7,:);
            RFspikeCount{ch}(1:7,:) = rfSpikes{1}(1:7,:);
            RFzScore{ch}(1:7,:) = rfzs{1}(1:7,:);
            
            blankResps{ch}(1:7,:) = blankR{1}(1:7,:);
            blankSpikeCount{ch}(1:7,:) = blankSpikes{1}(1:7,:);
            blankZscore{ch}(1:7,:) = blankzs{1}(1:7,:);
        end
        RFStimResps{ch} =  vertcat(RFStimResps{ch},rfResp{ch}(8:end-3,:));
        RFspikeCount{ch} =  vertcat(RFspikeCount{ch},rfSpikes{ch}(8:end-3,:));
        RFzScore{ch} =  vertcat(RFzScore{ch},rfzs{ch}(8:end-3,:));
        
        blankResps{ch} =  vertcat(blankResps{ch},blankR{ch}(8:end-3,:));
        blankSpikeCount{ch} =  vertcat(blankSpikeCount{ch},blankSpikes{ch}(8:end-3,:));
        blankZscore{ch} =  vertcat(blankZscore{ch},blankzs{ch}(8:end-3,:));
    end 
end

if exist('data.amap') == 0  
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
    if ~isempty(strfind(files(1,:),'V4')) || ~isempty(strfind(files(1,:),'nsp2'))
        disp 'data recorded from nsp2, V4 array'
        amap = arraymap('SN 1024-001795.cmp');
        
    elseif ~isempty(strfind(files(1,:),'V1')) || ~isempty(strfind(files(1,:),'nsp1'))
        disp 'data recorded from nsp1, V1/V2 array'
        amap = arraymap('SN 1024-001790.cmp');
        
    else
        error('Error: array ID missing or wrong')
    end
    
else
    amap = dataT.amap;
end

%% save new matrix
if strfind(files(1,:),'V1') | strfind(files(1,:),'nsp1')    
    if location == 2
        cd /home/bushnell/matFiles/V1/RadialFrequency/mergedMats/
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/mergedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/mergedMats/
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/V4/RadialFrequency/mergedMats/
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/mergedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/mergedMats/
    end
end
save(newName,'bins','amap','stimOn','stimOff','t_stim','filename',...
             'pos_x','pos_y','rf','amplitude','orientation','spatialFrequency',...
             'radius','name')









