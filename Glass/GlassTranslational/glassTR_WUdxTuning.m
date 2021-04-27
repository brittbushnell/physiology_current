clear
close all
clc
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
V1useCh = (V1data.inStim == 1) & (V1data.goodCh == 1);
V4useCh = (V4data.inStim == 1) & (V4data.goodCh == 1);

DpsV1t  = abs(squeeze(V1data.linNoiseDprime(:,end,:,:,V1useCh)));
DpsV4t  = abs(squeeze(V4data.linNoiseDprime(:,end,:,:,V4useCh)));
%% get OSIs for included channels 
OSIv1t = squeeze(V1data.OSI(:,:,:,V1useCh));
OSIv4t = squeeze(V4data.OSI(:,:,:,V4useCh));
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
        OSIv1(:,:,ch) = squeeze(OSIv1t(:,1,:,ch));
    elseif ndxV1(ch) == 2
        DpsV1(:,:,ch) = squeeze(DpsV1t(:,2,:,ch));
        OSIv1(:,:,ch) = squeeze(OSIv1t(:,2,:,ch));
    else
        DpsV1(:,:,ch) = squeeze(DpsV1t(:,3,:,ch));
        OSIv1(:,:,ch) = squeeze(OSIv1t(:,3,:,ch));
    end
end

for ch = 1:length(ndxV4)
    if ndxV4(ch) == 1
        DpsV4(:,:,ch) = squeeze(DpsV4t(:,1,:,ch));
        OSIv4(:,:,ch) = squeeze(OSIv4t(:,1,:,ch));
    elseif ndxV4(ch) == 2
        DpsV4(:,:,ch) = squeeze(DpsV4t(:,2,:,ch));
        OSIv4(:,:,ch) = squeeze(OSIv4t(:,2,:,ch));
    else
        DpsV4(:,:,ch) = squeeze(DpsV4t(:,3,:,ch));
        OSIv4(:,:,ch) = squeeze(OSIv4t(:,3,:,ch));
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
t.Position(1) = t.Position(1) + 1.25;
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

t = title('OSI distributions','FontSize',14);
t.Position(1) = t.Position(1) + 1.25;
t.Position(2) = t.Position(2) +0.02;

bigDpv4 = find(DpsV4>0.5);
nBig = numel(bigDpv4);
text(0.45,0.25,sprintf('%d channels with d'' > 0.5',nBig))

text(-0.5,0.15,'V4','FontSize',12,'FontWeight','bold')

subplot(2,2,2)
hold on
v1vect = reshape(OSIv1,[1,numel(OSIv1)]);
histogram(v1vect,'Normalization','probability','BinWidth',0.025)
plot([0.75 0.75],[0 0.25],':k')
ylim([0 0.3])
xlim([0 1])
set(gca,'tickdir','out','box','off')

bigOSIv1 = find(OSIv1>0.75);
nBig = numel(bigOSIv1);
text(0.65,0.25,sprintf('%d channels with OSI > 0.75',nBig))


subplot(2,2,4)
hold on
plot([0.75 0.75],[0 0.25],':k') 
v4vect = reshape(OSIv4,[1,numel(OSIv4)]);
histogram(v4vect,'Normalization','probability','BinWidth',0.025)
ylim([0 0.3])
xlim([0 1])
set(gca,'tickdir','out','box','off')

bigOSIv4 = find(OSIv4>0.75);
nBig = numel(bigOSIv4);
text(0.65,0.25,sprintf('%d channels with OSI > 0.75',nBig))

%% find channels that are highly selective by both metrics

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

v1Selective = intersect(bigOSIchV1, bigDpchV1);
v4Selective = intersect(bigOSIchV4, bigDpchV4);


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
