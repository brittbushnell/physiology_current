function [dataT] = getReceptiveFields_zScoreXT(dataT)

%%
locMtx = dataT.stimZscore;

% stim mtx is set up (y,x,ch,rep), but Manu's code assumes x,y
locZscores = nanmean(locMtx,4); % get mean z score at each location
locZscores = permute(locZscores,[2,1,3]); % reorganize so it's (x,y,ch)

%% Get receptive field information
arrayRF = nanmean(locZscores,3); % want hot spot of the entire array, so mean across channels

[params,rhat,errorsum,fullArray] = fit_gaussianrf_z(xPosRelFix,yPosRelFix,arrayRF);
%%

for ch = 1:96
    chZs = squeeze(locZscores(:,:,ch));
    [params,rhat,errorsum,cf] = fit_gaussianrf_z(xPosRelFix,yPosRelFix,chZs);
    chFit{ch} = cf.paramsadj;
end
%%
dataT.chReceptiveFieldParams = chFit;
dataT.arrayReceptiveFieldParams = fullArray.paramsadj;
dataT.xPosRelFix = xPosRelFix;
dataT.yPosRelFix = yPosRelFix;