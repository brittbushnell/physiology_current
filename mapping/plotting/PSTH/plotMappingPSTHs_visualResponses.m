function [] = plotMappingPSTHs_visualResponses(dataT)
% Plot PSTHs for map noise programs combining across all locations and
% sitmuli

location = determineComputer;
%% stim vs blank - all chs
for ch = 1:96   
    if dataT.goodCh(ch) == 1
        blankResp = nanmean(smoothdata(dataT.bins((dataT.stimulus == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = nanmean(smoothdata(dataT.bins((dataT.stimulus == 1), 1:35 ,ch),'gaussian',3))./0.01;
        mx(ch) = max([blankResp,stimResp]);
    end
end

yMax = round(max(mx));


figure(1);
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 800])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    
    subplot(dataT.amap,10,10,ch)
    hold on;
    blankResp = nanmean(smoothdata(dataT.bins((dataT.stimulus == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = nanmean(smoothdata(dataT.bins((dataT.stimulus == 1), 1:35 ,ch),'gaussian',3))./0.01;
    
    if dataT.goodCh(ch) == 1
        if contains(dataT.animal,'XT')
            if contains(dataT.eye,'RE')
                plot(1:35,blankResp,'color',[0.14 0.63 0.42 0.7],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0.14 0.63 0.42 0.8],'LineWidth',2);
            else
                plot(1:35,blankResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',2);
            end
        else
            if contains(dataT.eye,'RE')
                plot(1:35,blankResp,'color',[1 0 0 0.7],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[1 0 0 0.8],'LineWidth',2);
            else
                plot(1:35,blankResp,'color',[0 0.2 1 0.7],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0 0.2 1 0.8],'LineWidth',2);
            end
        end
        
    else
        if contains(dataT.animal,'XT')
            if contains(dataT.eye,'RE')
                plot(1:35,blankResp,'color',[0.14 0.63 0.42 0.4],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0.14 0.63 0.42 0.6],'LineWidth',2);
            else
                plot(1:35,blankResp,'color',[0.3 0.3 0.3 0.6],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0.3 0.3 0.3 0.6],'LineWidth',2);
            end
        else
            if contains(dataT.eye,'RE')
                plot(1:35,blankResp,'color',[1 0 0 0.4],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[1 0 0 0.6],'LineWidth',2);
            else
                plot(1:35,blankResp,'color',[0 0.2 1 0.4],'LineWidth',0.5);
                plot(1:35,stimResp,'color',[0 0.2 1 0.3],'LineWidth',2);
            end
        end
    end
    
    title(ch)
    set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');%,'FontSize',12);%'YTick',[0,yMax]
    %         ylim([0 yMax])
    ylim([0 inf])
    
end

suptitle((sprintf('%s %s %s stim vs blank all locations', dataT.animal,dataT.eye, dataT.array)))
%% save figure

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Mapping/%s/PSTH/',dataT.animal,dataT.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/Mapping/%s/PSTH/',dataT.animal,dataT.array);
end
cd(figDir)

% go to date specific folder, if it doesn't exist, make it
folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTHstimVBlank'];
print(gcf, figName,'-dpdf','-fillpage')
