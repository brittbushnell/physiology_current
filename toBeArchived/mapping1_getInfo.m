clear
close all
clc
%%

files = {
   'WV_LE_MapNoise_nsp2_20190130_all_thresh35';
   'WV_RE_MapNoise_nsp2_20190130_all_thresh35';
   
   'WV_LE_MapNoise_nsp1_20190130_all_thresh35';
   'WV_RE_MapNoise_nsp1_20190130_all_thresh35';
   
   'XT_LE_mapNoiseRight_nsp2_20181120_all_thresh35';
   'XT_RE_mapNoiseRight_nsp2_20181026_all_thresh35';
   
   'XT_LE_mapNoiseRight_nsp1_20181120_all_thresh35';
   'XT_RE_mapNoiseRight_nsp1_20181026_all_thresh35';
    
   'WU_LE_Gratmap_nsp2_20170428_all_thresh35';
   'WU_RE_Gratmap_nsp2_20170428_006_thresh35';
   
   'WU_LE_Gratmap_nsp1_20170428_all_thresh35';
   'WU_RE_Gratmap_nsp1_20170428_006_thresh35';
};
nameEnd = 'info';
%%
location = determineComputer;
failedFiles = {};
failNdx = 1;

for fi = 1:size(files,1)
    %% Get basic information about experiments
   % try
    filename = files{fi};
    dataT = load(filename);
    
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
    if contains(dataT.animal,'WU') && ~contains(dataT.runNum,'all')
        dataT.pos_x = dataT.xoffset(1,1:size(dataT.width,2)); % don't know why, but for some reason offset is reapeated twice
        dataT.pos_y = dataT.yoffset(1,1:size(dataT.width,2));
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
    %%
    if contains(filename, 'WU')
        % he was run using gratings, so no filename to parse out
    else
        dataT.stimulus = nan(1,size(dataT.filename,1));
        for i = 1:size(dataT.filename,1)
            dataT.stimulus(1,i) = parseMapNoiseName(dataT.filename(i,:));
        end
    end
    %% Plot clean vs raw PSTHs to check for timing fuckery
%     if contains(dataT.animal,'WU')        
%         plotGratingPSTH_rawVsClean (dataT,filename)
%     else
%         plotMapNoisePSTH_rawVsClean (dataT,filename)
%     end
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/mapping/',dataT.array);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/mapping/',dataT.array);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
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
%         catch ME
%             fprintf('\n%s did not work. \nError message: %s \n\n',filename,ME.message)
%             failedFiles{failNdx} = filename;
%             failedME{failNdx} = ME;
%             failNdx = failNdx+1;
%         end
end
%failedFiles
