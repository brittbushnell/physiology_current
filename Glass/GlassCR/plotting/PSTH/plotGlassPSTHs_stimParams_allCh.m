function [] = plotGlassPSTHs_stimParams_allCh(dataT)
% Plot PSTHs for concentric vs radial glass pattern stimuli
% [~,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(data);
%
% critType:
% 3: channels are 3sd above or below baseline
% 10: channels respond 10% higher or lower than baseline

%% use for testing
% close all
%
% file = 'WU_LE_Glass_nsp2_20170817_001_Clean_noT_goodChSD_RespDprime';
% %file = 'WU_RE_Glass_nsp2_20170821_001_Clean_noT_goodChSD_RespDprime';
% load(file)
%
% if contains(file,'LE')
%     dataT = cleanData.LE;
% else
%     dataT = cleanData.RE;
% end
%% stim vs blank - all chs
if contains(dataT.animal,'WU')
    bottomRow = [81 83 85 88 90 92 93 96];
elseif contains(dataT.animal,'WV')
    bottomRow = [2 81 85 88 90 92 93 96 10 83];
else
    bottomRow = [83 85 88 90 92 93 96];
end

location = determineComputer;
[~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(dataT);

for dt = 1:numDots
    for dx = 1:numDxs
        
        conNdx = (dataT.type == 1);
        radNdx = (dataT.type == 2);
        cohNdx = (dataT.coh == 1);
        
        figure
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1500 1200])
        set(gcf,'PaperOrientation','Landscape');
        
        for ch = 1:96
            if dataT.goodCh(ch) == 1
                dotNdx = (dataT.numDots == dots(dt));
                dxNdx  = (dataT.dx == dxs(dx));
                subplot(dataT.amap,10,10,ch)
                hold on;
                
                blankResp = nanmean(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
                radResp = nanmean(smoothdata(dataT.bins((radNdx & cohNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
                conResp = nanmean(smoothdata(dataT.bins((conNdx & cohNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
                noiseResp = nanmean(smoothdata(dataT.bins(((dataT.coh == 0) & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
                
                a = plot(1:35,blankResp,'k','LineWidth',0.75);
                n = plot(1:35,noiseResp,'color',[1 0.5 0.1 0.7],'LineWidth',1);
                r = plot(1:35,radResp,'color',[0 0.7 0.2 .7],'LineWidth',1);
                c = plot(1:35,conResp,'color',[0.7 0 0.7 0.7],'LineWidth',1);
                
                yMax = max([a.YData, c.YData, n.YData r.YData])+2;
                y = get(gca,'YLim');
                yMax = max(y);
                
                title(sprintf('%d',ch))
                
                if  ismember(ch,bottomRow)
                    set(gca,'Color','none','tickdir','out')
                else
                    set(gca,'Color','none','tickdir','out','XTickLabel',[]);
                end
            end
            
        end
        if contains(dataT.animal,'XT')
            nsubplot(10,10,10,10);
        else
            nsubplot(10,10,1,1);
        end
        axis off
        text(0,0.2,'baseline','Color',[0 0 0],'FontWeight','bold','FontSize',12)
        text(0,0.5,'noise','Color',[1 0.5 0.1],'FontWeight','bold','FontSize',12)
        text(0,0.8,'radial','Color',[0 0.6 0.2],'FontWeight','bold','FontSize',12)
        text(0,1.1,'concentric','Color',[0.7 0 0.7],'FontWeight','bold','FontSize',12)
        
        theseDots = dots(dt);
        theseDxs = dxs(dx);
        
        if contains(dataT.programID,'Small')
            suptitle({(sprintf('%s %s %s Glass 4 degree stim vs blank vs noise raw data', dataT.animal, dataT.eye, dataT.array));...
                (sprintf('%d dots %.2f dx coh 100',(theseDots),(theseDxs)))})
            figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTH4Deg_raw_50to250_dots',num2str(theseDots),'_dx',num2str(theseDxs),'.pdf'];
        else
            suptitle({(sprintf('%s %s %s Glass 8 degree stim vs blank vs noise raw data', dataT.animal, dataT.eye, dataT.array));...
                (sprintf('%d dots %.2f dx coh 100',(theseDots),(theseDxs)))})
            figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTH8Deg_raw_50to250_dots',num2str(theseDots),'_dx',num2str(theseDxs),'.pdf'];
        end
        %% save figure
        
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/PSTH/%s/byParam/',dataT.animal,dataT.programID,dataT.array,dataT.eye);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/PSTH/%s/byParam/',dataT.animal,dataT.programID,dataT.array,dataT.eye);
        end
    end
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    cd(figDir)
    print(gcf, figName,'-dpdf','-fillpage')
end
