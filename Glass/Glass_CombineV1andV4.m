clear
close all
clc
%%
% load('WV_BE_V1_bothGlass_cleanMerged');
% V1data = data;
% clear data;
% 
% load('WV_BE_V4_bothGlass_cleanMerged');
% V4data = data;
% clear data;
% newName = 'WV_2eyes_2arrays_GlassPatterns';
%%
% load('WU_BE_V1_bothGlass_cleanMerged');
% V1data = data;
% clear data;
% 
% load('WU_BE_V4_bothGlass_cleanMerged');
% V4data = data;
% clear data;
% newName = 'WU_2eyes_2arrays_GlassPatterns';
%%
load('XT_BE_V1_bothGlass_cleanMerged');
V1data = data;
clear data;

load('XT_BE_V4_bothGlass_cleanMerged');
V4data = data;
clear data;
newName = 'XT_2eyes_2arrays_GlassPatterns';
%% Get preferred pattern for each cell V1
V1chRanksLE = nan(1,96);
prefParams = V1data.trLE.prefParamsIndex; % this says which dot,dx is preferred

for ch = 1:96
    if V1data.trLE.goodCh(ch) == 1
        V1chRanksLE(1,ch) = V1data.conRadLE.dPrimeRankBlank{prefParams(ch)}(1,ch);
    end
end

V1chRanksRE = nan(1,96);
prefParams = V1data.trRE.prefParamsIndex; % this says which dot,dx is preferred

for ch = 1:96
    if V1data.trRE.goodCh(ch) == 1
        V1chRanksRE(1,ch) = V1data.conRadRE.dPrimeRankBlank{prefParams(ch)}(1,ch);
    end
end
%%
V4chRanksLE = nan(1,96);
prefParams = V4data.trLE.prefParamsIndex; % this says which dot,dx is preferred

for ch = 1:96
    if V4data.trLE.goodCh(ch) == 1
        V4chRanksLE(1,ch) = V4data.conRadLE.dPrimeRankBlank{prefParams(ch)}(1,ch);
    end
end

V4chRanksRE = nan(1,96);
prefParams = V4data.trRE.prefParamsIndex; % this says which dot,dx is preferred

for ch = 1:96
    if V4data.trRE.goodCh(ch) == 1
        V4chRanksRE(1,ch) = V4data.conRadRE.dPrimeRankBlank{prefParams(ch)}(1,ch);
    end
end
%%
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/RF/',V1data.trLE.animal,V1data.trLE.programID);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/RF/',V1data.trLE.animal, V1data.trLE.programID);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
if contains(V1data.trLE.animal,'XT')
    figure %(22)
    clf
    
    conLE = V1data.trLE.inStimCenter(V1chRanksLE == 1);
    radLE = V1data.trLE.inStimCenter(V1chRanksLE == 2);
    nosLE = V1data.trLE.inStimCenter(V1chRanksLE == 3);
    
    conRE = V1data.trRE.inStimCenter(V1chRanksRE == 1);
    radRE = V1data.trRE.inStimCenter(V1chRanksRE == 2);
    nosRE = V1data.trRE.inStimCenter(V1chRanksRE == 3);
    
    con = sum(conLE)+sum(conRE);
    rad = sum(radLE)+sum(radRE);
    nos = sum(nosLE)+sum(nosRE);
    
    numCh = sum(V1data.trLE.inStimCenter) + sum(V1data.trRE.inStimCenter);
    
    subplot(1,2,1)
    hold on
    bar(1,con/numCh,'FaceColor',[0.7 0 0.7])
    bar(2,rad/numCh,'FaceColor',[0 0.6 0.2])
    bar(3,nos/numCh,'FaceColor',[1 0.5 0.1])
    title(sprintf('V1 n: %d', numCh))
    ylim([0 0.7])
    set(gca,'tickdir','out','box','off',...
        'XTick',1:3,'XTickLabel',{'Con','Radial','Dipole'},...
        'FontSize',13,'FontWeight','bold','FontAngle','italic')
    
    
    % V4
    conLE = V4data.trLE.inStimCenter(V4chRanksLE == 1);
    radLE = V4data.trLE.inStimCenter(V4chRanksLE == 2);
    nosLE = V4data.trLE.inStimCenter(V4chRanksLE == 3);
    
    conRE = V4data.trRE.inStimCenter(V4chRanksRE == 1);
    radRE = V4data.trRE.inStimCenter(V4chRanksRE == 2);
    nosRE = V4data.trRE.inStimCenter(V4chRanksRE == 3);
    
    con = sum(conLE)+sum(conRE);
    rad = sum(radLE)+sum(radRE);
    nos = sum(nosLE)+sum(nosRE);
    
    numCh = sum(V4data.trLE.inStimCenter) + sum(V4data.trRE.inStimCenter);
    
    subplot(1,2,2)
    hold on
    bar(1,con/numCh,'FaceColor',[0.7 0 0.7])
    bar(2,rad/numCh,'FaceColor',[0 0.6 0.2])
    bar(3,nos/numCh,'FaceColor',[1 0.5 0.1])
    title(sprintf('V4 n: %d', numCh))
    ylim([0 0.7])
    set(gca,'tickdir','out','box','off',...
        'XTick',1:3,'XTickLabel',{'Con','Radial','Dipole'},...
        'FontSize',13,'FontWeight','bold','FontAngle','italic')
    
    
    s = suptitle(sprintf('%s Glass pattern preferences in center of stimuli',V1data.trLE.animal));
    s.FontAngle = 'italic';
    s.FontSize = 18;
    s.FontWeight = 'bold';
    
    figName = [V1data.trRE.animal,'BothArrays_prefPattern_centerStim','.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
else
    figure% (22)
    clf
    
    conLE = V1data.trLE.inStimCenter(V1chRanksLE == 1);
    radLE = V1data.trLE.inStimCenter(V1chRanksLE == 2);
    nosLE = V1data.trLE.inStimCenter(V1chRanksLE == 3);
    
    conRE = V1data.trRE.inStimCenter(V1chRanksRE == 1);
    radRE = V1data.trRE.inStimCenter(V1chRanksRE == 2);
    nosRE = V1data.trRE.inStimCenter(V1chRanksRE == 3);
    
    numChLE = sum(V1data.trLE.inStimCenter);
    numChRE = sum(V1data.trRE.inStimCenter);
    
    subplot(2,2,1)
    hold on
    bar(1,sum(conLE)/numChLE,'FaceColor',[0.7 0 0.7])
    bar(2,sum(radLE)/numChLE,'FaceColor',[0 0.6 0.2])
    bar(3,sum(nosLE)/numChLE,'FaceColor',[1 0.5 0.1])
    title(sprintf('V1 FE n: %d', numChLE))
    ylim([0 0.7])
    set(gca,'tickdir','out','box','off',...
        'XTick',1:3,'XTickLabel',{'Con','Radial','Dipole'},...
        'FontSize',13,'FontWeight','bold','FontAngle','italic')
    
    subplot(2,2,2)
    hold on
    bar(1,sum(conRE)/numChRE,'FaceColor',[0.7 0 0.7])
    bar(2,sum(radRE)/numChRE,'FaceColor',[0 0.6 0.2])
    bar(3,sum(nosRE)/numChRE,'FaceColor',[1 0.5 0.1])
    title(sprintf('V1 AE n: %d', numChRE))
    ylim([0 0.7])
    set(gca,'tickdir','out','box','off',...
        'XTick',1:3,'XTickLabel',{'Con','Radial','Dipole'},...
        'FontSize',13,'FontWeight','bold','FontAngle','italic')
    
    % V4
    conLE = V4data.trLE.inStimCenter(V4chRanksLE == 1);
    radLE = V4data.trLE.inStimCenter(V4chRanksLE == 2);
    nosLE = V4data.trLE.inStimCenter(V4chRanksLE == 3);
    
    conRE = V4data.trRE.inStimCenter(V4chRanksRE == 1);
    radRE = V4data.trRE.inStimCenter(V4chRanksRE == 2);
    nosRE = V4data.trRE.inStimCenter(V4chRanksRE == 3);
    
    numChLE = sum(V4data.trLE.inStimCenter);
    numChRE = sum(V4data.trRE.inStimCenter);
    
    subplot(2,2,3)
    hold on
    bar(1,sum(conLE)/numChLE,'FaceColor',[0.7 0 0.7])
    bar(2,sum(radLE)/numChLE,'FaceColor',[0 0.6 0.2])
    bar(3,sum(nosLE)/numChLE,'FaceColor',[1 0.5 0.1])
    title(sprintf('V4 FE n: %d', numChLE))
    ylim([0 0.7])
    set(gca,'tickdir','out','box','off',...
        'XTick',1:3,'XTickLabel',{'Con','Radial','Dipole'},...
        'FontSize',13,'FontWeight','bold','FontAngle','italic')
    
    subplot(2,2,4)
    hold on
    bar(1,sum(conRE)/numChRE,'FaceColor',[0.7 0 0.7])
    bar(2,sum(radRE)/numChRE,'FaceColor',[0 0.6 0.2])
    bar(3,sum(nosRE)/numChRE,'FaceColor',[1 0.5 0.1])
    title(sprintf('V4 AE n: %d', numChRE))
    ylim([0 0.7])
    set(gca,'tickdir','out','box','off',...
        'XTick',1:3,'XTickLabel',{'Con','Radial','Dipole'},...
        'FontSize',13,'FontWeight','bold','FontAngle','italic')
    
    s = suptitle(sprintf('%s Glass pattern preferences in center of stimuli',V1data.trLE.animal));
    s.FontAngle = 'italic';
    s.FontSize = 18;
    s.FontWeight = 'bold';
    
    figName = [V1data.trRE.animal,'BothArrays_prefPattern_centerStim','.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
    
end
%%
[V1data, V4data] = getGlassSumZscorePrefParams(V1data,V4data);
%%
figure(6)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1000])
hold on

[V1data, V4data] = PlotGlassZscoresCenterStimByPref(V1data, V4data);

s = suptitle(sprintf('%s Glass pattern z scores for each pattern in center of stimuli',V1data.trLE.animal));
s.FontAngle = 'italic';
s.FontSize = 18;
s.FontWeight = 'bold';
s.Position(2) = s.Position(2) + 0.02;

figName = [V1data.trRE.animal,'BothArrays_prefPattern_Zscorehist_separate','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')

%% 
figure(8)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 600 1000])
hold on

plotGlassZscoreHist_eyesTogether(V1data, V4data)

t = suptitle(sprintf('%s summed z scores for each pattern',V1data.trLE.animal));
t.Position(2) = t.Position(2) +0.03;
t.FontSize = 18;
t.FontWeight = 'bold';

figName = [V1data.trRE.animal,'BothArrays_prefPattern_Zscorehist_combinEye','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure (7)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 600])
hold on
plotGlass_zScoreScatter(V1data,V4data)

s = suptitle(sprintf('%s summed z scores for receptive fields in center of stimuli',V1data.trLE.animal));
s.FontAngle = 'italic';
s.FontSize = 18;
s.FontWeight = 'bold';
s.Position(2) = s.Position(2) + 0.02;

figName = [V1data.trRE.animal,'BothArrays_prefPattern_centerStimZscore_scatter','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%%
location = determineComputer;
if location == 1
    outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/Glass/allTypes/%s/',V1data.trRE.animal);
elseif location == 0
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/Glass/allTypes/%s/',V1data.trRE.animal);
end
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end
%%
data.V1 = V1data;
data.V4 = V4data;

saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)