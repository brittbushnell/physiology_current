% mapping1_getInfo3
% Likely the exact same as _getInfo2, but going through the pipeline step
% by step to see what's going on with the coordinate space.

%%
clear all
close all
clc
tic
%%
files = {
    'XT_LE_mapNoiseRight_nsp2_20181120_001_thresh35';
    'XT_LE_mapNoiseRight_nsp2_20181120_002_thresh35';
    'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35'
    };
%%
nameEnd = 'info4';
plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
for fi = 1:length(files)
    
    %% Get basic information about experiments
    %     try
    filename = files{fi};
    dataT = load(filename);
    filename = strrep(filename,'.mat','');
    
    fprintf('\n#### analyzing file %d of %d ####\n',fi,length(files))
    
    dataT.amap = getBlackrockArrayMap(filename);
    tmp = strsplit(filename,'_');
    dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3};
    array = tmp{4}; dataT.date2 = tmp{5};
    dataT.runNum = tmp{6}; dataT.reThreshold = tmp{7};
    dataT.date = convertDate(dataT.date2);
    
    if strcmp(array, 'nsp1')
        dataT.array = 'V1';
    elseif strcmp(array, 'nsp2')
        dataT.array = 'V4';
    end
    %% check and adjust locations so fixation is at (0,0)
    % adjust locations so fixation is at (0,0). This will also allow us to
    % combine across runs with different locations to get full maps.
    if contains(dataT.animal,'WU')
        dataT.pos_x = dataT.xoffset; % renaming so it's consistent with the rest of the mapping programs
        dataT.pos_y = dataT.yoffset;
    end
    if dataT.fix_x ~=0
        dataT.fix_xOrig = dataT.fix_x;
        dataT.fix_x = dataT.fix_x - dataT.fix_x;
        dataT.pos_xOrig = dataT.pos_x;
        dataT.pos_x = dataT.pos_x - double(unique(dataT.fix_xOrig));
    end
    if dataT.fix_y ~=0
        dataT.fix_yOrig = dataT.fix_y;
        dataT.fix_y = dataT.fix_y - dataT.fix_y;
        dataT.pos_yOrig = dataT.pos_y;
        dataT.pos_y = dataT.pos_y - double(unique(dataT.fix_yOrig));
    end
    %% parse stimulus name
    if ~contains(filename, 'WU')
        dataT.stimulus = nan(1,size(dataT.filename,1));
        for i = 1:size(dataT.filename,1)
            dataT.stimulus(1,i) = parseMapNoiseName(dataT.filename(i,:));
        end
    end
    %% Get spike counts and zscores
    % note: zscore and spike count matrices are organized so the x and y
    % coordinates reflect the proper cartesian coordinates. That means y
    % values are sorted descending so negative values are not inverted.
    [dataT.blankSpikeCount, dataT.stimSpikeCount, dataT.stimSpikeCountAllLoc, dataT.blankZscore, dataT.stimZscore,dataT.stimZscoreAllLoc] = getGratMapSpikeCountZscores(dataT,filename);
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/mapping/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/mapping/',dataT.array);
    end
    
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
    end
    %% make structures for each eye and save  file
    
    if contains(filename,'LE')
        data.LE = dataT;
        data.RE = [];
    else
        data.RE = dataT;
        data.LE = [];
    end
    
    saveName = [outputDir filename '_' nameEnd ''];
    save(saveName,'data');
    fprintf('%s saved\n', saveName)
    %     catch ME
    %         failNdx = failNdx+1;
    %         fprintf('\n%s did not work. \nError message: %s \n\n',filename,ME.message)
    %         failedFiles{failNdx,1} = filename;
    %         failedFiles{failNdx,2} = ME.message;
    %         failedME{failNdx} = ME;
    %
    %     end
end
fprintf('\n\n*** Mapping1 done in %.2f minutes. %d files failed at some point***\n',toc/60,failNdx)
