% function [REcorrPerm, LEcorrPerm] = radFreq_getFisherRFrot_perm(REdata, LEdata,numBoot)
% This function should be called after running radFreq_getFisherLoc_BE to
% get the preferred location for each good channel. Looking at the
% preferred location, this function will do a permutation test for orientation
% in each RF.

% This function does not plot the responses per channel or give
% true preferences. For that, use radFreq_getFisherRFrot_BE

% Brittany Bushnell 6/29/21

numBoot = 1000;
%%
% location = determineComputer;

% if location == 1
%     if contains(LEdata.animal,'WU')
%         figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/RFrot/means',LEdata.animal,LEdata.array);
%     elseif contains(LEdata.programID,'low','IgnoreCase')
%         figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/RFrot/means',LEdata.animal,LEdata.array);
%     else
%         figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/RFrot/means',LEdata.animal,LEdata.array);
%     end
% elseif location == 0
%     if contains(LEdata.animal,'WU')
%         figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/RFrot/means',LEdata.animal,LEdata.array);
%     elseif contains(LEdata.programID,'low','IgnoreCase')
%         figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/RFrot/means',LEdata.animal,LEdata.array);
%     else
%         figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/RFrot/means',LEdata.animal,LEdata.array);
%     end
% end
%
% if ~exist(figDir,'dir')
%     mkdir(figDir)
% end
% cd(figDir)
%%
locPair = LEdata.locPair;
LEprefLoc = LEdata.prefLoc;
REprefLoc = REdata.prefLoc;

%(RF,ori,amp,sf,radius,location, ch)
REspikes = REdata.RFspikeCount;
LEspikes = LEdata.RFspikeCount;

REzTrfmPerm = nan(3,96,numBoot); 
REcorrPerm = nan(3,96,numBoot);

LEzTrfmPerm = nan(3,96,numBoot);
LEcorrPerm = nan(3,96,numBoot);

% define ranges for each option
radfreqs = [4,8,16];
amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 0:6;

%%
% close all
for ch = 1:10%96
    %%
    for ey = 1:2
        if ey == 1
            dataT = LEdata;
            scCh = LEspikes{ch};
        else
            dataT = REdata;
            scCh = REspikes{ch};
        end
        
        if dataT.goodCh(ch) == 1
            
            muSc = nan(3,6);
            %             corrP = nan(3,2,numBoot); %RF, rotation, corr, significance
            
            if ey == 1
                locNdx = (scCh(6,:) == locPair(LEprefLoc(ch),1)) & (scCh(7,:) == locPair(LEprefLoc(ch),2));
            else
                locNdx = (scCh(6,:) == locPair(REprefLoc(ch),1)) & (scCh(7,:) == locPair(REprefLoc(ch),2));
            end
            
            for rf = 1:3
                %                 for rot = 1:2
                circNdx = (scCh(1,:) == 32);
                rfNdx   = (scCh(1,:) == radfreqs(rf));
                
                circSpikes = squeeze(scCh(8:end,locNdx & circNdx));
                circSpikes = reshape(circSpikes,[1,numel(circSpikes)]);
                muCirc = (nanmean(circSpikes,'all'));
                
                if rf == 1
                    rotNdx0 = scCh(3,:) == 0;
                    rotNdx1 = scCh(3,:) == 45;
                    ampRef = amps48;
                elseif rf == 2
                    rotNdx0 = scCh(3,:) == 0;
                    rotNdx1 = scCh(3,:) == 22.5;
                    ampRef = amps48;
                else
                    rotNdx0 = scCh(3,:) == 0;
                    rotNdx1 = scCh(3,:) == 11.25;
                    ampRef = amps16;
                end
                
                for nb = 1:numBoot
                    % for each amplitude, randomly choose to use either 0
                    % or the other orientation.
                    
                    randRotVal = randi(2,1,6);
                    for amp = 1:6
                        ampNdx = (scCh(2,:) == ampRef(amp));
                        
                        if randRotVal(amp) == 1
                            randRotNdx = rotNdx0;
                        else
                            randRotNdx = rotNdx1;
                        end
                        stimSpikes = squeeze(scCh(8:end,rfNdx & ampNdx & randRotNdx & locNdx));
                        stimSpikes = reshape(stimSpikes,[1,numel(stimSpikes)]);
                        
                        muStim = (nanmean(stimSpikes,'all'));
                        muSc(rf,amp) = muStim - muCirc;
                        
                        clear muStim stimSpikes
                    end %amplitude
                    
                    % get the correlation and p-value
                    muSct = squeeze(muSc(rf,:));
                    muScRFrot = [0, muSct];
                    corMtx = corrcoef(xs,muScRFrot);
                    sCorr = corMtx(2);
                    if ey == 1
                        LEcorrPerm(rf,ch,nb) = sCorr;
                    else
                        REcorrPerm(rf,ch,nb) = sCorr;
                    end
                    
                    % get the Fisher r to z transform
                    if ey == 1
                        zCh = atanh(sCorr);
                        LEzTrfmPerm(rf,ch,numBoot) = zCh;
                    else
                        zCh = atanh(sCorr);
                        REzTrfmPerm(rf,ch,numBoot) = zCh;
                    end
                    %                     end %rot
                    
                end %bootstrap  
            end %RF
        end % goodCh
    end %eye
end
%% sanity figures
for ch = 1%:10
    figure%(12)
    clf
    s = suptitle(sprintf('%s %s rotation permutation test ch %d',LEdata.animal,LEdata.array,ch));
    s.Position(2) = s.Position(2) + 0.024;
    
    subplot(3,2,1)
    hold on
    corr = squeeze(LEcorrPerm(1,ch,:));
    corr = reshape(corr,[1, numel(corr)]);
    title('FE')
    histogram(corr,'Normalization','probability','FaceColor','b','BinWidth',0.1)
    muCorr = nanmean(corr);
    plot([muCorr muCorr],[0 0.4],':k')
    text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
    xlim([-1 1])
    ylim([0 0.6])
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'XTickLabel',{sprintf('45%c', char(176)),'No preference',sprintf('0%c', char(176))},...
        'FontSize',10,'FontAngle','italic')
    ylabel('Proportion of chs','FontSize',11)
    text(-1.7,0.3,'RF4','FontSize',12,'FontWeight','bold')
    clear corr
    
    subplot(3,2,2)
    hold on
    corr = squeeze(REcorrPerm(1,ch,:));
    corr = reshape(corr,[1, numel(corr)]);
    title('AE')
    histogram(corr,'Normalization','probability','FaceColor','r','BinWidth',0.1)
    muCorr = nanmean(corr);
    plot([muCorr muCorr],[0 0.4],':k')
    text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
    xlim([-1 1])
    ylim([0 0.6])
  
    set(gca,'tickdir','out','Xtick',[-1 0 1],'XTickLabel',{sprintf('45%c', char(176)),'No preference',sprintf('0%c', char(176))},...
        'FontSize',10,'FontAngle','italic')
    clear corr
    
    subplot(3,2,3)
    hold on
    corr = squeeze(LEcorrPerm(2,ch,:));
    corr = reshape(corr,[1, numel(corr)]);
    
    histogram(corr,'Normalization','probability','FaceColor','b','BinWidth',0.1)
    muCorr = nanmean(corr);
    plot([muCorr muCorr],[0 0.4],':k')
    text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
    xlim([-1 1])
    ylim([0 0.6])
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'XTickLabel',{sprintf('22.5%c', char(176)),'No preference',sprintf('0%c', char(176))},...
        'FontSize',10,'FontAngle','italic')
    
    ylabel('Proportion of chs','FontSize',11)
    text(-1.7,0.3,'RF8','FontSize',12,'FontWeight','bold')
    clear corr
    
    subplot(3,2,4)
    hold on
    corr = squeeze(REcorrPerm(2,ch,:));
    corr = reshape(corr,[1, numel(corr)]);
    
    histogram(corr,'Normalization','probability','FaceColor','r','BinWidth',0.1)
    muCorr = nanmean(corr);
    plot([muCorr muCorr],[0 0.4],':k')
    text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
    xlim([-1 1])
    ylim([0 0.6])
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'XTickLabel',{sprintf('22.5%c', char(176)),'No preference',sprintf('0%c', char(176))},...
        'FontSize',10,'FontAngle','italic')
    clear corr
    
    subplot(3,2,5)
    hold on
    corr = squeeze(LEcorrPerm(3,ch,:));
    corr = reshape(corr,[1, numel(corr)]);
    
    histogram(corr,'Normalization','probability','FaceColor','b','BinWidth',0.1)
    muCorr = nanmean(corr);
    plot([muCorr muCorr],[0 0.4],':k')
    text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
    xlim([-1 1])
    ylim([0 0.6])
    set(gca,'tickdir','out','Xtick',[-1 0 1],'XTickLabel',{sprintf('11.25%c', char(176)),'No preference',sprintf('0%c', char(176))},...
        'FontSize',10,'FontAngle','italic')
    
%     xlabel('permuted correlation','FontSize',11)
    ylabel('Proportion of chs','FontSize',11)
    text(-1.7,0.3,'RF16','FontSize',12,'FontWeight','bold')
    clear corr
    
    subplot(3,2,6)
    hold on
    corr = squeeze(REcorrPerm(3,ch,:));
    corr = reshape(corr,[1, numel(corr)]);
    
    histogram(corr,'Normalization','probability','FaceColor','r','BinWidth',0.1)
    muCorr = nanmean(corr);
    plot([muCorr muCorr],[0 0.4],':k')
    text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
    xlim([-1 1])
    ylim([0 0.6])
    set(gca,'tickdir','out','Xtick',[-1 0 1],'XTickLabel',{sprintf('45%c', char(176)),'No preference',sprintf('0%c', char(176))},...
        'FontSize',10,'FontAngle','italic')
   
%        xlabel('permuted correlation','FontSize',11)
end