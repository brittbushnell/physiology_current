clear all
close all
clc
tic
%%
files = {
    'XT_LE_GlassCoh_nsp2_March2019_all_thresh35_info_goodRuns';
};
%%
nameEnd = '';
numPerm = 2000; 
numBoot = 200;
subsample = 0;
holdout = .90;
plotFlag = 0;
%% 
location = determineComputer;

failedFile= {};
failedME = {};
failNdx = 1;
%%
for fi = 1:size(files,1)
    %% Get basic information about experiments
    % try
    filename = files{fi};
    load(filename);
    fprintf('\n*** analyzing %s \n*** file %d/%d \n', filename,fi,size(files,1))
    
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    
    %% test figure
    figure(3)
clf

subplot(2,2,1)
hold on
cons = reshape(dataT.conZscore,1,numel(dataT.conZscore));
histogram(cons,'BinWidth',0.5,'Normalization','probability')
xlim([-5 5])
title('concentric z scores')

subplot(2,2,2)
hold on
rads = reshape(dataT.radZscore,1,numel(dataT.radZscore));
histogram(rads,'BinWidth',0.5,'Normalization','probability')
xlim([-5 5])
title('radial')

subplot(2,2,3)
hold on
noise =  reshape(dataT.noiseZscore,1,numel(dataT.noiseZscore));
noise(isnan(noise)) = [];
histogram(noise,'BinWidth',0.5,'Normalization','probability')
xlim([-5 5])
title('noise')

subplot(2,2,4)
hold on
blank =  reshape(dataT.blankZscore,1,numel(dataT.blankZscore));
histogram(blank,'BinWidth',0.5,'Normalization','probability')
xlim([-5 5])
title('blank')
    %% get stimulus d'
    
    
    %% get stimVs blank permutations
    
    %% coherence permutations
    
    %% 
    %%
    %     catch ME
    %         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
    %         failNdx = failNdx+1;
    %         failedFiles{failNdx,1} = filename;
    %         failedME{failNdx,1} = ME;
    %     end
end