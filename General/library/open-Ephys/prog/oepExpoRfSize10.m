function S = oepExpoRfSize10(azDir,unitLabel,runNum,doBoot,doPlot)

if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end

nElec = 32;
nBoot = 100;

forceOverwrite = 0;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
azFile = [azDir,'/',runStr,'_sizeAz.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoRfSize10: ',runStr,'\n'])

    load(passRespFile,'ExpoIn','passSpikeCounts','passPow','passPsth');
    nIso = size(passSpikeCounts,3)-1;
    doPsth = ~isempty(passPsth);
    if doPsth; nT=size(passPsth,1); end

    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    passSize1 = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],0,'Width')];
    passSize2 = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],1,'Width')];
    
    isBlank = (passSize1==0) & (passSize2==0);
    S.odVals = unique(passSize1(2:end));
    S.idVals = unique(passSize2(2:end));

    nDiam = numel(S.odVals);
    S.nDiam = nDiam;
    
    %%% ------- Blank conditions ------- %%%
    S.nSponTrials = sum(isBlank);

    % Threshold crossings
    S.sponCount = passSpikeCounts(isBlank,:,:);
    S.sponCountMean = reshape(nanmean(S.sponCount),[nElec,1+nIso]);
    S.sponCountStd = reshape(nanstd(S.sponCount),[nElec,1+nIso]);
    S.sponCountSem = S.sponCountStd./sqrt(S.nSponTrials);
    if doBoot
        for iIso = 1:1+nIso
            S.sponCountBoot(:,:,iIso) = bootstrp(nBoot,@mean,S.sponCount(:,:,iIso));
            S.sponCountBootMean(:,iIso) = mean(S.sponCountBoot(:,:,iIso));
            S.sponCountBootCi(:,:,iIso) = prctile(S.sponCountBoot(:,:,iIso),[5,95]);
        end
    end
    if doPsth
        S.sponPsthMean = reshape(mean(passPsth(:,isBlank,:,:),2),[nT,nElec,1+nIso]);
        S.sponPsthStd = reshape(std(passPsth(:,isBlank,:,:),[],2),[nT,nElec,1+nIso]);
        S.sponPsthSem = S.sponPsthStd./sqrt(S.nSponTrials);
    end
    
    
    % Spike-band power
    S.sponPow = passPow(isBlank,:);
    S.sponPowMean = nanmean(S.sponPow);
    S.sponPowStd = nanstd(S.sponPow);
    S.sponPowSem = S.sponPowStd./sqrt(S.nSponTrials);
    if doBoot
        S.sponPowBoot = bootstrp(nBoot,@mean,S.sponPow);
        S.sponPowBootMean = mean(S.sponPowBoot);
        S.sponPowBootCi = prctile(S.sponPowBoot,[5,95]);
    end

    %%% ------- Stimulus conditions ------- %%%
    for iX = 1:nDiam
        
        bind1 = (passSize2==0) & (passSize1==S.odVals(iX));
        S.nTrials(iX,1) = sum(bind1);
        if S.nTrials(iX,1)
            % Threshold crossings
            S.count{iX,1} = passSpikeCounts(bind1,:,:);
            S.countMean(iX,1,:,:) = reshape(nanmean(S.count{iX,1}),[1,1,nElec,1+nIso]);
            S.countStd(iX,1,:,:) = reshape(nanstd(S.count{iX,1}),[1,1,nElec,1+nIso]);
            S.countSem(iX,1,:,:) = S.countStd(iX,1,:)./sqrt(S.nTrials(iX,1));
            if doBoot
                for iIso = 1:1+nIso
                    S.countBoot(:,iX,1,:,iIso) = bootstrp(nBoot,@mean,S.count{iX,1}(:,:,iIso));
                end
            end
            if doPsth
                S.psthMean(:,iX,1,:,:) = reshape(mean(passPsth(:,bind1,:,:),2),[nT,1,1,nElec,1+nIso]);
                S.psthStd(:,iX,1,:,:) = reshape(std(passPsth(:,bind1,:,:),[],2),[nT,1,1,nElec,1+nIso]);
                S.psthSem(:,iX,1,:,:) = S.psthStd(:,iX,1,:,:)./sqrt(S.nSponTrials);
            end
        
            % Spike-band power
            S.pow{iX,1} = passPow(bind1,:);
            S.powMean(iX,1,:) = nanmean(S.pow{iX,1});
            S.powStd(iX,1,:) = nanstd(S.pow{iX,1});
            S.powSem(iX,1,:) = S.powStd(iX,1,:)./sqrt(S.nTrials(iX,1));
            if doBoot
                S.powBoot(:,iX,1,:) = bootstrp(nBoot,@mean,S.pow{iX,1});
            end
        end
        
        bind2 = passSize2==S.idVals(iX);
        S.nTrials(iX,2) = sum(bind2);
        if S.nTrials(iX,2)
            % Threshold crossings
            S.count{iX,2} = passSpikeCounts(bind2,:,:);
            S.countMean(iX,2,:,:) = reshape(nanmean(S.count{iX,2}),[1,1,nElec,1+nIso]);
            S.countStd(iX,2,:,:) = reshape(nanstd(S.count{iX,2}),[1,1,nElec,1+nIso]);
            S.countSem(iX,2,:,:) = S.countStd(iX,2,:)./sqrt(S.nTrials(iX,2));
            if doBoot
                for iIso = 1:1+nIso
                    S.countBoot(:,iX,2,:,iIso) = bootstrp(nBoot,@mean,S.count{iX,2}(:,:,iIso));
                end
            end
            if doPsth
                S.psthMean(:,iX,2,:,:) = reshape(mean(passPsth(:,bind2,:,:),2),[nT,1,1,nElec,1+nIso]);
                S.psthStd(:,iX,2,:,:) = reshape(std(passPsth(:,bind2,:,:),[],2),[nT,1,1,nElec,1+nIso]);
                S.psthSem(:,iX,2,:,:) = S.psthStd(:,iX,1,:,:)./sqrt(S.nSponTrials);
            end
            
            % Spike-band power
            S.pow{iX,2} = passPow(bind2,:);
            S.powMean(iX,2,:) = nanmean(S.pow{iX,2});
            S.powStd(iX,2,:) = nanstd(S.pow{iX,2});
            S.powSem(iX,2,:) = S.powStd(iX,2,:)./sqrt(S.nTrials(iX,2));
            if doBoot
                S.powBoot(:,iX,2,:) = bootstrp(nBoot,@mean,S.pow{iX,2});
            end
        end
    
    end
        
    if doBoot
        S.countBootMean = reshape(mean(S.countBoot),[nDiam,2,nElec,1+nIso]);
        S.countBootCi = reshape(prctile(S.countBoot,[5,95]),[2,nDiam,2,nElec,1+nIso]);
        S.powBootMean = reshape(mean(S.powBoot),[nDiam,2,nElec]);
        S.powBootCi = reshape(prctile(S.powBoot,[5,95]),[2,nDiam,2,nElec]);
    end
    
    S.countSub = bsxfun(@minus,S.countMean,reshape(S.sponCountMean,[1,1,nElec]));
    if doPsth
        S.psthSub = bsxfun(@minus,S.psthMean,reshape(S.sponPsthMean,[nT,1,1,nElec,1+nIso]));
    end
    
    S.powSub = bsxfun(@minus,S.powMean,reshape(S.sponPowMean,[1,1,nElec]));
    S.powNorm = bsxfun(@rdivide,S.powSub,reshape(S.sponPowMean,[1,1,nElec]));
    
    save(azFile,'S')
else
    load(azFile)
end
    

if doPlot
    load ChanMap_A32
    figure
    
    for i = 1:2
        if i==1
            Y = S.countSub;
        else
            Y = S.powNorm;
        end
        subplot(2,2,2*(i-1)+1), hold on
        imagesc(log10(S.odVals(2:end)),(1:nElec),squeeze(Y(2:end,1,chanMap)).'), colormap gray
        for iA = 1:nElec
            plot3(log10(S.odVals),iA*ones(1,S.nDiam),Y(:,1,chanMap(iA)),'.-')
        end
        axis ij
        xlabel('SIZE'), ylabel('Electrode')
        set(gca,'ytick',1:32)
        ylim([1,32])
        xlim([min(log10(S.idVals)),max(log10(S.idVals))])

        x = round(S.idVals*100)/100;
        idTickLabel = cellfun(@num2str,num2cell(x),'uniformoutput',0);
    %     set(gca,'xtick',log10(S.idVals),'xticklabel',idTickLabel,'xticklabelrotation',45)
        set(gca,'xtick',log10(S.idVals),'xticklabel',idTickLabel)

        subplot(2,2,2*(i-1)+2), hold on
    %     surf(log10(S.idVals),(1:nElec),squeeze(S.countSub(:,2,chanMap)).'), shading flat, colormap copper
        imagesc(log10(S.idVals(2:end)),(1:nElec),squeeze(Y(2:end,2,chanMap)).'), colormap gray
        for iA = 1:nElec
            plot3(log10(S.idVals),iA*ones(1,S.nDiam),Y(:,2,chanMap(iA)),'.-')
        end
        axis ij
        xlabel('INNER DIAMETER'), ylabel('Electrode')
        set(gca,'ytick',1:32)
        ylim([1,32])
        xlim([min(log10(S.idVals)),max(log10(S.idVals))])

        x = round(S.idVals*100)/100;
        idTickLabel = cellfun(@num2str,num2cell(x),'uniformoutput',0);
    %     set(gca,'xtick',log10(S.idVals),'xticklabel',idTickLabel,'xticklabelrotation',45)
        set(gca,'xtick',log10(S.idVals),'xticklabel',idTickLabel)
    end
    
    set(gcf,'position',[557          21        1150         964])
    set(gcf,'name',runStr)
end