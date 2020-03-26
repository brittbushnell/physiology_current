function S = oepExpoRelPhase12(azDir,unitLabel,runNum,doBoot,doPlot)

if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;

forceOverwrite = 0;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
azFile = [azDir,'/',runStr,'_relPhaseAz.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoRelPhase12: ',runStr,'\n'])

    load(passRespFile,'ExpoIn');
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    passConL = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Contrast')];
    passConR = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],1,'Contrast')];
    isBlank = passConL==0 & passConR==0;
    isLonly = passConL>0 & passConR==0;
    isRonly = passConR>0 & passConL==0;
    passRelPhase = [nan;GetEvents(ExpoIn,passIDs,'Op Variable',[],0,'Destination')];
    phiVals = unique(passRelPhase(2:end));
    
    passLab = passRelPhase;
    passLab(isLonly) = -1;
    passLab(isRonly) = -2;
    condLab = [-2;-1;phiVals];
    
    S = oepProc1Dexp(azDir,unitLabel,runNum,isBlank,condLab,passLab,doBoot);
    S.phiVals = phiVals;
    S.nPhi = numel(phiVals);
    
    S.LonlyCountMean = S.countMean(1,:);
    S.RonlyCountMean = S.countMean(2,:);
    
    S.LonlyCountSub = S.countSub(1,:);
    S.RonlyCountSub = S.countSub(2,:);
    
    save(azFile,'S')
    
else
    load(azFile)
end
    

if doPlot
    load ChanMap_A32
    figure, hold on
    rColor = [0.5,0,0];
    lColor = [0,0.5,0];
    dColor = [0.1,0.1,0.4];
    x = S.phiVals;
    for i = 1:2
        if i==1
            Y = S.countSub;
        else
            Y = S.powSub;
        end
        
        for iA = 1:nElec
            subplot(5,7,find(chanMap==iA)), hold on
            yR = S.RonlyCountSub(iA).*ones(size(x));
            yL = S.LonlyCountSub(iA).*ones(size(x));
            yD = S.countSub(3:end,iA);
            
            plot(x,yR,'color',rColor)
            plot(x,yL,'color',lColor)
            plot(x,yD,'color',dColor)
            
            title(num2str(iA))
        end
            
    end
    set(gcf,'name',runStr)
    set(gcf,'position',[325   150  1777  1161])
    drawnow
end
        
    