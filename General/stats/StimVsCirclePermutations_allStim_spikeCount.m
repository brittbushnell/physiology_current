function [dataT] = StimVsCirclePermutations_allStim_spikeCount(dataT,numBoot)
% function [realStimCircDprime,stimCircDprimeBootPerm,stimCircDprimePerm, stimCircSDPerm] = StimVsCirclePermutations_allStim_zScore(dataT, REdata, numBoot)

% This function is a modified version of
%
% REQUIRED INPUTS:
%  1) matrix of zscores to all stimuli that is organized as (ch x trials)
%  2) matrix of zscores for circle activity organized as (ch x trials)
%
% OPTIONAL INPUTS:
%  3) Number of bootstraps to run (default is 1,000)
%  4) precentage of the data to use for bootstraps (default is 0.9)
%
%
% OUTPUT:
%     allStimBlankDprimePerm
%     allStimBlankDprimeBootPerm
%     allStimBlankDprimeSDPerm
%     allStimBlankDprime
%
% Brittany Bushnell  October 1, 2020

%%
location = determineComputer;

if location == 1
    if contains(dataT.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
    elseif contains(dataT.animal,'XT')
        if contains(dataT.programID,'low','IgnoreCase',true)
            if contains(dataT.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
            end
        else
            if contains(dataT.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
            end
        end
    else
        if contains(dataT.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
        end
    end
elseif location == 0
    if contains(dataT.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
    elseif contains(dataT.animal,'XT')
        if contains(dataT.programID,'low','IgnoreCase',true)
            if contains(dataT.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
            end
        else
            if contains(dataT.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
            end
        end
    else
        if contains(dataT.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/Perm/dPrime',dataT.animal,dataT.array);
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

prefRad = dataT.prefSize;
%%
stimCircDprimePval = nan(3,6,96);
stimCircDprimeSig = nan(3,6,96);
stimCircDprimeBootPerm = nan(3,6,96,numBoot);

realStimCircDprime = nan(3,6,96);

radFreqs = [4,8,16];
amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];

holdout = 0.2;
%% mean responses and d' to each stimulus
% type codes 1=concentric  2=radial 0=noise  100=blank

for ch = 1%:96
    scCh = dataT.RFspikeCount{ch};
    
    if dataT.goodCh(ch)
        
        figure%(13)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1), pos(2), 1100, 500],'PaperOrientation','landscape')
        clf
        s = suptitle(sprintf('%s %s %s %s d'' permutation test ch %d',dataT.animal,dataT.eye,dataT.array,dataT.programID,ch));
        s.Position(2) = s.Position(2) + 0.024;
        
        ndx = 1;
        stimCircBoot = nan(1,numBoot);
        
        locNdx = (scCh(6,:) == locPair(prefLoc(ch),1)) & (scCh(7,:) == locPair(prefLoc(ch),2));
        radNdx = (scCh(5,:) == prefRad(ch));
        
        for rf = 1:3 
            if rf == 3
                ampsUse = amps16;
            else
                ampsUse = amps48;
            end
            
            for amp = 1:6
                for nb = 1:numBoot
                    rfNdx = scCh(1,:) == radFreqs(rf);
                    ampNdx = scCh(2,:) == ampsUse(amp);
                    circNdx = scCh(1,:) == 32;
                    
                    stimCols = scCh(8:end, rfNdx & ampNdx & locNdx & radNdx);
                    circCols = scCh(8:end, circNdx & locNdx & radNdx);
                    
                    circ = reshape(circCols,[1,numel(circCols)]);
                    stim = reshape(stimCols,[1,numel(stimCols)]);
                    
                    realDp = simpleDiscrim(circ,stim);
                    realStimCircDprime(rf,amp,ch) = realDp;
                    clear circReal stimReal
                    %% permutation
                    stimTrials = size(stimCols,1);
                    circTrials = size(circCols,1);
                    
                    numStimTrials = round(stimTrials*(1-holdout));
                    numCircTrials = round(circTrials*(1-holdout));
                    
                    % subsample so we can bootstrap and use the same number of stimuli for everything.
                    stimNdx = randperm(length(stim),numStimTrials);
                    circNdx = randperm(setdiff(allStim,stimNdx),numCircTrials);
                    
                    randStim = stim(stimNdx);
                    randCirc = circ(circNdx);
                    % d'
                    stimCircBoot(1,nb)  = simpleDiscrim((randCirc),(randStim));
                end %bootstrap
                
                %% do the actual permutation test for significance.
                high = find(stimCircBoot>realDp);
                pV = round(((length(high)+1)/(length(stimCircBoot)+1)),3);
                
                if pV > 0.5
                    pV = 1-pV;
                end
                
                if  pV <= 0.05
                    sigPerm = 1;
                else
                    sigPerm = 0;
                end
                stimCircDprimeBootPerm(rf,amp,ch,:) = stimCircBoot;
                stimCircDprimePval(rf,amp,ch) = pV;
                stimCircDprimeSig(rf,amp,ch) = sigPerm;
                %% sanity check figures
                subplot(3,6,ndx)
                hold on
                ylim([0 0.6])
%                 xlim([ 1])
                if ndx < 7
                    histogram(stimCircBoot,'Normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','BinWidth',0.25)
                    title(sprintf('Amplitude #%d',ndx))
                elseif ndx > 6 && ndx < 13
                    histogram(stimCircBoot,'Normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','BinWidth',0.25)
                else
                    histogram(stimCircBoot,'Normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','BinWidth',0.25)
                    xlabel('permuted d''')
                end
                
                if ndx == 1
                    ylabel('RF4','FontWeight','bold','FontSize',12)
                elseif ndx == 7
                    ylabel('RF8','FontWeight','bold','FontSize',12)
                elseif ndx == 13
                    ylabel('RF16','FontWeight','bold','FontSize',12)
                end     
                          
                plot([trueD trueD], [0 0.55],'-k')
                if pV <= 0.05
                    text(-0.95, 0.55, sprintf('p = %.2f*',pV),'FontWeight','bold','FontSize',10)
                else
                    text(-0.95, 0.55, sprintf('p = %.2f',pV),'FontSize',10)
                end
                set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
                
                ndx = ndx+1;
                clear pV sigPerm
            end %amp
        end %rf
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_dPrimePermDist_ch',num2str(ch),'.pdf'];
        print(gcf, figName,'-dpdf','-bestfit')
    end % goodCh
end
%%

dataT.stimCircDprimeBootPerm = stimCircDprimeBootPerm;
dataT.stimCircDprimePval     = stimCircDprimePval;
dataT.stimCircDprimeSig      = stimCircDprimeSig;
dataT.stimCircDprime         = realStimCircDprime;