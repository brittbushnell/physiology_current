figure(12)
clf
s = suptitle(sprintf('%s %s rotation permutation test ch %d',LEdata.eye,LEdata.array,ch));
s.Position(2) = s.Position(2) + 0.024;

subplot(3,2,1)
hold on
corr = squeeze(LEcorrPerm(1,ch,:));
corr = reshape(corr,[1, numel(corr)]);
title('FE')
histogram(corr,'Normalization','probability','FaceColor','b','BinWidth',0.1)
muCorr = nanmean(corr);
plot([muCorr muCorr],[0 0.4],':k')
text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
xlim([-1 1])
ylim([0 0.6])
set(gca,'tickdir','out')
ylabel('RF4')
clear corr

subplot(3,2,2)
hold on
corr = squeeze(REcorrPerm(1,ch,:));
corr = reshape(corr,[1, numel(corr)]);
title('AE')
histogram(corr,'Normalization','probability','FaceColor','r','BinWidth',0.1)
muCorr = nanmean(corr);
plot([muCorr muCorr],[0 0.4],':k')
text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
xlim([-1 1])
ylim([0 0.6])
set(gca,'tickdir','out')
clear corr

subplot(3,2,3)
hold on
corr = squeeze(LEcorrPerm(2,1,:));
corr = reshape(corr,[1, numel(corr)]);

histogram(corr,'Normalization','probability','FaceColor','b','BinWidth',0.1)
muCorr = nanmean(corr);
plot([muCorr muCorr],[0 0.4],':k')
text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
xlim([-1 1])
ylim([0 0.6])
set(gca,'tickdir','out')
ylabel('RF8')
clear corr

subplot(3,2,4)
hold on
corr = squeeze(REcorrPerm(2,1,:));
corr = reshape(corr,[1, numel(corr)]);

histogram(corr,'Normalization','probability','FaceColor','r','BinWidth',0.1)
muCorr = nanmean(corr);
plot([muCorr muCorr],[0 0.4],':k')
text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
xlim([-1 1])
ylim([0 0.6])
set(gca,'tickdir','out')
clear corr

subplot(3,2,5)
hold on
corr = squeeze(LEcorrPerm(3,1,:));
corr = reshape(corr,[1, numel(corr)]);

histogram(corr,'Normalization','probability','FaceColor','b','BinWidth',0.1)
muCorr = nanmean(corr);
plot([muCorr muCorr],[0 0.4],':k')
text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
xlim([-1 1])
ylim([0 0.6])
set(gca,'tickdir','out')
xlabel('permuted correlation')
ylabel('RF16')
clear corr

subplot(3,2,6)
hold on
corr = squeeze(REcorrPerm(3,1,:));
corr = reshape(corr,[1, numel(corr)]);

histogram(corr,'Normalization','probability','FaceColor','r','BinWidth',0.1)
muCorr = nanmean(corr);
plot([muCorr muCorr],[0 0.4],':k')
text(muCorr+0.1,0.42,sprintf('\\mu %.2f',muCorr))
xlim([-1 1])
ylim([0 0.6])
set(gca,'tickdir','out')
clear corr
xlabel('permuted correlation')