function S = oepExpoLocNxN(azDir,unitLabel,runNum,doBoot,doPlot)
% Note: this doesn't work on Brett's old localizer5x5, which uses Expo's Surface Matrix,
% just newer localizer11x11, or 15x15.

nElec = 32;
if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end

forceOverwrite = 0;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
azFile = [azDir,'/',runStr,'_loc11Az.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoLoc11x11: ',runStr,'\n'])

    load(passRespFile,'ExpoIn');
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    passX = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],0,'X Position')];
    passY = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],0,'Y Position')];
    passCon = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Contrast')];
    isBlank = passCon==0;
    xVals = unique(passX(~isnan(passX)));
    yVals = unique(passY(~isnan(passY)));
    S = oepProc2Dexp(azDir,unitLabel,runNum,isBlank,xVals,passX,yVals,passY,doBoot);
    S.xVals = xVals;
    S.yVals = yVals;
    S.nX = numel(xVals);
    S.nY = numel(yVals);

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
        Yx = reshape(nanmean(Y,1),[S.nX,nElec]);
        imagesc(S.xVals,(1:nElec),Yx(:,chanMap).'), colormap gray
        for iA = 1:nElec
            plot3(S.xVals,iA*ones(1,S.nX),Yx(:,chanMap(iA)),'.-')
        end
        axis ij
        xlabel('X'), ylabel('Electrode')
        set(gca,'ytick',1:32,'tickdir','out')
        ylim([1,32])
        xlim([min(S.xVals),max(S.xVals)])
        x = round(S.xVals*100)/100;
        xTickLabel = cellfun(@num2str,num2cell(x),'uniformoutput',0);
        set(gca,'xtick',S.xVals,'xticklabel',xTickLabel)

        subplot(2,2,2*(i-1)+2), hold on
        Yy = reshape(nanmean(Y,2),[S.nX,nElec]);
        imagesc(S.yVals,(1:nElec),Yy(:,chanMap).'), colormap gray
        for iA = 1:nElec
            plot3(S.yVals,iA*ones(1,S.nY),Yy(:,chanMap(iA)),'.-')
        end
        axis ij
        xlabel('Y'), ylabel('Electrode')
        set(gca,'ytick',1:32,'tickdir','out')
        ylim([1,32])
        xlim([min(S.yVals),max(S.yVals)])
        set(gcf,'position',[74  669  578  639])
        y = round(S.yVals*100)/100;
        yTickLabel = cellfun(@num2str,num2cell(y),'uniformoutput',0);
        set(gca,'xtick',S.yVals,'xticklabel',yTickLabel)
    end
    set(gcf,'name',runStr)
    set(gcf,'position',[899    28   973   948])
end