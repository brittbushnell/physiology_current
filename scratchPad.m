% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;
%%
figure(1)
clf

subplot(1,3,1)
hold on
cons = reshape(conBlankDprime,1,numel(conBlankDprime));
histogram(cons,10)

subplot(1,3,2)
hold on
rads = reshape(radBlankDprime,1,numel(radBlankDprime));
histogram(rads,10)

subplot(1,3,3)
hold on
noise = reshape(noiseBlankDprime,1,numel(noiseBlankDprime));
histogram(noise,10)
%%
figure(2)
clf

subplot(1,3,1)
hold on
histogram(conBlankDprimeBoot,10)

subplot(1,3,2)
hold on
histogram(radBlankDprimeBoot,10)

subplot(1,3,3)
hold on
histogram(noiseBlankDprimeBoot,10)
%%
figure(3)
clf

subplot(2,2,1)
hold on
cons = reshape(dataT.conZscore,1,numel(dataT.conZscore));
histogram(cons,'BinWidth',0.5,'Normalization','probability')
xlim([-5 5])

subplot(2,2,2)
hold on
rads = reshape(dataT.radZscore,1,numel(dataT.radZscore));
histogram(rads,'BinWidth',0.5,'Normalization','probability')
xlim([-5 5])

subplot(2,2,3)
hold on
noise =  reshape(dataT.noiseZscore,1,numel(dataT.noiseZscore));
histogram(noise,'BinWidth',0.5,'Normalization','probability')
xlim([-5 5])

subplot(2,2,4)
hold on
blank =  reshape(dataT.blankZscore,1,numel(dataT.blankZscore));
histogram(blank,'BinWidth',0.5,'Normalization','probability')
xlim([-5 5])
