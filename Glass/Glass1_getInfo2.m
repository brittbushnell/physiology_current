clear
close all
clc
tic
%%
monks = {
   % 'WU';
   %  'WV';
     'XT';
    };
ez = {
    'LE';
 % 'RE';
    };
brArray = {
  % 'V4';
  'V1';
    };
%%
nameEnd = 'info';
numPerm = 2000;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
for an = 1:length(monks)
    monk = monks{an};
    for ey = 1:length(ez)
        eye = ez{ey};
        for ar = 1:length(brArray)
            area = brArray{ar};
            %%
            if location == 0
                dataDir = sprintf('~/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            else
                dataDir = sprintf('/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            end
            cd(dataDir);
            
            tmp = dir;
            ndx = 1;
            corNdx = 1;
            filesT = {};
            filesC = {};
            %%
            for t = 1:size(tmp,1)
                if contains(tmp(t).name,'.mat')
                    if strcmp(tmp(t).name,'WU_LE_GlassTR_nsp2_20170822_002_thresh35.mat')
                    elseif contains(tmp(t).name,'_og')
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
            
            files = cat(1,filesC,filesT);
            
            if location == 0
                listDir ='~/Dropbox/ArrayData/matFiles/reThreshold/listMatrices/Glass/';
            else
                listDir = '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/listMatrices/Glass/';
            end
            
            mtxSaveName = [listDir,monk,'_',eye,'_',area,'_Glass_','FileList.mat'];
            save(mtxSaveName,'files')
            
            clear tmp
            clear ndx
        end
    end
end
%% 
for fi = 1:length(files)
    %% Get basic information about experiments
   % try
        
        filename = files{fi};
        dataT = load(filename);
        
        aMap = getBlackrockArrayMap(filename);
        
        tmp = strsplit(filename,'_');
        dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3}; array = tmp{4};
        dataT.date2 = tmp{5}; dataT.runNum = tmp{6}; dataT.date = convertDate(dataT.date2); %dataT.reThreshold = tmp{7};
        
        if strcmp(array, 'nsp1')
            dataT.array = 'V1';
        elseif strcmp(array, 'nsp2')
            dataT.array = 'V4';
        end
        
        if contains(dataT.animal,'XX')
            dataT.filename = reshape(dataT.filename,[numel(dataT.filename),1]);
            dataT.filename = char(dataT.filename);
        end
        
        ndx = 1;
        for i = 1:size(dataT.filename,1)
            [type, numDots, dx, coh, sample] = parseGlassName(dataT.filename(i,:));
            
            %  type: numeric versions of the first letter of the pattern type
            %     0:  noise
            %     1: concentric
            %     2: radial
            %     3: translational
            %     100:blank
            dataT.type(1,ndx)    = type;
            dataT.numDots(1,ndx) = numDots;
            dataT.dx(1,ndx)      = dx;
            dataT.coh(1,ndx)     = coh;
            dataT.sample(1,ndx)  = sample;
            ndx = ndx+1;
        end
        %%
        if sum(ismember(dataT.numDots,100)) ~=0 % if 100 and 0.01 were run, remove them.
            if ~contains(dataT.programID,'TR')
                dataT = removeTranslationalStim(dataT); % a small number of experiments were run with all 3 patterns
            end
            
            dataT = GlassRemoveLowDx(dataT);
            dataT = GlassRemoveLowDots(dataT);
        end
        % dataT.stimOrder = getStimPresentationOrder(dataT);
        % add in anything that's missing from the new dataT structure.
        tmp = strsplit(filename,'_');
        dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3}; array = tmp{4};
        dataT.date2 = tmp{5}; dataT.runNum = tmp{6}; dataT.date = convertDate(dataT.date2); %dataT.reThreshold = tmp{7};
        
        if strcmp(array, 'nsp1')
            dataT.array = 'V1';
        elseif strcmp(array, 'nsp2')
            dataT.array = 'V4';
        end
        
        if contains(dataT.animal,'WU')
            dataT.fix_x = 0;
            dataT.fix_y = 0;
        end
        
        dataT.amap = aMap;
        %% convert dx to a meaningful measurement
        dataT.dxDeg = 8.*dataT.dx;
        %% get receptive field parameters
        % RF center is relative to fixation, not center of the monitor.
        dataT = callReceptiveFieldParameters(dataT);
        %% find channels whose receptive fields are within the stimulus bounds
        [dataT.rfQuadrant, dataT.rfParams, dataT.inStim] = getRFsinStim(dataT);
        dataT.inStim = ~isnan(dataT.rfQuadrant); % want all channels whos RF center is within the stimulus bounds to be 1.
        %% get spike counts, Zscore, and split half correlations
        if contains(dataT.programID,'TR')
            [dataT.GlassTRSpikeCount,dataT.noiseSpikeCount,dataT.blankSpikeCount,dataT.allStimSpikeCount] = getGlassTRSpikeCounts(dataT);
            [dataT.GlassTRZscore,dataT.allStimZscore, dataT.blankZscore, dataT.noiseZscore] = getGlassTRStimZscore(dataT);
        else
            [dataT.radSpikeCount,dataT.conSpikeCount, dataT.noiseSpikeCount,dataT.blankSpikeCount,dataT.allStimSpikeCount] = getGlassCRSpikeCounts(dataT);
            [dataT.conZscore, dataT.radZscore, dataT.noiseZscore, dataT.allStimZscore,dataT.blankZscore] = getGlassStimZscore(dataT);
        end
       fprintf(sprintf('spike counts done, zscores computed %d minutes \n', toc/60))
       %%

        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/%/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
        end

    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    cd(figDir)
    %% plot LE
    figure;
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 800])
    set(gcf,'PaperOrientation','Landscape');
    for ch = 1:96
        
        subplot(dataT.amap,10,10,ch)
        hold on;
        %dataT.goodCh(ch);
        
        LEcoh = (dataT.coh == 1);
        LEnoiseCoh = (dataT.coh == 0);
        LEcohNdx = logical(LEcoh + LEnoiseCoh);
        
        %if dataT.goodCh(ch) == 1
            
            blankResp = nanmean(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(dataT.bins((LEcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'Color',[0.2 0.2 0.2],'LineWidth',0.5);
            plot(1:35,stimResp,'-k','LineWidth',2);
            
            title(ch)
%         else
%             axis off
%         end
        set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');
        ylim([0 inf])
    end
    fname = strrep(filename,'_',' ');
    suptitle({sprintf('%s %s %s %s stim vs blank', dataT.animal, dataT.array, dataT.programID, dataT.eye);...
        sprintf(sprintf('%s',string(fname)))});
    
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTHstimVBlank_raw'];
    print(gcf, figName,'-dpdf','-fillpage')
        %% save good data
        if location == 1
            outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/info/',dataT.array);
            if ~exist(outputDir, 'dir')
                mkdir(outputDir)
            end
        elseif location == 0
            outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/info/',dataT.array);
            if ~exist(outputDir, 'dir')
                mkdir(outputDir)
            end
        end
        
        if contains(filename,'LE')
            data.LE = dataT;
            data.RE = [];
        else
            data.RE = dataT;
            data.LE = [];
        end
        shortName = strrep(filename,'.mat','');
        saveName = [outputDir shortName '_' nameEnd '.mat'];
        save(saveName,'data');
        fprintf('%s saved\n  run time: %.2f minutes\n\n', saveName, toc/60)
        
%     catch ME
%         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
%         failNdx = failNdx+1;
%         failedFiles{failNdx,1} = filename;
%         failedME{failNdx,1} = ME;
%     end
    clear dataT
   % clearvars -except files fi nameEnd numPerm failedFiles failNdx numBoot location holdout plotFlag
end
%         end
%     end
% end
