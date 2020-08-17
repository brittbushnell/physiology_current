%%
load('WU_RE_Glass_nsp1_20170817_002_cleaned3_manu_perm2k');
manu3 = data.RE;

load('WU_RE_Glass_nsp1_20170817_002_cleaned_manu_perm2k');
manu4 = data.RE;

load('WU_RE_Glass_nsp1_20170817_002_raw_perm2k');
raw = data.RE;
    
%%
[~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(raw);
ch = 70;

figure(1)
clf

subplot(2,3,2)
hold on
cohNdx = (raw.coh == 1);
concNdx = (raw.type == 1);
radNdx = (raw.type == 2);
blankNdx = (raw.numDots == 0);
dotNdx = (raw.numDots == dots(2));
dxNdx = (raw.dx == dxs(2));
noiseNdx = (raw.coh == 0);


blankResp = nanmean(smoothdata(raw.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
glassResp = nanmean(smoothdata(raw.bins((cohNdx & concNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
radResp = nanmean(smoothdata(raw.bins((cohNdx & radNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
noiseResp = nanmean(smoothdata(raw.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;

c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',1);
b = plot(1:35,glassResp,'color',[0.5 0 0.5 0.7],'LineWidth',1);
a = plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',1);
r = plot(1:35,radResp,'color',[0 0.6 0.2 0.7],'LineWidth',1);

yMax = max([a.YData, b.YData, c.YData, r.YData])+2;
ylim([0 250])
title({'ch 70 raw data';'threshold -3.5'})
%%
subplot(2,3,1)
hold on
cohNdx = (manu3.coh == 1);
concNdx = (manu3.type == 1);
radNdx = (manu3.type == 2);
blankNdx = (manu3.numDots == 0);
dotNdx = (manu3.numDots == dots(2));
dxNdx = (manu3.dx == dxs(2));
noiseNdx = (manu3.coh == 0);


blankResp = nanmean(smoothdata(manu3.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
glassResp = nanmean(smoothdata(manu3.bins((cohNdx & concNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
radResp = nanmean(smoothdata(manu3.bins((cohNdx & radNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
noiseResp = nanmean(smoothdata(manu3.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;

c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',1);
b = plot(1:35,glassResp,'color',[0.5 0 0.5 0.7],'LineWidth',1);
a = plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',1);
r = plot(1:35,radResp,'color',[0 0.6 0.2 0.7],'LineWidth',1);

yMax = max([a.YData, b.YData, c.YData, r.YData])+2;
ylim([0 250])
title({'ch 70 cleaned data';'threshold -3'})
%%
subplot(2,3,3)
hold on
cohNdx = (manu4.coh == 1);
concNdx = (manu4.type == 1);
radNdx = (manu4.type == 2);
blankNdx = (manu4.numDots == 0);
dotNdx = (manu4.numDots == dots(2));
dxNdx = (manu4.dx == dxs(2));
noiseNdx = (manu4.coh == 0);


blankResp = nanmean(smoothdata(manu4.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
glassResp = nanmean(smoothdata(manu4.bins((cohNdx & concNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
radResp = nanmean(smoothdata(manu4.bins((cohNdx & radNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
noiseResp = nanmean(smoothdata(manu4.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;

c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',1);
b = plot(1:35,glassResp,'color',[0.5 0 0.5 0.7],'LineWidth',1);
a = plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',1);
r = plot(1:35,radResp,'color',[0 0.6 0.2 0.7],'LineWidth',1);

yMax = max([a.YData, b.YData, c.YData, r.YData])+2;
ylim([0 250])
title({'ch 70 cleaned data';'threshold -4'})
%%
ch = 54;
subplot(2,3,5)
hold on
cohNdx = (raw.coh == 1);
concNdx = (raw.type == 1);
radNdx = (raw.type == 2);
blankNdx = (raw.numDots == 0);
dotNdx = (raw.numDots == dots(2));
dxNdx = (raw.dx == dxs(2));
noiseNdx = (raw.coh == 0);


blankResp = nanmean(smoothdata(raw.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
glassResp = nanmean(smoothdata(raw.bins((cohNdx & concNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
radResp = nanmean(smoothdata(raw.bins((cohNdx & radNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
noiseResp = nanmean(smoothdata(raw.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;

c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',1);
b = plot(1:35,glassResp,'color',[0.5 0 0.5 0.7],'LineWidth',1);
a = plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',1);
r = plot(1:35,radResp,'color',[0 0.6 0.2 0.7],'LineWidth',1);

yMax = max([a.YData, b.YData, c.YData, r.YData])+2;
ylim([0 300])
title({'ch 54 raw data';'threshold -3.5'})
%%
subplot(2,3,4)
hold on
cohNdx = (manu3.coh == 1);
concNdx = (manu3.type == 1);
radNdx = (manu3.type == 2);
blankNdx = (manu3.numDots == 0);
dotNdx = (manu3.numDots == dots(2));
dxNdx = (manu3.dx == dxs(2));
noiseNdx = (manu3.coh == 0);


blankResp = nanmean(smoothdata(manu3.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
glassResp = nanmean(smoothdata(manu3.bins((cohNdx & concNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
radResp = nanmean(smoothdata(manu3.bins((cohNdx & radNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
noiseResp = nanmean(smoothdata(manu3.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;

c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',1);
b = plot(1:35,glassResp,'color',[0.5 0 0.5 0.7],'LineWidth',1);
a = plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',1);
r = plot(1:35,radResp,'color',[0 0.6 0.2 0.7],'LineWidth',1);

yMax = max([a.YData, b.YData, c.YData, r.YData])+2;
ylim([0 300])
title({'ch 54 cleaned data';'threshold -3'})
%%
subplot(2,3,6)
hold on
cohNdx = (manu4.coh == 1);
concNdx = (manu4.type == 1);
radNdx = (manu4.type == 2);
blankNdx = (manu4.numDots == 0);
dotNdx = (manu4.numDots == dots(2));
dxNdx = (manu4.dx == dxs(2));
noiseNdx = (manu4.coh == 0);


blankResp = nanmean(smoothdata(manu4.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
glassResp = nanmean(smoothdata(manu4.bins((cohNdx & concNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
radResp = nanmean(smoothdata(manu4.bins((cohNdx & radNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
noiseResp = nanmean(smoothdata(manu4.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;

c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',1);
b = plot(1:35,glassResp,'color',[0.5 0 0.5 0.7],'LineWidth',1);
a = plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',1);
r = plot(1:35,radResp,'color',[0 0.6 0.2 0.7],'LineWidth',1);

yMax = max([a.YData, b.YData, c.YData, r.YData])+2;
ylim([0 300])
title({'ch 54 cleaned data';'threshold -4'})