%function [] = runGratArrayMwks(filename,numBins,beOriVerbose,beSFVerbose,baselineFigs)
% RUNGRATARRAYMWKS is a function that runs the gratMapMwksCh program on a
% folder of grating data recorded with Utah Arrays, and parsed using
% Darren's parsing code on Zemina.
%
% INPUT
% FILENAME - no suffix
% NUMBINS - number of bins you want to look at after the computed latency.
% BEORIVERBOSE and BESFVERBOSE - if you want indivial figures of either
% orienation or spatial frequency responses for each channel, set these to
% 1.
% BASELINEFIGS - If you want figures where data is baseline subtracted, set
% to 1.
%
% Written: June 19, 2017 by Brittany Bushnell

close all
clear all
tic
%%
%files = ['WU_LE_Gratings_nsp2_20170908_002'; 'WU_RE_Gratings_nsp2_20170908_001'];
files = ['XT_LE_Gratings_nsp2_20190321_001';'XT_RE_Gratings_nsp2_20190319_002'];
%%
for fi = 1:size(files,1)
    filename = files(fi,:);
    textName = figTitleName(filename);
    beOriVerbose = 0;
    beSFVerbose = 0;
    baselineFigs = 0;
    location = 1;  %1 = Amfortas
    if strfind(filename,'LE')
        [FEdata] = gratingMwksCh(filename,location,beOriVerbose,beSFVerbose,baselineFigs);
    else
        [AEdata] = gratingMwksCh(filename,location,beOriVerbose,beSFVerbose,baselineFigs);
    end
end

amap = FEdata.amap;
%% Define channels as AE, FE, or binoc
AEgoodCh = AEdata.goodChannels';
FEgoodCh = FEdata.goodChannels';
binocCh = intersect(FEgoodCh,AEgoodCh); % Gives the channels that are present in both lists

for i = 1:length(AEgoodCh)
    if ismember(AEgoodCh(i),binocCh)
        AEgoodCh(i) = nan;
    end
end

for l = 1:length(FEgoodCh)
    if ismember(FEgoodCh(l), binocCh)
        FEgoodCh(l) = nan;
    end
end

%remove the nan's in each vector
feNdx = find(isnan(FEgoodCh));
aeNdx = find(isnan(AEgoodCh));

FEgoodCh(feNdx) = [];
AEgoodCh(aeNdx) = [];
%% count max responses for good channels per preferred eye
% row 1: spatial frequency values
% row 2: counts for FE channels
% row 3: counts for AE channels
% row 4: counts for binoc channels

for i = 1:FEgoodCh
    FEmaxSF(i) = FEdata.maxSF(i);
end

for i = 1:AEgoodCh
    AEmaxSF(i) = AEdata.maxSF(i);
end

for i = 1:binocCh
    AEmaxSFbinoc(i) = AEdata.maxSF(i);
    FEmaxSFbinoc(i) = FEdata.maxSF(i);
end

mxSFs(1,:) = unique(FEdata.spatial_frequency(1,:));

for a = 1:size(mxSFs,2)
    mxSFs(2,a) = sum(FEdata.maxSF(1,:) == mxSFs(1,a));
    mxSFs(3,a) = sum(AEdata.maxSF(1,:) == mxSFs(1,a));
end
mxSFsGrat = mxSFs(:,(4:end));
mxSFsFlash = mxSFs(:,(1:3));
xVals = [2 4 8 16 32 64];
xVals = log(xVals);
%% Plot AE vs FE spatial frequency responses
figure
for ch = 1:96
    subplot(aMap,10,10,ch)
    hold on
    plot(FEdata.spatialFrequencyResp{ch}(1,4:end),FEdata.spatialFrequencyResp{ch}(3,4:end),'k.-' , 'MarkerSize',9)
    plot(20, FEdata.spatialFrequencyResp{ch}(3,2),'k.', 'MarkerSize',9) % white flash
    plot(40, FEdata.spatialFrequencyResp{ch}(3,3),'kO', 'MarkerSize',4) % black flash
    FEblankResp = FEdata.spatialFrequencyResp{ch}(3,1);
    plot([0.3 45], [FEblankResp FEblankResp],'k') % blank
    
    plot(AEdata.spatialFrequencyResp{ch}(1,4:end),AEdata.spatialFrequencyResp{ch}(3,4:end),'.-','Color',[0.5, 0.5, 0.5], 'MarkerSize',9)
    plot(20, AEdata.spatialFrequencyResp{ch}(3,2),'.','MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5], 'MarkerSize',9) % white flash
    plot(40, AEdata.spatialFrequencyResp{ch}(3,3),'o','MarkerEdgeColor',[0.5,0.5,0.5], 'MarkerSize',4) % black flash
    
    AEblankResp = AEdata.spatialFrequencyResp{ch}(3,1);
    plot([0.3 45], [AEblankResp AEblankResp],'Color',[0.5, 0.5, 0.5]) % blank
    
    if AEdata.maxSF(1,ch) == 0.0003
        plot(20, (FEdata.maxSF(2,ch)+10),'kv','MarkerSize',4)
        plot(20, (AEdata.maxSF(2,ch)+10),'v','MarkerFaceColor',[0.5,0.5,0.5],...
            'MarkerEdgeColor',[0.5,0.5,0.5],'MarkerSize',4)
        
    elseif AEdata.maxSF(1,ch) == 0.0006
        plot(40, (FEdata.maxSF(2,ch)+10),'kv','MarkerSize',4)
        plot(40, (AEdata.maxSF(2,ch)+10),'v','MarkerFaceColor',[0.5,0.5,0.5],...
            'MarkerEdgeColor',[0.5,0.5,0.5],'MarkerSize',4)
    else
        plot(FEdata.maxSF(1,ch), (FEdata.maxSF(2,ch)+10),'kv','MarkerSize',4)
        plot(AEdata.maxSF(1,ch), (AEdata.maxSF(2,ch)+10),'v','MarkerFaceColor',[0.5,0.5,0.5],...
            'MarkerEdgeColor',[0.5,0.5,0.5],'MarkerSize',4)
    end
    
    title(sprintf('%d',ch))
    axis square xy
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
        'XTick',[0.3 0.6 1.25 2.5 5 10 20 40],...
        'XTickLabel',{'0.3', '', '1.25', '', '5', '10', 'W','B'},...
        'XTickLabelRotation', 45)
    xlim([0.1 40])
    
    subplot(10,10,1)
    xlabel('sf')
    ylabel('sp/s')
    axis square xy
    
    if ch == 1
        if strfind(filename,'nsp2')
            array = 'V4';
        else
            array = 'V1/V2';
        end
        topTitle = sprintf('Spatial frequency tuning AE(gray) vs FE(black) %s', textName);
        annotation('textbox',...
            [0.4 0.94 0.35 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',16,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
    if ~isempty(strfind(filename,'nsp2'))
        set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    end
end
%% Histograms of max SF AE vs FE vs binoc
figure
subplot(2,1,1)
hold on
bar(xVals,mxSFsGrat(2,:),'b','FaceAlpha',.25)
bar(xVals,mxSFsGrat(3,:),'r','FaceAlpha',.25)

set(gca,'TickDir','out','Color','none','FontSize',11,'TickDir','out','XTick',...
    [0.69 1.38 2.08 2.77 3.46 4.16],'XTickLabel',...
    {'0.3','0.6','1.25','2.5','5','10'},'XTickLabelRotation',45);
legend('FE','AE')
xlabel('Spatial Frequency (cpd)')
ylabel('# of channels')
xlim([0.3 5])

if strfind(filename, 'nsp2')
    title({'Distribution of maximum firing rates in V4 across SFs for AE and FE'; sprintf('%s',filename)},'Interpreter','none')
else
    title('Distribution of maximum firing rates in V1/V2 across SFs for AE and FE')
end

subplot('Position',[0.13 0.05 0.7 0.3])
hold on
% response to blank
bar(1,mxSFsFlash(2,1),'b','FaceAlpha',.25)
bar(1,mxSFsFlash(3,1),'r','FaceAlpha',.25)
% response to black flash (SF = 0.0006)
bar(2,mxSFsFlash(2,2),'b','FaceAlpha',.25)
bar(2,mxSFsFlash(3,2),'r','FaceAlpha',.25)
% response to white flash (SF = 0.0003)
bar(3,mxSFsFlash(2,3),'b','FaceAlpha',.25)
bar(3,mxSFsFlash(3,3),'r','FaceAlpha',.25)

set(gca,'TickDir','out','Color','none','FontSize',11,'XTick',[1 2 3],'XTickLabel',{'Blank','Black flash','White flash'})
ylabel('# of channels')
title('Maximum responses to other stimuli')
 %% Plot PSTHs of eyes together
% stimOn  = unique(FEdata.stimOn);
% stimOff = unique(FEdata.stimOff);
% binStimOn  = stimOn/10;
% binStimOff = stimOff/10;
% for ch = 1:96
%     FEblankNdx = find(FEdata.spatial_frequency == 0);
%     FEstimNdx  = find(FEdata.spatial_frequency > 0);
%     
%     FEblankResps = FEdata.bins(FEblankNdx,1:(binStimOn+binStimOff),ch);
%     FEblankRespsMean = mean(FEblankResps,1)./0.010;
%     
%     FEstimResps = FEdata.bins(FEstimNdx,1:(binStimOn+binStimOff),ch);
%     FEstimRespsMean = mean(FEstimResps,1)./0.010;
%     
%     AEblankNdx = find(AEdata.spatial_frequency == 0);
%     AEstimNdx  = find(AEdata.spatial_frequency > 0);
%     
%     AEblankResps = AEdata.bins(AEblankNdx,1:(binStimOn+binStimOff),ch);
%     AEblankRespsMean = mean(AEblankResps,1)./0.010;
%     
%     AEstimResps = AEdata.bins(AEstimNdx,1:(binStimOn+binStimOff),ch);
%     AEstimRespsMean = mean(AEstimResps,1)./0.010;
%     
%     xaxis = 1:10:stimOn+stimOff;
%     
%     % plot PSTHs
%     if strfind (filename, 'nsp1')
%         topTitle = sprintf('V1/V2 grating PSTH FE(blue) AE(red) FE blank(black) AE blank(yellow)');
%     else
%         topTitle = sprintf('V4 grating PSTH FE(blue) AE(red) FE blank(black) AE blank(yellow)');
%     end
%     
%     subplot(aMap,10,10,ch)
%     hold on
%     plot(xaxis, FEblankRespsMean,'k','LineWidth',2)
%     plot(xaxis, FEstimRespsMean,'r','LineWidth',2)
%     
%     plot(xaxis, AEblankRespsMean,'y','LineWidth',2)
%     plot(xaxis, AEstimRespsMean,'b','LineWidth',2)
%     
%     title(sprintf('%d',ch))
%     axis square xy
%     set(gca,'box', 'off','color', 'none', 'tickdir','out', 'XTickLabelRotation', 45)
%     
%     if ch == 1
%         annotation('textbox',...
%             [0.4 0.94 0.35 0.05],...
%             'LineStyle','none',...
%             'String',topTitle,...
%             'Interpreter','none',...
%             'FontSize',16,...
%             'FontAngle','italic',...
%             'FontName','Helvetica Neue');
%     end
% end


%%
load handel
sound(y,Fs)

toc