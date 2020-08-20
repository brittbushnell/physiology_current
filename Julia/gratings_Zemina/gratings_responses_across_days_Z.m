%% Compare channel responses for one eye across days.
%  This will be used to evaluate consistency of responses across recording
%  sessions.
%  Loads in preproceesed files (that were generated from
%  gratings_analysis_#####(date))

clearvars;
clc

%  Set up directories.
% addpath(genpath('/Volumes/BIGZINGY/BlackrockData'))                        % Data stored here.
% addpath(genpath('/u/vnl/users/julia'))                                     % Analysis scripts and helper functions.
% addpath(genpath('/Library/Application Support/MWorks/Scripting/Matlab'))   % Matlab support for Mworks (needed to run parser).

animalID        = 'XT';
eye             = 'LE';                                                    % LE = fellow eye, RE = amblyopic
arrayID         = 'nsp2';                                                  % nsp1 = V1/V2, nsp2 = V4
nChan       	= 96;
nSf             = 6;
nOri            = 6;


dataDir         = '/mnt/vnlstorage/bushnell_arrays/'; %'/home/bushnell/binned_dir/XT/';

if strmatch(arrayID,'nsp2')
    outputDir       = '/home/bushnell/matFiles/XT/V4/Gratings/';
    figureDir       = '/home/bushnell/Figures/V4/XT/Gratings/';
else
    outputDir       = '/home/bushnell/matFiles/XT/V1/Gratings/';
    figureDir       = '/home/bushnell/Figures/V1/XT/Gratings/';
end


dataDir         = '/home/bushnell/binned_dir/XT/';
outputDir       = [ '/home/bushnell/matFiles/XT/Gratings/'];
figureDir       = [ '/home/bushnell/Figures/V1/XT/Gratings/'];
allRespSaveFile = [outputDir 'XT_' eye '_' arrayID '_allResp.mat'];
allRespFitFile  = [outputDir 'XT_' eye '_' arrayID '_allRespFit.mat'];

respOverwrite   = 0;
parseOverwrite  = 0;
redoFit         = 0;

% Get list of experiment names.
fileList        = getBlackrockRecFileList(dataDir, arrayID, eye, 'gratings',animalID);
parsedFiles     = strcat(fileList, '.mat');
respFiles       = strcat(fileList, '_resp.mat');
fitFiles        = strcat(fileList, '_fits.mat');

oriAxis         = [0    30    60    90   120   150];
sfAxis          = 5 * 2.^[-4 : 1];
%% determine arraymap
if strcmp(arrayID,'nsp2')
    disp 'data recorded from nsp2, V4 array'
    
    if strcmp(animalID,'WU')
        aMap = arraymap('SN 1024-001795.cmp');
    elseif strcmp(animalID,'XT')
        aMap = arraymap('SN1024-001854.cmp');
    elseif strcmp(animalID,'WV')
        aMap = arraymap('SN1024-001851.cmp');
    else
        error('Cannot determine animal identity from filename')
    end
    
elseif strcmp(arrayID,'nsp1')
    disp 'data recorded from nsp1, V1/V2 array'
    
    if strcmp(animalID,'WU')
        aMap = arraymap('SN 1024-001795.cmp');
    elseif strcmp(animalID,'XT')
        aMap = arraymap('SN1024-001852.cmp');
    elseif strcmp(animalID,'WV')
        aMap = arraymap('SN1024-001848.cmp');
    else
        error('Cannot determine animal identity from filename')
    end
    
else
    error('Error: array ID missing or wrong')
end
%% Build structure containing relevant responses across all days.
nS          = length(respFiles);                                           % number of recording sessions/files.
badFiles    = [];                                                          % some of these just don't have mworks files on the server...

%%%% Sort recordings sessions by day.
allDate             = {};
allRecSes           = cell(1, nS);
allRespFile         = cell(1, nS);
allFitFile          = cell(1, nS);
iS_                 = 0;
for iS = 1:nS
    try
        R       = load(respFiles{iS});
        date_   = R.info.date;
        recSes_ = R.info.recSes;
        if sum(contains(allDate,date_)) == 0
            iS_                 = iS_ + 1;
            allDate{iS_}        =  date_;
            allRecSes{iS_}      = {};
            allRespFile{iS_}    = {};
            
            allRecSes{iS_}(end+1)   = {recSes_};
            allRespFile{iS_}(end+1) = {respFiles{iS}};
            allFitFile{iS_}(end+1)  = {fitFiles{iS}};
        else
            allRecSes{iS_}(end+1)   = {recSes_};
            allRespFile{iS_}(end+1) = {respFiles{iS}};
            allFitFile{iS_}(end+1)  = {fitFiles{iS}};
        end
    catch
        disp([respFiles{iS} ' didnt work'])
    end
end

% Organize responses, get average responses for each day's recording
nS          = length(allDate);
binStart    = 5;
binEnd      = 15;
nOri        = 6;
nSf         = 6;
nBins       = 30;                                                          % number of bins used in parsing (10 ms intervals)
nParam      = 5;

sesRespMat          = cell(1, iS);
sesRespMatZS        = cell(1, iS);
sesRespMatRel       = cell(1, iS);
sesRespAvgOverTime  = cell(1, iS);
sesRespBlankOverTime= cell(1, iS);

respMat             = NaN(nSf, nOri, nChan, nS);                           % Sum of responses from 50-150 ms after stim on
respMatZS           = NaN(nSf, nOri, nChan, nS);                           % Z-scored to blank trials
respMatRel          = NaN(nSf, nOri, nChan, nS);                           % baseline subtracted
respAvgOverTime     = NaN(nBins, nChan, nS);                               % Averaged across all 'real' grating stimuli
respBlankOverTime   = NaN(nBins, nChan, nS);
maxRespPerChan      = NaN(nChan, nS);

goodChanByChan      = zeros(nChan, nS);
goodChanByDay       = cell(nS,1);
responsiveChanByChan      = zeros(nChan, nS);                              % each recording session
responsiveChanByDay       = cell(nS, 1);

plotRespEachSes     = 1;

for iS = 1:nS
    dayRecSes   = allRecSes{iS};
    dayRespFile = allRespFile{iS};
    nRecSes     = length(dayRecSes);
    
    dayRespMat          = nan(nSf,nOri, nChan, nRecSes);
    dayRespMatZS        = nan(nSf,nOri, nChan, nRecSes);
    dayRespMatRel       = nan(nSf,nOri, nChan, nRecSes);
    dayRespAvgOverTime  = nan(nBins, nChan, nRecSes);
    dayRespBlankOverTime = nan(nBins, nChan, nRecSes);
    dayMaxResp          = nan(nChan, nRecSes);
    dayJTS              = nan(nChan, nRecSes);
    dayChanWithSignal   = zeros(nChan, nRecSes);
    
    for iR  = 1:nRecSes                                                    % collect responses for each record
        R       = load(dayRespFile{iR});
        oriAxis = R.oris;
        sfAxis  = R.sfs;
        %F       = load(dayFitFile{iR});
        aMap    = R.aMap;
        
        for iC = 1:nChan
            dayRespMat(:,:,iC,iR)       = R.respMat(:,:,iC);
            dayRespMatZS(:,:,iC,iR)     = R.ZSrespMat(:,:,iC);
            dayRespMatRel(:,:,iC,iR)    = R.respMatRel(:,:,iC);
            dayRespAvgOverTime(:,iC,iR) = nanmean(nanmean(R.respAvg(:,:,:,iC)));
            dayRespBlankOverTime(:,iC,iR) = R.respBlankAvg(iC,:);
            dayJTS(iC, iR)              = R.JTS(iC);
        end
        dayChanWithSignal(R.indChanWithSignal,iR)   = 1;
        dayMaxResp(:,iR)                = R.maxRespPerChan;
        
        if plotRespEachSes
            figure; hold on                                                        % Plot response matrices
            pos = get(gcf,'Position');
            set(gcf,'Position',[pos(1) pos(2) 600 600])
            maxSessResp = max(R.respMatRel(:));
            colorax = [-maxSessResp maxSessResp];
            for iC = 1:nChan
                nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
                imagesc(dayRespMatRel(:,:,iC,iR));
                axis tight; axis off
                colormap redblue; caxis(colorax)
                set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
                title(iC)
            end
            suptitle([allDate{iS} ' - session ' dayRecSes{iR}])
            print([figureDir animalID '_' eye '_Gratings_' arrayID '_' allDate{iS} '_' dayRecSes{iR} '_respMatRel'], ...
                '-dpdf');
        end
    end
    close all;
    sesRespMat{iS}      = dayRespMat;
    sesRespMatZS{iS}    = dayRespMatZS;
    sesRespMatRel{iS}   = dayRespMatRel;
    sesRespAvgOverTime{iS}    = dayRespAvgOverTime;
    sesRespBlankOverTime{iS}  = dayRespBlankOverTime;
    
    % Now average across recording sessions
    respMat(:,:,:,iS)       = nanmean(dayRespMat, 4);
    respMatZS(:,:,:,iS)     = nanmean(dayRespMatZS, 4);
    respMatRel(:,:,:,iS)    = nanmean(dayRespMatRel, 4);
    respAvgOverTime(:,:,iS) = nanmean(dayRespAvgOverTime, 3);
    respBlankOverTime(:,:,iS)   = nanmean(dayRespBlankOverTime, 3);
    maxRespPerChan(:,iS)    = max(dayMaxResp, [], 2);                      % maximum response elicited to any stimulus presentation across all recording sessions
    
    % Find good channels - strict criteria that (most) sessions had to have consistent tuning
    goodChanByChan(:,iS)    = (nanmean(dayJTS,2) > 0.90);
    goodChanByDay{iS}       =  find(nanmean(dayJTS,2) > 0.90);
    % Channels that had some kind of activity (ie, not dead electrodes)
    responsiveChanByChan(:,iS)  = (nanmean(dayChanWithSignal,2) == 1);
    responsiveChanByDay{iS}     = find(responsiveChanByChan(:,iS));
end

clearvars R F
save(allRespSaveFile, ...
    'nS', 'binStart', 'binEnd', 'nOri', 'nSf', 'nBins', 'aMap', 'oriAxis', 'sfAxis',...
    'allDate', 'allRecSes', 'allRespFile', ...
    'sesRespMat', 'sesRespMatZS', 'sesRespAvgOverTime', 'sesRespBlankOverTime', ...
    'respMat', 'respMatZS', 'respMatRel', 'respAvgOverTime', 'respBlankOverTime', ...
    'goodChanByChan', 'goodChanByDay', 'responsiveChanByChan', 'responsiveChanByDay' ...
    );

A = load(allRespSaveFile)

%% Fit each day's combined responses (and plot).
if ~exist(allRespFitFile) || redoFit == 1
    
    A               = load(allRespSaveFile);
    aMap            = A.aMap;
    doFit           = 1;
    plotDayResp     = 1;
    plotFit         = 1;
    
    dataType        = 'baseline subtracted';
    nParam          = 5;
    nStarts         = 100;
    fit             = nan(nSf, nOri, nChan, A.nS);
    param           = nan(nParam, nChan, A.nS);
    fval            = nan(nChan, A.nS);
    
    % upsampled orientation and sf indices for computing tuning parameters
    oriAxisUp       = 1:180;
    sfAxisUp        = linspace(-4, 1, 50);        % to get to cyc/deg: 5 * 2.^[-4:1]
    
    % preallocate space for tuning parameters derived from model fit
    pkOri           = nan(nChan, A.nS);
    pkSfInd         = nan(nChan, A.nS);
    pkSf            = nan(nChan, A.nS);
    tuningOri       = nan(length(oriAxisUp), nChan, A.nS);
    tuningSf        = nan(length(sfAxisUp), nChan, A.nS);
    osiOri      = nan(nChan, A.nS);
    %bwOri           = nan(nChan, A.nS);
    %bwSf            = nan(nChan, A.nS);
    
    for iS = 1:A.nS
        date            = A.allDate{iS};
        respToFit       = A.respMatRel(:,:,:,iS);
        goodChan        = A.goodChanByDay{iS};
        
        % Fit each channel's responses with a von Mises * gaussian 2d tuning
        % model.
        disp(['Fitting: ', date '... ' num2str(iS) ' / ' num2str(A.nS)])
        for iC = 1:nChan
            [param(:,iC,iS), fit(:,:,iC,iS), fval(iC,iS)] = FitVMBlob(respToFit(:,:,iC), nStarts);
            fprintf('%g ', iC);
            if mod(iC, 24) == 0
                fprintf('\n')
            end
        end
        
        % From the fits, derive tuning parameters.
        for iC = 1:nChan
            fitUp            = VMBlob(oriAxisUp, sfAxisUp, param(:, iC, iS));
            [~,maxind]       = max(fitUp(:));
            [maxy, maxx]     = ind2sub(size(fitUp), maxind);
            pkOri(iC,iS)     = maxx;
            pkSfInd(iC,iS)   = sfAxisUp(maxy);                                  % Easier to plot on this axis: 5 * 2.^[-4:1]; then relabel
            pkSf(iC,iS)      = 5 * 2^(pkSfInd(iC,iS));
            tuningOri(:,iC,iS)   = fitUp(maxy, :);
            tuningSf(:,iC,iS)    = fitUp(:,maxx);
            [osiOri(iC,iS),~]    = osi(tuningOri(:,iC,iS), oriAxisUp);          % orientation selectivity index
        end
        
        % Plot the responses for each day and the model fits.
        if plotFit
            figure; hold on                                                        % Plot fit
            pos = get(gcf,'Position');
            set(gcf,'Position',[pos(1) pos(2) 600 600])
            maxSessResp = max(respToFit(:));
            colorax = [-maxSessResp maxSessResp];
            for iC = 1:nChan
                nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
                imagesc(fit(:,:,iC,iS));
                axis tight; axis off
                colormap redblue; caxis(colorax)
                set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
                if ismember(iC, goodChan)
                    axis on; set(gca, 'XTick', [], 'YTick', []);
                    title([num2str(iC) '**'])
                else
                    title(iC)
                end
            end
            suptitle([date ' - model fits'])
            print([figureDir animalID '_' eye '_Gratings_' arrayID '_' date '_allRecSesRespMatRel_fit'], ...
                '-dpdf');
        end
        
        if plotDayResp
            figure; hold on                                                        % Plot response matrices
            pos = get(gcf,'Position');
            set(gcf,'Position',[pos(1) pos(2) 600 600])
            maxSessResp = max(respToFit(:));
            colorax = [-maxSessResp maxSessResp];
            for iC = 1:nChan
                nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
                imagesc(respToFit(:,:,iC));
                axis tight; axis off
                colormap redblue; caxis(colorax)
                set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
                if ismember(iC, goodChan)
                    axis on; set(gca, 'XTick', [], 'YTick', []);
                    title([num2str(iC) '**'])
                else
                    title(iC)
                end
            end
            suptitle([date ' - baseline subtracted response'])
            print([figureDir animalID '_' eye '_Gratings_' arrayID '_' date '_allRecSesRespMatRel'], ...
                '-dpdf');
        end
        close all
    end
    
    save(allRespFitFile, ....
        'dataType', 'nParam', 'nStarts', 'fit', 'param', 'fval', ...
        'oriAxisUp', 'sfAxisUp', ...
        'pkOri', 'pkSfInd', 'pkSf', 'tuningOri', 'tuningSf', 'osiOri');
    
end

%% Look at tuning from fits
A               = load(allRespSaveFile);
F               = load(allRespFitFile);

goodChanInd     = find(A.goodChanByChan);

% Distribution of orientation preferences
figure;
histogram(F.pkOri(goodChanInd))
xlabel('degrees')
ylabel('sites')
title('preferred orientation')

% Distribution of spatial frequency preferences
figure;
histogram(F.pkSfInd(goodChanInd))
set(gca, 'XTick', [-4:1], 'XTickLabel', sfAxis)
xlabel('spatial frequency (cyc/deg)')
ylabel('sites')
title('preferred spatial frequency')

% Distribution of orientation selectivity
figure;
histogram(F.osiOri(goodChanInd))
xlabel('OSI')
ylabel('sites')
title('orientation selectivity')

%% Plot responses combined across all days
%  Get visual sense if tuning stayed consistent across days.
A       = load(allRespSaveFile);
F       = load(allRespFitFile);
aMap    = A.aMap;

% First, normalize response within each day.
normRespAvgOverDays     = nan(nSf, nOri, nChan);
for iS = A.nS
    dayResp     = A.respMatRel(:,:,:,iS);
    normRespAvgOverDays(:,:,:)  = dayResp / max(dayResp(:));
end

normRespAvgOverDays     = nanmean(A.respMatRel, 4);         % comment this out if actually normalizing

figure; hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 600 600])
maxSessResp = max(normRespAvgOverDays(:));
colorax = [-maxSessResp maxSessResp];
for iC = 1:nChan
    nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
    imagesc(normRespAvgOverDays(:,:,iC));
    axis tight; axis off
    colormap redblue; caxis(colorax)
    set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
    title(iC);
end
suptitle('responses averaged over all days')
print([figureDir animalID '_' eye '_Gratings_' arrayID '_respAvgAcrossDays'], ...
    '-dpdf');

%% For each channel, plot responses for each day

for iC = 1:nChan
    figSaveName = [figureDir animalID '_' eye '_Gratings_' arrayID '_respEachDay_chan' num2str(iC) '.png'];
    chanResp    = squeeze(A.respMatRel(:,:,iC,:));
    maxSessResp = max(chanResp(:));
    colorax = [-maxSessResp maxSessResp];
    figure; hold on
    set(gcf,'Position',[pos(1) pos(2) 2500 150])
    for iS = 1:A.nS
        nsubplot(1, A.nS, 1, iS);
        imagesc(chanResp(:,:,iS));
        axis tight; axis square
        set(gca, 'XTick', [1 4], 'XTickLabel', {'0', '90'});
        if iS == 1
            set(gca, 'YTick', [1 4 6], 'YTickLabel', {'0.3125', '2.5', '10'});
            ylabel('SF')
        else
            set(gca, 'YTick', [])
        end
        colormap redblue; caxis(colorax)
        set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
    end
    suptitle(['channel ' num2str(iC)])
    %print(figSaveName, '-dpdf')
    export_fig(figSaveName, '-q100')
    close all
end

%% (OLD) Plot responses for each day.
% A = load(allRespSaveFile)
% plotEachDay = 0;
%
% if plotEachDay == 1
%     for iS = 1:length(respFiles)
%         try
%
%         figure; hold on                                                        % Plot response matrices
%         pos = get(gcf,'Position');
%         set(gcf,'Position',[pos(1) pos(2) 600 600])
%         maxSessResp = max(maxChanResp(:,iS));
%         colorax = [-maxSessResp maxSessResp];
%         %colorax = [-10 10];
%         for iC = 1:nChan
%             nsubplot(10, 10, A.aMap.row(iC)+1, A.aMap.col(iC)+1);
%             imagesc(A.respBinned(:,:,iC,iS));
%             axis tight; axis off
%             colormap redblue; caxis(colorax)
%             set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
%             title(iC)
%         end
%         suptitle('baseline subtracted responses, 50-150 ms')
%         export_fig([figureDir A.files{iS} '_avgResp.pdf'] );
%
%         figure; hold on                                                        % Plot response matrices
%         pos = get(gcf,'Position');
%         set(gcf,'Position',[pos(1) pos(2) 600 600])
%         maxSessResp = max(maxChanResp(:,iS));
%         colorax = [-1 1];
%         %colorax = [-10 10];
%         for iC = 1:nChan
%             nsubplot(10, 10, A.aMap.row(iC)+1, A.aMap.col(iC)+1);
%             imagesc(A.respBinnedNorm(:,:,iC,iS));
%             axis tight; axis off
%             colormap redblue; caxis(colorax)
%             set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
%             title(iC)
%         end
%         suptitle('baseline subtracted responses, normalized, 50-150 ms')
%         export_fig([figureDir A.files{iS} '_avgNorm.pdf'] );
%
%         figure; hold on                                                        % Plot PSTHs
%         pos = get(gcf,'Position');
%         set(gcf,'Position',[pos(1) pos(2) 900 900])
%         maxSessResp = max(max([respAvgOverTime(:,:,iS) respBlankOverTime(:,:,iS)]));
%         for iC = 1:nChan
%             nsubplot(10, 10, A.aMap.row(iC)+1, A.aMap.col(iC)+1);
%             hold on
%             plot(respAvgOverTime(:,iC,iS), 'r');
%             plot(respBlankOverTime(:,iC,iS), 'k');
%             xlim([0 30]);
%             set(gca, 'XTick', [])
%             %ylim([0 maxSessResp]);
%             %axis off
%             set(gca, 'Position',get(gca, 'Position')+[0 0 0.001 0.001]);
%             title(iC)
%         end
%         suptitle('response PSTHs 0-300 ms after stim on')
%         export_fig([figureDir A.files{iS} '_psth.pdf'] );
%
%         figure; hold on                                                    % Histogram of maximum spiking rate for each trial/channel
%         pos = get(gcf,'Position');                                         % (Check for artifacts that show up as abnormally high FR for one/few trials)
% %         set(gcf,'Position',[pos(1) pos(2) 900 900])
% %         maxSessResp = max(max([respAvgOverTime(:,:,iS) respBlankOverTime(:,:,iS)]));
% %         for iC = 1:nChan
% %             nsubplot(10, 10, A.aMap.row(iC)+1, A.aMap.col(iC)+1);
% %             hold on
% %             plot(respAvgOverTime(:,iC,iS), 'r');
% %             plot(respBlankOverTime(:,iC,iS), 'k');
% %             xlim([0 30]);
% %             set(gca, 'XTick', [])
% %             %ylim([0 maxSessResp]);
% %             %axis off
% %             set(gca, 'Position',get(gca, 'Position')+[0 0 0.001 0.001]);
% %             title(iC)
% %         end
%         suptitle('response PSTHs 0-300 ms after stim on')
%         export_fig([figureDir A.files{iS} '_psth.pdf'] );
%
%         close all
%
%         end
%     end
% end
%
% % Plot shuffle test results for each channel across days
% figure; hold on
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 900 900])
% for iC = 1:nChan
%     nsubplot(10, 10, A.aMap.row(iC)+1, A.aMap.col(iC)+1);
%     imagesc(A.goodChanByChan(iC,:))
%     colormap redblue
%     caxis([0 1])
%     axis tight; axis off
%     set(gca, 'Position',get(gca, 'Position')+[0 0 0.001 0.001]);
%     title(iC)
% end
% suptitle('shuffle test results across recording sessions, red = passed')
%
% % Plot maximum response (baseline subtracted) for each channel across days
% figure; hold on
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 900 900])
% for iC = 1:nChan
%     nsubplot(10, 10, A.aMap.row(iC)+1, A.aMap.col(iC)+1);
%     plot(A.maxChanResp(iC,:))
%     xlim([0 nS])
%     ylim([0 max(A.maxChanResp(:))])
%     set(gca, 'XTick', [], 'YTick', [])
%     set(gca, 'Position',get(gca, 'Position')+[0 0 0.001 0.001]);
%     title(iC)
% end
% suptitle('maximum response across days')
%
% % Plot histogram of good vs bad channels for each day
% figure; hold on
% goodVsBadEachDay = NaN(nS,2);
% for iS = 1:nS
%    goodVsBadEachDay(iS,:) = [sum(A.goodChanByChan(:,iS)==0); sum(A.goodChanByChan(:,iS)==1)];
% end
% bar(goodVsBadEachDay)
% legend({'Bad chan', 'Good chan'})
% ylim([0 96])
% xlim([0 nS])
% xlabel('Recording session')
%

