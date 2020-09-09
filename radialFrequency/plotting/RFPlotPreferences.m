% RFPlotPreferences
clear all
close all
clc
%%
%files = ['WU_V1_RadFreq_combined_sub'; 'WU_V4_RadFreq_combined_sub'];
% files = ['WU_V1_RadFreq_combined'; 'WU_V_RadFreq_combined'];
files = ['WU_V1_RadFreq_0707_find2'; 'WU_V4_RadFreq_0707_find2'];

location = 0;

if location == 2
    addpath(genpath('/home/bushnell/ArrayAnalysis/'))
    addpath(genpath('/home/bushnell/Figures/'))
    addpath(genpath('/home/bushnell/binned_data/'))
    addpath(genpath('/home/bushnell/matFiles/'))
end
%% Extract information
for fi = 1:size(files,1)
    file = files(fi,:);
    load(file);
    
    numCh = size(LEdata.bins,3);
    amap = LEdata.amap;
    
    RFs   = unique(LEdata.rf);
    amps  = unique(LEdata.amplitude);
    phase = unique(LEdata.orientation);
    sfs   = unique(LEdata.spatialFrequency);
    xLocs = unique(LEdata.pos_x);
    yLocs = unique(LEdata.pos_y);
    rads  = unique(LEdata.radius);
    
    if strfind(file,'V1')
        array = 'V1';
    else
        array = 'V4';
    end
    %% Extract preferred information
    [SfPrefRE,SfPrefLE, sizePrefRE, sizePrefLE, phasePrefRE, phasePrefLE]  = radFreqMwks_getPrefs(file,1);
    %    [SfPrefRE2,SfPrefLE2, sizePrefRE2, sizePrefLE2, phasePrefRE2, phasePrefLE2]  = radFreqMwks_getPrefs2(file);
    %% CD to correct folder for saving
    if strfind(file,'V1')
        if location == 0
            cd ~/Dropbox/Figures/wu_Arrays/RF/V1/Prefs
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/V1/RF/Prefs
        elseif location == 2
            cd ~/Figures/V1/RadFreq/Prefs
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/wu_Arrays/RF/V4/Prefs
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/V4/RF/Prefs
        elseif location == 2
            cd ~/Figures/V4/RadFreq/Prefs
        end
    end
    %% plot pref SF - hist
    figure
    hold on
    subplot(2,1,1)
    if array == 'V1'
        histogram(SfPrefLE(1,:),'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'LineWidth',2)
    else
        histogram(SfPrefLE(1,:),'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'LineWidth',2)
    end
    set(gca,'TickDir','out','box','off','XTick',1:3,'XTickLabel',{'1','2','blank'})
    ylabel('# of channels')
    title(sprintf('FE Preferred SF for RadFreq stimuli %s',array))
    
    
    subplot(2,1,2)
    if array == 'V1'
        histogram(SfPrefRE(1,:),'FaceColor',[1 0 0]','EdgeColor',[1 0 0],'LineWidth',2)
    else
        histogram(SfPrefRE(1,:),'FaceColor',[1 0 0],'EdgeColor',[1 0 0],'LineWidth',2)
    end
    set(gca,'TickDir','out','box','off','XTick',1:3,'XTickLabel',{'1','2','blank'})
    ylabel('# of channels')
    title(sprintf('AE Preferred SF for RadFreq stimuli %s',array))
    
    figName = ['WU','_',array,'_RadFreq_SFpref_histresp'];
    saveas(gcf,figName,'pdf')
    %%
    %     figure
    %     hold on
    %     subplot(2,1,1)
    %     yyaxis left
    %     histogram(SfPrefLE2(1,:),'FaceColor',[0 0 1],'EdgeColor',[0 0 1])
    % %     yyaxis right
    % %     plot(SfPrefLE2(1,:),SfPrefLE2(2,:),'ob')
    %     set(gca,'TickDir','out','box','off','XTick',1:3,'XTickLabel',{'1','2','blank'})
    %     yyaxis left
    %     ylabel('# of channels')
    % %     yyaxis right
    % %     ylabel('mean response - baseline')
    %     title(sprintf('FE Preferred SF for RadFreq stimuli %s mean sub',array))
    %
    %
    %     subplot(2,1,2)
    %     yyaxis left
    %     histogram(SfPrefRE2(1,:),'FaceColor',[0 0 1],'EdgeColor',[0 0 1])
    % %     yyaxis right
    % %     plot(SfPrefRE2(1,:),SfPrefRE2(2,:),'or')
    %     set(gca,'TickDir','out','box','off','XTick',1:3,'XTickLabel',{'1','2','blank'})
    %     yyaxis left
    %     ylabel('# of channels')
    % %     yyaxis right
    % %     ylabel('mean response - baseline')
    %     title(sprintf('AE Preferred SF for RadFreq stimuli %s',array))
    %
    %     figName = ['WU','_',array,'_RadFreq_SFpref_histresp_sub'];
    %     saveas(gcf,figName,'pdf')
    %% plot SF w/resps scatter
    figure
    hold on
    if array == 'V1'
        plot(SfPrefLE(1,:),SfPrefLE(2,:),'ob')
        plot(SfPrefRE(1,:),SfPrefRE(2,:),'or')
    else
        
    end
    xlabel('spatial frequency (cpd)')
    ylabel('mean response - baseline')
    xlim([0 3])
    legend('FE','AE')
    set(gca,'XTick',0:3,'XTickLabel',{'','1','2',''})
    
    title(sprintf('Baseline subtracted response for preferred SF %s',array))
    
    figName = ['WU','_',array,'_RadFreq_sfPref_resp'];
    saveas(gcf,figName,'pdf')
    
    %% plot pref Size - hist
    figure
    hold on
    subplot(2,1,1)
    histogram(sizePrefLE(1,:),'FaceColor',[0 0 1],'EdgeColor',[0 0 1])
    ylabel('# of channels')
    set(gca,'TickDir','out','box','off','XTick',1:2)
    title(sprintf('FE Preferred size for RadFreq stimuli %s',array))
    
    
    subplot(2,1,2)
    histogram(sizePrefRE(1,:),'FaceColor',[1 0 0],'EdgeColor',[1 0 0])
    ylabel('# of channels')
    xlabel('Mean radius (deg)')
    set(gca,'TickDir','out','box','off','XTick',1:2)
    title(sprintf('AE Preferred size for RadFreq stimuli %s',array))
    
    figName = ['WU','_',array,'_RadFreq_SizePref_hist'];
    saveas(gcf,figName,'pdf')
   
    %% plot Size w/resps scatter
    figure
    hold on
    plot(sizePrefLE(1,:),sizePrefLE(2,:),'ob')
    plot(sizePrefRE(1,:),sizePrefRE(2,:),'or')
    xlabel('spatial frequency (cpd)')
    ylabel('mean response - baseline')
    xlim([0 3])
    legend('FE','AE')
    set(gca,'XTick',0:3,'XTickLabel',{'','1','2',''})
    title(sprintf('Baseline subtracted response for preferred size %s',array))
    
    figName = ['WU','_',array,'_RadFreq_SizePref_resp'];
    saveas(gcf,figName,'pdf')
    
    %% plot pref Ori hist
    figure
    subplot(3,2,1)
    histogram(phasePrefLE{1}(1,:),'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'BinWidth',15)
    ylabel('# of channels')
    set(gca,'TickDir','out','box','off','XTick',0:45:45,'XTickLabel',{'0','45'})
    xlim([0 50])
    title('FE RF 4')
    
    subplot(3,2,3)
    histogram(phasePrefLE{2}(1,:),'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'BinWidth',10)
    ylabel('# of channels')
    xlim([0 30])
    set(gca,'TickDir','out','box','off','XTick',0:22.5:22.5,'XTickLabel',{'0','22.5'})
    title('RF 8')
    
    subplot(3,2,5)
    histogram(phasePrefLE{3}(1,:),'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'BinWidth',5)
    ylabel('# of channels')
    xlabel('Orientation (deg)')
    xlim([0 15])
    set(gca,'TickDir','out','box','off','XTick',0:11.25:11.25,'XTickLabel',{'0','11.25'})
    title('RF 16')
    
    subplot(3,2,2)
    histogram(phasePrefRE{1}(1,:),'FaceColor',[1 0 0],'EdgeColor',[1 0 0],'BinWidth',15)
    set(gca,'TickDir','out','box','off','XTick',0:45:45,'XTickLabel',{'0','45'})
    xlim([0 50])
    title('AE RF 4')
    
    subplot(3,2,4)
    histogram(phasePrefRE{2}(1,:),'FaceColor',[1 0 0],'EdgeColor',[1 0 0],'BinWidth',10)
    title('RF 8')
    xlim([0 30])
    set(gca,'TickDir','out','box','off','XTick',0:22.5:22.5,'XTickLabel',{'0','22.5'})
    
    subplot(3,2,6)
    histogram(phasePrefRE{3}(1,:),'FaceColor',[1 0 0],'EdgeColor',[1 0 0],'BinWidth',5)
    xlabel('Orientation (deg)')
    title('RF 16')
    xlim([0 15])
    set(gca,'TickDir','out','box','off','XTick',0:11.25:11.25,'XTickLabel',{'0','11.25'})
    
    
    if strfind(file,'V4')
        topTitle = 'V4 Rad Freq phase preference';
    else
        topTitle = 'V1 Rad Freq phase preference';
    end
    
    annotation('textbox',...
        [0.08 0.96 0.95 0.05],...
        'LineStyle','none',...
        'String',topTitle,...
        'Interpreter','none',...
        'FontSize',14,...
        'FontAngle','italic',...
        'FontName','Helvetica Neue');
    
    
    
    figName = ['WU','_',array,'_RadFreq_phasePref_hist'];
    saveas(gcf,figName,'pdf')
    

end
