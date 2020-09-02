%% Compare responses between amblyopic eye and fellow eye. 
%  Done separately for V1/V2 array and V4 array.
%  In WU: LE = fellow eye, RE = amblyopic eye.

clearvars;

%  Set up directories.
addpath(genpath('/Volumes/BIGZINGY/BlackrockData'))                        % Data stored here.
addpath(genpath('/u/vnl/users/julia'))                                     % Analysis scripts.
addpath(genpath('/Library/Application Support/MWorks/Scripting/Matlab'))   % Matlab support for Mworks (needed to run parser).

animalID    = 'WU';
ambEye      = 'RE';
felEye      = 'LE';

arrayID     = 'nsp1';                                                      % nsp1 = V1/V2, nsp2 = V4
if arrayID == 'nsp1'
    recArea     = 'V1/V2';
elseif arrayID == 'nsp2'
    recArea     = 'V4';
end
nChan       = 96;
oriAxis     = [0    30    60    90   120   150];
sfAxis      = 5 * 2.^[-4 : 1];

dataDir     = '/Volumes/BIGZINGY/BlackRockData/';
outputDir   = [ '/Volumes/BIGZINGY/BlackRockData/' arrayID '/preproc/'];
%figureDir   = [ '/Volumes/BIGZINGY/BlackRockData/' arrayID '/figures/'];
figureDir   = [ '/Volumes/BIGZINGY/BlackRockData/compFigures/'];           % directory to save out figures

ambResp     = load([outputDir 'WU_' ambEye '_' arrayID '_allResp.mat']);
felResp     = load([outputDir 'WU_' felEye '_' arrayID '_allResp.mat']);
ambRespFit  = load([outputDir 'WU_' ambEye '_' arrayID '_allRespFit.mat']);
felRespFit  = load([outputDir 'WU_' felEye '_' arrayID '_allRespFit.mat']);

% Dates where both eyes were recorded.
biDate      = intersect(ambResp.allDate, felResp.allDate);
nBiDate     = length(biDate);

aMap        = felResp.aMap;

%% Compare ODI and spatial frequency across eyes.
ocDom       = [];
ambPrefSfInd   = [];
felPrefSfInd   = [];
felDayInd      = nan(1, nBiDate);
ambDayInd      = nan(1, nBiDate);
% ambRespRel  = {};
% felRespRel  = {};
% ambFit      = {};
% felFit      = {};

for iD = 1:nBiDate
    date        = biDate(iD);
    felDayInd(iD)   = find(strcmp(felResp.allDate, date));
    ambDayInd(iD)   = find(strcmp(ambResp.allDate, date));
    biDayResponsiveChan = intersect(ambResp.responsiveChanByDay{ambDayInd(iD)}, felResp.responsiveChanByDay{felDayInd(iD)});
    
    % Average response across all gratings for each channel.
    felStimAvg  = squeeze(nanmean(nanmean(felResp.respMat(:,:,:,felDayInd(iD)))));
    ambStimAvg  = squeeze(nanmean(nanmean(ambResp.respMat(:,:,:,ambDayInd(iD)))));
    responsiveChanBothEyes = intersect(felResp.goodChanByDay{felDayInd(iD)}, ambResp.goodChanByDay{ambDayInd(iD)});
    % Calculate ocular dominance
    ocDom       = [ocDom; ...
        (felStimAvg(responsiveChanBothEyes) - ambStimAvg(responsiveChanBothEyes)) ./ ...
        (felStimAvg(responsiveChanBothEyes) + ambStimAvg(responsiveChanBothEyes)) ];
    % Collect channel-matched spatial frequency preferences
    ambPrefSfInd    = [ambPrefSfInd; ambRespFit.pkSfInd(responsiveChanBothEyes, ambDayInd(iD))];
    felPrefSfInd    = [felPrefSfInd; felRespFit.pkSfInd(responsiveChanBothEyes, felDayInd(iD))];
    
end
nSites      = length(ocDom);

figure;  % Ocular dominance histogram
    histogram(ocDom);
    xlim([-1 1]);
    ylim([0 nSites/4])
    set(gca, 'XTick', [-1 -0.5 0 0.5 1], 'XTickLabel', {'AE', '', 'Binocular', '', 'FE'});
    set(gca, 'YTick', [0 nSites*0.1 nSites*0.2], 'YTickLabel', {'0', '0.1', '0.2'})
    line([0 0], ylim)
    line([nanmean(ocDom) nanmean(ocDom)], ylim, 'Color', 'r')
    ylabel('Proportion sites')
    title([recArea ' -- Ocular dominance -- mean = ' num2str(nanmean(ocDom))])
    
figure; hold on   % SF preference distributions
nsubplot(2, 1, 1, 1);
    histogram(felPrefSfInd);
    set(gca, 'XTick', [-4:1], 'XTickLabel', sfAxis)
    xlabel('spatial frequency (cyc/deg)')
    ylim([0 nSites/3])
    set(gca, 'YTick', [0 nSites*0.1 nSites*0.2 nSites*0.3], 'YTickLabel', {'0', '0.1', '0.2', '0.3'})
    line([nanmean(felPrefSfInd) nanmean(felPrefSfInd)], ylim, 'Color', 'r')
    title(['Fellow eye - mean = ' num2str(5*2^(nanmean(felPrefSfInd)))])
nsubplot(2, 1, 2, 1);
    histogram(ambPrefSfInd);
    set(gca, 'XTick', [-4:1], 'XTickLabel', sfAxis)
    xlabel('spatial frequency (cyc/deg)')
    ylim([0 nSites/3])
    set(gca, 'YTick', [0 nSites*0.1 nSites*0.2 nSites*0.3], 'YTickLabel', {'0', '0.1', '0.2', '0.3'})
    line([nanmean(ambPrefSfInd) nanmean(ambPrefSfInd)], ylim, 'Color', 'r')
    title(['Amblyopic eye -  mean = ' num2str(5*2^(nanmean(ambPrefSfInd)))])
suptitle([recArea ' -- preferred spatial frequency '])
    
%% Plot responses averaged across all days 
%  Get visual sense if tuning stayed consistent across days. 

figure; hold on    % fellow eye
    chanResp    = nanmean(felResp.respMatRel(:,:,:,:),4);
    pos         = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 600 600])
    maxSessResp = max(chanResp(:));
    colorax = [-maxSessResp maxSessResp];
    for iC = 1:nChan
        nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
        imagesc(chanResp(:,:,iC));
        axis tight; axis off
        colormap redblue; caxis(colorax)
        set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
        title(iC);
    end
    suptitle([arrayID ' - ' felEye ': responses averaged over all days'])
    print([figureDir animalID '_' felEye '_Gratings_' arrayID '_respAvgAcrossDays'], ...
        '-dpdf');

figure; hold on    % amb eye
    chanResp    = nanmean(ambResp.respMatRel(:,:,:,:),4);
    pos         = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 600 600])
    maxSessResp = max(chanResp(:));
    colorax = [-maxSessResp maxSessResp];
    for iC = 1:nChan
        nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
        imagesc(chanResp(:,:,iC));
        axis tight; axis off
        colormap redblue; caxis(colorax)
        set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
        title(iC);
    end
    suptitle([arrayID ' - ' ambEye ': responses averaged over all days'])
    print([figureDir animalID '_' ambEye '_Gratings_' arrayID '_respAvgAcrossDays'], ...
        '-dpdf');
    
%% For each channel, plot responses for each day

for iC = 1:nChan
    % Plot responses
    figSaveName = [figureDir 'byChannel/' arrayID '/' animalID '_Gratings_' arrayID '_respEachDay_chan' num2str(iC) '.png'];
    
    felChanResp    = squeeze(felResp.respMatRel(:,:,iC,:));
    ambChanResp    = squeeze(ambResp.respMatRel(:,:,iC,:));
    felChanFit    = squeeze(felRespFit.fit(:,:,iC,:));
    ambChanFit    = squeeze(ambRespFit.fit(:,:,iC,:));
    
    maxSessResp = max([ max(felChanResp(:)) max(ambChanResp(:)) max(felChanFit(:)) max(ambChanFit(:))]);
    colorax = [-maxSessResp maxSessResp];
    
    figure; hold on
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 2500 600])
    for iS = 1:nBiDate
        nsubplot(5, nBiDate, 1, iS); % Fellow eye response
        imagesc(felChanResp(:,:,felDayInd(iS)));
        axis tight; axis square
        set(gca, 'XTick', [1 4], 'XTickLabel', {'0', '90'});
        if iS == 1
            set(gca, 'YTick', [1 4 6], 'YTickLabel', {'0.3125', '2.5', '10'});
            ylabel('FE response')
        else
            set(gca, 'YTick', [])
        end
        colormap redblue; caxis(colorax)
        set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
        
        nsubplot(5, nBiDate, 2, iS);  % amb eye response
        imagesc(ambChanResp(:,:,ambDayInd(iS)));
        axis tight; axis square
        set(gca, 'XTick', [1 4], 'XTickLabel', {'0', '90'});
        if iS == 1
            set(gca, 'YTick', [1 4 6], 'YTickLabel', {'0.3125', '2.5', '10'});
            ylabel('AE response')
        else
            set(gca, 'YTick', [])
        end
        colormap redblue; caxis(colorax)
        set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
        %
        nsubplot(5, nBiDate, 3, iS); hold on
        plot(felResp.respAvgOverTime(:,iC,felDayInd(iS)), 'r');
        plot(felResp.respBlankOverTime(:,iC,felDayInd(iS)), 'r--');
        plot(ambResp.respAvgOverTime(:,iC,ambDayInd(iS)), 'k');
        plot(ambResp.respBlankOverTime(:,iC,ambDayInd(iS)), 'k--');
        set(gca, 'XTick', [0 30], 'XTickLabel', {'0', '300'});
        set(gca, 'YTick', [0 max(ylim)], 'XTickLabel', {'0', num2str(max(ylim))});
        xlim([0 30])
        if iS == 1
            ylabel('FE=red, AE=black');
        end
        %
        nsubplot(5, nBiDate, 4, iS); % fellow eye fit
        imagesc(felChanFit(:,:,felDayInd(iS)));
        axis tight; axis square
        set(gca, 'XTick', [1 4], 'XTickLabel', {'0', '90'});
        if iS == 1
            set(gca, 'YTick', [1 4 6], 'YTickLabel', {'0.3125', '2.5', '10'});
            ylabel('FE fit')
        else
            set(gca, 'YTick', [])
        end
        colormap redblue; caxis(colorax)
        set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
        %
        nsubplot(5, nBiDate, 5, iS); % amb eye fit
        imagesc(ambChanFit(:,:,ambDayInd(iS)));
        axis tight; axis square
        set(gca, 'XTick', [1 4], 'XTickLabel', {'0', '90'});
        if iS == 1
            set(gca, 'YTick', [1 4 6], 'YTickLabel', {'0.3125', '2.5', '10'});
            ylabel('AE fit')
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

%% Plot orientation and SF tuning over time for each channel
figure; hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 850])
for iC = 1:nChan
    felChanJTS = felResp.goodChanByChan(iC,felDayInd);
    ambChanJTS = ambResp.goodChanByChan(iC,felDayInd);
    felScatColor = repmat([1 0 0], nBiDate, 1);
    felScatColor(find(felChanJTS==0),:) = felScatColor(find(felChanJTS==0),:) + [0 0.8 0.8]; % make not-good days pink
    ambScatColor = repmat([0 0 0], nBiDate, 1);
    ambScatColor(find(ambChanJTS==0),:) = ambScatColor(find(ambChanJTS==0),:)+0.8; % make not-good days gray
    
    nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
    scatter([1:nBiDate], felRespFit.pkOri(iC, felDayInd), 15, felScatColor, 'filled')
    scatter([1:nBiDate],ambRespFit.pkOri(iC, ambDayInd), 15, ambScatColor, 'filled')
    axis tight;
    set(gca, 'YTick', [90])
    set(gca, 'XTick', [])
    title(iC)
end
suptitle([arrayID ': Preferred orientation each day- FE = red, AE = black'])
export_fig([figureDir animalID '_' arrayID '_prefOriEachDay.png'], '-q100')
close

figure; hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 850])
for iC = 1:nChan
    felChanJTS = felResp.goodChanByChan(iC,felDayInd);
    ambChanJTS = ambResp.goodChanByChan(iC,felDayInd);
    felScatColor = repmat([1 0 0], nBiDate, 1);
    felScatColor(find(felChanJTS==0),:) = felScatColor(find(felChanJTS==0),:) + [0 0.8 0.8]; % make not-good days pink
    ambScatColor = repmat([0 0 0], nBiDate, 1);
    ambScatColor(find(ambChanJTS==0),:) = ambScatColor(find(ambChanJTS==0),:)+0.8; % make not-good days gray
    
    nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
    scatter([1:nBiDate], felRespFit.pkSfInd(iC, felDayInd), 15, felScatColor, 'filled')
    scatter([1:nBiDate], ambRespFit.pkSfInd(iC, ambDayInd), 15, ambScatColor, 'filled')
    axis tight;
    set(gca, 'YTick', [-4 -1 1], 'YTickLabel', {'0.31', '2.5', '10'})
    set(gca, 'XTick', [])
    title(iC)
end
suptitle([arrayID ': Preferred spatial frequency each day- FE = red, AE = black'])
export_fig([figureDir animalID '_' arrayID '_prefSFEachDay.png'], '-q100')
close