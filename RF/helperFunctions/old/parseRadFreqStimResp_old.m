function [RFStimResps,blankResps] = parseRadFreqStimResp_old(data,startBin,endBin)%,ch)
 % PARSERADFREQSTIMRESP function will return an cell matrix of the
 % responses of each channel to each unique stimulus.
 %
 %     The first column is always the blank stimulus
 %
 % Written April 28,2018 Brittany Bushnell
%% Testing
 % clear all
 % close all
 % clc
 % tic
%%
 % %file = 'WU_RE_RadFreqLoc2_nsp2_20170707_005';
 % file = 'WU_LE_RadFreqLoc2_nsp2_20170707_002';
 % data = load(file);
 %params = sortrows(params,1);
 %% Create grouped and sorted matrices
 [types,~,indexOfTypes] = unique(params,'rows'); % types is a matrix of the stimulus parameters, index of types are the indices that correspond to each type
 
 [groupedNums] = accumarray(indexOfTypes,1,[]); 
 [~,sortedIndices] = sort(indexOfTypes);
 FR2 = data.bins(sortedIndices,:, :);
 
 stimResps = mat2cell(FR2,groupedNums,size(data.bins,2),numChannels);
% build matrix of RF stimulus resposnes

%%
typeTps = types';
blankParams = typeTps(:,end-2:end);
typeTps = typeTps(:,1:end-3);
 

numBlank = size(blankParams,1) + 3.*size(stimResps{end},1) + 4; % adding 4 onto the end for mean, median, ste, and normalized response.
numStim = size(typeTps,2) + size(stimResps{1},1) + 4;

tmp = nan(numStim,length(types));
blankTmp = nan(numBlank,1);

RFStimResps = cell(1,numChannels);
blankResps  = cell(1,numChannels);
 
%%
for ch = 1:numChannels
    
    blankTmp(1:size(blankParams,1),1) = blankParams(:,1);
    a = vertcat(stimResps{end}(:,startBin:endBin,ch),stimResps{end-1}(:,startBin:endBin,ch),stimResps{end-1}(:,startBin:endBin,ch));
    mu_a = mean(a,2)./.01;
    blankTmp(8:8+length(mu_a)-1) = mean(a,2)./.01;
    blankTmp(8+length(a),1) = mean(mu_a);
    blankTmp(8+length(a)+1,1) = median(mu_a);
    blankTmp(8+length(a)+2,1) = std(mu_a)/sqrt(length(mu_a));
    blankResps{ch} = blankTmp;
    %%
    tmp = nan(21,size(typeTps,2));
    for r = 1:length(typeTps) %the first three are the blank stimuli
        tmp(1:size(typeTps,1),:) = typeTps;
        muResp = mean(stimResps{r}(:,startBin:endBin,ch),2)./0.01;
        tmp(8:8+length(muResp)-1,r) = muResp;
        tmp(18,r) = mean(muResp);
        tmp(19,r) = median(muResp);
        tmp(20,r) = std(muResp)/sqrt(length(muResp));
     end
     RFStimResps{ch} = tmp;
 end