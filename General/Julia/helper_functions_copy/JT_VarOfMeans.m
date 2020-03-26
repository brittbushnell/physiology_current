function [JTS, oriTS, sfTS] = JT_VarOfMeans(chanPowMat)
% Modified from Christopher's 'JointTuning_VarOfMeans.m'
% Bootstrap analysis that compares the variance across stimuli and compares
% them to a shuffled distribution
%
% Input:
%   chanPowMat = (nSf x nOri x nRep/stimulus condition) - power for each
%   pass

nOri = size(chanPowMat,2);
nSf = size(chanPowMat,1);
nRep = size(chanPowMat,3);
nBoot = 100;
nTrials = nRep*nOri*nSf;
nTrialsPerSf = nRep*nOri;
nTrialsPerOri = nRep*nSf;

chanPowMean = nanmean(chanPowMat,3);

% Variance across all conditions
v1 = nanvar(chanPowMean(:));
if v1 == 0
    JTS = 0;
else
    v0 = nan(nBoot,1);
    for iB = 1:nBoot
        % Create shuffled distribution
        ind = randsample(nTrials,nTrials);  
        X = nanmean(reshape(chanPowMat(ind), [nSf nOri nRep]),3);
        v0(iB) = nanvar(X(:));
    end
    JTS = 1 - sum(v0>v1)./nBoot;
end

% Variance across orientations for each SF
oriTS = nan(1, nSf);
for iSf = 1:nSf
   v1 = var(chanPowMean(iSf,:)); 
   v0 = nan(nBoot,1);
   for iB = 1:nBoot
       ind = randsample(nTrials,nTrialsPerSf);
       X = nanmean(reshape(chanPowMat(ind),[nRep,nOri]));
       v0(iB) = nanvar(X);
   end
   oriTS(iSf) = 1 - sum(v0>v1)./nBoot;
end

% Variance across spatial frequencies
sfTS = nan(1, nOri);
for iOri = 1:nOri
   v1 = var(chanPowMean(:,iOri)); 
   v0 = nan(nBoot,1);
   for iB = 1:nBoot
       ind = randsample(nTrials,nTrialsPerOri);
       X = nanmean(reshape(chanPowMat(ind),[nRep,nSf]));
       v0(iB) = nanvar(X);
   end
   sfTS(iOri) = 1 - sum(v0>v1)./nBoot;
end