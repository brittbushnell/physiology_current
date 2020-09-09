function [] = plotRadialPSTH_rawVsClean(cleanData,filename)
location = determineComputer;

%% now do the same for the raw data
rawName = strrep(filename,'_thresh35','');
rawData = load(rawName);

% all of the other unique parameters are stored in the file name and need
% to be parsed out.
for i = 1:length(rawData.filename)
    [name, rf, rad, mod, ori, sf] = parseRFName(rawData.filename(i,:));
    
    rawData.rf(i,1)  = rf;
    rawData.amplitude(i,1) = mod;
    rawData.orientation(i,1) = ori;
    rawData.spatialFrequency(i,1) = sf;
    rawData.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
    %         name  = char(name);
    %         rawData.name(i,:) = name;
end
%% plot stim vs blank PSTH to look for timing funkiness
if location == 0
    figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/radialFrequency/%s/PSTH/%s/stimVblank',cleanData.animal, cleanData.array,eye);
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
else
    figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/radialFrequency/%s/PSTH/%s/stimVblank',cleanData.animal,cleanData.array,eye);
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
    
    blankResp = mean(smoothdata(cleanData.bins((cleanData.rf == 10000), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(cleanData.bins((cleanData.rf ~= 10000), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'b','LineWidth',0.5);
    plot(1:35,stimResp,'b','LineWidth',2);
    
    
    blankResp = mean(smoothdata(rawData.bins((rawData.rf == 10000), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(rawData.bins((rawData.rf ~= 10000), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'r','LineWidth',0.5);
    plot(1:35,stimResp,'r','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[]);
    
end
suptitle({(sprintf('%s %s %s radial frequency %s run %s', cleanData.animal, cleanData.eye,cleanData.array,cleanData.date,cleanData.runNum));...
    'blue: cleaned  red: raw'})

figName = [cleanData.animal,'_',cleanData.eye,'_',cleanData.array,'_radialFrequency_PSTH_',cleanData.date2,'_',cleanData.runNum,'.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
