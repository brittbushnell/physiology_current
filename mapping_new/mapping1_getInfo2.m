clear
close all
clc
tic
%%
monks = {
    'WU';
    %     'WV';
    %'XT';
    };
ez = {
    'LE';
    'RE';
    };
brArray = {
    'V4';
    'V1';
    };
%%
nameEnd = 'info3';
numPerm = 2000;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
ndx = 1;
corNdx = 1;
filesT = {};
filesC = {};
for an = 1:length(monks)
    monk = monks{an};
    for ey = 1:length(ez)
        eye = ez{ey};
        for ar = 1:length(brArray)
            area = brArray{ar};
            %%
            if contains(monk,'WU')
                if location == 0
                    dataDir = sprintf('~/Dropbox/ArrayData/matFiles/reThreshold/gratings/%s/%s/Mapping/%s/',monk,area,eye);
                else
                    dataDir = sprintf('/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/gratings/%s/%s/Mapping/%s/',monk,area,eye);
                end
            else
                if location == 0
                    dataDir = sprintf('~/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Mapping/%s/',monk,area,eye);
                else
                    dataDir = sprintf('/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Mapping/%s/',monk,area,eye);
                end
            end
            cd(dataDir);
            
            tmp = dir;
            %%
            for t = 1:size(tmp,1)
                if contains(tmp(t).name,'.mat')
                    if contains(tmp(t).name,'_og')
                        % make a list of all of the files that have
                        % been realigned
                        
                        filesC{corNdx,1} = tmp(t).name;
                        corNdx = corNdx+1;
                    else
                        % list of un-aligned files
                        filesT{ndx,1} = tmp(t).name;
                        ndx = ndx+1;
                    end
                end
            end
            
            for c = 1:length(filesC)
                shortName = strrep(filesC{c,1},'_ogcorrupt','');
                %remove from the list any _thresh35 files that were
                %later realigned.  No reason to run through everything
                %on all of them.
                filesT(strcmp(shortName,filesT)) = [];
            end
            
            if isempty(filesT)
                list = filesC;
            elseif isempty(filesC)
                list = filesT;
            else
                list = cat(1,filesC,filesT);
            end
            
            clear tmp
        end
    end
end
%%
if location == 0
    listDir ='~/Dropbox/ArrayData/matFiles/reThreshold/listMatrices/Mapping/';
else
    listDir = '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/listMatrices/Mapping/';
end

if ~exist(listDir,'dir')
    mkdir(listDir)
end
mtxSaveName = [listDir,monk,'_',eye,'_',area,'_mapping_','FileList.mat'];
save(mtxSaveName,'list')
%% very cludgy way to get rid of empty cells
files = {};
ndx = 1;
for i = 1:length(list)
    if ~isempty(list{i})
        files{ndx,1} = list{i};
        ndx = ndx+1;
    end
end
%%
% files = {
%     'WU_RE_GratingsMapRF_nsp2_20170427_001_thresh35';
%     'WU_RE_GratingsMapRF_nsp2_20170427_002_thresh35';
%     'WU_RE_GratingsMapRF_nsp1_20170427_001_thresh35';
%     'WU_RE_GratingsMapRF_nsp1_20170427_002_thresh35';
%     };
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
        %%
        if contains(filename, 'WU')
            % he was run using gratings, so no filename to parse out
        else
            dataT.stimulus = nan(1,size(dataT.filename,1));
            for i = 1:size(dataT.filename,1)
                dataT.stimulus(1,i) = parseMapNoiseName(dataT.filename(i,:));
            end
        end
        %% Get spike counts and zscores
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
%failedFiles
%         end
%     end
% end






