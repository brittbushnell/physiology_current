clear
close all
clc
%%

files = {
    % beginning of recording
    %     'WV_LE_MapNoiseRight_nsp2_20190121_all';
    %     'WV_LE_MapNoiseRightWide_nsp2_20190122_002';
    %     'WV_RE_MapNoiseRightWide_nsp2_20190122_001';
    
    % active arrays
    %     'WV_LE_MapNoise_nsp2_20190204_all';
    %     'WV_RE_MapNoise_nsp2_20190205_001';
    %
    %     'WV_LE_MapNoise_nsp1_20190204_all';
    %     'WV_RE_MapNoise_nsp1_20190205_001';
    %
    %     'XT_LE_mapNoise_nsp2_Oct2018';
    %     'XT_LE_mapNoiseRight_nsp2_Nov2018';
    
    %     'WV_LE_MapNoise_nsp2_Jan2019_all_thresh35';
    %     'WV_RE_MapNoise_nsp2_Jan2019_all_thresh35';
    'XT_LE_mapNoiseRight_nsp2_nov2018_all_thresh35';
    'XT_LE_mapNoiseRight_nsp2_nov20182_all_thresh35';
    'XT_RE_mapNoiseRight_nsp2_nov2018_all_thresh35';
    
    'WV_LE_MapNoise_nsp2_20190122_003_thresh35';
    'WV_LE_MapNoise_nsp2_20190130_001_thresh35';
    'WV_LE_MapNoise_nsp2_20190130_002_thresh35';
    'WV_RE_MapNoise_nsp2_20190130_003_thresh35';
    'WV_RE_MapNoise_nsp2_20190130_004_thresh35';
    'XT_LE_mapNoiseRight_nsp2_20181105_003_thresh35';
    'XT_LE_mapNoiseRight_nsp2_20181105_004_thresh35';
    'XT_LE_mapNoiseRight_nsp2_20181120_001_thresh35';
    'XT_LE_mapNoiseRight_nsp2_20181120_002_thresh35';
    'XT_LE_mapNoiseRight_nsp2_20181120_003_thresh35';
    'XT_LE_mapNoiseRight_nsp2_20181127_001_thresh35';
    'XT_LE_mapNoise_nsp2_20181023_002_thresh35';
    'XT_LE_mapNoise_nsp2_20181025_001_thresh35';
    'XT_RE_mapNoiseLeft_nsp2_20181026_001_thresh35';
    'XT_RE_mapNoiseRight_nsp2_20181026_001_thresh35';
    'XT_RE_mapNoiseRight_nsp2_20181026_003_thresh35';
    'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35';
    'XT_RE_mapNoise_nsp2_20181024_001_thresh35';
    'XT_RE_mapNoise_nsp2_20181024_002_thresh35';
    'XT_RE_mapNoise_nsp2_20181024_003_thresh35';
    };
nameEnd = 'info';
%%
location = determineComputer;
failedFiles = {};
failNdx = 1;

aMap = getBlackrockArrayMap(files(1,:));
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %try
    filename = files{fi};
    dataT = load(filename);
    
    nChan = 96;
    dataT.amap = aMap;
    tmp = strsplit(filename,'_');
    
    % extract information about what was run from file name.
    if length(tmp) == 6
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum] = deal(tmp{:});
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        dataT.date = convertDate(dataT.date2);
    elseif length(tmp) == 7
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum,ign] = deal(tmp{:});
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        %        dataT.date = convertDate(dataT.date2);
    else
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2] = deal(tmp{:});
        dataT.date = dataT.date2;
    end
    
    if strcmp(dataT.array, 'nsp1')
        dataT.array = 'V1';
    elseif strcmp(dataT.array, 'nsp2')
        dataT.array = 'V4';
    end
    %% check and adjust locations so fixation is at (0,0)
    % adjust locations so fixation is at (0,0). This will also allow us to
    % combine across runs with different locations to get full maps.
    if dataT.fix_x ~=0
        dataT.fix_xOrig = dataT.fix_x;
        dataT.fix_x = dataT.fix_x - dataT.fix_x;
        dataT.pos_xOrig = dataT.pos_x;
        dataT.pos_x = dataT.pos_x - dataT.fix_xOrig;
    end
    if dataT.fix_y ~=0
        dataT.fix_yOrig = dataT.fix_y;
        dataT.fix_y = dataT.fix_y - dataT.fix_y;
        dataT.pos_yOrig = dataT.pos_y;
        dataT.pos_y = dataT.pos_y - dataT.fix_yOrig;
    end
    %%
    dataT.stimulus = nan(1,size(dataT.filename,1));
    for i = 1:size(dataT.filename,1)
        dataT.stimulus(1,i) = parseMapNoiseName(dataT.filename(i,:));
    end
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
    end
    %% add stimulus center for other programs
    if contains(filename,'WU')
        dataT.stimXGlass = -3.5;
        dataT.stimYGlass = 0;
        dataT.fixXGlass = 0;
        dataT.fixYGlass = 0;
    elseif contains(filename,'WV')
        dataT.stimXGlass = 1.5;
        dataT.stimYGlass = -1;
        dataT.fixXGlass = 0;
        dataT.fixYGlass = 0;
    elseif contains(filename,'XT') % ran it in a location that would hit both arrays knowing they were on the way out
        dataT.stimXGlass = -2;
        dataT.stimYGlass = -1;
        dataT.fixXGlass = -1;
        dataT.fixYGlass = 1;
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
    %         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
    %         failedFiles{failNdx} = filename;
    %         failedME{failNdx} = ME;
    %         failNdx = failNdx+1;
    %     end
end
%failedFiles
