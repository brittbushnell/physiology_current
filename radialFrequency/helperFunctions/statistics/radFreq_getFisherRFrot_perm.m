function [REsigPerms, LEsigPerms, REcorrPerm, LEcorrPerm] = radFreq_getFisherRFrot_perm(REdata, LEdata,numBoot,realCorr)
% This function should be called after running radFreq_getFisherLoc_BE to
% get the preferred location for each good channel. Looking at the
% preferred location, this function will do a permutation test for orientation
% in each RF.
%
% organization of real correlations should be: (eye, RF, ori, ch)
%    eye 1 = LE   ori 1 = 0deg

% Brittany Bushnell 6/29/21

%%

location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
        end
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/ori/perm',LEdata.animal,LEdata.array);
        end
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
RErealCorr = squeeze(realCorr(2,:,:));
LErealCorr = squeeze(realCorr(1,:,:));

%(RF,ori,amp,sf,radius,location, ch)
REspikes = REdata.RFspikeCount;
LEspikes = LEdata.RFspikeCount;

REcorrPerm = nan(3,96,numBoot);
LEcorrPerm = nan(3,96,numBoot);

LEsigPerms = nan(3,96);
REsigPerms = nan(3,96);

LEpVal = nan(3,96);
REpVal = nan(3,96);
% define ranges for each option
radfreqs = [4,8,16];
amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 0:6;
holdout = 0.2; % percentage of the data you want to withold when doing the permutations

if contains(REdata.animal,'WU')
    spikeStart = 8;
else
    spikeStart = 7;
end
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
        sigDiff = nan(3,2,96);
        
        if dataT.goodCh(ch) == 1
            muSc = nan(3,6);
            
            if ey == 1
                locNdx = (scCh(6,:) == locPair(LEprefLoc(ch),1)) & (scCh(7,:) == locPair(LEprefLoc(ch),2));
            else
                locNdx = (scCh(6,:) == locPair(REprefLoc(ch),1)) & (scCh(7,:) == locPair(REprefLoc(ch),2));
            end
            
            for rf = 1:3
                circNdx = (scCh(1,:) == 32);
                rfNdx   = (scCh(1,:) == radfreqs(rf));
                
                circSpikes = squeeze(scCh(spikeStart:end,locNdx & circNdx));
                circSpikes = reshape(circSpikes,[1,numel(circSpikes)]);
                muCirc = (nanmean(circSpikes,'all'));
                
                if rf == 1
                    ampRef = amps48;
                elseif rf == 2
                    ampRef = amps48;
                else
                    ampRef = amps16;
                end
                %%
                for nb = 1:numBoot
                    for amp = 1:6
                        ampNdx = (scCh(2,:) == ampRef(amp));
                        
                        stimSpikes = squeeze(scCh(:,rfNdx & ampNdx & locNdx));
                        numStimTrials = round((size(stimSpikes,2)/2) * (1-holdout));
                        
                        stimSub1 = randperm(size(stimSpikes,2),numStimTrials);
                        useStim1 = stimSpikes(spikeStart:end,stimSub1);
                        
                        muStim1 = (nanmean(useStim1,'all'));
                        muSc(rf,1,amp) = muStim1 - muCirc;
                        
                        stimSub2 = datasample(setdiff(1:(size(stimSpikes,2)), stimSub1),numStimTrials);
                        useStim2 = stimSpikes(spikeStart:end,stimSub2);
                        
                        muStim2 = (nanmean(useStim2,'all'));
                        muSc(rf,2,amp) = muStim2 - muCirc;
                        
                        clear muStim stimSpikes
                    end %amplitude
                    
                    for rot = 1:2
                        % get the correlation
                        muSct = squeeze(muSc(rf,rot,:)); %(rf,rot,amp)
                        muScRFrot = [0, muSct'];
                        corMtx = corrcoef(xs,muScRFrot);
                        sCorr(rot) = corMtx(2);
                    end
                    if ey == 1
                        LEcorrPerm(rf,ch,nb) = sCorr(1) - sCorr(2);
                    else
                        REcorrPerm(rf,ch,nb) = sCorr(1) - sCorr(2);
                    end
                    clear muScRFrot sCorr corMtx
                end %bootstrap
                
                %% do the actual permutation test for significance.
                
                if ey == 1
                    corrs = squeeze(LEcorrPerm(rf,ch,:));
                    trueCorr = squeeze(LErealCorr(rf,ch));
                else
                    corrs = squeeze(REcorrPerm(rf,ch,:));
                    trueCorr = squeeze(RErealCorr(rf,ch));
                end
                
                high = find(corrs>trueCorr);
                pV = round(((length(high)+1)/(length(corrs)+1)),3);
                
                if pV > 0.5
                    pV = 1-pV;
                end
                
                if ey == 1
                    LEpVal(rf,ch) = pV;
                else
                    REpVal(rf,ch) = pV;
                end
                
                if  pV <= 0.05
                    if ey == 1
                        LEsigPerms(rf,ch) = 1;
                    else
                        REsigPerms(rf,ch) = 1;
                    end
                else
                    if ey == 1
                        LEsigPerms(rf,ch) = 0;
                    else
                        REsigPerms(rf,ch) = 0;
                    end
                end
            end %RF
        end % goodCh
    end %eye
end
%% sanity figures
%
for ch = 1:96
    figure(6)
    clf
    s = suptitle(sprintf('%s %s rotation permutation test ch %d',LEdata.animal,LEdata.array,ch));
    s.Position(2) = s.Position(2) + 0.024;
    
    subplot(3,2,1)
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    cDiffs = squeeze(LEcorrPerm(1,ch,:));
    cDiffs = reshape(cDiffs,1,numel(cDiffs));
    histogram(cDiffs,'Normalization','probability','BinWidth',0.1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    plot([LErealCorr(1,ch) LErealCorr(1,ch)], [0 0.5],'-k')
    
    if LEpVal(1,ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',LEpVal(1,ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',LEpVal(1,ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    ylabel('Proportion of chs','FontSize',11)
    text(-1.75,0.3,'RF4','FontSize',12,'FontWeight','bold')
    
    if contains(LEdata.animal,'XT')
        title('LE','FontSize',12,'FontWeight','bold','FontAngle','italic')
    else
        title('FE','FontSize',12,'FontWeight','bold','FontAngle','italic')
    end
    
    subplot(3,2,3)
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    cDiffs = squeeze(LEcorrPerm(2,ch,:));
    cDiffs = reshape(cDiffs,1,numel(cDiffs));
    histogram(cDiffs,'Normalization','probability','BinWidth',0.1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    plot([LErealCorr(2,ch) LErealCorr(2,ch)], [0 0.5],'-k')
    
    if LEpVal(2,ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',LEpVal(2,ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',LEpVal(2,ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    ylabel('Proportion of chs','FontSize',11)
    text(-1.75,0.3,'RF8','FontSize',12,'FontWeight','bold')
    
    
    subplot(3,2,5)
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    cDiffs = squeeze(LEcorrPerm(3,ch,:));
    cDiffs = reshape(cDiffs,1,numel(cDiffs));
    histogram(cDiffs,'Normalization','probability','BinWidth',0.1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    plot([LErealCorr(3,ch) LErealCorr(3,ch)], [0 0.5],'-k')
    
    if LEpVal(1,ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',LEpVal(3,ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',LEpVal(3,ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    ylabel('Proportion of chs','FontSize',11)
    xlabel('Difference in orientation correlations','FontSize',11)
    text(-1.75,0.3,'RF16','FontSize',12,'FontWeight','bold')
    
    subplot(3,2,2)
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    cDiffs = squeeze(REcorrPerm(1,ch,:));
    cDiffs = reshape(cDiffs,1,numel(cDiffs));
    histogram(cDiffs,'Normalization','probability','BinWidth',0.1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
    plot([RErealCorr(1,ch) RErealCorr(1,ch)], [0 0.5],'-k')
    
    if REpVal(1,ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',REpVal(1,ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',REpVal(1,ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    if contains(LEdata.animal,'XT')
        title('RE','FontSize',12,'FontWeight','bold','FontAngle','italic')
    else
        title('AE','FontSize',12,'FontWeight','bold','FontAngle','italic')
    end
    
    subplot(3,2,4)
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    cDiffs = squeeze(REcorrPerm(2,ch,:));
    cDiffs = reshape(cDiffs,1,numel(cDiffs));
    histogram(cDiffs,'Normalization','probability','BinWidth',0.1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
    plot([RErealCorr(2,ch) RErealCorr(2,ch)], [0 0.5],'-k')
    
    if REpVal(2,ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',REpVal(2,ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',REpVal(2,ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    
    subplot(3,2,6)
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    cDiffs = squeeze(REcorrPerm(3,ch,:));
    cDiffs = reshape(cDiffs,1,numel(cDiffs));
    histogram(cDiffs,'Normalization','probability','BinWidth',0.1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
    plot([RErealCorr(3,ch) RErealCorr(3,ch)], [0 0.5],'-k')
    
    if REpVal(1,ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',REpVal(3,ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',REpVal(3,ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    xlabel('Difference in orientation correlations','FontSize',11)
    
    if contains(LEdata.animal,'WU')
        figName = [LEdata.animal,'_BE_',LEdata.array,'_rotationPerm_ch',num2str(ch),'.pdf'];
    else
        figName = [LEdata.animal,'_BE_',LEdata.array,'_',LEdata.programID,'_rotationPerm_ch',num2str(ch),'.pdf'];
    end
    print(gcf, figName,'-dpdf','-bestfit')
end
fprintf('time to do rotation permutations %.2f minutes\n',toc/60)

