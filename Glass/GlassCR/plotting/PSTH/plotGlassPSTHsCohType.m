function [] = plotGlassPSTHsCohType(dataT)
location = determineComputer;
[~,~,~,numCoh,~,~,~,~,coherences,~] = getGlassParameters(dataT);
%% save location
if contains(dataT.animal,'WV')
    if contains(dataT.programID,'Small')
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/4Deg/PSTH/%s/coherences',dataT.animal,dataT.array,dataT.eye);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/4Deg/PSTH/%s/coherences',dataT.animal,dataT.array,dataT.eye);
        end
    else
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/8Deg/PSTH/%s/coherences',dataT.animal,dataT.array,dataT.eye);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/8Deg/PSTH/%s/coherences',dataT.animal,dataT.array,dataT.eye);
        end
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/PSTH/%s/coherences',dataT.animal,dataT.array,dataT.eye);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/PSTH/%s/coherences',dataT.animal,dataT.array,dataT.eye);
    end
end
cd(figDir)

% go to date specific folder, if it doesn't exist, make it
folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))
%% plot concentric coherences
if contains(dataT.animal,'WU')
    bottomRow = [81 83 85 88 90 92 93 96];
elseif contains(dataT.animal,'WV')
    bottomRow = [2 81 85 88 90 92 93 96 10 83];
else
    bottomRow = [83 85 88 90 92 93 96];
end
%%
figure (3)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1500 1200])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    
    subplot(dataT.amap,10,10,ch)
    hold on;
    if dataT.goodCh(ch) == 1
        ndx = 0.2;
        for co = 1:numCoh
            cohNdx = (dataT.coh == coherences(co));
            concNdx = (dataT.type == 1);
            blankNdx = (dataT.numDots == 0);
            dotNdx = (dataT.numDots == 200);
            dxNdx = (dataT.dx == 0.03);
            noiseNdx = (dataT.coh == 0);
            
            
            blankResp = nanmean(smoothdata(dataT.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
            glassResp = nanmean(smoothdata(dataT.bins((cohNdx & concNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
            noiseResp = nanmean(smoothdata(dataT.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
            
            c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.8],'LineWidth',1);
            b = plot(1:35,glassResp,'color',[0.5 0 0.5 ndx],'LineWidth',1);
            a = plot(1:35,blankResp,'color',[0 0 0 0.8],'LineWidth',1);
            
            yMax = max([a.YData, b.YData, c.YData])+2;
            
            title(sprintf('%d', ch))
            
            if  ismember(ch,bottomRow)
                set(gca,'Color','none','tickdir','out','FontSize',8)
            else
                set(gca,'Color','none','tickdir','out','XTick',[],'FontSize',8);
            end
            ndx = ndx + .2;
        end
        suptitle(sprintf('%s %s %s concentric Glass patterns across coherences',dataT.animal, dataT.array, dataT.eye))
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTH_concCoh_',num2str(coherences(co))*100,'.pdf'];
        print(gcf, figName,'-dpdf','-fillpage')
        %         if dataT.conNoiseSelective(ch) == 1
        %             plot(3,yMax,'*k','MarkerSize',7)
        %         end
    else
        axis off
    end
end


%% plot high radial vs noise
figure (4)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1500 1200])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    
    subplot(dataT.amap,10,10,ch)
    hold on;
    if dataT.goodCh(ch) == 1
        cohNdx = (dataT.coh == 1);
        radNdx = (dataT.type == 2);
        blankNdx = (dataT.numDots == 0);
        dotNdx = (dataT.numDots == 200);
        dxNdx = (dataT.dx == 0.03);
        
        
        blankResp = nanmean(smoothdata(dataT.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
        glassResp = nanmean(smoothdata(dataT.bins((cohNdx & radNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
        noiseResp = nanmean(smoothdata(dataT.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
        
        c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.8],'LineWidth',1);
        b = plot(1:35,glassResp,'color',[0 0.6 0.2 ndx],'LineWidth',1);
        a = plot(1:35,blankResp,'color',[0 0 0 0.8],'LineWidth',1);
        
        yMax = max([a.YData, b.YData, c.YData])+2;
        
        title(sprintf('%d', ch))
        
        if  ismember(ch,bottomRow)
            set(gca,'Color','none','tickdir','out','FontSize',8)
        else
            set(gca,'Color','none','tickdir','out','XTick',[],'FontSize',8);
        end
        %         if dataT.radNoiseSelective(ch) == 1
        %             plot(3,yMax,'*k','MarkerSize',12)
        %         end
    else
        axis off
    end
end

suptitle(sprintf('%s %s %s radial 100%% Glass pattern vs noise',dataT.animal, dataT.array, dataT.eye))
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTH_sigRad'];
print(gcf, figName,'-dpdf','-fillpage')
%% plot radial coherence
figure (5)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1500 1200])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    
    subplot(dataT.amap,10,10,ch)
    hold on;
    if dataT.goodCh(ch) == 1
        ndx = 0.2;
        for co = 1:numCoh
            cohNdx = (dataT.coh == coherences(co));
            radNdx = (dataT.type == 2);
            blankNdx = (dataT.numDots == 0);
            dotNdx = (dataT.numDots == 200);
            dxNdx = (dataT.dx == 0.03);
            
            
            blankResp = nanmean(smoothdata(dataT.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
            glassResp = nanmean(smoothdata(dataT.bins((cohNdx & radNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
            noiseResp = nanmean(smoothdata(dataT.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
            
            c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.8],'LineWidth',1);
            b = plot(1:35,glassResp,'color',[0 0.6 0.2 ndx],'LineWidth',1);
            a = plot(1:35,blankResp,'color',[0 0 0 0.8],'LineWidth',1);
            
            yMax = max([a.YData, b.YData, c.YData])+2;
            
            title(sprintf('%d', ch))
            
            if  ismember(ch,bottomRow)
                set(gca,'Color','none','tickdir','out','FontSize',8)
            else
                set(gca,'Color','none','tickdir','out','XTick',[],'FontSize',8);
            end
            ndx = ndx + .2;
        end
        suptitle(sprintf('%s %s %s radial Glass patterns across coherences',dataT.animal, dataT.array, dataT.eye))
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTH_radCoh_',num2str(coherences(co))*100,'.pdf'];
        print(gcf, figName,'-dpdf','-fillpage')
        %         if dataT.radNoiseSelective(ch) == 1
        %             plot(3,yMax,'*k','MarkerSize',12)
        %         end
    else
        axis off
    end
end
%% high coherence concentric vs radial vs noise
[~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(dataT);
for dt = 1:numDots
    for dx = 1:numDxs
        figure (6)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1500 1200])
        set(gcf,'PaperOrientation','Landscape');
        for ch = 1:96
            subplot(dataT.amap,10,10,ch)
            hold on;
            if dataT.goodCh(ch) == 1
                cohNdx = (dataT.coh == 1);
                concNdx = (dataT.type == 1);
                radNdx = (dataT.type == 2);
                blankNdx = (dataT.numDots == 0);
                dotNdx = (dataT.numDots == dots(dt));
                dxNdx = (dataT.dx == dxs(dx));
                noiseNdx = (dataT.coh == 0);
                
                
                blankResp = nanmean(smoothdata(dataT.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
                glassResp = nanmean(smoothdata(dataT.bins((cohNdx & concNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
                radResp = nanmean(smoothdata(dataT.bins((cohNdx & radNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
                noiseResp = nanmean(smoothdata(dataT.bins((noiseNdx & dotNdx & dxNdx), 1:35 ,ch),'gaussian',3))./0.01;
                
                c = plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',1);
                b = plot(1:35,glassResp,'color',[0.5 0 0.5 0.7],'LineWidth',1);
                a = plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',1);
                r = plot(1:35,radResp,'color',[0 0.6 0.2 0.7],'LineWidth',1);
                
                yMax = max([a.YData, b.YData, c.YData, r.YData])+2;
                
                title(sprintf('%d', ch))
                
                if  ismember(ch,bottomRow)
                    set(gca,'Color','none','tickdir','out','FontSize',8)
                else
                    set(gca,'Color','none','tickdir','out','XTick',[],'FontSize',8);
                end
                %         if dataT.conNoiseSelective(ch) == 1
                %             plot(3,yMax,'*k','MarkerSize',7)
                %         end
            else
                axis off
            end
        end
        suptitle({sprintf('%s %s %s full coherence Glass pattern %d dots dx %.2f',dataT.animal, dataT.array, dataT.eye, dots(dt),dxs(dx));...
            ('concentric: purple  radial: green  dipole: orange')})
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTH_fullCoh_dots',num2str(dots(dt)),'_dx',num2str(dxs(dx)),'.pdf'];
        print(gcf, figName,'-dpdf','-fillpage')
    end
end
