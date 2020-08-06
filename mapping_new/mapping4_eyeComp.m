%mapping4_eyeComp;
clear all
close all
clc
%%
% LE = load('WV_LE_MapNoise_nsp2_Jan2019_all_thresh35_info_resps');
% RE = load('WV_RE_MapNoise_nsp2_Jan2019_all_thresh35_info_resps');

RE = load('WU_RE_GratingsMapRF_nsp2_20170814_all_thresh35_info_resps');


LE = load('WU_LE_GratingsMapRF_nsp2_20170620_001_thresh35_info_resps');

LEdata = LE.data.LE;
REdata = RE.data.RE;
%%
% RFParams:
%   1 x coordinate of center
%   2 y coordinate of center
%   3 x standard deviation
%   4 y standard deviation
%   5 rotation
%   6 gain
%   7 firing rate of offset
REx = nan(1,96);
REy = nan(1,96);
LEx = nan(1,96);
LEy = nan(1,96);
for ch = 1:96
    REx(1,ch) = REdata.chReceptiveFieldParams{ch}(1);
    REy(1,ch) = REdata.chReceptiveFieldParams{ch}(2);
        
    LEx(1,ch) = LEdata.chReceptiveFieldParams{ch}(1);
    LEy(1,ch) = LEdata.chReceptiveFieldParams{ch}(2);
end
%%
xDiff = REx - LEx;
yDiff = REy - LEy;

figure
hold on
plot(xDiff,yDiff,'ok')
plot([0 0], [6, 6],':k')
xlabel('difference between x center')
ylabel('difference between y center')

title(sprintf('%s %s differences in receptive field centers between eyes',REdata.animal, REdata.array))
%%
figure

subplot(2,2,1)
hold on
plot(REx,'ro')
plot(LEx,'bo')
ylabel('x center')
axis square

subplot(2,2,2)
hold on
plot(REy,'ro')
plot(LEy,'bo')
ylabel('y center')
axis square

subplot(2,2,3)
hold on
plot(xDiff,'ok')
plot([0 100],[0 0],':k')
ylabel('RE-LE x center')
xlabel('ch')
axis square

subplot(2,2,4)
hold on
plot(yDiff,'ok')
plot([0 100],[0 0],':k')
ylabel('RE-LE y center')
xlabel('ch')
axis square