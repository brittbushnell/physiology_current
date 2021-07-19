function [rfMuZ, rfStErZ,circMuZ, circStErZ,...
    rfMuSc, rfStErSc,circMuSc, circStErSc] = radFreq_getMuSerrSCandZ_WVXT(dataT)

%% separate zscores into RF and phase matrices
% phases per RF:
%   4: 0 & 45
%   8: 0 & 22.5
%   16: 0 & 11.25

zScores = dataT.RFzScore;
sCount  = dataT.RFspikeCount;

locPair = dataT.locPair;
%%
%(RF,ori,amp,radius,location, ch)
rfMuZ = nan(3,2,6,2,3,96);
rfStErZ= nan(3,2,6,2,3,96);

% (radius,location, ch)
circMuZ = nan(2,3,96);
circStErZ = nan(2,3,96);

%(RF,ori,amp,radius,location, ch)
rfMuSc = nan(3,2,6,2,3,96);
rfStErSc= nan(3,2,6,2,3,96);

% (radius,location, ch)
circMuSc = nan(2,3,96);
circStErSc = nan(2,3,96);
%%
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/%s/tuningCurves/byCh/',dataT.animal,dataT.array,dataT.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/%s/tuningCurves/byCh/',dataT.animal,dataT.array,dataT.eye);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)
%%


for ch = 1:96
    %%
    for loc = 1:3
        for rad = 1:2
            zCh = zScores{ch};
            
            radNdx = (zCh(5,:) == rad);
            locNdx = (zCh(6,:) == locPair(loc,1)) & (zCh(7,:) == locPair(loc,2));
            circNdx = (zCh(1,:) == 32);
            
            rf4Ndx0  = (zCh(1,:) == 4) & (zCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
            rf4Ndx2  = (zCh(1,:) == 4) & (zCh(3,:) == 45);
            rf8Ndx0  = (zCh(1,:) == 8) & (zCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
            rf8Ndx2  = (zCh(1,:) == 8) & (zCh(3,:) == 22.5);
            rf16Ndx0  = (zCh(1,:) == 16) & (zCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
            rf16Ndx2  = (zCh(1,:) == 16) & (zCh(3,:) == 11.25);
            
            rf4rot0  = zCh(8:end,rf4Ndx0  & radNdx & locNdx);
            rf4rot2  = zCh(8:end,rf4Ndx2  & radNdx & locNdx);
            rf8rot0  = zCh(8:end,rf8Ndx0  & radNdx & locNdx);
            rf8rot2  = zCh(8:end,rf8Ndx2  & radNdx & locNdx);
            rf16rot0 = zCh(8:end,rf16Ndx0  & radNdx & locNdx);
            rf16rot2 = zCh(8:end,rf16Ndx2  & radNdx & locNdx);
            
            rfMuZ(1,1,:,rad,loc,ch) = nanmean(rf4rot0);
            rfMuZ(1,2,:,rad,loc,ch) = nanmean(rf4rot2);
            rfMuZ(2,1,:,rad,loc,ch) = nanmean(rf8rot0);
            rfMuZ(2,2,:,rad,loc,ch) = nanmean(rf8rot2);
            rfMuZ(3,1,:,rad,loc,ch) = nanmean(rf16rot0);
            rfMuZ(3,2,:,rad,loc,ch) = nanmean(rf16rot2);
            
            rfStErZ(1,1,:,rad,loc,ch) = std(rf4rot0)/sqrt(length(rf4rot0));
            rfStErZ(1,2,:,rad,loc,ch) = std(rf4rot0)/sqrt(length(rf4rot2));
            rfStErZ(2,1,:,rad,loc,ch) = std(rf8rot0)/sqrt(length(rf8rot0));
            rfStErZ(2,2,:,rad,loc,ch) = std(rf8rot0)/sqrt(length(rf8rot2));
            rfStErZ(3,1,:,rad,loc,ch) = std(rf16rot0)/sqrt(length(rf16rot0));
            rfStErZ(3,2,:,rad,loc,ch) = std(rf16rot0)/sqrt(length(rf16rot2));
            
            circZs = zCh(8:end,circNdx & radNdx & locNdx);
            circMuZ(rad,loc,ch) = nanmean(circZs);
            circStErZ(rad,loc,ch) = std(circZs)/sqrt(length(circZs));
            %% spike counts
            spikeCh =  sCount{ch};
            
            rf4Ndx0Sc  = (spikeCh(1,:) == 4) & (spikeCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
            rf4Ndx2Sc  = (spikeCh(1,:) == 4) & (spikeCh(3,:) == 45);
            rf8Ndx0Sc  = (spikeCh(1,:) == 8) & (spikeCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
            rf8Ndx2Sc  = (spikeCh(1,:) == 8) & (spikeCh(3,:) == 22.5);
            rf16Ndx0Sc  = (spikeCh(1,:) == 16) & (spikeCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
            rf16Ndx2Sc  = (spikeCh(1,:) == 16) & (spikeCh(3,:) == 11.25);
            
            rf4rot0Sc = spikeCh(8:end,rf4Ndx0Sc  & radNdx & locNdx);
            rf4rot2Sc = spikeCh(8:end,rf4Ndx2Sc  & radNdx & locNdx);
            rf8rot0Sc = spikeCh(8:end,rf8Ndx0Sc  & radNdx & locNdx);
            rf8rot2Sc = spikeCh(8:end,rf8Ndx2Sc  & radNdx & locNdx);
            rf16rot0Sc = spikeCh(8:end,rf16Ndx0Sc  & radNdx & locNdx);
            rf16rot2Sc = spikeCh(8:end,rf16Ndx2Sc  & radNdx & locNdx);
            
            rfMuSc(1,1,:,rad,loc,ch) = nanmean(rf4rot0Sc);
            rfMuSc(1,2,:,rad,loc,ch) = nanmean(rf4rot2Sc);
            rfMuSc(2,1,:,rad,loc,ch) = nanmean(rf8rot0Sc);
            rfMuSc(2,2,:,rad,loc,ch) = nanmean(rf8rot2Sc);
            rfMuSc(3,1,:,rad,loc,ch) = nanmean(rf16rot0Sc);
            rfMuSc(3,2,:,rad,loc,ch) = nanmean(rf16rot2Sc);
            
            rfStErSc(1,1,:,rad,loc,ch) = std(rf4rot0Sc)/sqrt(length(rf4rot0Sc));
            rfStErSc(1,2,:,rad,loc,ch) = std(rf4rot0Sc)/sqrt(length(rf4rot2Sc));
            rfStErSc(2,1,:,rad,loc,ch) = std(rf8rot0Sc)/sqrt(length(rf8rot0Sc));
            rfStErSc(2,2,:,rad,loc,ch) = std(rf8rot0Sc)/sqrt(length(rf8rot2Sc));
            rfStErSc(3,1,:,rad,loc,ch) = std(rf16rot0Sc)/sqrt(length(rf16rot0Sc));
            rfStErSc(3,2,:,rad,loc,ch) = std(rf16rot0Sc)/sqrt(length(rf16rot2Sc));
            
            circSCs = spikeCh(8:end,circNdx  & radNdx & locNdx);
            circMuSc(rad,loc,ch) = nanmean(circSCs);
            circStErSc(rad,loc,ch) = std(circSCs)/sqrt(length(circSCs));
            %% verify spike count and zscore parameters are identical
            rf4ParamsZ  = zCh(1:7,rf4Ndx0  & radNdx & locNdx);
            rf8ParamsZ  = zCh(1:7,rf8Ndx0  & radNdx & locNdx);
            rf16ParamsZ = zCh(1:7,rf16Ndx0  & radNdx & locNdx);
            
            rf4ParamsSc  = spikeCh(1:7,rf4Ndx0  & radNdx & locNdx);
            rf8ParamsSc  = spikeCh(1:7,rf8Ndx0  & radNdx & locNdx);
            rf16ParamsSc = spikeCh(1:7,rf16Ndx0  & radNdx & locNdx);
            
            if size(rf4ParamsZ) ~= size(rf4ParamsSc)
                error('z score and spike count matrices are different sizes')
            end
            
            rf4ParamDiff = rf4ParamsZ - rf4ParamsSc;
            rf8ParamDiff = rf8ParamsZ - rf8ParamsSc;
            rf16ParamDiff = rf16ParamsZ - rf16ParamsSc;
            
            if sum(rf4ParamDiff) > 0
                error('There is a difference in RF 4 parameters between Zscores and spike counts')
            end
            
            if sum(rf8ParamDiff) > 0
                error('There is a difference in RF 8 parameters between Zscores and spike counts')
            end
            
            if sum(rf16ParamDiff) > 0
                error('There is a difference in RF 16 parameters between Zscores and spike counts')
            end
            
        end
    end
end



