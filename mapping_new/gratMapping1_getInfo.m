%gratMapping1_getInfo
clear all
close all
clc
%%
files = {
    'WU_RE_GratingsMapRF_nsp2_20170814_002_thresh35';
    'WU_LE_GratingsMapRF_nsp2_20170814_003_thresh35';    
    
    'WU_RE_GratingsMapRF_nsp1_20170814_002_thresh35';
    'WU_LE_GratingsMapRF_nsp1_20170814_003_thresh35';
     };
nameEnd ='info';
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
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GratMapRF/info/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GratMapRF/info/',dataT.array);
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
    
        
    if ~contains(filename,'all')
        dataT.pos_x = dataT.xoffset;
        dataT.pos_y = dataT.yoffset;
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