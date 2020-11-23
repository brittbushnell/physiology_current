function [dataT] = getReceptiveFields_zScore(dataT)

%%
locMtx = dataT.stimZscore;

% stim mtx is set up (y,x,ch,rep), but Manu's code assumes x,y
locZscores = nanmean(locMtx,4); % get mean z score at each location
locZscores = permute(locZscores,[2,1,3]); % reorganize so it's (x,y,ch)
%%
fixX = double(unique(dataT.fix_x));
fixY = double(unique(dataT.fix_y));
xPos = double(unique(dataT.pos_x));
yPos = double(unique(dataT.pos_y));

% adjust locations so they are relative to fixation, not to the center of the monitor (as they were in MWorks)
% graphically, this will make it so fixation is always at origin, and you can get
% a better sense of the actual eccentricies of the receptive fields.

if fixX ~= 0
    xPosRelFix = xPos-fixX;
else
    xPosRelFix = xPos;
end

if fixY ~= 0
    yPosRelFix = yPos-fixY;
else
    yPosRelFix = yPos;
end

%% Get receptive field information
arrayRF = nanmean(locZscores,3); % want hot spot of the entire array, so mean across channels

saveName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_rfInputs.mat'];
save(saveName,'xPosRelFix','yPosRelFix','arrayRF','locZscores');
fprintf('%s saved\n', saveName)

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