function plotMapNoisePSTH_rawVsClean (cleanData,filename)
%%
location = determineComputer;

%% get the raw data
rawName = strrep(filename,'_thresh35','');
if location == 1
    rawDir = sprintf('bushnell/Desktop/my_zemina_home/binned_dir/%s',cleanData.animal);
    rawName = fullfile(rawDir,rawName);
end
rawData = load(rawName);

rawData.stimulus = nan(1,size(rawData.filename,1));
for i = 1:size(rawData.filename,1)
    rawData.stimulus(1,i) = parseMapNoiseName(rawData.filename(i,:));
end
%% plot stim vs blank PSTH to look for timing funkiness
if location == 0
    figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank',cleanData.animal, cleanData.programID, cleanData.array,eye);
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
else
    figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank',cleanData.animal, cleanData.programID, cleanData.array,eye);
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
end
cd(figDir)
%% plot PSTH
figure(200);
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 900])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    
    subplot(cleanData.amap,10,10,ch)
    hold on;
    
    blankResp = mean(smoothdata(cleanData.bins((cleanData.stimulus == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(cleanData.bins((cleanData.stimulus ~= 0), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'b','LineWidth',0.5);
    plot(1:35,stimResp,'b','LineWidth',2);
    
    
    blankResp = mean(smoothdata(rawData.bins((rawData.stimulus == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(rawData.bins((rawData.stimulus ~= 0), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'r','LineWidth',0.5);
    plot(1:35,stimResp,'r','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[]);
    
end
suptitle({(sprintf('%s %s %s %s %s run %s', cleanData.animal, cleanData.eye,cleanData.array,cleanData.programID,cleanData.date,cleanData.runNum));...
    'blue: cleaned  red: raw'})

figName = [cleanData.animal,'_',cleanData.eye,'_',cleanData.array,'_',cleanData.programID,'_PSTH_',cleanData.date2,'_',cleanData.runNum,'.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
