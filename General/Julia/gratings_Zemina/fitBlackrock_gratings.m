function F = fitBlackrock_gratings(R, resp, filename, outputDir, binStart, binEnd, nStarts, forceOverwrite)

% NOTE 09/08/18: 
% DO WE WANT TO FIT WITH 0 SF RESPONSE?

fitFile     = [outputDir filename '_fits.mat'];
if ~exist(fitFile) || forceOverwrite
    nParam          = 5;
    
    nSf             = R.iSf;
    nOri            = R.iOri;
    nChan           = R.iC;
    
    fits            = nan(nSf, nOri, nChan);
    param           = nan(nParam, nChan);
    MSE             = nan(1, nChan);
    disp('Fitting responses...')
    for iC = 1:96
        %resp        = nansum(R.respAvg(:,:,binStart:binEnd,iC),3) - nansum(R.respBlankAvg(iC,binStart:binEnd));
        chanResp    = resp(:,:,iC);
        [param(:,iC), fits(:,:,iC), MSE(iC)] = FitVMBlob(chanResp, nStarts);
        fprintf('%g ', iC);
        if mod(iC, 24) == 0
            fprintf('\n')
        end
    end

    save(fitFile)
    F = load(fitFile);
else
    F = load(fitFile);
end