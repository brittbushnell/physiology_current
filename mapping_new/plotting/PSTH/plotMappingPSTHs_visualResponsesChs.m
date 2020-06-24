function [] = plotMappingPSTHs_visualResponsesChs(dataT,useGoodCh)
% Plot PSTHs for map noise programs combining across all locations and
% sitmuli

xPos = unique(dataT.pos_x);
yPos = unique(dataT.pos_y);
numXs = length(xPos);
numYs = length(yPos);
%%
location = determineComputer;
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

folder = 'byChannel';
mkdir(folder)
cd(sprintf('%s',folder))
%% get maximum responses for each channel
stimNdx = (dataT.stimulus == 1);
blankNdx = (dataT.stimulus == 0);

for ch = 1:96
    for x = 1:numXs
        for y = 1:numYs
            xNdx = (dataT.pos_x == xPos(x));
            yNdx = (dataT.pos_y == xPos(y));
            blankResp(x,y,ch,:) = nanmean(smoothdata(dataT.bins(blankNdx, 1:35 ,ch),'gaussian',3))./0.01;
            stimResp(x,y,ch,:) = nanmean(smoothdata(dataT.bins(stimNdx & xNdx & yNdx, 1:35 ,ch),'gaussian',3))./0.01;
        end
    end
end

%%
if useGoodCh == 0
    goodCh = ones(1,96);
end
for ch = 1:96
    figure(3);
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 600])
    set(gcf,'PaperOrientation','Landscape');
    chResp = squeeze(stimResp(:,:,ch,:));
    yMax = max(chResp(:));
    yMax = yMax +(yMax*.75);
    
    ndx = 1;
    for x = 1:numXs
        for y = 1:numYs           
            
            subplot(numXs,numYs,ndx)
            hold on;
            bR = squeeze(blankResp(x,y,ch,:));
            sR = squeeze(stimResp(x,y,ch,:));
            
            if goodCh == 1
                if contains(dataT.animal,'XT')
                    if contains(dataT.eye,'RE')
                        plot(1:35,bR,'color',[0.14 0.63 0.42 0.7],'LineWidth',0.5);
                        plot(1:35,sR,'color',[0.14 0.63 0.42 0.8],'LineWidth',2);
                    else
                        plot(1:35,bR,'color',[0.3 0.3 0.3 0.9],'LineWidth',0.5);
                        plot(1:35,sR,'color',[0.3 0.3 0.3 0.9],'LineWidth',2);
                    end
                else
                    if contains(dataT.eye,'RE')
                        plot(1:35,bR,'color',[1 0 0 0.7],'LineWidth',0.5);
                        plot(1:35,sR,'color',[1 0 0 0.8],'LineWidth',2);
                    else
                        plot(1:35,bR,'color',[0 0.2 1 0.7],'LineWidth',0.5);
                        plot(1:35,sR,'color',[0 0.2 1 0.8],'LineWidth',2);
                    end
                end
                
            else
                if contains(dataT.animal,'XT')
                    if contains(dataT.eye,'RE')
                        plot(1:35,bR,'color',[0.14 0.63 0.42 0.4],'LineWidth',0.5);
                        plot(1:35,sR,'color',[0.14 0.63 0.42 0.6],'LineWidth',2);
                    else
                        plot(1:35,bR,'color',[0.3 0.3 0.3 0.6],'LineWidth',0.5);
                        plot(1:35,sR,'color',[0.3 0.3 0.3 0.6],'LineWidth',2);
                    end
                else
                    if contains(dataT.eye,'RE')
                        plot(1:35,bR,'color',[1 0 0 0.4],'LineWidth',0.5);
                        plot(1:35,sR,'color',[1 0 0 0.3],'LineWidth',2);
                    else
                        plot(1:35,bR,'color',[0 0.2 1 0.4],'LineWidth',0.5);
                        plot(1:35,sR,'color',[0 0.2 1 0.3],'LineWidth',2);
                    end
                end
            end
            title(sprintf('(%d,%d)',xPos(x),yPos(y)))

            set(gca,'Color','none','tickdir','out','FontAngle','italic',...
                'XTick',[0,unique(dataT.stimOn)/10,unique(dataT.stimOff)/10],'XTickLabel',{'on','off','on'},...
                'TickLength',[0.03, 0.25]);
            ylim([0 yMax])
            ndx = ndx+1;
        end
    end
    suptitle((sprintf('%s %s %s stim vs blank all locations ch %d', dataT.animal,dataT.eye, dataT.array,ch)));
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTHstimVBlank_ch',num2str(ch)];
    print(gcf, figName,'-dpdf','-fillpage')
end



