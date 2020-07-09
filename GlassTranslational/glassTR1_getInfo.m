% Use this program to go through single sessions that threw errors in the
% big program that goes through each session.

clear all
close all
clc
fprintf('running glassTR1_getInfo \n')
tic

%%
% XT
% files = {
%     'XT_RE_GlassTR_nsp2_20190125_001';...
%     'XT_RE_GlassTR_nsp2_20190125_002';...
%     'XT_RE_GlassTR_nsp2_20190125_003';...
%     'XT_RE_GlassTR_nsp2_20190125_004';...
%     'XT_RE_GlassTR_nsp2_20190125_005';...
%     'XT_RE_GlassTR_nsp2_20190128_001';...
%     'XT_RE_GlassTR_nsp2_20190128_002';...
%
%     'XT_LE_GlassTR_nsp2_20190130_001';...
%     'XT_LE_GlassTR_nsp2_20190130_002';...
%     'XT_LE_GlassTR_nsp2_20190130_003';...
%     'XT_LE_GlassTR_nsp2_20190130_004';...
%     'XT_LE_GlassTR_nsp2_20190131_001';...
%
%     'XT_RE_GlassTRCoh_nsp2_20190322_002';...
%     'XT_RE_GlassTRCoh_nsp2_20190322_003';...
%     'XT_RE_GlassTRCoh_nsp2_20190322_004';...
%     'XT_RE_GlassTRCoh_nsp2_20190324_002';...
%     'XT_RE_GlassTRCoh_nsp2_20190324_003';...
%     'XT_RE_GlassTRCoh_nsp2_20190324_004';...
%     'XT_LE_GlassTRCoh_nsp2_20190325_005';...
%     % V1
%     'XT_RE_GlassTR_nsp1_20190125_001';...
%     'XT_RE_GlassTR_nsp1_20190125_002';...
%     'XT_RE_GlassTR_nsp1_20190125_003';...
%     'XT_RE_GlassTR_nsp1_20190125_004';...
%     'XT_RE_GlassTR_nsp1_20190125_005';...
%     'XT_RE_GlassTR_nsp1_20190128_001';...
%     'XT_RE_GlassTR_nsp1_20190128_002';...
%
%     'XT_LE_GlassTR_nsp1_20190130_001';...
%     'XT_LE_GlassTR_nsp1_20190130_002';...
%     'XT_LE_GlassTR_nsp1_20190130_003';...
%     'XT_LE_GlassTR_nsp1_20190130_004';...
%     'XT_LE_GlassTR_nsp1_20190131_001';...
%
%     'XT_RE_GlassTRCoh_nsp1_20190322_002';...
%     'XT_RE_GlassTRCoh_nsp1_20190322_003';...
%     'XT_RE_GlassTRCoh_nsp1_20190322_004';...
%     'XT_RE_GlassTRCoh_nsp1_20190324_002';...
%     'XT_RE_GlassTRCoh_nsp1_20190324_003';...
%     'XT_RE_GlassTRCoh_nsp1_20190324_004';...
%     'XT_LE_GlassTRCoh_nsp1_20190325_005';...
%
%     % WV
%     'WV_RE_glassTRCoh_nsp2_20190405_002';...
%     'WV_RE_glassTRCoh_nsp2_20190408_001';...
%     'WV_RE_glassTRCoh_nsp2_20190409_001';...
%     'WV_RE_glassTRCoh_nsp2_20190409_002';...
%     'WV_RE_glassTRCoh_nsp2_20190410_001';...
%     'WV_RE_glassTRCoh_nsp2_20190410_002';...
%
%     'WV_LE_glassTRCoh_nsp2_20190411_001';...
%     'WV_LE_glassTRCoh_nsp2_20190412_001';...
%     'WV_LE_glassTRCoh_nsp2_20190415_001';...
%     'WV_LE_glassTRCoh_nsp2_20190415_002';...
%     'WV_LE_glassTRCoh_nsp2_20190416_001';...
%     'WV_LE_glassTRCoh_nsp2_20190416_002';...
%     'WV_LE_glassTRCoh_nsp2_20190416_003';...
%     'WV_LE_glassTRCoh_nsp2_20190417_001';...
%     'WV_LE_glassTRCoh_nsp2_20190417_002';...
%
%     % V1
%     'WV_RE_glassTRCoh_nsp1_20190405_002';...
%     'WV_RE_glassTRCoh_nsp1_20190408_001';...
%     'WV_RE_glassTRCoh_nsp1_20190409_001';...
%     'WV_RE_glassTRCoh_nsp1_20190409_002';...
%     'WV_RE_glassTRCoh_nsp1_20190410_001';...
%     'WV_RE_glassTRCoh_nsp1_20190410_002';...
%
%     'WV_LE_glassTRCoh_nsp1_20190411_001';...
%     'WV_LE_glassTRCoh_nsp1_20190412_001';...
%     'WV_LE_glassTRCoh_nsp1_20190415_001';...
%     'WV_LE_glassTRCoh_nsp1_20190415_002';...
%     'WV_LE_glassTRCoh_nsp1_20190416_001';...
%     'WV_LE_glassTRCoh_nsp1_20190416_002';...
%     'WV_LE_glassTRCoh_nsp1_20190416_003';...
%     'WV_LE_glassTRCoh_nsp1_20190417_001';...
%     'WV_LE_glassTRCoh_nsp1_20190417_002';...
%
% WU
%     'WU_RE_GlassTR_nsp2_20170829_001';...
%     'WU_RE_GlassTR_nsp2_20170828_003';...
%     'WU_RE_GlassTR_nsp2_20170828_002';...
%     'WU_RE_GlassTR_nsp2_20170825_001';...
%
%     'WU_LE_GlassTR_nsp2_20170825_002';...
%     'WU_LE_GlassTR_nsp2_20170824_001';
%
%     %V1
%     'WU_RE_GlassTR_nsp1_20170829_001';...
%     'WU_RE_GlassTR_nsp1_20170828_003';...
%     'WU_RE_GlassTR_nsp1_20170828_002';...
%     'WU_RE_GlassTR_nsp1_20170825_001';...
%
%     'WU_LE_GlassTR_nsp1_20170825_002';...
%     'WU_LE_GlassTR_nsp1_20170824_001'

%    'XT_RE_GlassTR_nsp2_20190125_all';
%    'XT_RE_GlassTR_nsp2_20190128_all';
%    'XT_LE_GlassTR_nsp2_20190130_all';
%
%    'XT_RE_GlassTR_nsp1_20190125_all';
%    'XT_RE_GlassTR_nsp1_20190128_all';
%    'XT_LE_GlassTR_nsp1_20190130_all';
%
%    'XT_RE_GlassTRCoh_nsp2_20190322_all';
%    'XT_RE_GlassTRCoh_nsp2_20190324_all';
%    'XT_RE_GlassTRCoh_nsp1_20190322_all';
%    'XT_RE_GlassTRCoh_nsp1_20190324_all';
%
%    'WV_RE_GlassTRCoh_nsp2_20190409_all';
%    'WV_RE_GlassTRCoh_nsp2_20190410_all';
%
%    'WV_LE_GlassTRCoh_nsp2_20190415_all';
%    'WV_LE_glassTRCoh_nsp2_20190416_all';
%     'WV_LE_GlassTRCoh_nsp2_20190417_all';
%
%     'WV_RE_GlassTRCoh_nsp1_20190409_all';
%     'WV_RE_GlassTRCoh_nsp1_20190410_all';
%
%    'WV_LE_GlassTRCoh_nsp1_20190415_all';
%    'WV_LE_glassTRCoh_nsp1_20190416_all';
%    'WV_LE_GlassTRCoh_nsp1_20190417_all';
%%
files = {
    %     'WU_LE_GlassTR_nsp2_20170825_002_thresh30'
    %     'WU_LE_GlassTR_nsp2_20170825_002_thresh35'
    %     'WU_LE_GlassTR_nsp2_20170825_002_thresh40'
    %     'WU_LE_GlassTR_nsp2_20170825_002_thresh45'
    
    %       'WU_RE_GlassTR_nsp2_20170828_all';...
    %       'WU_LE_GlassTR_nsp2_20170825_002';...
    %       'WU_RE_GlassTR_nsp1_20170828_all';...
    %       'WU_LE_GlassTR_nsp1_20170825_002';...
    
    %'WU_LE_GlassTR_nsp2_20170825_002_thresh35';
    %'WU_LE_GlassTR_nsp2_20170825_002_thresh35_pyParse';...
    'WU_LE_GlassTR_nsp2_20170825_002_thresh35_matParsed';...
    %'WU_LE_GlassTR_nsp2_20170825_002';...
    };
%%
nameEnd = 'vers2';
%%

startMean = 5;
endMean = 15;
startBin = 1;
endBin = 35;

numBoot = 2000;
%%

location = determineComputer;
failedFiles = {};
failNdx = 1;
%%
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %   try
    aMap = getBlackrockArrayMap(files(1,:));
    dataT = load(files{fi});
    
    filename = files{fi};
    nChan = 96;
    tmp = strsplit(filename,'_');    

    % extract information about what was run from file name. 
    if length(tmp) == 6
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum] = deal(tmp{:});
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        dataT.date = convertDate(dataT.date2);
      
    elseif length(tmp) == 7 % file was rerun with different thresholds and cleaned up
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2, dataT.runNum, threshTmp] = deal(tmp{:});
        threshT2 = strsplit(threshTmp,{'thresh','.'});
        thrsh = threshT2{2};
        dataT.threshold = str2num(thrsh)/10;
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        dataT.date = convertDate(dataT.date2);
      
    elseif length(tmp) == 8
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2, dataT.runNum,threshTmp,dataT.parser] = deal(tmp{:});
        threshT2 = strsplit(threshTmp,{'thresh','.'});
        thrsh = threshT2{2};
        dataT.threshold = str2num(thrsh)/10;
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        dataT.date = convertDate(dataT.date2);
      
    else
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2] = deal(tmp{:});
        dataT.date = dataT.date2;
       
    end
    
    ndx = 1;
    for i = 1:size(dataT.filename,1)
        [type, numDots, dx, coh, sample] = parseGlassName(dataT.filename(i,:));
        %  type: numeric versions of the first letter of the pattern type
        %     0:  noise
        %     1: concentric
        %     2: radial
        %     3: translational
        %     100:blank
        dataT.type(1,ndx)    = type;
        dataT.numDots(1,ndx) = numDots;
        dataT.dx(1,ndx)      = dx;
        dataT.coh(1,ndx)     = coh;
        dataT.sample(1,ndx)  = sample;
        ndx = ndx+1;
    end
    
    [numOris,numDots,numDxs,numCoh,numSamp,oris,dots,dxs,coherences,samples] = getGlassTRParameters(dataT);
    dataT.stimOrder = getStimPresentationOrder(dataT);
    %%
    if numDots > 2 %contains(filename,'WU') % remove all the extra parameters from WU's files.
        dataT = GlassRemoveLowDx(dataT);
        dataT = GlassRemoveLowDots(dataT);
        
        % runnign twice becuase things get deleted when removing
        if length(tmp) == 6
            [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum] = deal(tmp{:});
            % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
            dataT.date = convertDate(dataT.date2);
            
            dataT.amap = aMap;
        elseif length(tmp) == 7 % file was rerun with different thresholds and cleaned up
            [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2, dataT.runNum, threshTmp] = deal(tmp{:});
            threshT2 = strsplit(threshTmp,{'thresh','.'});
            thrsh = threshT2{2};
            dataT.threshold = str2num(thrsh)/10;
            dataT.amap = aMap;
            % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
            dataT.date = convertDate(dataT.date2);
            
        elseif length(tmp) == 8
            [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2, dataT.runNum,threshTmp,dataT.parser] = deal(tmp{:});
            threshT2 = strsplit(threshTmp,{'thresh','.'});
            thrsh = threshT2{2};
            dataT.threshold = str2num(thrsh)/10;
            dataT.amap = aMap;
            % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
            dataT.date = convertDate(dataT.date2);
          
        else
            [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2] = deal(tmp{:});
            dataT.date = dataT.date2;
            hasSlash = 0;
            dataT.amap = aMap;
        end
    end
    
    if strcmp(dataT.array, 'nsp1')
        dataT.array = 'V1';
    elseif strcmp(dataT.array, 'nsp2')
        dataT.array = 'V4';
    end
    
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',dataT.array);
    elseif location == 3
        outputDir = sprintf('~/matFiles/%s/Parsed/',dataT.array);
    end
    %% make structures for each eye and save .mat file
    
    if contains(filename,'LE')
        data.LE = dataT;
        data.RE = [];
    else
        data.RE = dataT;
        data.LE = [];
    end
    
    saveName = [outputDir filename '_' nameEnd '.mat'];
    save(saveName,'data');
    %fprintf('%s saved\n', saveName)
    %     catch ME
    %         fprintf('\n Error message: %s \n',ME.message)
    %         failedFiles{failNdx} = filename;
    %         failedCause{failNdx} = ME.identifier;
    %         failNdx = failNdx+1;
    %     end
end
%failedFiles
toc