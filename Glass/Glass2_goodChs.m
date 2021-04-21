clear all
close all
clc
tic
%%
files = {
%     'XT_LE_GlassTR_nsp2_Jan2019_all_thresh35_info3';
%     'XT_LE_GlassTR_nsp1_Jan2019_all_thresh35_info3';
%     'XT_RE_GlassTR_nsp2_Jan2019_all_thresh35_info3';
%     'XT_RE_GlassTR_nsp1_Jan2019_all_thresh35_info3';
%     
%     'XT_LE_Glass_nsp2_Jan2019_all_thresh35_info3';
%     'XT_LE_Glass_nsp1_Jan2019_all_thresh35_info3';
%     'XT_RE_Glass_nsp2_Jan2019_all_thresh35_info3';
%     'XT_RE_Glass_nsp1_Jan2019_all_thresh35_info3';
    
%     'WV_RE_glassTRCoh_nsp2_April2019_all_thresh35_info3';
%     'WV_RE_glassTRCoh_nsp1_April2019_all_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp2_April2019_all_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp1_April2019_all_thresh35_info3';
% 
%     'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info3';
%     'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info3';
%     'WV_LE_glassCoh_nsp2_April2019_all_thresh35_info3';
%     'WV_LE_glassCoh_nsp1_April2019_all_thresh35_info3';
%     
%     'WU_RE_Glass_nsp2_Aug2017_all_thresh35_info3';
%     'WU_RE_Glass_nsp1_Aug2017_all_thresh35_info3';
%     'WU_LE_Glass_nsp2_Aug2017_all_thresh35_info3';
%     'WU_LE_Glass_nsp1_Aug2017_all_thresh35_info3';
% 
%     'WU_RE_GlassTR_nsp2_Aug2017_all_thresh35_info3';
%     'WU_RE_GlassTR_nsp1_Aug2017_all_thresh35_info3';
%     'WU_LE_GlassTR_nsp1_Aug2017_all_thresh35_info3';
%     'WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info3';

% 'WU_LE_GlassTR_nsp1_Aug2019_all_thresh35_DxComp';
'WU_LE_GlassTR_nsp2_Aug2019_all_thresh35_DxComp';
};
%%
nameEnd = 'goodRuns';
numPerm = 200;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
for fi = 1:length(files)
    %%
    %try
        filename = files{fi};
        fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
        
        if contains(filename,'all') % data has been merged across sessions
            dataT = load(filename);
        else
            load(filename);
            if contains(filename,'RE')
                dataT = data.RE;
            else
                dataT = data.LE;
            end
        end
        %% determine reponsive channels
        %dataT = GlassStimVsBlankPermutations_allStim(dataT,numPerm,holdout);
        [dataT.allStimBlankDprime, dataT.allStimBlankDprimeBootPerm, dataT.stimBlankDprimePerm, dataT.stimBlankSDPerm] = StimVsBlankPermutations_allStim_zScore(dataT.allStimZscore,dataT.blankZscore);
        [dataT.stimBlankChPvals, dataT.responsiveCh] = getPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm,2,1);
        fprintf('responsive channels defined\n')
        %% setup for split-half
        if contains(dataT.programID,'TR')
            GlassChLast = permute(dataT.GlassTRZscore,[1 2 3 4 6 5]);% rearrange so number of channels is the last thing.
            numRepeats = size(dataT.GlassTRZscore,6);
            if contains(filename,'Coh','IgnoreCase',true)
                GlassReshape = reshape(GlassChLast,64,numRepeats,96);
            else
                %                 GlassReshape = reshape(GlassChLast,16,numRepeats,96);
                GlassReshape = reshape(GlassChLast,144,numRepeats,96);
            end
            
            nozChLast = permute(dataT.noiseZscore,[1 2 3 4 6 5]);
            numRepeats = size(dataT.noiseZscore,6);
            nozReshape = reshape(nozChLast,144,numRepeats,96); % use this for WU with all conditions only
            %             if contains(filename,'Coh','IgnoreCase',true)
            %                 nozReshape = reshape(nozChLast,64,numRepeats,96);
            %             else
%                 nozReshape = reshape(nozChLast,16,numRepeats,96);
%             end
            zScoreReshape = cat(2,GlassReshape,nozReshape);
            %%
        else
            glassZchLast = permute(dataT.glassZscore,[1 2 3 4 6 5]);% rearrange so number of channels is the last thing.
            zScoreReshape = reshape(glassZchLast,12,size(glassZchLast,5),96);
        end
        %% do split half correlations and permutations
        [dataT.zScoreReliabilityIndex, dataT.zScoreReliabilityPvals,dataT.zScoreSplitHalfSigChs,dataT.zScoreReliabilityIndexPerm] = getHalfCorrPerm(zScoreReshape,filename);
        %     plotResponsePvalsVSreliabilityPvals_inStim(dataT)
        plotResponsePvalsVSreliabilityPvals(dataT)
        fprintf('Split-Half correlations computed and permuted %.2f minutes\n',toc/60)
        %% Define truly good channels that pass either the visually responsive OR split-half reliability metric
        dataT.goodCh = logical(dataT.responsiveCh) | logical(dataT.zScoreSplitHalfSigChs);
        %% plot PSTHs
        if ~contains(filename,'all') % running on a single session rather than merged data
            if location == 1
                figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
            elseif location == 0
                figDir =  sprintf('~/Dropbox/Figures/%s/%/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
            end
        else
            if location == 1
                figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%/%s/PSTH/',dataT.animal,dataT.programID,dataT.array);
            elseif location == 0
                figDir =  sprintf('~/Dropbox/Figures/%s/%/%s/PSTH/',dataT.animal,dataT.programID,dataT.array);
            end
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
            dataT.goodCh(ch);
            
            LEcoh = (dataT.coh == 1);
            LEnoiseCoh = (dataT.coh == 0);
            LEcohNdx = logical(LEcoh + LEnoiseCoh);
            
            if dataT.goodCh(ch) == 1
                
                blankResp = nanmean(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
                stimResp = nanmean(smoothdata(dataT.bins((LEcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
                plot(1:35,blankResp,'Color',[0.2 0.2 0.2],'LineWidth',0.5);
                plot(1:35,stimResp,'-k','LineWidth',2);
                
                title(ch)
            else
                axis off
            end
            set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');
            ylim([0 inf])
        end
        
        suptitle(sprintf('%s %s %s %s stim vs blank', dataT.animal, dataT.array, dataT.programID, dataT.eye));
        
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTHstimVBlank'];
        print(gcf, figName,'-dpdf','-bestfit')
        %% save good data
        if location == 1
            outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/goodChs/',dataT.array);
            if ~exist(outputDir, 'dir')
                mkdir(outputDir)
            end
        elseif location == 0
            outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/goodChs/',dataT.array);
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
    %% clean up workspace
    clearvars -except files fi nameEnd numPerm failedFiles failNdx numBoot location holdout
end