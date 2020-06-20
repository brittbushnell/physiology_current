clear
close all
clc
%%

files = {
    % beginning of recordin
%     'WV_LE_MapNoiseRight_nsp2_20190121_all';
%     'WV_LE_MapNoiseRightWide_nsp2_20190122_002';
%     'WV_RE_MapNoiseRightWide_nsp2_20190122_001';
    
    % active arrays
    'WV_LE_MapNoise_nsp2_20190204_all';
    'WV_RE_MapNoise_nsp2_20190205_001';
    
    'WV_LE_MapNoise_nsp2_20190204_all';
    'WV_RE_MapNoise_nsp2_20190205_001';
    };
nameEnd = 'raw';
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
        dataT.date = convertDate(dataT.date2);
    else
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2] = deal(tmp{:});
        dataT.date = dataT.date2;
    end
    
    if strcmp(dataT.array, 'nsp1')
        dataT.array = 'V1';
    elseif strcmp(dataT.array, 'nsp2')
        dataT.array = 'V4';
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
    fprintf('%s saved\n', saveName)
    %     catch ME
    %         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
    %         failedFiles{failNdx} = filename;
    %         failedME{failNdx} = ME;
    %         failNdx = failNdx+1;
    %     end
end
%failedFiles
