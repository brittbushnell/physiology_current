% plotMWksGratSurface_daily
%
%
clear all
close all
clc
tic
%%
% files = ['fit_WU_LE_V4_Gratings_daily_recut_surface';
%     'fit_WU_RE_V4_Gratings_daily_recut_surface'];

% files = ['fit_WU_LE_V1_Gratings_daily_recut_surface';
%          'fit_WU_RE_V1_Gratings_daily_recut_surface'];

% files = [ 'fit_WU_LE_V1_Gratings_dailyCombo_surface';
%           'fit_WU_RE_V1_Gratings_dailyCombo_surface'];
%%
files = ['WV_RE_Gratings_V4_20190205_fit';'WV_LE_Gratings_V4_20190205_fit'];
%%
location = 1;
dailyPlot = 1;
%%
for fi = 1:size(files,1)
    filename = files(fi,:);
    load(filename);
    [animal, eye, program, array, date] = parseFileName(filename);
    
    if strfind(filename,'LE')
        numChannels = size(LEdata_all{1}.bins,3);
        numDaysLE = length(LEdata_all);
    else
        numChannels = size(REdata_all{1}.bins,3);
        numDaysRE = length(REdata_all);
    end
    
    cmap = [1 0 0;
        1 0.5 0;
        0 0.7 0;
        0 0 1;
        0 1 1;
        0.5 0 1];
    
    [X,Y] = meshgrid([0.3125 0.625 1.25 2.5 5 10], [0 30 60 90 120 150]);
    
    %% Rank channels by quality of fits (residuals)
    % resRE = nan(numChannels,2);
    % resLE = nan(numChannels,2);
    %
    % for ch = 1:numChannels
    %     resRE(ch,2) = nanmean(REdata.residuals{ch}(:));
    %
    %     resLE(ch,2) = nanmean(LEdata.residuals{ch}(:));
    % end
    % [resRankRE,resRankREch] = sort(resRE);
    % [resRankLE,resRankLEch] = sort(resLE);
    %% Create figure for LE
    if dailyPlot == 1
        if strfind(filename,'LE')
            for ch = 1:numChannels
                for dy = 1:numDaysLE
                    LEblank = repmat(mean(LEdata_all{dy}.oriXsf{ch}(:,1)),size(LEdata_all{dy}.oriXsf_sparse{ch},1),size(LEdata_all{dy}.oriXsf_sparse{ch},2));
                    LENormBlank = repmat(mean(LEdata_all{dy}.normOriXsf{ch}(:,1)),size(LEdata_all{dy}.oriXsf_sparse{ch},1),size(LEdata_all{dy}.oriXsf_sparse{ch},2));
                    
                    LEdataMax1(1,dy) = max(LEdata_all{dy}.normOriXsf_sparse{ch}(:));
                    LEfitMax1(1,dy) = max(LEdata_all{dy}.normSurfFitVals{ch}(:));
                    LEdataMax = max(LEdataMax1);
                    LEfitMax  = max(LEfitMax1);
                    LENormMax = max(LEdataMax, LEfitMax);
                end
                zNormMax =LENormMax + (LENormMax/10);
                
                figure
                for dy = 1:numDaysLE
                    
                    subplot(2,3,dy)
                    if ~isempty(intersect(ch,LEdata_all{dy}.goodChannels))
                        hold on
                        surface(X,Y,LEdata_all{dy}.normSurfFitVals{ch},'FaceColor','none')
                        plot3(X,Y,LEdata_all{dy}.normOriXsf_sparse{ch},'.','MarkerSize',10)
                        plot3(X,Y,LEdata_all{dy}.normSurfFitVals{ch},'LineWidth',2)
                        %         text(5,-5,nline1,num2str(LEdata_all{dy}.normSurfParams{ch}(1),'amp = %.2f'))
                        %         text(5,-5,nline2,num2str(LEdata_all{dy}.normSurfParams{ch}(2),'muOr = %.2f'))
                        %         text(5,-5,nline3,num2str(LEdata_all{dy}.normSurfParams{ch}(3),'muSf = %.2f'))
                        %         text(5,-5,nline4,num2str(LEdata_all{dy}.normSurfParams{ch}(4),'kOr = %.2f'))
                        %         text(5,-5,nline5,num2str(LEdata_all{dy}.normSurfParams{ch}(5),'kSf = %.2f'))
                    end
                    surface(X,Y,LENormBlank,'FaceColor','none')
                    grid on
                    zlim([0 zNormMax])
                    if dy == 1
                        title(sprintf('%s FE ch %d',array, ch));
                    end
                    %  title(sprintf('FE %s ch %d normalized fits', array, ch))
                    %                 ylabel('ori(deg)','Rotation',-30)
                    %                 zlabel('Z score')                ylabel('ori(deg)','Rotation',-30)
                    zlabel('Z score')
                    view(-52,22)
                end
                
                if strfind(filename,'V1')
                    if location == 0
                        cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1
                    elseif location == 1
                        cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1
                    elseif location == 2
                        cd /home/bushnell/Figures/V1/Gratings/Surfaces
                    end
                else
                    if location == 0
                        cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4
                    elseif location == 1
                        cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4
                    elseif location == 2
                        cd /home/bushnell/Figures/V4/Gratings/Surfaces
                    end
                end
                figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','FE','_','dailySurf'];
                saveas(gcf,figName,'pdf')
            end
            close all
            %% Create figure for RE
        else
            for ch = 1:numChannels
                for dy = 1:numDaysRE
                    REblank = repmat(mean(REdata_all{dy}.oriXsf{ch}(:,1)),size(REdata_all{dy}.oriXsf_sparse{ch},1),size(REdata_all{dy}.oriXsf_sparse{ch},2));
                    RENormBlank = repmat(mean(REdata_all{dy}.normOriXsf{ch}(:,1)),size(REdata_all{dy}.oriXsf_sparse{ch},1),size(REdata_all{dy}.oriXsf_sparse{ch},2));
                    
                    REdataMax1(1,dy) = max(REdata_all{dy}.normOriXsf_sparse{ch}(:));
                    REfitMax1(1,dy) = max(REdata_all{dy}.normSurfFitVals{ch}(:));
                    REdataMax = max(REdataMax1);
                    REfitMax  = max(REfitMax1);
                    RENormMax = max(REdataMax, REfitMax);
                end
                zNormMax =RENormMax + (RENormMax/10);
                
                figure
                for dy = 1:numDaysRE
                    
                    subplot(2,4,dy)
                    if ~isempty(intersect(ch,REdata_all{dy}.goodChannels))
                        hold on
                        surface(X,Y,REdata_all{dy}.normSurfFitVals{ch},'FaceColor','none')
                        plot3(X,Y,REdata_all{dy}.normOriXsf_sparse{ch},'.','MarkerSize',10)
                        plot3(X,Y,REdata_all{dy}.normSurfFitVals{ch},'LineWidth',2)
                        %         text(5,-5,nline1,num2str(REdata_all{dy}.normSurfParams{ch}(1),'amp = %.2f'))
                        %         text(5,-5,nline2,num2str(REdata_all{dy}.normSurfParams{ch}(2),'muOr = %.2f'))
                        %         text(5,-5,nline3,num2str(REdata_all{dy}.normSurfParams{ch}(3),'muSf = %.2f'))
                        %         text(5,-5,nline4,num2str(REdata_all{dy}.normSurfParams{ch}(4),'kOr = %.2f'))
                        %         text(5,-5,nline5,num2str(REdata_all{dy}.normSurfParams{ch}(5),'kSf = %.2f'))
                    end
                    surface(X,Y,RENormBlank,'FaceColor','none')
                    grid on
                    zlim([0 zNormMax])
                    if dy == 1
                        title(sprintf('%s AE ch %d',array, ch));
                    end
                    %  title(sprintf('FE %s ch %d normalized fits', array, ch))
                    %                 ylabel('ori(deg)','Rotation',-30)
                    %                 zlabel('Z score')
                    view(-52,22)
                end
                
                if strfind(filename,'V1')
                    if location == 0
                        cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1
                    elseif location == 1
                        cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1
                    elseif location == 2
                        cd /home/bushnell/Figures/V1/Gratings/Surfaces
                    end
                else
                    if location == 0
                        cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4
                    elseif location == 1
                        cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4
                    elseif location == 2
                        cd /home/bushnell/Figures/V4/Gratings/Surfaces
                    end
                end
                figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','AE','_','dailySurf'];
                saveas(gcf,figName,'pdf')
            end
        end
    end
    close all
end
%% Create plots to compare parameters FE
for ch = 1:numChannels
    legend1 = cell(numDaysLE,1);
    for d = 1:numDaysLE
        amps(d) = LEdata_all{d}.normSurfParams{ch}(1);
    end
    maxAmp = max(amps);
    
    figure
    
    for dy = 1:numDaysLE
        subplot(1,3,1)
        hold on
        if ~isempty(intersect(ch,LEdata_all{dy}.goodChannels))
            plot(dy,LEdata_all{dy}.normSurfParams{ch}(1),'.','MarkerSize',20)
        else
            plot(dy,0,'x')
        end
        if dy == 1
            title(sprintf('%s FE ch %d',array, ch));
        end
        ylabel('amp')
        %ylim([0 maxAmp])
        xlabel('day')
        xlim([0 numDaysLE])
        
        subplot(1,3,2)
        hold on
        if ~isempty(intersect(ch,LEdata_all{dy}.goodChannels))
            plot(dy,LEdata_all{dy}.normSurfParams{ch}(2),'.','MarkerSize',20)
        else
            plot(dy,0,'x')
        end
        ylabel('mu or')
        ylim([0 360])
        xlabel('day')
        xlim([0 numDaysLE])
        
        subplot(1,3,3)
        hold on
        if ~isempty(intersect(ch,LEdata_all{dy}.goodChannels))
            plot(dy,LEdata_all{dy}.normSurfParams{ch}(3),'.','MarkerSize',20)
        else
            plot(dy,0,'x')
        end
        set(gca,'YScale','log')
        ylim([0.03 10])
        ylabel('mu sf')
        xlabel('day')
        xlim([0 numDaysLE])
        
        %legend1{dy} = strcat('day ',num2str(dy));
    end
    %legend(legend1,'Location','EastOutside')
    
    if strfind(filename,'V1')
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/DailySurfFits
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1
        elseif location == 2
            cd /home/bushnell/Figures/V1/Gratings/DailySurfFits
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/DailySurfFits
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4
        elseif location == 2
            cd /home/bushnell/Figures/V4/Gratings/DailySurfFits
        end
    end
    figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','FE','_','ParamComp'];
    saveas(gcf,figName,'pdf')
end
close all
%% Create plots to compare parameters FE
for ch = 1:numChannels
    legend1 = cell(numDaysRE,1);
    
    for d = 1:numDaysRE
        amps(d) = REdata_all{d}.normSurfParams{ch}(1);
    end
    maxAmp = max(amps);
    
    figure
    for dy = 1:numDaysRE
        subplot(1,3,1)
        hold on
        if ~isempty(intersect(ch,REdata_all{dy}.goodChannels))
            plot(dy,REdata_all{dy}.normSurfParams{ch}(1),'.','MarkerSize',20)
        else
            plot(dy,0,'x')
        end
        if dy == 1
            title(sprintf('%s AE ch %d',array,ch));
        end
        ylabel('amp')
        %ylim([0 maxAmp])
        xlabel('day')
        xlim([0 numDaysLE])
        
        subplot(1,3,2)
        hold on
        if ~isempty(intersect(ch,REdata_all{dy}.goodChannels))
            plot(dy,REdata_all{dy}.normSurfParams{ch}(2),'.','MarkerSize',20)
        else
            plot(dy,0,'x')
        end
        ylabel('mu or')
        ylim([0 360])
        xlabel('day')
        xlim([0 numDaysLE])
        
        subplot(1,3,3)
        hold on
        if ~isempty(intersect(ch,REdata_all{dy}.goodChannels))
            plot(dy,REdata_all{dy}.normSurfParams{ch}(3),'.','MarkerSize',20)
        else
            plot(dy,0,'x')
        end
        set(gca,'YScale','log')
        ylabel('mu sf')
        ylim([0.03 10])
        xlabel('day')
        xlim([0 numDaysRE])
        
        %legend1{dy} = strcat('day ',num2str(dy));
    end
    %legend(legend1,'Location','EastOutside')
    
    if strfind(filename,'V1')
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1
        elseif location == 2
            cd /home/bushnell/Figures/V1/Gratings/DailySurfFits
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4
        elseif location == 2
            cd /home/bushnell/Figures/V4/Gratings/DailySurfFits
        end
    end
    figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','AE','_','ParamComp'];
    saveas(gcf,figName,'pdf')
end
%%
toc/60