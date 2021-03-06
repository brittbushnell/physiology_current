%% Preprocess blackrock array data (gratings program run at beginning of each day) for each recording session.
%  (AKA, for each file -- there may be multiple sessions for one day).
%  Marry blackrock/mworks data, and parse responses according to stimulus.

% 10/11/18 Editing to run on Zemina -BB
%% Set up directories and lists of files to analyze.
clearvars
clc
%% Set paths
addpath(genpath('/ArrayAnalysis/'))
addpath(genpath('/mnt/vnl
% addpath(genpath('/Volumes/BIGZINGY/BlackrockData'))
% addpath(genpath('/u/vnl/users/julia'))
% addpath(genpath('/Library/Application Support/MWorks/Scripting/Matlab'))   % necessary to run parser.
%%
% WU specs:
%   - nsp1  = V1/V2
%   - nsp2  = V4
%   - LE    = fellow eye
%   - RE    = amblyopic eye
animal      = 'WU';
arrayID     = 'nsp2';
eye         = 'LE';
experiment  = 'Gratings_';
plotResp    = 0;

nChan       = 96;
binStart    = 5;
binEnd      = 15;
%% handle directories and such
dataDir = '/mnt/vnlstorage/bushnell_arrays/';                           %'/Volumes/BIGZINGY/BlackRockData/';

% define where you want to save the outputs
if strcmp(animal,'WU')
    outputDir    = '/home/bushnell/binned_dir/WU/';
elseif strcmp(animal,'WV')
    outputDir    = '/home/bushnell/binned_dir/WV/';
elseif strcmp(animal,'XT')
    outputDir    = '/home/bushnell/binned_dir/XT/';
else
    error('animal name not recognized. Make sure name is correct, and capitalized')
end

% List of blackrock/recording files
fileList    = getBlackrockRecFileList(dataDir,arrayID,eye,experiment,animal);
%% Run analyses on all the files.
failedFiles     = {''};
failedFilesInd  = [];

close all
for iF = 1:length(fileList)
    try
        filename    = fileList{iF};
        
        temp        =  strsplit(filename, '_');
        [info.animalID, info.eye, info.task, info.array, info.date, info.recSes] = ...
            deal(temp{:});
        %outputDir   = [dataDir info.array '/preproc/'];
        processedFile = [outputDir filename '.mat'];
        
        % Align the .nev blackrock file to mworks times.
        plotNEVTimestamps = 0;
        if ~exist(processedFile)
            bin_spike_bushnell10_gratings(filename, dataDir, outputDir, plotNEVTimestamps);
            S = load([outputDir filename '.mat']);
        else
            disp([filename ' already processed'])
            S = load([outputDir filename '.mat']);
        end
        
        % Align recording data to stimulus presentations.
        R = structBlackrock_gratings(S, filename, outputDir, info, binStart, binEnd, 1); 
        pause
        %% Plot responses if specified plotResp == 1
        if plotResp == 1
            
            maxResp = max(R.respMat(:));
            colorax = [-maxResp maxResp];
            figure; hold on                                                            % Plot response matrices
            binStart = 5;
            binEnd = 15;
            for iC = 1:nChan
                nsubplot(10, 10, R.aMap.row(iC)+1, R.aMap.col(iC)+1);
                imagesc(R.respMat(:,:,iC));
                axis tight; axis off
                colormap redblue; caxis(colorax)
                set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
                title(iC)
            end
            suptitle('average from 50 - 150 ms')
            
            %maxResp = max(R.ZSrespMat(:));
            colorax = [-5 5];
            figure; hold on                                                            % Z=scored response
            binStart = 5;
            binEnd = 15;
            for iC = 1:nChan
                nsubplot(10, 10, R.aMap.row(iC)+1, R.aMap.col(iC)+1);
                imagesc(R.ZSrespMat(:,:,iC));
                axis tight; axis off
                colormap redblue; caxis(colorax)
                set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
                title(iC)
            end
            suptitle('z-scored average from 50 - 150 ms')
            
            maxResp = max(R.respMatRel(:));
            colorax = [-maxResp maxResp];
            figure; hold on                                                            % response relative to baseline resp
            binStart = 5;
            binEnd = 15;
            for iC = 1:nChan
                nsubplot(10, 10, R.aMap.row(iC)+1, R.aMap.col(iC)+1);
                imagesc(R.respMatRel(:,:,iC));
                axis tight; axis off
                colormap redblue; caxis(colorax)
                set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
                title(iC)
            end
            suptitle('baseline subtracted average from 50 - 150 ms')
            
        end
        %%       
        % 9/24/18 --- don't do this here. combine responses across recording
        % sessions in one day first (gratings_responses_across_days.mat) then
        % fit
        % Fit responses
        % respToFit = R.ZSrespMat;
        % F = fitBlackrock_gratings(R, respToFit, filename, outputDir, 5, 15, 100, 0);
        
        clearvars info
        fprintf('%s ..... %g / %g \n', filename, iF, length(fileList))
    catch
        disp([filename ' didnt work'])
        failedFiles{end+1} = filename;
        failedFilesInd{end+1} = iF;
    end
end

% goodChan = find(JTS>0.95);
% badChan = find(JTS<=0.95);

%% Plot some responses across the array
maxResp = max(R.respAvg(:));

figure; hold on
for iC = 1:nChan
    nsubplot(10, 10, R.aMap.row(iC)+1, R.aMap.col(iC)+1);
    if R.JTS(iC) > 0.95
        imagesc([0 0 0])
    else
        imagesc([1 1 1])
    end
    axis tight
    colormap redblue; caxis([0 1])
    set(gca, 'XTick', [], 'YTick', [])
    set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
    title(iC)
end
suptitle('blue = passed shuffle')

figure; hold on                                                            % Plot average PSTHs for all stimuli for each channel.
for iC = 1:nChan
    nsubplot(10, 10, R.aMap.row(iC)+1, R.aMap.col(iC)+1);
    hold on
    plot(squeeze(nanmean(nanmean(R.respAvg(:, :, :, iC)),2)), 'k', 'LineWidth', 2)
    plot(R.respBlankAvg(iC, :), 'r', 'LineWidth', 2)
    ylim([0 maxResp])
    xlim([0 30])
    set(gca, 'XTick', [], 'YTick', [])
    %axis off
    set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
    title(iC)
    %colormap redblue; caxis(colorax)
end
suptitle('bins of 10 ms')

colorax = [-15 15];
%colorax = [-10 10];
figure; hold on                                                            % Plot response matrices
binStart = 5;
binEnd = 15;
for iC = 1:nChan
    nsubplot(10, 10, R.aMap.row(iC)+1, R.aMap.col(iC)+1);
    imagesc(nansum(R.respAvg(:,:,binStart:binEnd,iC),3) - nansum(R.respBlankAvg(iC,binStart:binEnd)));
    axis tight; axis off
    colormap redblue; caxis(colorax)
    set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
    title(iC)
end
suptitle('baseline subtracted responses, 50-150 ms')

