clear
close all
clc
tic
%%
% monks = {
% %      'WU';
% %      'WV';
%      'XT';
%     };
% ez = {
%     'LE';
%     'RE';
%     };
% brArray = {
%     'V4';
%     'V1';
%     };
%%
location = determineComputer;
nameEnd = 'info';
numPerm = 2000;
numBoot = 200;
holdout = 0.9;
saveData = 0;

plotFlag = 0;
failedFiles = {};
failNdx = 0;
 %%
% ndx = 1;
% corNdx = 1;
% filesT = {};
% filesC = {};
% for an = 1:length(monks)
%     monk = monks{an};
%     for ey = 1:length(ez)
%         eye = ez{ey};
%         for ar = 1:length(brArray)
%             area = brArray{ar};
%             %%
%             if location == 0
%                 dataDir = sprintf('~/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/RadialFrequency/%s/',monk,area,eye);
%             else
%                 dataDir = sprintf('/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/RadialFrequency/%s/',monk,area,eye);
%             end
%             
%             cd(dataDir);
%             tmp = dir;
%             %%
%             
%             for t = 1:size(tmp,1)
%                 if contains(tmp(t).name,'.mat') && contains(tmp(t).name,'freq','IgnoreCase',true)
%                     if contains(tmp(t).name,'_og')
%                         % make a list of all of the files that have
%                         % been realigned
%                         filesC{corNdx,1} = tmp(t).name;
%                         corNdx = corNdx+1;
%                     else
%                         % list of un-aligned files
%                         filesT{ndx,1} = tmp(t).name;
%                         ndx = ndx+1;
%                     end
%                 end
%             end
%             
%             for c = 1:length(filesC)
%                 shortName = strrep(filesC{c,1},'_ogcorrupt','');
%                 %remove from the list any _thresh35 files that were
%                 %later realigned.  No reason to run through everything
%                 %on all of them.
%                 filesT(strcmp(shortName,filesT)) = [];
%             end
%             if isempty(filesC)
%                 files = filesT;
%             elseif isempty(filesT)
%                 files = filesC;
%             else
%                 files = cat(1,filesC,filesT);
%             end
%             
%             clear tmp
%         end
%     end
% end
%% Debugging specific files
files = {  
    'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35';
    'WU_RE_RadFreqLoc1_nsp2_20170627_002_thresh35';
    'WU_RE_RadFreqLoc1_nsp2_20170628_002_thresh35';
    'WU_RE_RadFreqLoc1_nsp1_20170627_002_thresh35';
    'WU_RE_RadFreqLoc1_nsp1_20170628_002_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170703_003_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170704_005_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170705_005_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170706_004_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170707_002_thresh35';
    'WU_LE_RadFreqLoc2_nsp1_20170703_003_thresh35';
    'WU_LE_RadFreqLoc2_nsp1_20170705_005_thresh35';
    'WU_LE_RadFreqLoc2_nsp1_20170706_004_thresh35';
    'WU_LE_RadFreqLoc2_nsp1_20170707_002_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170704_002_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170704_003_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170705_002_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170706_002_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170707_005_thresh35';
    'WU_RE_RadFreqLoc2_nsp1_20170705_002_thresh35';
    'WU_RE_RadFreqLoc2_nsp1_20170706_002_thresh35';
    'WU_RE_RadFreqLoc2_nsp1_20170707_005_thresh35';

    'WV_LE_RadFreqHighSF_nsp2_20190313_001_thresh35_ogcorrupt';
    'WV_LE_RadFreqHighSF_nsp2_20190313_002_thresh35_ogcorrupt';
    'WV_LE_RadFreqHighSF_nsp2_20190315_001_thresh35_ogcorrupt';
    'WV_LE_RadFreqHighSF_nsp1_20190313_002_thresh35_ogcorrupt';
    'WV_LE_RadFreqHighSF_nsp1_20190315_001_thresh35_ogcorrupt';
    'WV_LE_RadFreqHighSF_nsp1_20190313_001_thresh35';
    'WV_RE_RadFreqHighSF_nsp1_20190315_002_thresh35_ogcorrupt';
    'WV_RE_RadFreqHighSF_nsp1_20190318_001_thresh35_ogcorrupt';
    'WV_RE_RadFreqHighSF_nsp1_20190318_002_thresh35_ogcorrupt';
    'WV_RE_RadFreqHighSF_nsp1_20190319_001_thresh35_ogcorrupt';
    'WV_RE_RadFreqHighSF_nsp1_20190319_002_thresh35_ogcorrupt';
    'WV_RE_RadFreqHighSF_nsp2_20190315_002_thresh35';
    'WV_RE_RadFreqHighSF_nsp2_20190318_001_thresh35';
    'WV_RE_RadFreqHighSF_nsp2_20190318_002_thresh35';
    'WV_RE_RadFreqHighSF_nsp2_20190319_001_thresh35';
    'WV_RE_RadFreqHighSF_nsp2_20190319_002_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190328_001_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp2_20190328_002_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp2_20190329_001_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp2_20190329_002_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp2_20190401_001_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp2_20190402_001_thresh35_ogcorrupt_info.mat'
    'WV_LE_RadFreqLowSF_nsp1_20190328_001_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp1_20190328_002_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp1_20190329_001_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp1_20190329_002_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp1_20190401_001_thresh35_ogcorrupt';
    'WV_LE_RadFreqLowSF_nsp1_20190402_001_thresh35_ogcorrupt_info.mat'
    'WV_RE_RadFreqLowSF_nsp2_20190320_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190321_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190321_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190322_001_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp2_20190325_002_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp2_20190325_003_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp2_20190327_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190327_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190320_001_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp1_20190321_001_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp1_20190321_002_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp1_20190322_001_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp1_20190325_002_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp1_20190325_003_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp1_20190327_001_thresh35_ogcorrupt';
    'WV_RE_RadFreqLowSF_nsp1_20190327_002_thresh35_ogcorrupt_info.mat'

    'XT_RE_radFreqLowSF_nsp2_20181217_002_thresh35';
    'XT_RE_radFreqLowSF_nsp2_20181217_003_thresh35';
    'XT_RE_radFreqLowSF_nsp2_20181217_004_thresh35';
    'XT_RE_radFreqLowSF_nsp2_20181217_005_thresh35';
    'XT_RE_radFreqLowSF_nsp1_20181217_002_thresh35_ogcorrupt';
    'XT_RE_radFreqLowSF_nsp1_20181217_003_thresh35_ogcorrupt';
    'XT_RE_radFreqLowSF_nsp1_20181217_004_thresh35_ogcorrupt';
    'XT_RE_radFreqLowSF_nsp1_20181217_005_thresh35_ogcorrupt';
    'XT_LE_RadFreqLowSF_nsp2_20181211_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp2_20181211_002_thresh35';
    'XT_LE_RadFreqLowSF_nsp2_20181213_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp2_20181213_002_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181211_001_thresh35_ogcorrupt';
    'XT_LE_RadFreqLowSF_nsp1_20181211_002_thresh35_ogcorrupt';
    'XT_LE_RadFreqLowSF_nsp1_20181213_001_thresh35_ogcorrupt';
    'XT_LE_RadFreqLowSF_nsp1_20181213_002_thresh35_ogcorrupt';
    'XT_RE_radFreqHighSF_nsp2_20181227_001_thresh35';
    'XT_RE_radFreqHighSF_nsp2_20181228_001_thresh35';
    'XT_RE_radFreqHighSF_nsp2_20181228_002_thresh35';
    'XT_RE_radFreqHighSF_nsp2_20181231_001_thresh35';
    'XT_RE_radFreqHighSF_nsp1_20181227_001_thresh35_ogcorrupt';
    'XT_RE_radFreqHighSF_nsp1_20181228_001_thresh35_ogcorrupt';
    'XT_RE_radFreqHighSF_nsp1_20181228_002_thresh35_ogcorrupt';
    'XT_RE_radFreqHighSF_nsp1_20181231_001_thresh35_ogcorrupt';
    'XT_LE_radFreqHighSF_nsp2_20190102_001_thresh35';
    'XT_LE_radFreqHighSF_nsp2_20190102_002_thresh35';
    'XT_LE_radFreqHighSF_nsp2_20190103_001_thresh35';
    'XT_LE_radFreqHighSF_nsp2_20190103_002_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190102_001_thresh35_ogcorrupt';
    'XT_LE_radFreqHighSF_nsp1_20190102_002_thresh35_ogcorrupt';
    'XT_LE_radFreqHighSF_nsp1_20190103_001_thresh35_ogcorrupt';
    'XT_LE_radFreqHighSF_nsp1_20190103_002_thresh35_ogcorrupt';
    'XT_RE_RadFreqLowSFV4_nsp2_20190228_001_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp2_20190228_002_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp2_20190301_001_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp2_20190301_002_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp2_20190304_001_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp1_20190301_002_thresh35_ogcorrupt';
    'XT_RE_RadFreqLowSFV4_nsp1_20190228_001_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp1_20190228_002_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp1_20190301_001_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp1_20190304_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190226_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190226_003_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190227_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190227_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190227_003_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190226_002_thresh35_ogcorrupt';
    'XT_LE_RadFreqLowSFV4_nsp1_20190226_003_thresh35_ogcorrupt';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_001_thresh35_ogcorrupt';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_002_thresh35_ogcorrupt';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_003_thresh35_ogcorrupt';
    'XT_RE_RadFreqHighSFV4_nsp2_20190304_002_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp2_20190305_002_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp2_20190306_001_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp2_20190306_002_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp2_20190306_003_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp2_20190307_001_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp1_20190304_002_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp1_20190305_002_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp1_20190306_001_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp1_20190306_002_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp1_20190307_002_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp2_20190306_003_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp2_20190307_001_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp1_20190306_003_thresh35_ogcorrupt';
    'XT_LE_RadFreqHighSFV4_nsp1_20190307_001_thresh35_ogcorrupt';
    };

%%
ndx = 1;
for fi = 1:length(files)
%     try
        %% get basic information about what was run overall, and for each trial.
        if ~isempty(files{fi})
        filename = files{fi};
        dataT = load(filename);
        fprintf('*** Running file %d/%d ***\n',fi,length(files))
        
        tmp = strsplit(filename,'_');
        dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3}; dataT.array = tmp{4}; dataT.date2 = tmp{5};
        dataT.runNum = tmp{6};  dataT.date = convertDate(dataT.date2); % dataT.reThreshold = tmp{7};
        
        if strcmp(dataT.array, 'nsp1')
            dataT.array = 'V1';
        elseif strcmp(dataT.array, 'nsp2')
            dataT.array = 'V4';
        end
        
        % all of the other unique parameters are stored in the file name and need
        % to be parsed out.
        for i = 1:length(dataT.filename)
            [name, rf, rad, mod, ori, sf] = parseRFName(dataT.filename(i,:));
            
            dataT.rf(i,1)  = rf;
            dataT.amplitude(i,1) = mod;
            dataT.orientation(i,1) = ori;
            dataT.spatialFrequency(i,1) = sf;
            dataT.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
            name  = char(name);
            dataT.name{i,1} = name;
        end
        numCh = size(dataT.bins,3);
        
        % Make all of the vectors the same orientations
        dataT.pos_x = dataT.pos_x';
        dataT.pos_y = dataT.pos_y';
        dataT.size_x = dataT.size_x';
        
        dataT.amap = getBlackrockArrayMap(files(fi,:));
        %% get spike counts and z scores
        [dataT.RFStimResps,dataT.blankResps, dataT.stimResps] = parseRadFreqStimResp(dataT); 
        [dataT.RFspikeCount,dataT.blankSpikeCount,dataT.RFzScore,dataT.blankZscore] = getRadFreqSpikeCountZscore2(dataT);
        %% save data    
        if location == 1
            outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',dataT.array);
        elseif location == 0
            outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',dataT.array);
        end
        
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
        
        if contains(filename,'LE')
            data.LE = dataT;
            data.RE = [];
        else
            data.RE = dataT;
            data.LE = [];
        end
        
        fname2 = strrep(filename,'.mat','');
        saveName = [outputDir fname2 '_' nameEnd '.mat'];
        save(saveName,'data');
        fprintf('%s saved\n\n',saveName)
%     catch ME
%         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
%         failNdx = failNdx+1;
%         failedFiles{failNdx,1} = filename;
%         failedME{failNdx,1} = ME;
%     end
        end
end

toc/60