clear
close all
clc
%%
% TODO: 
%  - Add column to each matrix to indicate original channel numbers to make it easier to reference back at the end
%  - make final d' matrix real d' not absolute values
%%
V1 = 'WU_LE_GlassTR_nsp1_Aug2019_all_thresh35_DxComp_goodRuns_stimPerm_OSI';
V4 = 'WU_LE_GlassTR_nsp2_Aug2019_all_thresh35_DxComp_goodRuns_stimPerm_OSI';

%% 
load(V1)
V1data = data.LE;
clear data

load(V4)
V4data = data.LE;
clear data
%% get receptive field info
V1data = callReceptiveFieldParameters(V1data);
V4data = callReceptiveFieldParameters(V4data);

[V1data.rfQuadrant, V1data.inStim, V1data.inStimCenter] = getRFsRelGlass_ecc(V1data);
[V4data.rfQuadrant, V4data.inStim, V4data.inStimCenter] = getRFsRelGlass_ecc(V4data);


V1data = GlassTR_bestSumDOris(V1data);
V4data = GlassTR_bestSumDOris(V4data);

close all
%% get d' for all included channels at 100% coherence
chs = 1:96;

V1t = abs(squeeze(V1data.linNoiseDprime(:,end,:,:,:)));
V4t = abs(squeeze(V4data.linNoiseDprime(:,end,:,:,:)));
%%
V1useCh = (V1data.inStim == 1) & (V1data.goodCh == 1);
V4useCh = (V4data.inStim == 1) & (V4data.goodCh == 1);

DpsV1t  = abs(squeeze(V1data.linNoiseDprime(:,end,:,:,V1useCh)));
DpsV4t  = abs(squeeze(V4data.linNoiseDprime(:,end,:,:,V4useCh)));
%% get OSIs and preferred orientations for included channels 
OSIv1t = squeeze(V1data.OSI(end,:,:,V1useCh));
OSIv4t = squeeze(V4data.OSI(end,:,:,V4useCh));

%% find best density
v1dpT = squeeze(mean(DpsV1t,1)); % get the mean orientation
v1dpT = squeeze(mean(v1dpT,2)); % get the mean dx
[~,ndxV1] = max(v1dpT); % find the density with the max d'


v4dpT = squeeze(mean(DpsV4t,1)); % get the mean orientation
v4dpT = squeeze(mean(v4dpT,2)); % get the mean dx
[~,ndxV4] = max(v4dpT); % find the density with the max d'
%% limit OSI and d' to best density
for ch = 1:length(ndxV1)
    if ndxV1(ch) == 1
        DpsV1(:,:,ch) = squeeze(DpsV1t(:,1,:,ch));
        OSIv1(:,:,ch) = squeeze(OSIv1t(1,:,ch));
    elseif ndxV1(ch) == 2
        DpsV1(:,:,ch) = squeeze(DpsV1t(:,2,:,ch));
        OSIv1(:,:,ch) = squeeze(OSIv1t(2,:,ch));
    else
        DpsV1(:,:,ch) = squeeze(DpsV1t(:,3,:,ch));
        OSIv1(:,:,ch) = squeeze(OSIv1t(3,:,ch));
    end
end

for ch = 1:length(ndxV4)
    if ndxV4(ch) == 1
        DpsV4(:,:,ch) = squeeze(DpsV4t(:,1,:,ch));
        OSIv4(:,:,ch) = squeeze(OSIv4t(1,:,ch));
    elseif ndxV4(ch) == 2
        DpsV4(:,:,ch) = squeeze(DpsV4t(:,2,:,ch));
        OSIv4(:,:,ch) = squeeze(OSIv4t(2,:,ch));
    else
        DpsV4(:,:,ch) = squeeze(DpsV4t(:,3,:,ch));
        OSIv4(:,:,ch) = squeeze(OSIv4t(3,:,ch));
    end
end
%%
figure(1)
clf
subplot(2,2,1)
hold on
v1vect = reshape(DpsV1,[1,numel(DpsV1)]);
histogram(v1vect,'Normalization','probability','BinWidth',0.025)
plot([0.5 0.5],[0 0.25],':k')
ylim([0 0.3])
xlim([0 1.75])
set(gca,'tickdir','out','box','off')

t = title('d'' distributions','FontSize',14);
% t.Position(1) = t.Position(1) + 1.25;
t.Position(2) = t.Position(2) +0.02;

bigDpv1 = find(DpsV1>0.5);
nBig = numel(bigDpv1);
text(0.45,0.25,sprintf('%d channels with d'' > 0.5',nBig))

text(-0.625,0.15,'V1/V2','FontSize',12,'FontWeight','bold')

subplot(2,2,3)
hold on
plot([0.5 0.5],[0 0.25],':k') 
v4vect = reshape(DpsV4,[1,numel(DpsV4)]);
histogram(v4vect,'Normalization','probability','BinWidth',0.025)
ylim([0 0.3])
xlim([0 1.75])
set(gca,'tickdir','out','box','off')



bigDpv4 = find(DpsV4>0.5);
nBig = numel(bigDpv4);
text(0.45,0.25,sprintf('%d channels with d'' > 0.5',nBig))

text(-0.5,0.15,'V4','FontSize',12,'FontWeight','bold')

subplot(2,2,2)
hold on
v1vect = reshape(OSIv1,[1,numel(OSIv1)]);
histogram(v1vect,'Normalization','probability','BinWidth',0.025)
plot([0.7 0.7],[0 0.25],':k')
ylim([0 0.3])
xlim([0 1])
set(gca,'tickdir','out','box','off')
t = title('OSI distributions','FontSize',14);
% t.Position(1) = t.Position(1) + 1.25;
t.Position(2) = t.Position(2) +0.02;

bigOSIv1 = find(OSIv1>0.7);
nBig = numel(bigOSIv1);
text(0.65,0.25,sprintf('%d channels with OSI > 0.7',nBig))


subplot(2,2,4)
hold on
plot([0.7 0.7],[0 0.25],':k') 
v4vect = reshape(OSIv4,[1,numel(OSIv4)]);
histogram(v4vect,'Normalization','probability','BinWidth',0.025)
ylim([0 0.3])
xlim([0 1])
set(gca,'tickdir','out','box','off')

bigOSIv4 = find(OSIv4>0.7);
nBig = numel(bigOSIv4);
text(0.65,0.25,sprintf('%d channels with OSI > 0.7',nBig))

%% find channels that are highly selective by both metrics
bigOSIchV1 = [];
bigOSIchV4 = [];
bigDpchV1 = [];
bigDpchV4 = [];

for ch = 1:length(bigOSIv1)
    [~,~,bigOSIchV1(ch)] = ind2sub(size(OSIv1),bigOSIv1(ch));
end

for ch = 1:length(bigOSIv4)
    [~,~,bigOSIchV4(ch)] = ind2sub(size(OSIv4),bigOSIv4(ch));
end

for ch = 1:length(bigDpv1)
    [~,~,bigDpchV1(ch)] = ind2sub(size(DpsV1),bigDpv1(ch));
end

for ch = 1:length(bigDpv4)
    [~,~,bigDpchV4(ch)] = ind2sub(size(DpsV4),bigDpv4(ch));
end

v1Selective = intersect(bigOSIchV1, bigDpchV1)
v4Selective = intersect(bigOSIchV4, bigDpchV4)
%% create matrices for what will be plotted

v1dx1 = DpsV1(:,1,v1Selective);    v4dx1 = DpsV4(:,1,v4Selective);
v1dx2 = DpsV1(:,2,v1Selective);    v4dx2 = DpsV4(:,2,v4Selective);
v1dx3 = DpsV1(:,3,v1Selective);    v4dx3 = DpsV4(:,3,v4Selective);

v1OSI1 = OSIv1(:,1,v1Selective);    v4OSI1 = squeeze(OSIv4(:,1,v4Selective));
v1OSI2 = OSIv1(:,2,v1Selective);    v4OSI2 = squeeze(OSIv4(:,2,v4Selective));
v1OSI3 = OSIv1(:,3,v1Selective);    v4OSI3 = squeeze(OSIv4(:,3,v4Selective));
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/dxTuning/',V1data.animal);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/dxTuning/',V1data.animal);
end
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
oris = 0:45:315;
oris(end+1) = 0;
oris = deg2rad(oris);
dxs = unique(V1data.dxDeg);

maxLim = 0.7;

figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 500 1000])

s = suptitle('WU V1/V2 dx tuning in highly selective channels');
s.Position(2) = s.Position(2)+0.025;
s.FontSize = 14;
s.FontWeight = 'bold';

axis off

d = subplot(3,1,1,polaraxes);
hold on
lin = squeeze(v1dx1(:,1,1));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('ch %d',v1Selective(1)),'FontSize',12)
% d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;

text(3.14,1.25,sprintf('\\Deltax %.2f%c',dxs(2),char(176)),'FontSize',11,'FontWeight','bold')
text(0,1,sprintf('OSI %.2f',v1OSI1),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,1,2,polaraxes);
hold on
lin = squeeze(v1dx2(:,1,1));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
% d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(3.14,1.25,sprintf('\\Deltax %.2f%c',dxs(3),char(176)),'FontSize',11,'FontWeight','bold')
text(0,1,sprintf('OSI %.2f',v1OSI2),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,1,3,polaraxes);
hold on
lin = squeeze(v1dx3(:,1,1));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
% d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(3.14,1.25,sprintf('\\Deltax %.2f%c',dxs(4),char(176)),'FontSize',11,'FontWeight','bold')
text(0,1,sprintf('OSI %.2f',v1OSI3),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

figName = ['WU_V1V2_dxTuning','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 600 1000])
maxLim = 2;

s = suptitle('WU V4 dx tuning in highly selective channels');
s.Position(2) = s.Position(2)+0.03;
s.FontSize = 14;
s.FontWeight = 'bold';

axis off

d = subplot(3,2,1,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,1));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('Ch %d',v4Selective(1)); sprintf('OSI %.2f',v4OSI1(1))})
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;

text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(2),char(176)),'FontSize',11,'FontWeight','bold')
ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,3,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,1));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(1)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(3),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,5,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,1));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(1)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(4),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,2,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,2));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('Ch %d',v4Selective(1)); sprintf('OSI %.2f',v4OSI1(2))})
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,4,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,2));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(2)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,6,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,2));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(2)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

figName = ['WU_V4_dxTuning_gp1','.pdf'];

print(gcf, figName,'-dpdf','-fillpage')
%%
figure
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 600 1000])


s = suptitle('WU V4 dx tuning in highly selective channels');
s.Position(2) = s.Position(2)+0.025;
s.FontSize = 14;
s.FontWeight = 'bold';

axis off

d = subplot(3,2,1,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,3));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('ch %d',v4Selective(3)); sprintf('OSI %.2f',v4OSI1(3))})
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;

text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(2),char(176)),'FontSize',11,'FontWeight','bold')
ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,3,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,3));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(3)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(3),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,5,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,3));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(3)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(4),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,2,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,4));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('ch %d',v4Selective(4)); sprintf('OSI %.2f',v4OSI1(4))})
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,4,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,4));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(4)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,6,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,4));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(4)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

figName = ['WU_V4_dxTuning_gp2','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 600 1000])


s = suptitle('WU V4 dx tuning in highly selective channels');
s.Position(2) = s.Position(2)+0.025;
s.FontSize = 14;
s.FontWeight = 'bold';

axis off

d = subplot(3,2,1,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,5));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('ch %d',v4Selective(5));sprintf('OSI %.2f',v4OSI1(5))});
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;

text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(2),char(176)),'FontSize',11,'FontWeight','bold')
ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,3,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,5));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(5)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(3),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,5,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,5));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(5)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(4),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,2,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,6));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('ch %d',v4Selective(6));sprintf('OSI %.2f',v4OSI1(6))})
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,4,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,6));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(6)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,6,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,6));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(6)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

figName = ['WU_V4_dxTuning_gp3','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 600 1000])


s = suptitle('WU V4 dx tuning in highly selective channels');
s.Position(2) = s.Position(2)+0.025;
s.FontSize = 14;
s.FontWeight = 'bold';

axis off

d = subplot(3,2,1,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,7));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('ch %d',v4Selective(7)); sprintf('OSI %.2f',v4OSI1(7))})
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;

text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(2),char(176)),'FontSize',11,'FontWeight','bold')
ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,3,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,7));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(7)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(3),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,5,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,7));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(7)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(4),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,2,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,8));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('ch %d',v4Selective(8));sprintf('OSI %.2f',v4OSI1(8))});
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,4,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,8));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(8)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,6,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,8));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(8)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

figName = ['WU_V4_dxTuning_gp4','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%

figure
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 600 1000])


s = suptitle('WU V4 dx tuning in highly selective channels');
s.Position(2) = s.Position(2)+0.025;
s.FontSize = 14;
s.FontWeight = 'bold';

axis off

d = subplot(3,2,1,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,9));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('ch %d',v4Selective(9));sprintf('OSI %.2f',v4OSI1(9))});
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;

text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(2),char(176)),'FontSize',11,'FontWeight','bold')
ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,3,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,9));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(9)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(3),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,5,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,9));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(9)))
d.Position(1) = d.Position(1) - 0.035;
d.Position(2) = d.Position(2) - 0.015;
text(0,2.725,sprintf('\\Deltax %.2f%c',dxs(4),char(176)),'FontSize',11,'FontWeight','bold')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,2,polaraxes);
hold on
lin = squeeze(v4dx1(:,1,10));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title({sprintf('ch %d',v4Selective(10)); sprintf('OSI %.2f',v4OSI2(10))});
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,4,polaraxes);
hold on
lin = squeeze(v4dx2(:,1,10));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI2(10)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

d = subplot(3,2,6,polaraxes);
hold on
lin = squeeze(v4dx3(:,1,10));
lin = repmat(lin,2,1);
lin(end+1) = lin(1);

l = polarplot(oris',lin,'-o');
l.LineWidth = 1.2;
clear lin;
title(sprintf('OSI %.2f',v4OSI3(10)))
d.Position(1) = d.Position(1) + 0.035;
d.Position(2) = d.Position(2) - 0.015;

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];

figName = ['WU_V4_dxTuning_gp5','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%