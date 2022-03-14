function [circ_train, circ_test, stim_train, stim_test] = subsample_testvstrain_clean(spikes_circ,spikes, fracSplit)
% This function is modified from Christopher's LDA_discrim.m code. I just
% adapted a couple of things:

% You tell it by what factor you want to divide the data (0.5 means take half of the size of the stim set),
% and it subsamples that same amount of trials from the circle set to match the number of trials


% Inputs are specific to this analysis:
% spikes_circ = nChan, 1, nTrials, nPos
% spikes = nChan, nMods, nTrials, nRFS, nPos
% fracSplit = how do you want to split the number of stim trials (in half?
% a quarter? a third?)

clear circ_train circ_test stim_train stim test

%fprintf('Trial matching stim vs circ and splitting datasets into train v test sets.\n\n')

% Get the number of trials in each set
nT_stim = size(spikes,3);
nT_circ = size(spikes_circ,3); 

% Match the number of trials between circ and stim
subCirc_nDx = randsample(nT_circ, nT_stim); % get values for nT_stim trials from the circle set
subSamp_circ = spikes_circ(:,:,subCirc_nDx,:); 

% Divide in test v train
nTest = round(fracSplit*nT_stim); % compute subsample size based on fracSplit
indTest = randsample(nT_stim,nTest); % sample test set values
indTrain = setdiff(1:nT_stim,indTest); % sample training set values
intersect_test = intersect(indTest,indTrain);
if isempty(intersect_test)
   % fprintf('There are no commom trials between train and test sets. Proceeding to split.\n\n')
else
    fprint('Common trials found. Aborting.\n\n')
    return
end

% Test data
circ_test = subSamp_circ(:,:,indTest,:);
stim_test = spikes(:,:,indTest,:,:); % spikes is 5D

% Train data
circ_train = subSamp_circ(:,:,indTrain,:); % spikes_circ is 4D
stim_train = spikes(:,:,indTrain,:,:); % spikes is 5D

%fprintf('Data is now ready for the classifier.\n\n')
end

