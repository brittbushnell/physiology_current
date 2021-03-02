function plotGlassPSTH_rawVsClean (cleanData,filename,goodFlag)
%%
location = determineComputer;

%% now do the same for the raw data
rawName = strrep(filename,'_thresh35','');
rawName = strrep(rawName,'_ogcorrupt','');
rawData = load(rawName);
ndx = 1;
for i = 1:size(rawData.filename,1)
    [type, numDots, dx, coh, sample] = parseGlassName(rawData.filename(i,:));
    
    %  type: numeric versions of the first letter of the pattern type
    %     0:  noise
    %     1: concentric
    %     2: radial
    %     3: translational
    %     100:blank
    rawData.type(1,ndx)    = type;
    rawData.numDots(1,ndx) = numDots;
    rawData.dx(1,ndx)      = dx;
    rawData.coh(1,ndx)     = coh;
    rawData.sample(1,ndx)  = sample;
    ndx = ndx+1;
end
%% plot stim vs blank PSTH to look for timing funkiness
if location == 0
    if goodFlag == 1
        figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank/good/',cleanData.animal, cleanData.programID, cleanData.array,cleanData.eye);
    else
        figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank/bad/',cleanData.animal, cleanData.programID, cleanData.array,cleanData.eye);
    end
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
else
    if goodFlag == 1
        figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank/good/',cleanData.animal, cleanData.programID, cleanData.array,cleanData.eye);
    else
        figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank/bad/',cleanData.animal, cleanData.programID, cleanData.array,cleanData.eye);
    end
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
end
cd(figDir)
%% plot PSTH
figure(2);
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 900])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    
    subplot(cleanData.amap,10,10,ch)
    hold on;
    
    blankResp = mean(smoothdata(cleanData.bins((cleanData.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(cleanData.bins((cleanData.numDots > 0), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'b','LineWidth',0.5);
    plot(1:35,stimResp,'b','LineWidth',2);
    
    
    blankResp = mean(smoothdata(rawData.bins((rawData.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(rawData.bins((rawData.numDots > 0), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'r','LineWidth',0.5);
    plot(1:35,stimResp,'r','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[]);
    
end


if goodFlag == 1
    suptitle({(sprintf('%s %s %s %s %s run %s', cleanData.animal, cleanData.eye,cleanData.array,cleanData.programID,cleanData.date,cleanData.runNum));...
        'blue: cleaned  red: raw good file'})
    figName = [cleanData.animal,'_',cleanData.eye,'_',cleanData.array,'_',cleanData.programID,'_PSTH_good_',cleanData.date2,'_',cleanData.runNum,'.pdf'];
else
   suptitle({(sprintf('%s %s %s %s %s run %s', cleanData.animal, cleanData.eye,cleanData.array,cleanData.programID,cleanData.date,cleanData.runNum));...
        'blue: cleaned  red: raw bad file'})
    figName = [cleanData.animal,'_',cleanData.eye,'_',cleanData.array,'_',cleanData.programID,'_PSTH_bad_',cleanData.date2,'_',cleanData.runNum,'.pdf']; 
end
print(gcf, figName,'-dpdf','-bestfit')


