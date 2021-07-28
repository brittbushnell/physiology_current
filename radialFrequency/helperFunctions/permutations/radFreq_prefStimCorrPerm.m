function [sigPerms, corrPerm] = radFreq_prefStimCorrPerm(dataT,numBoot,realCorr)
% This function should be called after running radFreq_getFisherLoc_BE to
% get the preferred location for each good channel. Looking at the
% preferred location, this function will do a permutation test for orientation
% in each RF.
%
% organization of real correlations should be: (RF, ori, ch)
%    eye 1 = LE   ori 1 = 0deg

% Brittany Bushnell 6/29/21

%%
location = determineComputer;

if location == 1
    if contains(dataT.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
    elseif contains(dataT.animal,'XT')
        if contains(dataT.programID,'low','IgnoreCase',true)
            if contains(dataT.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
            end
        else
            if contains(dataT.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
            end
        end
    else
        if contains(dataT.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
        end
    end
elseif location == 0
    if contains(dataT.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
    elseif contains(dataT.animal,'XT')
        if contains(dataT.programID,'low','IgnoreCase',true)
            if contains(dataT.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
            end
        else
            if contains(dataT.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
            end
        end
    else
        if contains(dataT.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/Perm/prefStimCorr',dataT.animal,dataT.array);
        end
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
locPair = dataT.locPair;
prefLoc = dataT.prefLoc;
% realCorr = squeeze(realCorr(1,:,:));

prefRad = dataT.prefSize;
%(RF,ori,amp,sf,radius,location, ch)
spikes = dataT.RFspikeCount;

corrPerm = nan(3,96,numBoot);
sigPerms = nan(3,96);

pVal = nan(3,96);

% define ranges for each option
radfreqs = [4,8,16];
amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 0:6;
holdout = 0.2; % percentage of the data you want to withold when doing the permutations

%%
% close all
for ch = 1:96
    %%
    
    scCh = spikes{ch};
    
%     sigDiff = nan(3,1,96);
    
    if dataT.goodCh(ch) == 1
        muSc = nan(3,6);
        
%         if contains(dataT.animal,'WU')
            locNdx = (scCh(6,:) == locPair(prefLoc(ch),1)) & (scCh(7,:) == locPair(prefLoc(ch),2));
            radNdx = (scCh(5,:) == prefRad(ch));
            
%         else
%             locNdx = (scCh(5,:) == locPair(prefLoc(ch),1)) & (scCh(6,:) == locPair(prefLoc(ch),2));
%             radNdx = (scCh(4,:) == prefRad(ch));
%             
%         end
%         
        for rf = 1:3
            circNdx = (scCh(1,:) == 32);
            rfNdx   = (scCh(1,:) == radfreqs(rf));
            
            circSpikes = squeeze(scCh(8:end,locNdx & circNdx & radNdx));
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
                    
                    stimSpikes = squeeze(scCh(8:end,rfNdx & ampNdx & locNdx & radNdx));
                    stimSpikes = reshape(stimSpikes,[1,numel(stimSpikes)]);
                    numStimTrials = round((length(stimSpikes)) * (1-holdout));
                    
                    stimSub1 = randperm(size(stimSpikes,2),numStimTrials);
                    useStim1 = stimSpikes(stimSub1);
                    
                    muStim1 = (nanmean(useStim1,'all'));
                    muSc(rf,amp) = muStim1 - muCirc;
                    
                    clear muStim stimSpikes
                end %amplitude

                % get the correlation
                muSct = squeeze(muSc(rf,:)); %(rf,rot,amp)
                muScRFrot = [0, muSct];
                corMtx = corrcoef(xs,muScRFrot);
                corrPerm(rf,ch,nb) = corMtx(2);
                
                clear muScRFrot sCorr corMtx
            end %bootstrap
            
            %% do the actual permutation test for significance.
                        
            corrs = squeeze(corrPerm(rf,ch,:));
            trueCorr = squeeze(realCorr(rf,ch));
            
            high = find(corrs>trueCorr);
            pV = round(((length(high)+1)/(length(corrs)+1)),3);
            
            if pV > 0.5
                pV = 1-pV;
            end 
            
            pVal(rf,ch) = pV;
            
            if  pV <= 0.05    
                sigPerms(rf,ch) = 1; 
            else
                sigPerms(rf,ch) = 0;  
            end
            
        end %RF
    end % goodCh
end
%% sanity figures
%
for ch = 1:96
    figure(12)
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2), 450, 500])
    clf
    s = suptitle(sprintf('%s %s %s %s permutation test ch %d',dataT.animal,dataT.eye,dataT.array,dataT.programID,ch));
    s.Position(2) = s.Position(2) + 0.024;
    
    h = subplot(3,1,1);
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    stimCorrs = squeeze(corrPerm(1,ch,:));
    stimCorrs = reshape(stimCorrs,1,numel(stimCorrs));
    histogram(stimCorrs,'Normalization','probability','BinWidth',0.1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    plot([realCorr(1,ch) realCorr(1,ch)], [0 0.5],'-k')
    
    if pVal(1,ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',pVal(1,ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',pVal(1,ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    ylabel('Proportion of chs','FontSize',11)
    text(-1.3,0.3,'RF4','FontSize',12,'FontWeight','bold','Rotation',90)
     
    h.Position(1) = h.Position(1) + 0.055;
    
    h = subplot(3,1,2);
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    stimCorrs = squeeze(corrPerm(2,ch,:));
    stimCorrs = reshape(stimCorrs,1,numel(stimCorrs));
    histogram(stimCorrs,'Normalization','probability','BinWidth',0.1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    plot([realCorr(2,ch) realCorr(2,ch)], [0 0.5],'-k')
    
    if pVal(2,ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',pVal(2,ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',pVal(2,ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    ylabel('Proportion of chs','FontSize',11)
    text(-1.3,0.3,'RF8','FontSize',12,'FontWeight','bold','Rotation',90)
    
    h.Position(1) = h.Position(1) + 0.055;
    
    h = subplot(3,1,3);
    hold on
    ylim([0 0.6])
    xlim([-1 1])
    
    stimCorrs = squeeze(corrPerm(3,ch,:));
    stimCorrs = reshape(stimCorrs,1,numel(stimCorrs));
    histogram(stimCorrs,'Normalization','probability','BinWidth',0.1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    plot([realCorr(3,ch) realCorr(3,ch)], [0 0.5],'-k')
    
    if pVal(1,ch) <=0.05
        text(-0.9,0.58,sprintf('*p %.3f',pVal(3,ch)),'FontSize',10.5,'FontAngle','italic','FontWeight','bold')
    else
        text(-0.9,0.58,sprintf('p %.3f',pVal(3,ch)),'FontSize',10,'FontAngle','italic')
    end
    
    set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
    ylabel('Proportion of chs','FontSize',11)
    xlabel('Permuted amplitude correlations','FontSize',11)
    text(-1.3,0.3,'RF16','FontSize',12,'FontWeight','bold','Rotation',90)
    
    h.Position(1) = h.Position(1) + 0.055;
   
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_NeuroCorrDist_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
end
fprintf('time to do permutations %.2f minutes\n',toc/60)

