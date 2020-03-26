function RG = oepExpoRedGreen14(azDir,unitLabel,runNum,doBoot,doPlot)

if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;
nBoot = 100;
iqrThresh = 100;
forceOverwrite = 0;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
rgAzFile = [azDir,'/',runStr,'_rgAz.mat'];

if ~exist(rgAzFile,'file') || forceOverwrite
    fprintf(['oepExpoRedGreen14: ',runStr,'\n'])

    load(passRespFile,'ExpoIn','passCounts','passPow','passMaxIqrScore');
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    passSize = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],0,'Width')];
    passG = [nan;GetEvents(ExpoIn,passIDs,'RGB Texture',[],1,'Opacity')];

    isArt = max(passMaxIqrScore)>iqrThresh;
    passPow(:,isArt) = nan;
    
    isBlank = passSize==0;
    temp = unique(passG);
    RG.gVals = temp(~isnan(temp));
    nG = numel(RG.gVals);
    RG.nG = nG;
    
    RG.nSponTrials = sum(isBlank);
    RG.sponPow = passPow(:,isBlank).';
    RG.sponPowMean = nanmean(RG.sponPow);
    RG.sponPowStd = nanstd(RG.sponPow);
    RG.sponPowSem = RG.sponPowStd./sqrt(RG.nSponTrials);
    if doBoot
        RG.sponPowBoot = bootstrp(nBoot,@mean,RG.sponPow);
        RG.sponPowBootMean = mean(RG.sponPowBoot);
        RG.sponPowBootCi = prctile(RG.sponPowBoot,[5,95]);
    end
    
    for iG = 1:nG
        bind = ~isBlank & (passG==RG.gVals(iG));
        RG.nTrials(iG) = sum(bind);
        RG.condPow{iG} = passPow(:,bind).';
        RG.condPowMean(iG,:) = nanmean(RG.condPow{iG});
        RG.condPowStd(iG,:) = nanstd(RG.condPow{iG});
        RG.condPowSem(iG,:) = RG.condPowStd(iG,:)./sqrt(RG.nTrials(iG));
        if doBoot
            RG.condPowBoot(:,iG,:) = bootstrp(nBoot,@mean,RG.condPow{iG});
        end
    end
    if doBoot
        RG.condPowBootMean = reshape(mean(RG.condPowBoot),[nG,nElec]);
        RG.condPowBootCi = reshape(prctile(RG.condPowBoot,[5,95]),[2,nG,nElec]);
    end

    RG.condPowSub = bsxfun(@minus,RG.condPowMean,RG.sponPowMean);
    RG.condPowNorm = bsxfun(@rdivide,RG.condPowSub,RG.sponPowMean);

    RG.condPowZ = bsxfun(@minus,RG.condPowMean,RG.sponPowMean)./...
        sqrt(bsxfun(@plus,RG.condPowStd.^2,RG.sponPowStd.^2)./2);
    
    save(rgAzFile,'RG')
    
else
    load(rgAzFile)
end
    

if doPlot
    load ChanMap_A32
    figure, hold on
    
    Y = RG.condPowNorm;
    surf(RG.gVals,(1:nElec),Y(:,chanMap).'), shading flat, colormap copper
    for iA = 1:nElec
        plot3(RG.gVals,iA*ones(1,RG.nG),Y(:,chanMap(iA)),'-')
    end
    axis ij
    xlabel('GREEN'), ylabel('Electrode')
    set(gca,'ytick',1:32,'tickdir','out')
    ylim([1,32])
    xlim([0,max(RG.gVals)])
    set(gcf,'position',[74  669  578  639])
    
    gTickLabel = cellfun(@num2str,num2cell(RG.gVals),'uniformoutput',0);
%     set(gca,'xtick',RG.oriVals,'xticklabel',oriTickLabel,'xticklabelrotation',45)
    set(gca,'xtick',RG.gVals,'xticklabel',gTickLabel)
    set(gcf,'name',runStr)
    
%     figure
%     Y = RG.condPowNorm([1:end,1],:);
%     theta = RG.oriVals([1:end,1])*pi/180;
%     polarplot(theta,Y)
%     set(gca,'thetaTick',0:10:350)
%     set(gcf,'position',[93  161  560  420])
%     set(gcf,'name',runStr)
    
end
        
    