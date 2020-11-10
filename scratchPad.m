% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;

%%
con = reshape(dataT.conSpikeCount,1,numel(dataT.conSpikeCount));
rad = reshape(dataT.radSpikeCount,1,numel(dataT.radSpikeCount));
noz = reshape(dataT.noiseSpikeCount,1,numel(dataT.noiseSpikeCount));

conZ = reshape(dataT.conZscore,1,numel(dataT.conZscore));
radZ = reshape(dataT.radZscore,1,numel(dataT.radZscore));
nozZ = reshape(dataT.noiseZscore,1,numel(dataT.noiseZscore));


figure(5)
clf
subplot(3,2,1)
hold on
histogram(noz,'BinWidth',4,'Normalization','probability','FaceColor',[0.6 0.6 0.6],'FaceAlpha',0.25)
histogram(con,'BinWidth',4,'Normalization','probability','FaceColor',[0.6 0 0.6],'FaceAlpha',0.25)

ylim([0, 0.4])
title('noise spike count')

subplot(3,2,3)
hold on
histogram(con,'BinWidth',4,'Normalization','probability','FaceColor',[0.6 0 0.6],'FaceAlpha',0.25)
ylim([0, 0.4])
title('concentric')

subplot(3,2,5)
hold on
histogram(rad,'BinWidth',4,'Normalization','probability','FaceColor',[0.1 0.6 0.3],'FaceAlpha',0.25)
ylim([0, 0.4])
title('radial')

subplot(3,2,2)
hold on
histogram(nozZ,'BinWidth',0.25,'Normalization','probability','FaceColor',[0.6 0.6 0.6],'FaceAlpha',0.25)

histogram(conZ,'BinWidth',0.25,'Normalization','probability','FaceColor',[0.7 0 0.7],'FaceAlpha',0.25)

histogram(radZ,'BinWidth',0.25,'Normalization','probability','FaceColor',[0.1 0.6 0.3],'FaceAlpha',0.25)

title('zscore')
legend('noise','con','rad')
%%
randRep = randi(length(con),[1,200]);
figure(4)
hold on
plot(con(randRep),'o','color',[0.7 0 0.7])
plot(rad(randRep),'o','color',[0.1 0.4 0.3])
plot(noz(randRep),'o','color',[0.7 0.7 0.7])
grid on 