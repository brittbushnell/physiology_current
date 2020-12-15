clear all
close all
clc
tic
%%
files = {
    'WV_LE_MapNoise_nsp2_Jan2019_all_thresh35_info3';
    'WV_RE_MapNoise_nsp2_Jan2019_all_thresh35_info3';
    'WV_LE_MapNoise_nsp1_Jan2019_all_thresh35_info3';
    'WV_RE_MapNoise_nsp1_Jan2019_all_thresh35_info3';
    
    'XT_LE_mapNoise_nsp1_Oct2018_all_thresh35';
    'XT_RE_mapNoise_nsp1_Oct2018_all_thresh35';
    
    'WU_LE_GratingsMapRF_nsp2_20170426_003_thresh35_info3';
    'WU_RE_GratingsMapRF_nsp2_20170426_001_thresh35_info3';
    'WU_LE_GratingsMapRF_nsp1_20170426_003_thresh35_info3';
    'WU_RE_GratingsMapRF_nsp1_20170426_001_thresh35_info3';
    };
nameEnd = 'resps';
%%
numPerm = 2000;
numBoot = 200;
holdout = .90;
plotFlag = 0; % 0 if you don't want to plot anything.
%%
location = determineComputer;
failedFiles = {};
failNdx = 1;
%%
for fi = 1:length(files)
    %% Get basic information about experiments
    % try
    filename = files{fi};
    fprintf('\n*** analyzing %s *** \n file %d/%d \n', filename,fi,size(files,1))
    
    if ~contains(filename,'all')
        load(filename);
        if contains(filename,'RE')
            dataT = data.RE;
        else
            dataT = data.LE;
        end
    else
        dataT =load(filename);
    end
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/%s/',dataT.array,dataT.programID);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/%s/',dataT.array,dataT.programID);
    end
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
    end
    %% do stim vs blank permutation test

    
    %% get receptive field centers and boundaries
    % verify 1) using z-scores  2)  using (y,x) for mapping receptive
    % fields.
    dataT = getReceptiveFields_zScore(dataT);
    %% plot location specific responses
    % plotMapping_locHeatMapbyCh(dataT)
    % plotMappingPSTHs_visualResponsesChs(dataT,0)
    % dataT = plotArrayReceptiveFields(dataT);
    %%
    location = determineComputer;
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/',dataT.animal,dataT.programID, dataT.eye);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/',dataT.animal, dataT.programID, dataT.eye);
    end
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    cd(figDir)
    %%
    
    figure%(6)
    clf
    hold on
    for ch = 1:96
        if contains(filename,'RE')
            scatter(dataT.chReceptiveFieldParams{ch}(1),dataT.chReceptiveFieldParams{ch}(2),35,[0.8 0 0.4],'filled','MarkerFaceAlpha',0.7);
        else
            scatter(dataT.chReceptiveFieldParams{ch}(1),dataT.chReceptiveFieldParams{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
        end
        
        grid on;
        xlim([-14,14])
        ylim([-14,14])
        set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
            'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
        axis square
    end
    if contains(dataT.animal,'WU')
        viscircles([0,0],1.5, 'color',[0.2 0.2 0.2]);
    else
        viscircles([0,0],0.75, 'color',[0.2 0.2 0.2]);
    end
    plot(dataT.fix_x, dataT.fix_y,'ok','MarkerFaceColor','k','MarkerSize',8)
    title(sprintf('%s %s %s recepive field centers',dataT.animal, dataT.array, dataT.eye),'FontSize',14,'FontWeight','Bold')
    figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_receptiveFieldCenter','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
        
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
    end
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
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
    %         failNdx = failNdx+1;
    %         fprintf('\n%s did not work. \nError message: %s \n\n',filename,ME.message)
    %         failedFiles{failNdx,1} = filename;
    %         failedFiles{failNdx,2} = ME.message;
    %     end
end