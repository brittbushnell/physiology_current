%% Preprocess blackrock array data for each recording session for contour integration experiment.
%  (AKA, for each file -- there may be multiple sessions for one day).
%  Marry blackrock/mworks data, and parse responses according to stimulus.

%% Set up directories and lists of files to analyze.
clearvars

% addpath(genpath('/Volumes/BIGZINGY/BlackrockData'))
% addpath(genpath('/u/vnl/users/julia'))
% addpath(genpath('/Library/Application Support/MWorks/Scripting/Matlab'))   % necessary to run parser.
% 
% dataDir     = '/Volumes/BIGZINGY/BlackRockData/';

% WU specs:
%   - nsp1  = V1/V2
%   - nsp2  = V4
%   - LE    = fellow eye
%   - RE    = amblyopic eye
arrayID     = 'nsp1';
eye         = 'LE';
experiment  = 'ContourIntegrationFoveal';

nChan       = 96;
binStart    = 1;
binEnd      = 35;

% List of blackrock/recording files
fileList    = getBlackrockRecFileList(dataDir,arrayID,eye,experiment);
fileList    = unique(fileList);

%% Run analysis on all the files.

failedFiles     = {''};
failedFilesInd  = [];

close all
for iF = 1:length(fileList)
    try
        filename    = fileList{iF};
        
        temp        =  strsplit(filename, '_');
        [info.animalID, info.eye, info.task, info.array, info.date, info.recSes] = ...
            deal(temp{:});
        outputDir   = [dataDir info.array '/preproc/'];                        % where to output preprocessing files
        processedFile = [outputDir filename '.mat'];
        
        % Align the .nev blackrock file to mworks times.
        plotNEVTimestamps   = 1;
        parseOverwrite      = 0;
        if ~exist(processedFile) || parseOverwrite
            bin_spike_bushnell11_contourInt(filename, dataDir, outputDir, plotNEVTimestamps);
            S = load([outputDir filename '.mat']);
        else
            S = load([outputDir filename '.mat']);
        end
        
        % Parse the binned data and organize into sensible data matrices.
        plotResp = 1;
        R = structBlackrock_contourInt(S, filename, outputDir, info, binStart, binEnd, plotResp, 1);
        
        fprintf('\n%s ..... %g / %g \n', filename, iF, length(fileList))         % display filename when done.
    catch
        disp([filename ' didnt work'])
        failedFiles{end+1} = filename;
        failedFilesInd{end+1} = iF;
    end
end