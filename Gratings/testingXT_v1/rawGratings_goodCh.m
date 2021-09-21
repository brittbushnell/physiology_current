clear
close all

%%
cd '/Users/brittany/Dropbox/ArrayData/matFiles/raw_Grat'

tmp = dir;
ndx = 1;
for t = 1:length(tmp)
    if contains(tmp(t),'.mat')
        tmp2(ndx) = tmp(t).name;
    end
    ndx = ndx+1;
end
%%
for i = 1:length(tmp)
    
    try
        fname = tmp(i).name;
        data = load(fname);
        
        amap = getBlackrockArrayMap(fname);
        blank = data.spatial_frequency == 0;
        grat  = data.spatial_frequency > 0.1;
        
        fnameParts = strsplit(fname,'_');
        %% get spike counts and z scores
        % future problem
        %         [dataT.RFStimResps,dataT.blankResps, dataT.stimResps] = parseRadFreqStimResp(dataT);
        %         [dataT.RFspikeCount,dataT.blankSpikeCount,dataT.RFzScore,dataT.blankZscore] = getRadFreqSpikeCountZscore2(dataT);
        %% determine visually responsive channels
        % input needs to be (ch x trials)
        blankResp = nan(96, 2000);
        stimResp  = nan(96,2000);
        
        
        for ch = 1:96
            blankT  = mean(smoothdata(data.bins((data.spatial_frequency == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimT = mean(smoothdata(data.bins((data.spatial_frequency > 0.1), 1:35 ,ch),'gaussian',3))./0.01;
            
            blankResp(ch,1:length(blankT)) = blankT;
            stimResp(ch,1:length(stimT)) = stimT;
        end
        
        [data.allStimBlankDprime, data.allStimBlankDprimeBootPerm, data.stimBlankDprimePerm, data.stimBlankSDPerm]...
            = StimVsBlankPermutations_allStim_zScore(stimResp,blankResp,1000,0.75);
        fprintf('stim vs Blank permutations done %.2f\n',toc/60)
        
        [data.stimBlankChPvals, data.responsiveCh]...
            = getPermutationStatsAndGoodCh(data.allStimBlankDprime,data.allStimBlankDprimeBootPerm,2,1);
        fprintf('%d responsive channels defined\n', sum(data.responsiveCh))
        
        if sum(data.responsiveCh) == 0
            fprintf('There were no responsive channels found, something''s funky')
            keyboard
        end
        
        %% do split half correlations and permutations
        % needs to be (conditions x repeats x channels)
        sfs = unique(data.spatial_frequency);
        sfsReal = sfs > 0.1;
        oris = unique(data.rotation);
        
        stimCon = nan(length(sfsReal)+length(oris),96,2000);
        
        ndx = 1;
        blankNdx = data.spatial_frequency == 0;
        for s = 1:length(sfsReal)
            sfNdx = data.spatial_frequency == sfsReal(s);
            for or = 1:length(oris)
                orNdx = data.rotation == oris(or);
                
                for ch = 1:96
                    stimConT = mean(smoothdata(data.bins((sfNdx & orNdx), 1:35 ,ch),'gaussian',3))./0.01;
                    stimCon(ndx,ch,1:length(stimConT)) = stimConT;
                end
                ndx = ndx+1;
            end
        end
        
        [data.zScoreReliabilityIndex, data.zScoreReliabilityPvals,data.zScoreSplitHalfSigChs,data.zScoreReliabilityIndexPerm]...
            = getHalfCorrPerm(stimZs,filename);
        %     plotResponsePvalsVSreliabilityPvals(data)
        fprintf('Split-Half correlations computed and permuted %.2f minutes\n',toc/60)
        %% Define truly good channels that pass either the visually responsive OR split-half reliability metric
        data.goodCh = logical(data.responsiveCh) | logical(data.zScoreSplitHalfSigChs);
        fprintf('%d channels passed inclusion criteria\n',sum(data.goodCh))
        
        %% setup for PSTH
        if contains(fnameParts{4},'nsp1')
            array = 'V1';
        else
            array = 'V4';
        end
        figDir = sprintf('~/Dropbox/Figures/%s/Gratings/%s/cleanRawPSTH/raw',fnameParts{1},array);
        
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
        cd(figDir)
        
        
        figure(1)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1200 900])
        set(gcf,'PaperOrientation','Landscape');
        %% plot PSTH
        
        for ch = 1:96
            subplot(amap,10,10,ch)
            hold on
            
            blankResp = mean(smoothdata(data.bins((data.spatial_frequency == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = mean(smoothdata(data.bins((data.spatial_frequency > 0.1), 1:35 ,ch),'gaussian',3))./0.01;
            
            if goodCh(ch) == 1
                plot(1:35,blankResp,'k','LineWidth',0.5);
                plot(1:35,stimResp,'k','LineWidth',2);
            else
                plot(1:35,blankResp,'color',[0.5 0.5 0.5],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0.5 0.5 0.5],'LineWidth',2);
            end
        end
        s = suptitle(sprintf('%s',fname));
        s.Position(2) = s.Position(2) +0.02;
        s.Interpreter = 'none';
        figName = [fname,'_','PSTH','.pdf'];
        print(gcf, figName,'-dpdf','-bestfit')
        %% save data
        
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/info/',dataT.array);
        
        if ~exist(outputDir, 'dir')
            mkdir(outputDir)
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
    catch
    end
end

