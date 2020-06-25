function [] = plotMappingPSTHs_visualResponsesChs(dataT,useGoodCh)
% Plot PSTHs for map noise programs combining across all locations and
% sitmuli

xPos = unique(dataT.pos_x);
yPos = unique(dataT.pos_y);
yPos = sort(yPos,'descend');

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
    for y = 1:numYs
        for x = 1:numXs
            xNdx = (dataT.pos_x == xPos(x));
            yNdx = (dataT.pos_y == yPos(y));
            blankResp(y,x,ch,:) = nanmean(smoothdata(dataT.bins(blankNdx, 1:35 ,ch),'gaussian',3))./0.01;
            stimResp(y,x,ch,:) = nanmean(smoothdata(dataT.bins(stimNdx & xNdx & yNdx, 1:35 ,ch),'gaussian',3))./0.01;
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
    if ~isnan(yMax)
        ndx = 1;
        for y = 1:numYs
            for x = 1:numXs
                
                subplot(numYs,numXs,ndx)
                hold on;
                bR = squeeze(blankResp(y,x,ch,:));
                sR = squeeze(stimResp(y,x,ch,:));
                
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
                ylim([0 yMax])
                plot([unique(dataT.stimOn)/10,unique(dataT.stimOn)/10],[0,yMax],'k:')
                plot([unique(dataT.stimOff)/10,unique(dataT.stimOff)/10],[0,yMax],'k:')
                t = title(sprintf('(%d,%d)',xPos(x),yPos(y)));
                t.Position(2) = t.Position(2)-(yMax/10);
                
                set(gca,'Color','none','tickdir','out','FontAngle','italic',...
                    'XTick',[0,unique(dataT.stimOn)/10,unique(dataT.stimOff)/10],'XTickLabel',{'on','off','on'},...
                    'TickLength',[0.03, 0.25]);
                
                ndx = ndx+1;
            end
        end

suptitle({(sprintf('%s %s %s stim vs blank by locations ch', dataT.animal,dataT.eye, dataT.array,ch)),...
    sprintf('%s fixation at (%d,%d)',dataT.date, unique(dataT.fix_x),unique(dataT.fix_y))});
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTHstimVBlank_ch',num2str(ch)];
        print(gcf, figName,'-dpdf','-fillpage')
    end
end
%% all channels
cd ../
figure(8);
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 600])
set(gcf,'PaperOrientation','Landscape');
chResp = squeeze(mean(stimResp(:,:,:,:),3));
yMax = max(chResp(:));
yMax = yMax +(yMax*.75);

ndx = 1;
for y = 1:numYs
    for x = 1:numXs
        
        subplot(numYs,numXs,ndx)
        hold on;
        bR = squeeze(mean(blankResp(y,x,:,:),3));
        sR = squeeze(mean(stimResp(y,x,:,:),3));
        
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
        plot([unique(dataT.stimOn)/10,unique(dataT.stimOn)/10],[0,yMax],'k:')
        plot([unique(dataT.stimOff)/10,unique(dataT.stimOff)/10],[0,yMax],'k:')
        
        ylim([0 yMax])
        t = title(sprintf('(%d,%d)',xPos(x),yPos(y)));
        t.Position(2) = t.Position(2)-(yMax/10);
        
        set(gca,'Color','none','tickdir','out','FontAngle','italic','TickLength',[0.03, 0.25],...
            'XTick',[0,unique(dataT.stimOn)/10,unique(dataT.stimOff)/10],'XTickLabel',{'on','off','on'},...
            'YTick',[0,round(yMax/2),round(yMax)]);
        
        ndx = ndx+1;
    end
end
suptitle({(sprintf('%s %s %s stim vs blank by locations all chs', dataT.animal,dataT.eye, dataT.array)),...
    sprintf('%s fixation at (%d,%d)',dataT.date, unique(dataT.fix_x),unique(dataT.fix_y))});
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTHstimVBlank_allch_',num2str(dataT.date2)];
print(gcf, figName,'-dpdf','-fillpage')


