clear all
close all
clc
%% XT
%  rd = load('XT_LE_mapNoiseRight_nsp2_nov2018_all_thresh35_info_resps');
%  gd = load('XT_BE_GlassTR_V4_May2020');
%  eye = 'LE';

%  rd = load('XT_RE_mapNoiseRight_nsp2_nov2018_all_thresh35_info_resps');
%  gd = load('XT_BE_GlassTR_V4_May2020');
%  eye = 'RE';
%% WV
% V4
rd = load('WV_LE_MapNoise_nsp2_20190130_all_thresh35_info_resps');
gd = load('WV_LE_glassTRCoh_nsp2_20190416_all_s1_2kFixPerm_OSI_prefOri');
eye = 'LE';
%
% rd = load('WV_RE_MapNoise_nsp2_20190130_all_thresh35_info_resps';);
% gd = load('WV_RE_GlassTRCoh_nsp2_20190410_all_s1_2kFixPerm');
% eye = 'RE';
%
% % V1
% rd = load('WV_LE_MapNoise_nsp1_20190130_all_thresh35_info_resps';);
% gd = load('WV_LE_glassTRCoh_nsp1_20190416_all_s1_2kFixPerm');
% eye = 'LE';
%
% rd = load('WV_RE_MapNoise_nsp1_20190130_all_thresh35_info_resps';);
% gd = load('WV_RE_GlassTRCoh_nsp1_20190410_all_s1_2kFixPerm');
% eye = 'RE';
%% WU

% rd = load('WU_RE_GratingsMapRF_nsp2_20170814_all_thresh35_info_resps');
% gd = load('WU_RE_GlassTR_nsp2_20170828_all_raw_2kFixPerm_OSI_prefOri_PermTests');
% eye = 'RE';

% gd = load('WU_LE_GlassTR_nsp2_20170825_002_raw_2kFixPerm_OSI_prefOri_PermTests');
% rd = load('WU_LE_GratingsMapRF_nsp2_20170620_001_thresh35_info_resps');
% eye = 'LE';
%%
if strcmp(eye,'RE')
    rfData = rd.data.RE;
    glassData = gd.data.RE;
    if contains(rd.data.RE.animal,'WU')
        glassData.fix_x = 0;
        glassData.fix_y = 0;
        glassData.size_x = 8;
    end
else
    rfData = rd.data.LE;
    glassData = gd.data.LE;
    if contains(rd.data.LE.animal,'WU')
        glassData.fix_x = 0;
        glassData.fix_y = 0;
        glassData.size_x = 8;
    end
end
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Mapping/%s/RFMaps/%s/',rfData.animal,rfData.array,rfData.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/Mapping/%s/RFmaps/%s/',rfData.animal,rfData.array,rfData.eye);
end
cd(figDir)

% go to date specific folder, if it doesn't exist, make it
folder = rfData.date2;
mkdir(folder)
cd(sprintf('%s',folder))
%%
fixXGlass = double(unique(glassData.fix_x));
fixYGlass = double(unique(glassData.fix_y));
xPosGlass = double(unique(glassData.pos_x));
yPosGlass = double(unique(glassData.pos_y));
glassSize = double(unique(glassData.size_x)); % diameter of the stimulus

% adjust locations so graphically fixation is always at origin, and can get
% a better sense of the actual eccentricies of the receptive fields.
if fixXGlass ~= 0
    xPosRelFix = xPosGlass-fixXGlass;
else
    xPosRelFix = xPosGlass;
end

if fixYGlass ~= 0
    yPosRelFix = yPosGlass-fixYGlass;
else
    yPosRelFix = yPosGlass;
end
%%
chFit = rfData.chReceptiveFieldParams;
%% plot all channels on one
figure(1)
clf
hold on

for ch = 1:96
    if contains(rfData.eye,'LE')
        draw_ellipse(chFit{ch},[.4 .6 .7])
    else
        draw_ellipse(chFit{ch},[.8 .2  .5])
    end
end
viscircles([xPosRelFix,yPosRelFix],glassSize/2,...
    'color',[0.6 0.6 0.0]);
draw_ellipse(rfData.arrayReceptiveFieldParams)
plot(0,0,'r.','MarkerSize',16)

ylim([-15, 15]);
xlim([-15, 15]);

if contains(rfData.eye,'LE')
    text(5,14,'Channel receptive fields','color',[.4 .6 .7],'FontWeight','bold','FontSize',14,'FontAngle','italic')
else
    text(5,14,'Channel receptive fields','color',[.8 .2  .5],'FontWeight','bold','FontSize',14,'FontAngle','italic')
end

text(2,7.5,'Array receptive field','color',[0 0 0],'FontWeight','bold','FontSize',14,'FontAngle','italic')
text(2,7,'Glass Pattern location','color',[0.6 0.6 0.05],'FontWeight','bold','FontSize',14,'FontAngle','italic')
text(2,6.5,'Fixation point','color','r','FontWeight','bold','FontSize',14,'FontAngle','italic')


set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
    'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
axis square
title(sprintf('%s %s %s receptive field locations all channels',rfData.animal, rfData.eye, rfData.array),'FontSize',14,'FontAngle','italic')

figName = [rfData.animal,'_',rfData.eye,'_',rfData.array,'_',rfData.programID,'_receptiveFieldLocations_allCh'];
print(gcf, figName,'-dpdf','-bestfit')

%% plot all channels on one, limited to channels that are responsive to Glass patterns
figure(3)
clf
hold on

for ch = 1:96
    if glassData.goodCh(ch) == 1
        if contains(rfData.eye,'LE')
            draw_ellipse(chFit{ch},[.4 .6 .7])
        else
            draw_ellipse(chFit{ch},[.8 .2  .5])
        end
    end
end
viscircles([xPosRelFix,yPosRelFix],glassSize/2,...
    'color',[0.6 0.6 0.0]);
draw_ellipse(rfData.arrayReceptiveFieldParams)
plot(0,0,'r.','MarkerSize',16)

ax = gca;
xMax = max(abs(ax.XLim(:)));
yMax = max(abs(ax.YLim(:)));
lims = max(xMax,yMax);
ylim([-15, 15]);
xlim([-15, 15]);

if contains(rfData.eye,'LE')
    text(5,14,'Channel receptive fields','color',[.4 .6 .7],'FontWeight','bold','FontSize',14,'FontAngle','italic')
else
    text(5,14,'Channel receptive fields','color',[.8 .2  .5],'FontWeight','bold','FontSize',14,'FontAngle','italic')
end

text(2,7.5,'Array receptive field','color',[0 0 0],'FontWeight','bold','FontSize',14,'FontAngle','italic')
text(2,7,'Glass Pattern location','color',[0.6 0.6 0.05],'FontWeight','bold','FontSize',14,'FontAngle','italic')
text(2,6.5,'Fixation point','color','r','FontWeight','bold','FontSize',14,'FontAngle','italic')


set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
    'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
axis square
title(sprintf('%s %s %s receptive field locations Glass responsive channels',rfData.animal, rfData.eye, rfData.array),'FontSize',14,'FontAngle','italic')

figName = [rfData.animal,'_',rfData.eye,'_',rfData.array,'_',rfData.programID,'_receptiveFieldLocations_goodCh'];
print(gcf, figName,'-dpdf','-bestfit')
%% prepare for plotting preferred orientation of Glass patterns
stimRad = glassSize/2;
lEdgeGlass = (xPosRelFix - stimRad)-1;
rEdgeGlass = (xPosRelFix + stimRad)+1;
%%
folder = 'byCh';
mkdir(folder)
cd(sprintf('%s',folder))
%%
for ch = 1:96
    if glassData.goodCh(ch) == 1
        figure(2)
        clf
        hold on
        
        if contains(rfData.eye,'LE')
            draw_ellipse(chFit{ch},[.4 .6 .7])
        else
            draw_ellipse(chFit{ch},[.8 .2  .5])
        end
        
        viscircles([xPosRelFix,yPosRelFix],stimRad,...
            'color',[0.6 0.6 0.05],'LineWidth',1.5);
        
        plot(0,0,'r.','MarkerSize',16)
        
        set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
            'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
        
        % use limits from the full array - they'll be largest and therefore
        % consistent across everything
        ylim([-15, 15]);
        xlim([-15, 15]);
        if contains(rfData.eye,'LE')
            % text(5,14,'Channel receptive fields','color',[.4 .6 .7],'FontWeight','bold','FontSize',14,'FontAngle','italic')
            text(2,7.5,'Channel receptive fields','color',[.4 .6 .7],'FontWeight','bold','FontSize',14,'FontAngle','italic')
        else
            %             text(5,14,'Channel receptive fields','color',[.8 .2  .5],'FontWeight','bold','FontSize',14,'FontAngle','italic')
            text(2,7.5,'Channel receptive fields','color',[.8 .2  .5],'FontWeight','bold','FontSize',14,'FontAngle','italic')
        end
        %         text(5,12,'Glass pattern location','color',[0.6 0.6 0.05],'FontWeight','bold','FontSize',14,'FontAngle','italic')
        %         text(5,10,'Fixation point','color','r','FontWeight','bold','FontSize',14,'FontAngle','italic')
        %         text(5,8,'preferred Glass orientation','color','k','FontWeight','bold','FontSize',14,'FontAngle','italic')
        text(2,7,'Glass Pattern location','color',[0.6 0.6 0.05],'FontWeight','bold','FontSize',14,'FontAngle','italic')
        text(2,6.5,'Fixation point','color','r','FontWeight','bold','FontSize',14,'FontAngle','italic')
        title(sprintf('%s %s %s screen geometry ch %d',rfData.animal, rfData.eye, rfData.array,ch),'FontSize',14,'FontAngle','italic')
        
        figName = [rfData.animal,'_',rfData.eye,'_',rfData.array,'_',rfData.programID,'_receptiveField_ch',num2str(ch)];
        % print(gcf, figName,'-dpdf','-bestfit')
    end
    
end
%%
cd ..
figure(5)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1000])
set(gcf,'PaperOrientation','Landscape');

rfParams = rfData.chReceptiveFieldParams;

for ch = 1:96
    subplot(glassData.amap,10,10,ch)
    hold on;
    
    if contains(rfData.eye,'LE')
        draw_ellipse(rfParams{ch},[.4 .6 1])
    else
        draw_ellipse(rfParams{ch},[.8 .2  .5])
    end
    viscircles([0,0],4,...
        'color',[0.6 0.6 0.0],'LineWidth',0.75);
    
    title(ch)
    xlim([-8,8])
    ylim([-8,8])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic','XTickLabel',[],'YTickLabel',[])
    axis square
end
suptitle(sprintf('%s %s %s receptive fields relative to Glass pattern location',rfData.animal, rfData.eye, rfData.array))


figName = [rfData.animal,'_',rfData.eye,'_',rfData.array,'_',rfData.programID,'_receptiveField_arrayLayout'];
print(gcf, figName,'-dpdf','-bestfit')