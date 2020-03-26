function S = oepExpoSf11(azDir,unitLabel,runNum,doBoot,doPlot)

if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;

forceOverwrite = 0;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
azFile = [azDir,'/',runStr,'_sfAz.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoSf11: ',runStr,'\n'])

    load(passRespFile,'ExpoIn');
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    passCon = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Contrast')];
    isBlank = passCon==0;
    passSf = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Spatial Frequency X')];
    sfVals = unique(passSf( ~isnan(passSf) & passCon>0 ));
    
    S = oepProc1Dexp(azDir,unitLabel,runNum,isBlank,sfVals,passSf,doBoot);
    S.sfVals = sfVals;
    S.nSf = numel(sfVals);
    
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
  
        imagesc(log10(S.sfVals),(1:nElec),Y(:,chanMap).'), colormap gray
        for iA = 1:nElec
            plot3(log10(S.sfVals),iA*ones(1,S.nSf),Y(:,chanMap(iA)),'.-','markersize',10)
        end
        axis ij
        xlabel('SF'), ylabel('Electrode')
        set(gca,'ytick',1:32)
        ylim([1,32])
        xlim([min(log10(S.sfVals)),max(log10(S.sfVals))])
        set(gcf,'position',[472    22   387   961])

        x = round(S.sfVals*100)/100;
        sfTickLabel = cellfun(@num2str,num2cell(x),'uniformoutput',0);
        set(gca,'xtick',log10(S.sfVals),'xticklabel',sfTickLabel)
     end
    set(gcf,'name',runStr)
end





