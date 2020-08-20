clc
close all
clear all
tic
%%
%file = 'fit_WU_Gratings_V1_recut_surf_6days_1ch';
%  file = 'fit_WU_Gratings_V4_recut_surf_6days_1ch';
%
%file = 'fit_WU_Gratings_V4_withRF_recut_surface_raw';
%file = 'fit_WU_Gratings_V1_withRF_recut_surface_raw';

file = 'WU_Gratings_V4_withRF_goodCh_fit_asym';
%file = 'WU_Gratings_V1_withRF_goodCh_fit'_asym;

%file = 'fit_WU_Gratings_V4_recut_surf_6days_1ch';

location = 2; % 0 = laptop 1 = amfortas 2 = zemina
plotChs = 1;
%%
load(file);
%[animal, eye, program, array, date] = parseFileName(file);
program = 'Gratings';
date = 'WithRF';
animal = 'WU';
if strfind(file,'V1')
    array = 'V1';
else
    array = 'V4';
end

numChannels = size(LEdata.bins,3);

if strfind(file,'1ch')
    if strfind(file,'V1')
        ch = 73;
    else
        ch = 84;
    end
end

cmap = [1 0 0;
    1 0.5 0;
    0 0.7 0;
    0 0 1;
    0 1 1;
    0.5 0 1];
%% Rank channels by quality of fits (residuals)
resRE = nan(numChannels,2);
resLE = nan(numChannels,2);

for ch = 1:numChannels
    resRE(ch,2) = nanmean(REdata.residuals{ch}(:));
    
    resLE(ch,2) = nanmean(LEdata.residuals{ch}(:));
end
[resRankRE,resRankREch] = sort(resRE);
[resRankLE,resRankLEch] = sort(resLE);
%% setup figures
LEblanks_ind = find(LEdata.spatial_frequency==0);
LEstim_ind = find(LEdata.spatial_frequency~=0);

REblanks_ind = find(REdata.spatial_frequency==0);
REstim_ind = find(REdata.spatial_frequency~=0);
steps = (ones(100,1)*0.1*[1:1:96]);

mfrLE = (ones(100,1)*mean(squeeze(mean(LEdata.bins(:,:,:),1))));
mfrstimLE = (ones(100,1)*mean(squeeze(mean(LEdata.bins(LEstim_ind,:,:),1))));
blank_respsLE = squeeze(mean(LEdata.bins(LEblanks_ind,:,:),1))-mfrLE+steps;
stim_respsLE = squeeze(mean(LEdata.bins(LEstim_ind,:,:),1))-mfrLE+steps;

mfrRE = (ones(100,1)*mean(squeeze(mean(REdata.bins(:,:,:),1))));
mfrstimRE = (ones(100,1)*mean(squeeze(mean(REdata.bins(REstim_ind,:,:),1))));

blank_respsRE = squeeze(mean(REdata.bins(REblanks_ind,:,:),1))-mfrRE+steps;
stim_respsRE  = squeeze(mean(REdata.bins(REstim_ind,:,:),1))-mfrRE+steps;

[X,Y] = meshgrid([0.3125 0.625 1.25 2.5 5 10], [0 30 60 90 120 150]);
%    [XX, YY] = meshgrid(REdata.sfs_fine, REdata.oris_fine);

sfs = unique(LEdata.spatial_frequency);
sfs = (sfs(1,4:end));

oris = unique(LEdata.rotation);
oris = oris(1,1:end-1);
%% Make figure of responses across all channels
figure
subplot(1,2,1);
hold on;
for ind = 1:96
    plot(blank_respsLE(:,ind),'k-');
    %    plot(stim_respsLE(:,ind),'r-');
end
title('AE')
xlabel('time')
ylabel('channel')

subplot(1,2,2)
hold on;
for ind = 1:96
    plot(blank_respsRE(:,ind),'k-');
    %    plot(stim_respsRE(:,ind),'r-');
end
title('FE')
xlabel('time')
ylabel('channel')
%% Make one figure per channel with surface fits FE
if plotChs == 1
    for ch = 1:numChannels
        %LErank = resRankLEch(ch,2);
        
        LEdataMax = max(LEdata.normOriXsf_sparse{ch}(:));
        LEfitMax  = max(LEdata.normSurfFitVals{ch}(:));
        LENormMax = max(LEdataMax, LEfitMax);
        
        REdataMax = max(REdata.normOriXsf_sparse{ch}(:));
        REfitMax  =  max(REdata.normSurfFitVals{ch}(:));
        RENormMax = max(REdataMax, REfitMax);
        
        zNormMax = max(RENormMax, LENormMax);
        zNormMax =zNormMax + (zNormMax/10);
        
        RENormBlank = repmat(mean(REdata.normOriXsf{ch}(:,1)),size(REdata.oriXsf_sparse{ch},1),size(REdata.oriXsf_sparse{ch},2));
        LENormBlank = repmat(mean(LEdata.normOriXsf{ch}(:,1)),size(LEdata.oriXsf_sparse{ch},1),size(LEdata.oriXsf_sparse{ch},2));
       
        nline1 = zNormMax+2;
        nline2 = nline1-2;
        
        figure
        subplot(1,2,1)
        set(gca,'XScale','log',...
            'ColorOrder',cmap,'NextPlot','replacechildren')
        hold on
        if ~isempty(intersect(ch,LEdata.goodChannels))
            surface(X,Y,LEdata.normSurfFitVals{ch},'FaceColor','none')
            plot3(X,Y,LEdata.normOriXsf_sparse{ch},'.','MarkerSize',10)
            plot3(X,Y,LEdata.normSurfFitVals{ch},'LineWidth',2)
            text(5,60,nline1,num2str(LEdata.normSurfParams{ch}(2),'muOr = %.2f'))
            text(5,60,nline2,num2str(LEdata.normSurfParams{ch}(3),'muSf = %.2f'))
        end
        surface(X,Y,LENormBlank,'FaceColor','none')
        grid on
        if zNormMax > 0
            zlim([0 zNormMax])
        end
        ylim([0 160])
        xlim([0.3 11])
        title(sprintf('FE %s ch %d normalized fits', array, ch))
        set(gca, 'XTick',[0.3  1.25 10],'XTickLabel',{'0.3','1.25' ,'10'},...
            'YTick',[0  90 150],'YTickLabel',{'0','90' ,'150'})
        ylabel('ori(deg)','Rotation',-30)
        zlabel('Z score')
        view(-52,22)
        
        subplot(1,2,2)
        set(gca,'XScale','log',...
            'ColorOrder',cmap,'NextPlot','replacechildren')
        hold on
        if ~isempty(intersect(ch,REdata.goodChannels))
            surface(X,Y,REdata.normSurfFitVals{ch},'FaceColor','none')
            plot3(X,Y,REdata.normOriXsf_sparse{ch},'.','MarkerSize',10)
            plot3(X,Y,REdata.normSurfFitVals{ch},'LineWidth',2)
            text(5,60,nline1,num2str(REdata.normSurfParams{ch}(2),'muOr = %.2f'))
            text(5,60,nline2,num2str(REdata.normSurfParams{ch}(3),'muSf = %.2f'))
        end
        surface(X,Y,RENormBlank,'FaceColor','none')
        grid on
        if zNormMax > 0
            zlim([0 zNormMax])
        end
        ylim([0 160])
        xlim([0.3 11])
        set(gca, 'XTick',[0.3  1.25 10],'XTickLabel',{'0.3','1.25' ,'10'},...
            'YTick',[0  90 150],'YTickLabel',{'0','90' ,'150'})
        title('AE')
        xlabel('SF (cpd)','Rotation',45)
        
        view(-52,22)
        
        if strfind(file,'V1')
            if location == 0
                cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/Surfacess
            elseif location == 1
                cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1
            elseif location == 2
                cd ~/Figures/V1/Gratings/Surfaces/
            end
        else
            if location == 0
                cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/Surfaces
            elseif location == 1
                cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4
            elseif location == 2
                cd ~/Figures/V4/Gratings/Surfaces/
            end
        end
        figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','Surf_fitsT'];
        saveas(gcf,figName,'pdf')
    end
    %% Make one figure per channel with surface fits RE
    %     for ch = 1:numChannels
    %         RErank = resRankREch(ch,2);
    %
    %         REdataMax = max(REdata.normOriXsf_sparse{ch}(:));
    %         REfitMax = max(REdata.normSurfFitVals{ch}(:));
    %         RENormMax = max(REdataMax, REfitMax);
    %         zNormMax =RENormMax + (RENormMax/10);
    %
    %         REdataMax = max(REdata.oriXsf_sparse{ch}(:));
    %         REfitMax = max(REdata.surfFitVals{ch}(:));
    %         REMax = max(REdataMax, LEfitMax);
    %         zMax = REMax + (REMax/10);
    %
    % %         line1 = zMax;
    % %         line2 = zMax -5;
    % %         line3 = zMax-10;
    % %         line4 = zMax-15;
    % %         line5 = zMax-20;
    % %
    % %         nline1 = zNormMax;
    % %         nline2 = zNormMax-0.5;
    % %         nline3 = zNormMax-1;
    % %         nline4 = zNormMax-1.5;
    % %         nline5 = zNormMax-2;
    %
    %         figure
    %         RENormBlank = repmat(mean(REdata.normOriXsf{ch}(:,1)),size(REdata.oriXsf_sparse{ch},1),size(REdata.oriXsf_sparse{ch},2));
    %         REblank = repmat(mean(REdata.oriXsf{ch}(:,1)),size(REdata.oriXsf_sparse{ch},1),size(REdata.oriXsf_sparse{ch},2));
    %
    %         subplot(1,2,2)
    %         set(gca,'XScale','log',...
    %             'ColorOrder',cmap,'NextPlot','replacechildren')
    %         hold on
    %         if ~isempty(intersect(ch,REdata.goodChannels))
    %             surface(X,Y,REdata.normSurfFitVals{ch},'FaceColor','none')
    %             plot3(X,Y,REdata.normOriXsf_sparse{ch},'.','MarkerSize',10)
    %             plot3(X,Y,REdata.normSurfFitVals{ch},'LineWidth',2)
    %             text(5,-5,nline1,num2str(REdata.normSurfParams{ch}(1),'amp = %.2f'))
    %             text(5,-5,nline2,num2str(REdata.normSurfParams{ch}(2),'muOr = %.2f'))
    %             text(5,-5,nline3,num2str(REdata.normSurfParams{ch}(3),'muSf = %.2f'))
    %             text(5,-5,nline4,num2str(REdata.normSurfParams{ch}(4),'kOr = %.2f'))
    %             text(5,-5,nline5,num2str(REdata.normSurfParams{ch}(5),'kSf = %.2f'))
    %         end
    %         surface(X,Y,RENormBlank,'FaceColor','none')
    %         grid on
    %         title(sprintf('AE %s ch %d norma fits', array, ch))
    %         if zMax>0
    %             zlim([0 zNormMax])
    %         end
    %         xlabel('sf(cpd)','Rotation',45)
    %         view(-52,22)
    %
    %         subplot(1,2,1)
    %         set(gca,'XScale','log',...
    %             'ColorOrder',cmap,'NextPlot','replacechildren')
    %         hold on
    %         if ~isempty(intersect(ch,REdata.goodChannels))
    %             surface(X,Y,REdata.surfFitVals{ch},'FaceColor','none')
    %             plot3(X,Y,REdata.oriXsf_sparse{ch},'.','MarkerSize',10)
    %             plot3(X,Y,REdata.surfFitVals{ch},'LineWidth',2)
    %             text(5,-5,line1,num2str(REdata.surfParams{ch}(1),'amp = %.2f'))
    %             text(5,-5,line2,num2str(REdata.surfParams{ch}(2),'muOr = %.2f'))
    %             text(5,-5,line3,num2str(REdata.surfParams{ch}(3),'muSf = %.2f'))
    %             text(5,-5,line4,num2str(REdata.surfParams{ch}(4),'kOr = %.2f'))
    %             text(5,-5,line5,num2str(REdata.surfParams{ch}(5),'kSf = %.2f'))
    %         end
    %         surface(X,Y,REblank,'FaceColor','none')
    %         grid on
    %         title(sprintf('AE %s ch %d thresh fits', array, ch))
    %         if zMax>0
    %             zlim([0 zMax])
    %         end
    %         xlabel('sf(cpd)','Rotation',45)
    %         view(-52,22)
    %
    %         if strfind(file,'V1')
    %             if location == 0
    %                 cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1
    %             elseif location == 1
    %                 cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1
    %             elseif location == 2
    %                 cd ~/Figures/V1/Gratings/Surfaces/
    %             end
    %         else
    %             if location == 0
    %                 cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4
    %             elseif location == 1
    %                 cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4
    %             elseif location == 2
    %                 cd ~/Figures/V4/Gratings/Surfaces/
    %             end
    %         end
    %         figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','AE','_','Surf_goodCh'];
    %         saveas(gcf,figName,'pdf')
    %     end
end
%% Verify results are the same for normalized and thresholded data
figure
for ch = 1:numChannels
    REint = intersect(ch,REdata.goodChannels);
    LEint = intersect(ch,LEdata.goodChannels);
    if REint > 0 & LEint > 0
        subplot(2,2,1)
        hold on
        plot(REdata.surfParams{ch}(2), REdata.normSurfParams{ch}(2),'.r','MarkerSize',10)
        ylim([0 360])
        xlim([0 360])
        xlabel('threshold')
        ylabel('normalized')
        title(sprintf(' %s AE mu Ori', array))
        
        subplot(2,2,2)
        hold on
        plot(log10(REdata.surfParams{ch}(3)), log10(REdata.normSurfParams{ch}(3)),'.r','MarkerSize',10)
        set(gca,'XScale','log','YScale','log')
        %         ylim([0.01 10])
        %         xlim([0.01 10])
        xlabel('threshold')
        ylabel('normalized')
        title('AE mu SF')
        
        subplot(2,2,3)
        hold on
        plot(LEdata.surfParams{ch}(2), LEdata.normSurfParams{ch}(2),'.b','MarkerSize',10)
        ylim([0 360])
        xlim([0 360])
        xlabel('threshold')
        ylabel('normalized')
        title('FE mu Ori')
        
        subplot(2,2,4)
        hold on
        plot(log10(LEdata.surfParams{ch}(3)), log10(LEdata.normSurfParams{ch}(3)),'.b','MarkerSize',10)
        set(gca,'XScale','log','YScale','log')
        %         ylim([0.01 10])
        %         xlim([0.01 10])
        xlabel('threshold')
        ylabel('normalized')
        title('mu SF')
    end
end
%%
toc/60