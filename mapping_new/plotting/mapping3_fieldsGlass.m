clear all
close all
clc
%% XT
% rd = load('XT_LE_mapNoiseRight_nsp2_Nov2018_raw_perm.mat');
% gd = load('XT_BE_GlassTR_V4_May2020');
%% WV
% V4
rd = load('WV_LE_MapNoise_nsp2_20190204_all_raw_perm');
gd = load('WV_BE_GlassTRCoh_V4_May2020');
% 
% rd = 'WV_RE_MapNoise_nsp2_20190205_001_raw';
% gd = 'WV_RE_GlassTRCoh_nsp2_20190410_all_s1_2kFixPerm';...
% 
% % V1
% rd = 'WV_LE_MapNoise_nsp1_20190204_all_raw';
% gd = 'WV_LE_glassTRCoh_nsp1_20190416_all_s1_2kFixPerm';
% 
% rd = 'WV_RE_MapNoise_nsp1_20190205_001_raw';
% gd = 'WV_RE_GlassTRCoh_nsp1_20190410_all_s1_2kFixPerm';...
%    
%%
rfData = rd.data.LE;
glassData = gd.data.LE;
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

ax = gca;
xMax = max(abs(ax.XLim(:)));
yMax = max(abs(ax.YLim(:)));
lims = max(xMax,yMax);
ylim([-lims, lims]);
xlim([-lims, lims]);

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
print(gcf, figName,'-dpdf','-fillpage')
%% prepare for plotting preferred orientation of Glass patterns
stimRad = glassSize/2;
lEdgeGlass = (xPosRelFix - stimRad)-1;
rEdgeGlass = (xPosRelFix + stimRad)+1;
%%
folder = 'byCh';
mkdir(folder)
cd(sprintf('%s',folder))

folder = 'prefOri';
mkdir(folder)
cd(sprintf('%s',folder))
%%
% for ch = 1:96
%     if glassData.goodCh(ch) == 1
%         figure(2)
%         %pause(2)
%         clf
%         hold on
%         
%         if contains(rfData.eye,'LE')
%             draw_ellipse(chFit{ch},[.4 .6 .7])
%         else
%             draw_ellipse(chFit{ch},[.8 .2  .5])
%         end
%         
%         viscircles([xPosRelFix,yPosRelFix],stimRad,...
%             'color',[0.6 0.6 0.05],'LineWidth',1.5);
%         
%         plot(0,0,'r.','MarkerSize',16)
%         ln = plot([lEdgeGlass rEdgeGlass],[yPosRelFix yPosRelFix],'-sk');
%         pOri = glassData.prefOriBestDprime(ch);
%         rotate(ln,[1,1,0],pOri)
%         text(rEdgeGlass+0.5,yPosRelFix,sprintf('%.2f %c',pOri,char(176)),'FontSize',11)
%         
%         set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
%             'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
%         
%         % use limits from the full array - they'll be largest and therefore
%         % consistent across everything
%         ylim([-lims, lims]);
%         xlim([-lims, lims]);
%         if contains(rfData.eye,'LE')
%             text(5,14,'Channel receptive fields','color',[.4 .6 .7],'FontWeight','bold','FontSize',14,'FontAngle','italic')
%         else
%             text(5,14,'Channel receptive fields','color',[.8 .2  .5],'FontWeight','bold','FontSize',14,'FontAngle','italic')
%         end
%         text(5,12,'Glass pattern location','color',[0.6 0.6 0.05],'FontWeight','bold','FontSize',14,'FontAngle','italic')
%         text(5,10,'Fixation point','color','r','FontWeight','bold','FontSize',14,'FontAngle','italic')
%         text(5,8,'preferred Glass orientation','color','k','FontWeight','bold','FontSize',14,'FontAngle','italic')
%         
%         title(sprintf('%s %s %s screen geometry ch %d',rfData.animal, rfData.eye, rfData.array,ch),'FontSize',14,'FontAngle','italic')
%         
%         figName = [rfData.animal,'_',rfData.eye,'_',rfData.array,'_',rfData.programID,'_receptiveField_pOri_ch',num2str(ch)];
%         print(gcf, figName,'-dpdf','-fillpage')
%     end
%     
% end
%%
cd ..
folder = 'normal';
mkdir(folder)
cd(sprintf('%s',folder))
%%
for ch = 1:96
    if glassData.goodCh(ch) == 1
        figure(2)
        %pause(2)
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
%        ln = plot([lEdgeGlass rEdgeGlass],[yPosRelFix yPosRelFix],'-sk');
%         pOri = glassData.prefOriBestDprime(ch);
%         rotate(ln,[1,1,0],pOri)
%        text(rEdgeGlass+0.5,yPosRelFix,sprintf('%.2f %c',pOri,char(176)),'FontSize',11)
        
        set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
            'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
        
        % use limits from the full array - they'll be largest and therefore
        % consistent across everything
        ylim([-lims, lims]);
        xlim([-lims, lims]);
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
        print(gcf, figName,'-dpdf','-fillpage')
    end
    
end