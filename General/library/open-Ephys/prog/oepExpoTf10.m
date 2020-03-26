function S = oepExpoTf10(azDir,unitLabel,runNum,doBoot,doPlot)

if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;

forceOverwrite = 0;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
azFile = [azDir,'/',runStr,'_tfAz.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoTf10: ',runStr,'\n'])

    load(passRespFile,'ExpoIn');
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    passCon = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Contrast')];
    isBlank = passCon==0;
    passTf = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],0,'Drift Rate')];
    tfVals = unique(passTf( ~isnan(passTf) & passCon>0 ));
    
    S = oepProc1Dexp(azDir,unitLabel,runNum,isBlank,tfVals,passTf,doBoot);
    S.tfVals = tfVals;
    S.nTf = numel(tfVals);
    
    save(azFile,'S')
    
else
    load(azFile)
end


if doPlot
    load ChanMap_A32
    figure, hold on
    
     for i = 1:2
        if i==1
            Y = S.countSub;
        else
            Y = S.powNorm;
        end
        subplot(2,1,i), hold on

        imagesc(log10(S.tfVals),(1:nElec),Y(:,chanMap).'), colormap gray
        for iA = 1:nElec
            plot3(log10(S.tfVals),iA*ones(1,S.nTf),Y(:,chanMap(iA)),'.-','markersize',10)
        end
        axis ij
        xlabel('TF'), ylabel('Electrode')
        set(gca,'ytick',1:32)
        ylim([1,32])
        xlim([min(log10(S.tfVals)),max(log10(S.tfVals))])
        set(gcf,'position',[670  667  586  640])

        x = round(S.tfVals*100)/100;
        tfTickLabel = cellfun(@num2str,num2cell(x),'uniformoutput',0);
        set(gca,'xtick',log10(S.tfVals),'xticklabel',tfTickLabel)
     end
     set(gcf,'position',[873    20   418   965])
    set(gcf,'name',runStr)
end
    