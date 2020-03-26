function CSD = oepExpoCsd(azDir,unitLabel,runNum,fsLfp,chanMap,doBoot,doPlot)

if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;
nBoot = 100;

forceOverwrite = 1;

hCen = [-1/12   4/3   -5/2     4/3    -1/12];
hCenMid = [-5/48    13/16   -17/24   -17/24   13/16    -5/48];
%hFor = [15/4   -77/6  107/6   -13  61/12   -5/6];
hFor = [1,-2,1,0,0,0];
%hForMid = [95/48  -269/48  49/8  -85/24  59/48  -3/16];
hForMid = [1,-2,1,0,0,0];
hBack = fliplr(hFor);
hBackMid = fliplr(hForMid);

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
azFile = [azDir,'/',runStr,'_csdAz.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoCsd: ',runStr,'\n'])

    load(passRespFile,'ExpoIn','passLfpTrace');
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    temp = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Elevation')];
    con = double(temp==90);
    con(temp==-90) = -1;
    if any(con==-1); nCon=2; else nCon=1; end
    CSD.nCon = nCon;
    
    lfpNt = size(passLfpTrace,1);
    CSD.t = (1:lfpNt)/fsLfp;
    
    csdN = nElec*2-1;
    
    for iC = 1:nCon
        if iC==1; bind=con==1; else bind=con==-1; end
        nTrials = sum(bind);
        LFP = passLfpTrace(:,bind,:);
        LFP = bsxfun(@minus,LFP,mean(LFP,3));
        
        lfpBs = nan(lfpNt,nElec,nBoot);
        for iB = 1:nBoot
            ind = randsample(nTrials,floor(nTrials./2),true);
            lfpBs(:,:,iB) = nanmean(LFP(:,ind,chanMap),2);
        end
%         lfpBs = bsxfun(@minus,lfpBs,mean(lfpBs,2));
        
        csdBs = nan(nBoot,lfpNt,csdN);
        for iB = 1:nBoot
            for i = 1:nElec
                k = 2*(i-1)+1;
                if i<3
                    csdBs(iB,:,k) = 0;
                    csdBs(iB,:,k+1) = 0;
                elseif i<30
                    csdBs(iB,:,k) = lfpBs(:,i-2:i+2,iB) * hCen';
                    csdBs(iB,:,k+1) = lfpBs(:,i-2:i+3,iB) *hCenMid';
                elseif i==30
                    csdBs(iB,:,k) = lfpBs(:,i-2:i+2,iB) * hCen';
                    csdBs(iB,:,k+1) = lfpBs(:,i-4:i+1,iB) * hBackMid';
                else
                    csdBs(iB,:,k) = 0;
                    if i==31
                        csdBs(iB,:,k+1) = 0;
                    end
                end
            end
        end

        CSD.csdBsMean(:,:,iC) = reshape(median(csdBs),[lfpNt,csdN]);
        CSD.csdBsCi(:,:,:,iC) = reshape(prctile(csdBs,[5,95]),[2,lfpNt,csdN]);

        CSD.lfpBsMean(:,:,iC) = median(lfpBs,3);
        CSD.lfpBsCi(:,:,:,iC) = prctile(lfpBs,[5,95],3);
        
%         keyboard

    end
    CSD.csdN = csdN;
    CSD.x = 1:0.5:32;
    save(azFile,'CSD') 
else
    load(azFile)
end

    