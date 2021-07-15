function [REsigPerms, LEsigPerms, REcorrPerm, LEcorrPerm] = radFreq_getFisherRFsize_perm(REdata, LEdata,numBoot,realCorr)
% This function should be called after running radFreq_getFisherLoc_BE to
% get the preferred location for each good channel. Looking at the
% preferred location, this function will do a permutation test for orientation
% in each RF.
%
% organization of real correlations should be: (eye, RF, ori, ch)
%    eye 1 = LE   ori 1 = 0deg

% Brittany Bushnell 6/29/21
%%
% tic
location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/Size/perm',LEdata.animal,LEdata.array);
    elseif contains(LEdata.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/Size/perm',LEdata.animal,LEdata.array);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/Size/perm',LEdata.animal,LEdata.array);
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/Size/perm',LEdata.animal,LEdata.array);
    elseif contains(LEdata.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/Size/perm',LEdata.animal,LEdata.array);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/Size/perm',LEdata.animal,LEdata.array);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
locPair = LEdata.locPair;
LEprefLoc = LEdata.prefLoc;
REprefLoc = REdata.prefLoc;
RErealCorr = squeeze(realCorr(2,:));
LErealCorr = squeeze(realCorr(1,:));

%(RF,ori,amp,sf,radius,location, ch)
REspikes = REdata.RFspikeCount;
LEspikes = LEdata.RFspikeCount;

REcorrPerm = nan(96,numBoot);
LEcorrPerm = nan(96,numBoot);

LEsigPerms = nan(1,96);
REsigPerms = nan(1,96);

LEpVal = nan(1,96);
REpVal = nan(1,96);
% define ranges for each option
amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 0:6;
holdout = 0.2; % percentage of the data you want to withold when doing the permutations
%%
%%
% close all
for ch = 1:96
    %%
    for ey = 1:2
        if ey == 1
            dataT = LEdata;
            scCh = LEspikes{ch};
        else
            dataT = REdata;
            scCh = REspikes{ch};
        end
%         sigDiff = nan(2,96);
        
        if dataT.goodCh(ch) == 1
            muSc = nan(3,6);
            
            if ey == 1
                locNdx = (scCh(6,:) == locPair(LEprefLoc(ch),1)) & (scCh(7,:) == locPair(LEprefLoc(ch),2));
            else
                locNdx = (scCh(6,:) == locPair(REprefLoc(ch),1)) & (scCh(7,:) == locPair(REprefLoc(ch),2));
            end
            
                circNdx = (scCh(1,:) == 32);
                
                circSpikes = squeeze(scCh(8:end,locNdx & circNdx));
                circSpikes = reshape(circSpikes,[1,numel(circSpikes)]);
                muCirc = (nanmean(circSpikes,'all'));
                %%
                for nb = 1:numBoot
                    for amp = 1:6
                        amp48Ndx = (scCh(2,:) == amps48(amp) & (scCh(1,:) < 16));
                        amp16Ndx = (scCh(2,:) == amps16(amp)& (scCh(1,:) == 16));
                        
                        stim48Spikes = squeeze(scCh(8:end, amp48Ndx & locNdx));
                        stim16Spikes = squeeze(scCh(8:end, amp16Ndx & locNdx));
                        stimSpikes = [stim48Spikes, stim16Spikes];
                        numStimTrials = round((size(stimSpikes,2)/2) * (1-holdout));
                        
                        stimSub1 = randperm(size(stimSpikes,2),numStimTrials);
                        useStim1 = stimSpikes(8:end,stimSub1);
                        
                        muStim1 = (nanmean(useStim1,'all'));
                        muSc(1,amp) = muStim1 - muCirc;
                        
                        stimSub2 = datasample(setdiff(1:(size(stimSpikes,2)), stimSub1),numStimTrials);
                        useStim2 = stimSpikes(8:end,stimSub2);
                        
                        muStim2 = (nanmean(useStim2,'all'));
                        muSc(2,amp) = muStim2 - muCirc;
                        
                        clear muStim stimSpikes
                    end %amplitude
                    
                    for sz = 1:2
                        % get the correlation
                        muSct = squeeze(muSc(sz,:)); %(rf,rot,amp)
                        muScSize = [0, muSct];
                        corMtx = corrcoef(xs,muScSize);
                        sCorr(sz) = corMtx(2);
                    end
                    if ey == 1
                        LEcorrPerm(ch,nb) = sCorr(1) - sCorr(2);
                    else
                        REcorrPerm(ch,nb) = sCorr(1) - sCorr(2);
                    end
                    clear muScSize sCorr corMtx
                end %bootstrap
                
                %% do the actual permutation test for significance.
                
                if ey == 1
                    corrs = squeeze(LEcorrPerm(ch,:));
                    trueCorr = squeeze(LErealCorr(ch));
                else
                    corrs = squeeze(REcorrPerm(ch,:));
                    trueCorr = squeeze(RErealCorr(ch));
                end
                
                high = find(corrs>trueCorr);
                pV = round(((length(high)+1)/(length(corrs)+1)),3);
                
                if pV > 0.5
                    pV = 1-pV;
                end
                
                if ey == 1
                    LEpVal(ch) = pV;
                else
                    REpVal(ch) = pV;
                end
                
                if  pV <= 0.05
                    if ey == 1
                        LEsigPerms(ch) = 1;
                    else
                        REsigPerms(ch) = 1;
                    end
                else
                    if ey == 1
                        LEsigPerms(ch) = 0;
                    else
                        REsigPerms(ch) = 0;
                    end
                end
        end % goodCh
    end %eye
end
%% sanity figures
%
for ch = 1:96
    figure(12)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2), 700, 400],'PaperOrientation','landscape')
    s = suptitle(sprintf('%s %s spatial frequency permutation test ch %d',LEdata.animal,LEdata.array,ch));
%     s.Position(2) = s.Position(2) + 0.024;
    
    subplot(1,2,1)
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    axis square
    
    cDiffs = squeeze(LEcorrPerm(ch,:));
    cDiffs = reshape(cDiffs,1,numel(cDiffs));
    histogram(cDiffs,'Normalization','probability','BinWidth',0.1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    plot([LErealCorr(ch) LErealCorr(ch)], [0 0.5],'-k')
    
    if LEpVal(ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',LEpVal(ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',LEpVal(ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    ylabel('Proportion of chs','FontSize',11)
    
    if contains(LEdata.animal,'XT')
        title('LE','FontSize',12,'FontWeight','bold','FontAngle','italic')
    else
        title('FE','FontSize',12,'FontWeight','bold','FontAngle','italic')
    end

    subplot(1,2,2)
    hold on
    ylim([0 0.6])
    xlim([-1.5 1.5])
    axis square
    
    cDiffs = squeeze(REcorrPerm(ch,:));
    cDiffs = reshape(cDiffs,1,numel(cDiffs));
    histogram(cDiffs,'Normalization','probability','BinWidth',0.1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
    plot([RErealCorr(ch) RErealCorr(ch)], [0 0.5],'-k')
    
    if REpVal(ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',REpVal(ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',REpVal(ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    if contains(LEdata.animal,'XT')
        title('RE','FontSize',12,'FontWeight','bold','FontAngle','italic')
    else
        title('AE','FontSize',12,'FontWeight','bold','FontAngle','italic')
    end
    figName = [LEdata.animal,'_BE_',LEdata.array,'_sizePerm_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
end
fprintf('%.2f minutes to finish size permutations from start of program\n',toc/60)

