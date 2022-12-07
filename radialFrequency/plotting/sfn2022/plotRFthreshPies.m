% function plotRFthreshPies(amblyRFdata,ctrlRFdata)
cmap = [0 0 1; 0 0.6 0.2];% 0.7 0 0.7];


figure(5)
clf
hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 350])
%
aeSig = squeeze(amblyRFdata.sigRFcomps(:,1,1));
feSig = squeeze(amblyRFdata.sigRFcomps(:,1,2));
aeComp = (amblyRFdata.rf4v8pref(aeSig== 1,1));
feComp = (amblyRFdata.rf4v8pref(feSig== 1,2));
amb4over8AE = (sum(aeComp == 4)/length(aeComp))*100;
amb8over4AE = (sum(aeComp == 8)/length(aeComp))*100;

amb4over8FE = (sum(feComp == 4)/length(feComp))*100;
amb8over4FE = (sum(feComp == 8)/length(feComp))*100;


s = subplot(2,6,1);
s.Position(1) = 0.03;
hold on
text(-0.2,1.75,'RF4 vs RF8','FontWeight','bold','FontSize',24)
title(sprintf('FE n %d',length(feComp)))
colormap(cmap)
pie([amb4over8FE,amb8over4FE])
axis off
axis square


s = subplot(2,6,2);
s.Position(1) = 0.14;
hold on
title(sprintf('AE n %d',length(aeComp)))
colormap(cmap)
pie([amb4over8AE,amb8over4AE])
axis off
axis square

clear aeComp feComp aeSig feSig


aeSig = squeeze(amblyRFdata.sigRFcomps(:,2,1));
feSig = squeeze(amblyRFdata.sigRFcomps(:,2,2));
aeComp = (amblyRFdata.rf4v16pref(aeSig== 1,1));
feComp = (amblyRFdata.rf4v16pref(feSig== 1,2));
amb4over16AE = (sum(aeComp == 4)/length(aeComp))*100;
amb16over4AE = (sum(aeComp == 16)/length(aeComp))*100;

amb4over16FE = (sum(feComp == 4)/length(feComp))*100;
amb16over4FE = (sum(feComp == 16)/length(feComp))*100;

s = subplot(2,6,3);
s.Position(1) = 0.375;
hold on
colormap(cmap)
text(0.,1.75,'RF4 vs RF16','FontWeight','bold','FontSize',24)
title(sprintf('FE n %d',length(feComp)))
colormap(cmap)
pie([amb4over16FE,amb16over4FE])
axis off
axis square

s = subplot(2,6,4);
s.Position(1) = 0.5;
hold on
colormap(cmap)
title(sprintf('AE n %d',length(aeComp)))
pie([amb4over16AE,amb16over4AE])
axis off
axis square

clear aeComp feComp aeSig feSig


aeSig = squeeze(amblyRFdata.sigRFcomps(:,3,1));
feSig = squeeze(amblyRFdata.sigRFcomps(:,3,2));
aeComp = (amblyRFdata.rf8v16pref(aeSig== 1,1));
feComp = (amblyRFdata.rf8v16pref(feSig== 1,2));
amb8over16AE = (sum(aeComp == 8)/length(aeComp))*100;
amb16over8AE = (sum(aeComp == 16)/length(aeComp))*100;

amb8over16FE = (sum(feComp == 8)/length(feComp))*100;
amb16over8FE = (sum(feComp == 16)/length(feComp))*100;


s = subplot(2,6,6);
s.Position(1) = 0.875;
hold on
colormap(cmap)
title(sprintf('AE n %d',length(aeComp)))
pie([amb8over16AE,amb16over8AE])
axis off
axis square

s = subplot(2,6,5);
s.Position(1) = 0.73;
hold on
text(0.,1.75,'RF8 vs RF16','FontWeight','bold','FontSize',24)
title(sprintf('FE n %d',length(feComp)))
colormap(cmap)
pie([amb8over16FE,amb16over8FE])
axis off
axis square



%%
leSig = squeeze(ctrlRFdata.sigRFcomps(:,1,1));
reSig = squeeze(ctrlRFdata.sigRFcomps(:,1,2));
reComp = (ctrlRFdata.rf4v8pref(leSig== 1,1));
leComp = (ctrlRFdata.rf4v8pref(reSig== 1,2));
amb4over8RE = (sum(reComp == 4)/length(reComp))*100;
amb8over4RE = (sum(reComp == 8)/length(reComp))*100;

amb4over8LE = (sum(leComp == 4)/length(leComp))*100;
amb8over4LE = (sum(leComp == 8)/length(leComp))*100;


s = subplot(2,6,7);
s.Position(1) = 0.03;
hold on
text(-0.2,1.75,'RF4 vs RF8','FontWeight','bold','FontSize',24)
title(sprintf('LE n %d',length(leComp)))
colormap(cmap)
pie([amb4over8LE,amb8over4LE])
axis off
axis square


s = subplot(2,6,8);
s.Position(1) = 0.14;
hold on
title(sprintf('RE n %d',length(reComp)))
colormap(cmap)
pie([amb4over8RE,amb8over4RE])
axis off
axis square

clear reComp leComp leSig reSig


leSig = squeeze(ctrlRFdata.sigRFcomps(:,2,1));
reSig = squeeze(ctrlRFdata.sigRFcomps(:,2,2));
reComp = (ctrlRFdata.rf4v16pref(leSig== 1,1));
leComp = (ctrlRFdata.rf4v16pref(reSig== 1,2));
amb4over16RE = (sum(reComp == 4)/length(reComp))*100;
amb16over4RE = (sum(reComp == 16)/length(reComp))*100;

amb4over16LE = (sum(leComp == 4)/length(leComp))*100;
amb16over4LE = (sum(leComp == 16)/length(leComp))*100;

s = subplot(2,6,9);
s.Position(1) = 0.375;
hold on
colormap(cmap)
text(0.,1.75,'RF4 vs RF16','FontWeight','bold','FontSize',24)
title(sprintf('LE n %d',length(leComp)))
colormap(cmap)
pie([amb4over16LE,amb16over4LE])
axis off
axis square

s = subplot(2,6,10);
s.Position(1) = 0.5;
hold on
colormap(cmap)
title(sprintf('RE n %d',length(reComp)))
pie([amb4over16RE,amb16over4RE])
axis off
axis square

clear reComp leComp leSig reSig


leSig = squeeze(ctrlRFdata.sigRFcomps(:,3,1));
reSig = squeeze(ctrlRFdata.sigRFcomps(:,3,2));
reComp = (ctrlRFdata.rf8v16pref(leSig== 1,1));
leComp = (ctrlRFdata.rf8v16pref(reSig== 1,2));
amb8over16RE = (sum(reComp == 8)/length(reComp))*100;
amb16over8RE = (sum(reComp == 16)/length(reComp))*100;

amb8over16LE = (sum(leComp == 8)/length(leComp))*100;
amb16over8LE = (sum(leComp == 16)/length(leComp))*100;


s = subplot(2,6,12);
s.Position(1) = 0.875;
hold on
colormap(cmap)
title(sprintf('RE n %d',length(reComp)))
% pie([amb8over16RE,amb16over8RE])
axis off
axis square

s = subplot(2,6,11);
s.Position(1) = 0.73;
hold on
text(0.,1.75,'RF8 vs RF16','FontWeight','bold','FontSize',24)
title(sprintf('LE n %d',length(leComp)))
colormap(cmap)
pie([amb8over16LE,amb16over8LE])
axis off
axis square