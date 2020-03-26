function S = oepExpoOri16(azDir,unitLabel,runNum,doBoot,doPlot)

if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;

forceOverwrite = 0;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
azFile = [azDir,'/',runStr,'_oriAz.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoOri16: ',runStr,'\n'])

    load(passRespFile,'ExpoIn');
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    passCon = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Contrast')];
    isBlank = passCon==0;
    passOri = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],0,'Orientation')];
    oriVals = unique(passOri(2:end));
    
    S = oepProc1Dexp(azDir,unitLabel,runNum,isBlank,oriVals,passOri,doBoot);
    S.oriVals = oriVals;
    S.nOri = numel(oriVals);
    
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
%         Ynorm = bsxfun(@minus,Y,min(Y));
%         Ynorm = bsxfun(@rdivide,Ynorm,max(Ynorm));
        
        subplot(2,1,i), hold on
        imagesc(S.oriVals,(1:nElec),Y(:,chanMap).'), colormap gray
%         imagesc(S.oriVals,(1:nElec),Ynorm(:,chanMap).'), colormap gray
        for iA = 1:nElec
            plot3(S.oriVals,iA*ones(1,S.nOri),Y(:,chanMap(iA)),'.-','markersize',10)
        end
        axis ij
        xlabel('ORI'), ylabel('Electrode')
        set(gca,'ytick',1:32,'tickdir','out')
        ylim([1,32])
        xlim([0,max(S.oriVals)])
        set(gcf,'position',[74    24   390   961])

        oriTickLabel = cellfun(@num2str,num2cell(S.oriVals),'uniformoutput',0);
        set(gca,'xtick',S.oriVals,'xticklabel',oriTickLabel)
    end
    set(gcf,'name',runStr)
end
        
    