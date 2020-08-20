%% Preprocess blackrock array data (gratings program run at beginning of each day) for each recording session.
%  (AKA, for each file -- there may be multiple sessions for one day).
%  Marry blackrock/mworks data, and parse responses according to stimulus.

%% Set up directories and lists of files to analyze.
clear all
close all
clc
%% WU
%dataDir = '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/unsorted/WU/';
%% XT
files = ['XT_LE_Gratings_nsp2_20190321_001';'XT_RE_Gratings_nsp2_20190319_002'];
newName = 'XT_Gratings_V4_March_ParsedJulias';
%% WV
%files = ['WV_LE_Gratings_nsp1_20190205_003';'WV_RE_Gratings_nsp1_20190205_002'];
%%
location = 1; % 0 = laptop 1 = desktop
useMatlabParser = 0; % set to 1 if you want to use the Matlab parser, 0 if want to use already parsed data.
plotResp        = 1;
%%
% WU specs:
%   - nsp1  = V1/V2
%   - nsp2  = V4
%   - LE    = fellow eye
%   - RE    = amblyopic eye

nChan       = 96;
binStart    = 5;
binEnd      = 15;

% List of blackrock/recording files
% files    = getBlackrockRecFileList(dataDir,arrayID,eye,experiment,animalID);
%% Run analyses on all the files.
% failedFiles     = {''};
% failedFilesInd  = [];

close all
for iF = 1:size(files,1)
    %try
    filename    = files(iF,:);
    %newName = [filename,'_parsed'];
    
    temp        =  strsplit(filename, '_');
    [data.animalID, data.eye, data.task, array, data.date, data.recSes] = ...
        deal(temp{:});
    data.amap = getBlackrockArrayMap(filename);
    if strcmp(array, 'nsp2')
        data.array = 'V4';
    elseif strcmp(array, 'nsp1')
        data.array = 'V1';
    end
    if location == 0
        outputDir       = sprintf('/Local/Users/bushnell/Dropbox/ArrayData/matFiles/%s/Gratings/parsed-Julias/',data.array);
        figureDir       = sprintf('/home/bushnell/Dropbox/Figures/%s/Gratings/%s/%s/',data.animalID,data.array,data.eye);
    elseif location == 1
        outputDir       = sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Gratings/parsed-Julias/',data.array);
        figureDir       = sprintf('~/bushnell-local/Dropbox/Figures/%s/Gratings/%s/%s/',data.animalID,data.array,data.eye);
    end
    % outputDir   = [dataDir info.array '/preproc/'];
    processedFile = [outputDir newName '.mat'];
    
    if useMatlabParser == 1
        % Align the .nev blackrock file to mworks times.
        plotNEVTimestamps = 0;
        if ~exist(processedFile)
            bin_spike_bushnell10_gratings(filename, dataDir, outputDir, plotNEVTimestamps);
            S = load([outputDir filename '.mat']);
        else
            S = load([outputDir filename '.mat']);
        end
    else
        % put in darren's parser output
        S = load(filename);
    end
    
    % Align recording data to stimulus presentations.
    R = structBlackrock_gratings(S, filename, outputDir, data, binStart, binEnd, 1);
    %% Plot responses if specified plotResp == 1
    
    cmap = brewermap(12,'*PrGn'); %PrGn goes from purple to green
    if plotResp == 1
        cd(figureDir)
        
        maxResp = max(R.respMat(:));
        colorax = [-maxResp maxResp];
        
        figure;
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 800 800])
        hold on                                                            % Plot response matrices
        binStart = 5;
        binEnd = 15;
        for iC = 1:nChan
            subplot(data.amap,10,10,iC)
            imagesc(R.respMat(:,:,iC));
            axis tight; axis off
            %colormap redblue;
            colormap(cmap);
            caxis(colorax)
            set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
            title(iC)
        end
        suptitle({sprintf('%s %s %s',data.animalID, data.eye, data.array);'average response to gratings from 50 - 150 ms'})
        %%
        %maxResp = max(R.ZSrespMat(:));
        colorax = [-5 5];
        figure;
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 800 800])
        hold on                                                            % Z=scored response
        binStart = 5;
        binEnd = 15;
        for iC = 1:nChan
            subplot(data.amap,10,10,iC)
            imagesc(R.ZSrespMat(:,:,iC));
            axis tight;
            axis off
            %colormap redblue;
            colormap(cmap);
            caxis(colorax)
            set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
            title(iC)
        end
        suptitle({sprintf('%s %s %s',data.animalID, data.eye, data.array);'z-scored average response to gratings from 50 - 150 ms'})
            figName = [data.animalID,'_', data.eye,'_',data.array,'Gratings_50to150zScore'];
    print(gcf,figName,'-dpdf','-fillpage')
        %%
        maxResp = max(R.respMatRel(:));
        colorax = [-maxResp maxResp];
        figure;
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 800 800])
        hold on                                                            % response relative to baseline resp
        for iC = 1:nChan
            subplot(data.amap,10,10,iC)
            imagesc(R.respMatRel(:,:,iC));
            axis tight;
            axis off
            %colormap redblue;
            colormap(cmap);
            caxis(colorax)
            set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
            title(iC)
        end
        suptitle({sprintf('%s %s %s',data.animalID, data.eye, data.array);'baseline subtracted average to gratings from 50 - 150 ms'})
        
    end
    %%
    
    % 9/24/18 --- don't do this here. combine responses across recording
    % sessions in one day first (gratings_responses_across_days.mat) then
    % fit
    % Fit responses
    % respToFit = R.ZSrespMat;
    % F = fitBlackrock_gratings(R, respToFit, filename, outputDir, 5, 15, 100, 0);
    
    clearvars info
    fprintf('%s ..... %g / %g \n', filename, iF, size(files,1))
    % catch
    %     disp([filename ' didnt work'])
    %     failedFiles{end+1} = filename;
    %     failedFilesInd{end+1} = iF;
    % end
    
    
    % goodChan = find(JTS>0.95);
    % badChan = find(JTS<=0.95);
    
    %% Plot some responses across the array
    maxResp = max(R.respAvg(:));
    cmap = brewermap(12,'*PrGn'); %PrGn goes from purple to green
    
    figure(1)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 800])
    hold on
    for iC = 1:nChan
        subplot(data.amap,10,10,iC)
        if R.JTS(iC) > 0.95
            imagesc([0 0 0])
        else
            imagesc([1 1 1])
        end
        axis tight
        %colormap redblue;
        colormap(cmap);
        caxis([0 1])
        set(gca, 'XTick', [], 'YTick', [])
        set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
        title(iC)
        
        if iC == 91
            xlabel('ori')
            ylabel('sf')
        end
    end
    suptitle({sprintf('%s %s %s',data.animalID, data.eye, data.array);'green = passed shuffle'})
    %%
    figure(2)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 800])
    hold on                                                            % Plot average PSTHs for all stimuli for each channel.
    for iC = 1:nChan
        subplot(data.amap,10,10,iC)
        hold on
        plot(smooth(R.respBlankAvg(iC, :),2), 'k', 'LineWidth', 2)
        plot(smooth(squeeze(nanmean(nanmean(R.respAvg(:, :, :, iC)),2)),2), 'r', 'LineWidth', 2)
        %ylim([0 maxResp])
        xlim([0 30])
        set(gca, 'XTick', [], 'YTick', [])
        %axis off
        set(gca, 'Position',get(gca, 'Position')+[0 0 0.0045 0.0045]);
        title(iC)
        %colormap redblue; caxis(colorax)
    end
    suptitle(sprintf('%s %s %s mean responses to gratings',data.animalID, data.eye, data.array))
    
    figName = [data.animalID,'_', data.eye,'_',data.array,'Gratings_meanResponses'];
    print(gcf,figName,'-dpdf','-fillpage')
    %%
    colorax = [-15 15];
    %colorax = [-10 10];
    
    figure(3)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 800])
    hold on                                                            % Plot response matrices
    binStart = 5;
    binEnd = 15;
    for iC = 1:nChan
        subplot(data.amap,10,10,iC)
        imagesc(nansum(R.respAvg(:,:,binStart:binEnd,iC),3) - nansum(R.respBlankAvg(iC,binStart:binEnd)));
        axis tight; axis off
        %colormap redblue;
        colormap(cmap);
        caxis(colorax)
        set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
        title(iC)
        
        if iC == 91
            xlabel('ori')
            ylabel('sf')
        end
    end
    suptitle({sprintf('%s %s %s',data.animalID, data.eye, data.array);'baseline subtracted responses to gratings, 50-150 ms'})
    
    figName = [data.animalID,'_', data.eye,'_',data.array,'Gratings_50to150BaseSub'];
    print(gcf,figName,'-dpdf','-fillpage')
    
    %%
    figure
    hold on
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 800])
    colorbar
    colormap(cmap)
end
