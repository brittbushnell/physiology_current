
%%
clear
close all
tic

location = 0; %0 = laptop 1 = Desktop 2 = zemina
%% WU
% WU LE radFreqLoc1 is one file.
% Hopefully radFreqLoc1 is best in terms of locations - that was the set
% where V1/V2 and V4 were collected simultaneously.

% files = {'WU_RE_RadFreqLoc1_nsp2_20170627_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc1_nsp2_20170628_002_thresh35_info.mat'};
% newName = 'WU_RE_radFreqLoc1_nsp2_June2017_info';

% files = {'WU_RE_RadFreqLoc1_nsp1_20170627_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc1_nsp1_20170628_002_thresh35_info.mat'};
% newName = 'WU_RE_radFreqLoc1_nsp1_June2017_info';

% files = {'WU_LE_RadFreqLoc2_nsp2_20170703_003_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp2_20170704_005_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp2_20170705_005_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp2_20170706_004_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp2_20170707_002_thresh35_info.mat'};
% newName ='WU_LE_RadFreqLoc2_nsp2_July2017_info';

% files = {'WU_LE_RadFreqLoc2_nsp1_20170703_003_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170705_005_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170706_004_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170707_002_thresh35_info.mat'};
% newName = 'WU_LE_RadFreqLoc2_nsp1_July2017_info';

% files = {'WU_RE_RadFreqLoc2_nsp2_20170704_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170704_003_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170705_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170706_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170707_005_thresh35_info.mat'};
% newName = 'WU_RE_RadFreqLoc2_nsp2_July2017_info';

% files = {'WU_RE_RadFreqLoc2_nsp1_20170705_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp1_20170706_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp1_20170707_005_thresh35_info.mat'};
% newName = 'WU_RE_RadFreqLoc2_nsp1_July2017_info';
%% WV

%  files = {%'WV_LE_RadFreqHighSF_nsp2_20190313_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqHighSF_nsp2_20190313_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqHighSF_nsp2_20190315_001_thresh35_ogcorrupt_info.mat'};
% newName = 'WV_LE_RadFreqHighSF_nsp2_March2019';

% files = {%'WV_LE_RadFreqHighSF_nsp1_20190313_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqHighSF_nsp1_20190315_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqHighSF_nsp1_20190313_001_thresh35_info.mat';};
% newName = 'WV_LE_RadFreqHighSF_nsp1_March2019';

% files = {%'WV_RE_RadFreqHighSF_nsp1_20190315_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqHighSF_nsp1_20190318_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqHighSF_nsp1_20190318_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqHighSF_nsp1_20190319_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqHighSF_nsp1_20190319_002_thresh35_ogcorrupt_info.mat'};
% newName = 'WV_RE_RadFreqHighSF_nsp1_March2019';

% files = {%'WV_RE_RadFreqHighSF_nsp2_20190315_002_thresh35_info.mat';
%     'WV_RE_RadFreqHighSF_nsp2_20190318_001_thresh35_info.mat';
%     'WV_RE_RadFreqHighSF_nsp2_20190318_002_thresh35_info.mat';
%     'WV_RE_RadFreqHighSF_nsp2_20190319_001_thresh35_info.mat';
%     'WV_RE_RadFreqHighSF_nsp2_20190319_002_thresh35_info.mat'};
% newName = 'WV_RE_RadFreqHighSF_nsp2_March2019';

% files = {%'WV_LE_RadFreqLowSF_nsp2_20190328_001_thresh35_ogcorrupt_info.mat';
%     %'WV_LE_RadFreqLowSF_nsp2_20190328_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190329_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190329_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190401_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190402_001_thresh35_ogcorrupt_info.mat'};
% newName = 'WV_LE_RadFreqLowSF_nsp2_March2019';

% files = {%'WV_LE_RadFreqLowSF_nsp1_20190328_001_thresh35_ogcorrupt_info.mat';
%     %'WV_LE_RadFreqLowSF_nsp1_20190328_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp1_20190329_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp1_20190329_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp1_20190401_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp1_20190402_001_thresh35_ogcorrupt_info.mat'};
% newName = 'WV_LE_RadFreqLowSF_nsp1_March2019';

% files = {'WV_RE_RadFreqLowSF_nsp2_20190320_001_thresh35_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190321_001_thresh35_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190321_002_thresh35_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190322_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190325_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190325_003_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190327_001_thresh35_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190327_002_thresh35_info.mat'};
% newName = 'WV_RE_RadFreqLowSF_nsp2_March2019';

% files = {'WV_RE_RadFreqLowSF_nsp1_20190320_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190321_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190321_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190322_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190325_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190325_003_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190327_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190327_002_thresh35_ogcorrupt_info.mat'};
% newName = 'WV_RE_RadFreqLowSF_nsp1_March2019';
%% XT
files = {'XT_RE_radFreqLowSF_nsp2_20181217_002_thresh35_info.mat';
'XT_RE_radFreqLowSF_nsp2_20181217_003_thresh35_info.mat';
'XT_RE_radFreqLowSF_nsp2_20181217_004_thresh35_info.mat';
'XT_RE_radFreqLowSF_nsp2_20181217_005_thresh35_info.mat';
};
newName = 'XT_RE_radFreqLowSF_nsp2_Dec2019_info';

% files = {'XT_RE_radFreqLowSF_nsp1_20181217_002_thresh35_ogcorrupt_info.mat';
% 'XT_RE_radFreqLowSF_nsp1_20181217_003_thresh35_ogcorrupt_info.mat';
% 'XT_RE_radFreqLowSF_nsp1_20181217_004_thresh35_ogcorrupt_info.mat';
% 'XT_RE_radFreqLowSF_nsp1_20181217_005_thresh35_ogcorrupt_info.mat';
% };
% newName = 'XT_RE_radFreqLowSF_nsp1_Dec2019_info';

% files = {
% 'XT_LE_RadFreqLowSF_nsp2_20181211_001_thresh35_info.mat';
% 'XT_LE_RadFreqLowSF_nsp2_20181211_002_thresh35_info.mat';
% 'XT_LE_RadFreqLowSF_nsp2_20181213_001_thresh35_info.mat';
% 'XT_LE_RadFreqLowSF_nsp2_20181213_002_thresh35_info.mat';
%     };
% newName = 'XT_LE_RadFreqLowSF_nsp2_Dec2018_info';

% files = {
% 'XT_LE_RadFreqLowSF_nsp1_20181211_001_thresh35_ogcorrupt_info.mat';
% 'XT_LE_RadFreqLowSF_nsp1_20181211_002_thresh35_ogcorrupt_info.mat';
% 'XT_LE_RadFreqLowSF_nsp1_20181213_001_thresh35_ogcorrupt_info.mat';
% 'XT_LE_RadFreqLowSF_nsp1_20181213_002_thresh35_ogcorrupt_info.mat';
% };
% newName = 'XT_LE_RadFreqLowSF_nsp1_Dec2018_info';

% files = {'XT_RE_radFreqHighSF_nsp2_20181227_001_thresh35_info.mat';
% 'XT_RE_radFreqHighSF_nsp2_20181228_001_thresh35_info.mat';
% 'XT_RE_radFreqHighSF_nsp2_20181228_002_thresh35_info.mat';
% 'XT_RE_radFreqHighSF_nsp2_20181231_001_thresh35_info.mat';
% };
% newName = 'XT_RE_radFreqHighSF_nsp2_Dec2018_info';

% files = {'XT_RE_radFreqHighSF_nsp1_20181227_001_thresh35_ogcorrupt_info.mat';
% 'XT_RE_radFreqHighSF_nsp1_20181228_001_thresh35_ogcorrupt_info.mat';
% 'XT_RE_radFreqHighSF_nsp1_20181228_002_thresh35_ogcorrupt_info.mat';
% 'XT_RE_radFreqHighSF_nsp1_20181231_001_thresh35_ogcorrupt_info.mat';
% };
% newName = 'XT_RE_radFreqHighSF_nsp1_Dec2018_info';

% files = {'XT_LE_radFreqHighSF_nsp2_20190102_001_thresh35_info.mat';
% 'XT_LE_radFreqHighSF_nsp2_20190102_002_thresh35_info.mat';
% 'XT_LE_radFreqHighSF_nsp2_20190103_001_thresh35_info.mat';
% 'XT_LE_radFreqHighSF_nsp2_20190103_002_thresh35_info.mat';
% };
% newName = 'XT_LE_radFreqHighSF_nsp2_Jan2019_info';

% files = {'XT_LE_radFreqHighSF_nsp1_20190102_001_thresh35_ogcorrupt_info.mat';
% 'XT_LE_radFreqHighSF_nsp1_20190102_002_thresh35_ogcorrupt_info.mat';
% 'XT_LE_radFreqHighSF_nsp1_20190103_001_thresh35_ogcorrupt_info.mat';
% 'XT_LE_radFreqHighSF_nsp1_20190103_002_thresh35_ogcorrupt_info.mat';
% };
% newName = 'XT_LE_radFreqHighSF_nsp1_Jan2019_info';

% files = {'XT_RE_RadFreqLowSFV4_nsp2_20190228_001_thresh35_info.mat';
% % 'XT_RE_RadFreqLowSFV4_nsp2_20190228_002_thresh35_info.mat';
% 'XT_RE_RadFreqLowSFV4_nsp2_20190301_001_thresh35_info.mat';
% 'XT_RE_RadFreqLowSFV4_nsp2_20190301_002_thresh35_info.mat';
% 'XT_RE_RadFreqLowSFV4_nsp2_20190304_001_thresh35_info.mat';
% };
% newName = 'XT_RE_RadFreqLowSFV4_nsp2_Feb2019_info';

% files = {'XT_RE_RadFreqLowSFV4_nsp1_20190301_002_thresh35_ogcorrupt_info.mat';
% 'XT_RE_RadFreqLowSFV4_nsp1_20190228_001_thresh35_info.mat';
% % 'XT_RE_RadFreqLowSFV4_nsp1_20190228_002_thresh35_info.mat';
% 'XT_RE_RadFreqLowSFV4_nsp1_20190301_001_thresh35_info.mat';
% 'XT_RE_RadFreqLowSFV4_nsp1_20190304_001_thresh35_info.mat';
% };
% newName = 'XT_RE_RadFreqLowSFV4_nsp1_Feb2019_info';

% files = {'XT_LE_RadFreqLowSFV4_nsp2_20190226_002_thresh35_info.mat';
% % 'XT_LE_RadFreqLowSFV4_nsp2_20190226_003_thresh35_info.mat';
% 'XT_LE_RadFreqLowSFV4_nsp2_20190227_001_thresh35_info.mat';
% 'XT_LE_RadFreqLowSFV4_nsp2_20190227_002_thresh35_info.mat';
% 'XT_LE_RadFreqLowSFV4_nsp2_20190227_003_thresh35_info.mat';
% };
% newName = 'XT_LE_RadFreqLowSFV4_nsp2_Feb2019_info';

% files = {'XT_LE_RadFreqLowSFV4_nsp1_20190226_002_thresh35_ogcorrupt_info.mat';
% % 'XT_LE_RadFreqLowSFV4_nsp1_20190226_003_thresh35_ogcorrupt_info.mat';
% 'XT_LE_RadFreqLowSFV4_nsp1_20190227_001_thresh35_ogcorrupt_info.mat';
% 'XT_LE_RadFreqLowSFV4_nsp1_20190227_002_thresh35_ogcorrupt_info.mat';
% 'XT_LE_RadFreqLowSFV4_nsp1_20190227_003_thresh35_ogcorrupt_info.mat';
% };
% newName = 'XT_LE_RadFreqLowSFV4_nsp1_Feb2019_info';

files = {
'XT_RE_RadFreqHighSFV4_nsp2_20190304_002_thresh35_info.mat';
'XT_RE_RadFreqHighSFV4_nsp2_20190305_002_thresh35_info.mat';
'XT_RE_RadFreqHighSFV4_nsp2_20190306_001_thresh35_info.mat';
'XT_RE_RadFreqHighSFV4_nsp2_20190306_002_thresh35_info.mat';
};
newName = 'XT_RE_RadFreqHighSFV4_nsp2_March2019_info';

% files = {'XT_RE_RadFreqHighSFV4_nsp1_20190304_002_thresh35_info.mat';
% 'XT_RE_RadFreqHighSFV4_nsp1_20190305_002_thresh35_info.mat';
% 'XT_RE_RadFreqHighSFV4_nsp1_20190306_001_thresh35_info.mat';
% 'XT_RE_RadFreqHighSFV4_nsp1_20190306_002_thresh35_info.mat';
% };
% newName = 'XT_RE_RadFreqHighSFV4_nsp1_March2019_info';

% files = {'XT_LE_RadFreqHighSFV4_nsp2_20190306_003_thresh35_info.mat';
% 'XT_LE_RadFreqHighSFV4_nsp2_20190307_001_thresh35_info.mat';
% };
% newName = 'XT_LE_RadFreqHighSFV4_nsp2_March2019_info';

% files = {'XT_LE_RadFreqHighSFV4_nsp1_20190306_003_thresh35_ogcorrupt_info.mat';
% 'XT_LE_RadFreqHighSFV4_nsp1_20190307_001_thresh35_ogcorrupt_info.mat';
% };
% newName = 'XT_LE_RadFreqHighSFV4_nsp1_March2019_info';

%% Extract stimulus information

for fi = 1:size(files,1)
    filename = files{fi};
    load(filename);

    if contains(filename,'RE') == 1
        dataT = data.RE;
    elseif contains(filename,'LE') == 1
        dataT = data.LE;
    end
    unique(dataT.pos_y)
    dataComp{fi} = dataT;
end
%% sanity check histograms
stimSpikesCh = [];
blankSpikesCh = [];

% stimSpikes = {};
% blankSpikes = {};

figure%(1)
clf
for ses = 1:length(dataComp)
    for ch = 1:96
        s = dataComp{ses}.RFspikeCount{ch}(8:end,:);
        stimSpikesCh = vertcat(stimSpikesCh, s);

        b = dataComp{ses}.blankSpikeCount{ch}(8:end,:);

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
rf =       [];
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

    pos_x = vertcat(pos_x, xPos);
    pos_y = vertcat(pos_y, yPos);
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
        RFStimResps{ch} =  vertcat(RFStimResps{ch},rfResp{ch}(8:end,:));
        RFspikeCount{ch} =  vertcat(RFspikeCount{ch},rfSpikes{ch}(8:end,:));
        RFzScore{ch} =  vertcat(RFzScore{ch},rfzs{ch}(8:end,:));

        blankResps{ch} =  vertcat(blankResps{ch},blankR{ch}(8:end,:));
        blankSpikeCount{ch} =  vertcat(blankSpikeCount{ch},blankSpikes{ch}(8:end,:));
        blankZscore{ch} =  vertcat(blankZscore{ch},blankzs{ch}(8:end,:));
    end

end


animal = dataComp{1}.animal;
eye = dataComp{1}.eye;
programID = dataComp{1}.programID;
array = dataComp{1}.array;
amap = dataComp{1}.amap;
%% save new matrix
% if location  == 1
%     saveDir = sprintf('/users/bushnell/bushnell-local/Dropbox/ArrayData/matFiles/%s/RadialFrequency/mergedMats/',dataT.array);
% elseif location  == 0
   saveDir = sprintf('~/Dropbox/ArrayData/matFiles/%s/RadialFrequency/mergedMats/',dataT.array);
% end

if ~exist(saveDir,'dir')
    mkdir(saveDir)
end
cd(saveDir);

save(newName,'animal','eye','array','programID','amap','bins','stimOn','stimOff','t_stim','filename',...
             'pos_x','pos_y','rf','amplitude','orientation','spatialFrequency',...
             'radius','name','RFStimResps','RFspikeCount','RFzScore','blankResps','blankSpikeCount','blankZscore')

fprintf('file %s done \n', newName)
