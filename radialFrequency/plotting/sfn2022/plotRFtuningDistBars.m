function plotRFtuningDistBars
%{
    Untuned  circles  high amplitude
XT
WU
WV

%}

%%
% LEV1 = [17 22 61; 20 17 63; 15 29 56];
% REV1 = [71 10 18; 53 7 40; 68 10 22];
% 
% LEV4 = [19 22 59; 14 11 75; 12 20 68];
% REV4 = [42 14 43; 42 17 41; 60 11 29];


%% 
wuV1le = [20 17 63 7];
wuV1re = [53 7 40 3];

wuV4le = [14 11 75 5];
wuV4re = [42 17 41 9];

wvV1le = [15 29 56 15];
wvV1re = [68 10 22 3];

wvV4le = [12 20 68 5];
wvV4re = [60 11 29 5];

xtV1le = [17 22 61 11];
xtV1re = [71 10 18 1];

xtV4le = [19 22 59 11];
xtV4re = [42 14 43 9];

V1le = [xtV1le; wuV1le; wvV1le];
V1re = [xtV1re; wuV1re; wvV1re];

V4le = [xtV4le; wuV4le; wvV4le];
V4re = [xtV4re; wuV4re; wvV4re];
%%
ht = 0.25;
btm = 0.2;

figure(4)
clf
hold on
suptitle('% of channels with each tuning type')

s = subplot(2,2,1);
s.Position(4)= ht;
hold on
title('LE/FE')
% b = bar(LEV1');

bar(V1le')%,'
text(-0.5,35, 'V1/V2','FontSize',18,'FontWeight','bold','Rotation',90)
ylim([0 80])
xlim([0.5 4.5])
set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
    'XTick',1:4,'XTickLabel',{'','',''},'YTick',0:20:80,'box','off')


s = subplot(2,2,2);
s.Position(4)= ht;
hold on
title('RE/AE')
% bar(REV1')
bar(V1le')
ylim([0 80])
xlim([0.5 4.5])
set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
    'XTick',1:4,'XTickLabel',{'','',''},'YTick',0:20:80,'box','off')
l = legend('XT','WU','WV');
l.Box = 'off';

s = subplot(2,2,3);
s.Position(4)= ht;
s.Position(2) = btm;
hold on
% bar(LEV4')
bar(V4le')
text(-0.5,40, 'V4','FontSize',20,'FontWeight','bold','Rotation',90)
ylim([0 80])
xlim([0.5 4.5])
set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
    'XTick',1:4,'XTickLabel',{'untuned','circles','high RF','mixed'},'XTickLabelRotation',45,...
    'YTick',0:20:80,'box','off')
xlabel('tuning type')

s = subplot(2,2,4);
s.Position(4)= ht;
s.Position(2) = btm;
% bar(REV4')
bar(V4re')
ylim([0 80])
xlim([0.5 4.5])
set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
    'XTick',1:4,'XTickLabel',{'untuned','circles','high RF','mixed'},'XTickLabelRotation',45,...
    'YTick',0:20:80,'box','off')


%% save
figDir = '~/Dropbox/posters/SfN/2022/figures/Radial/tuning';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['distRFtuneTypes','.pdf'];
set(gcf,'PaperOrientation','landscape','InvertHardcopy','off','PaperSize',[6 5],'Color','w')
print(figure(4), figName,'-dpdf','-bestfit')