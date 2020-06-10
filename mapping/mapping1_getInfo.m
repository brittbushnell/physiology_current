files = {

    };
%%
nameEnd = 'raw';
%%
startBin = 1;
endBin = 35;

numBoot = 2000;
%%
aMap = getBlackrockArrayMap(files(1,:));
location = determineComputer;
failedFiles = {};
failNdx = 1;
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
        oneDay = 1;
    elseif length(tmp) == 7
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum,ign] = deal(tmp{:});
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        dataT.date = convertDate(dataT.date2);
        oneDay = 1;
    else
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2] = deal(tmp{:});
        dataT.date = dataT.date2;
        oneDay = 0;
    end
    
    if strcmp(dataT.array, 'nsp1')
        dataT.array = 'V1';
    elseif strcmp(dataT.array, 'nsp2')
        dataT.array = 'V4';
    end
    
    if contains(dataT.animal,'XX')
        dataT.filename = reshape(dataT.filename,[numel(dataT.filename),1]);
        dataT.filename = char(dataT.filename);
    end
    dataT.amap = aMap;
    dataT.date2 = dataT.date2;
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
toc