clear
close all
tic
location = determineComputer;
%%
% if location == 0
%     cd '/Users/brittany/Dropbox/ArrayData/matFiles/raw_Grat'
% else
%     cd '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/raw_Grat'
% end
%
% tmp = dir;
% ndx = 1;
% for t = 1:length(tmp)
%     if contains(tmp(t).name,'.mat')
%         t2 = tmp(t).name;
%         tmp2{ndx} = t2;
%         ndx = ndx+1;
%     end
% end

files = {
    'WU_LE_Gratings_nsp1_20170704_004.mat'
    'WU_LE_Gratings_nsp2_20170704_004.mat'
    'WU_RE_Gratings_nsp1_20170704_001.mat'
    'WU_RE_Gratings_nsp2_20170704_001.mat'
    'WV_LE_gratings_nsp1_20190422_002.mat'
    'WV_LE_gratings_nsp2_20190422_002.mat'
    'WV_RE_gratings_nsp1_20190422_003.mat'
    'WV_RE_gratings_nsp2_20190422_003.mat'
    'XT_LE_Gratings_nsp1_20190131_002.mat'
    'XT_LE_Gratings_nsp2_20190131_002.mat'
    'XT_RE_Gratings_nsp1_20190122_002.mat'
    'XT_RE_Gratings_nsp2_20190122_002.mat'
    };
nameEnd = 'goodCh';


%%
for i = 1:length(files)
    
    %try
    fname = files{i};
    dataT = load(fname);
    
    amap = getBlackrockArrayMap(fname);
    blank = dataT.spatial_frequency == 0;
    grat  = dataT.spatial_frequency > 0.1;
    
    fnameParts = strsplit(fname,'_');
    %% get spike counts and z scores
    % future problem
    %         [dataT.RFStimResps,dataT.blankResps, dataT.stimResps] = parseRadFreqStimResp(dataT);
    %         [dataT.RFspikeCount,dataT.blankSpikeCount,dataT.RF,dataT.blank] = getRadFreqSpikeCount2(dataT);
    %% determine visually responsive channels
    % input needs to be (ch x trials)
    blankResp = nan(96, 2000);
    stimResp  = nan(96,2000);
    
    
    for ch = 1:96
        blankT  = mean(smoothdata(dataT.bins((dataT.spatial_frequency == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimT = mean(smoothdata(dataT.bins((dataT.spatial_frequency > 0.1), 1:35 ,ch),'gaussian',3))./0.01;
        
        blankResp(ch,1:length(blankT)) = blankT;
        stimResp(ch,1:length(stimT)) = stimT;
    end
    
    [dataT.allStimBlankDprime, dataT.allStimBlankDprimeBootPerm, dataT.stimBlankDprimePerm, dataT.stimBlankSDPerm]...
        = StimVsBlankPermutations_allStim_zScore(stimResp,blankResp,1000,0.75);
    fprintf('stim vs Blank permutations done %.2f\n',toc/60)
    
    [dataT.stimBlankChPvals, dataT.responsiveCh]...
        = getPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm,2,1);
    fprintf('%d responsive channels defined\n', sum(dataT.responsiveCh))
    
    if sum(dataT.responsiveCh) == 0
        fprintf('There were no responsive channels found, something''s funky')
        keyboard
    end
    
    %% do split half correlations and permutations
    % needs to be (conditions x repeats x channels)
    sfs = unique(dataT.spatial_frequency);
    sfsReal = sfs > 0.1;
    oris = unique(dataT.rotation);
    
    stimCon = nan(length(sfsReal)+length(oris),50,96);
    
    ndx = 1;
    for s = 1:length(sfsReal)
        sfNdx = dataT.spatial_frequency == sfsReal(s);
        for or = 1:length(oris)
            orNdx = dataT.rotation == oris(or);
            
            for ch = 1:96
                stimConT = mean(smoothdata(dataT.bins((sfNdx & orNdx), 1:35 ,ch),'gaussian',3))./0.01;
                stimCon(ndx,1:length(stimConT),ch) = stimConT;
            end
            ndx = ndx+1;
        end
    end
    
    [dataT.ReliabilityIndex, dataT.ReliabilityPvals,dataT.SplitHalfSigChs,dataT.ReliabilityIndexPerm]...
        = getHalfCorrPerm(stimCon,fname);
    %     plotResponsePvalsVSreliabilityPvals(data)
    fprintf('Split-Half correlations computed and permuted %.2f minutes\n',toc/60)
    %% Define truly good channels that pass either the visually responsive OR split-half reliability metric
    dataT.goodCh = logical(dataT.responsiveCh) | logical(dataT.SplitHalfSigChs);
    fprintf('%d channels passed inclusion criteria\n',sum(dataT.goodCh))
    
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
        
        blankResp = mean(smoothdata(dataT.bins((dataT.spatial_frequency == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = mean(smoothdata(dataT.bins((dataT.spatial_frequency > 0.1), 1:35 ,ch),'gaussian',3))./0.01;
        
        if dataT.goodCh(ch) == 1
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
    
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/info/',array);
    
    if ~exist(outputDir, 'dir')
        mkdir(outputDir)
    end
    if contains(fname,'LE')
        data.LE = dataT;
        data.RE = [];
    else
        data.RE = dataT;
        data.LE = [];
    end
    shortName = strrep(fname,'.mat','');
    saveName = [outputDir shortName '_' nameEnd '.mat'];
    save(saveName,'data');
    fprintf('%s saved\n  run time: %.2f minutes\n\n', saveName, toc/60)
    %     catch ME
    %         fprintf('\n\n %s failed  %s\n\n',fname,ME.message)
    %     end
end

