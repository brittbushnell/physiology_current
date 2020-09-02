clear
clc, close all

addpath('..')
LinArrayParams
Units = load('Units');
azDir = [azDirBase,'/joint-tuning'];

nEyes = 2;
nSf = 14;
nOri = 24;
global nElec
nElec = 32;
global chanMap

nBoot = 100;
nRep = 30;
nTrials = nRep*nOri*nSf;
nTrialsPerSf = nRep*nOri;
nTrialsPerOri = nRep*nSf;

doAz = 0;
doPlot = 1;
forceOverwrite = 1;


for iM = 7
for iP = 5%1:Units.nPen(iM)
chanMap = ChanMaps(:,Units.chanMapNum(iP,iM));
runNumVals = Units.dirSfRun{iP,iM};
if ~isempty(runNumVals)
for iR = 1:numel(runNumVals)
    runNum = runNumVals(iR);
    if ~isnan(runNum)
            
    runLab = oepGetRunLabel(Units.label{iP,iM},runNum);
    disp(runLab)
    saveFile = [azDir,'/',runLab,'_tuningScores.mat'];
           
    if ~exist(saveFile,'file') || forceOverwrite

        S = oepExpoOriSfPhase(azDir,Units.label{iP,iM},runNum,true,false);  

        % Variance across all conditions
        v1 = var(reshape(S.countMean,[nOri*nSf,nElec]));
        CNT = cell2mat(S.count(:));
        if size(CNT,1)<nTrials
            CNT(nTrials,:) = nan;
        end
        v0 = nan(nBoot,nElec);
        for iB = 1:nBoot
            ind = randsample(nTrials,nTrials);
            X = reshape(nanmean(reshape(CNT(ind,:),[nRep,nOri,nSf,nElec])),[nOri,nSf,nElec]);
            v0(iB,:) = nanvar(reshape(X,[nOri*nSf,nElec]));
        end
        jointTuneScore = 1 - sum(v0>v1)./nBoot;

        % Variance across ori for each sf
        oriTuneScore = nan(nSf,nElec);
        for iS = 1:nSf
            v1 = var(reshape(S.countMean(:,iS,:),[nOri,nElec]));
            CNT = cell2mat(S.count(:,iS));
            if size(CNT,1)<nTrialsPerSf
                CNT(nTrialsPerSf,:) = nan;
            end
            v0 = nan(nBoot,nElec);
            for iB = 1:nBoot
                ind = randsample(nTrialsPerSf,nTrialsPerSf);
                X = reshape(nanmean(reshape(CNT(ind,:),[nRep,nOri,nElec])),[nOri,nElec]);
                v0(iB,:) = nanvar(reshape(X,[nOri,nElec]));
            end
            oriTuneScore(iS,:) = 1 - sum(v0>v1)./nBoot;
        end

        % Variance across sf for each ori
        sfTuneScore = nan(nOri,nElec);
        for iO = 1:nOri
            v1 = var(reshape(S.countMean(iO,:,:),[nSf,nElec]));
            CNT = cell2mat(S.count(iO,:).');
            if size(CNT,1)<nTrialsPerOri
                CNT(nTrialsPerOri,:) = nan;
            end
            v0 = nan(nBoot,nElec);
            for iB = 1:nBoot
                ind = randsample(nTrialsPerOri,nTrialsPerOri);
                X = reshape(nanmean(reshape(CNT(ind,:),[nRep,nSf,nElec])),[nSf,nElec]);
                v0(iB,:) = nanvar(reshape(X,[nSf,nElec]));
            end
            sfTuneScore(iO,:) = 1 - sum(v0>v1)./nBoot;
        end
        
        JTS.jointTuneScore = jointTuneScore;
        JTS.oriTuneScore = oriTuneScore;
        JTS.sfTuneScore = sfTuneScore;
        save(saveFile,'JTS')
       
    else
        S = oepExpoOriSfPhase(azDir,Units.label{iP,iM},runNum,true,false);  
        load(saveFile)
    end % if overwrite
    

    if doPlot
        figure
        for iA = 1:nElec
            subplot(6,6,find(chanMap==iA)), hold on
            imagesc(S.countSub(:,:,iA)), axis xy
            for iS = 1:nSf
                if JTS.oriTuneScore(iS,iA)>0.999
                    plot(iS,0,'r.','markersize',10)
                end
            end
            for iO = 1:nOri
                if JTS.sfTuneScore(iO,iA)>0.999
                    plot(0,iO,'o','markersize',2,'color',[0,0,1])
                end
            end
            axis off
        end
        colormap gray
        set(gcf,'position',[558   101  1442  1222])
        set(gcf,'name',runLab)
        drawnow
    end
                    
    end
    end % iR
end
end % iP
end % iM
