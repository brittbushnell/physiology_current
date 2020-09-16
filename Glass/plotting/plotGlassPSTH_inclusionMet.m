function plotGlassPSTH_inclusionMet(dataT)
%%
location = determineComputer;

%%
if location == 0
    
    figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank/good/inclusion/',dataT.animal, dataT.programID, dataT.array,dataT.eye);
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
else
    figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank/good/inclusion/',dataT.animal, dataT.programID, dataT.array,dataT.eye);
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
end
cd(figDir)
%% plot PSTH
figure(3);
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 900])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    
    subplot(dataT.amap,10,10,ch)
    hold on;
    
    blankResp = mean(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(dataT.bins((dataT.numDots > 0), 1:35 ,ch),'gaussian',3))./0.01;
    
    if dataT.responsiveCh(ch) == 1 &&  dataT.splitHalfSigChs(ch) == 1
    plot(1:35,blankResp,'b','LineWidth',0.5);
    plot(1:35,stimResp,'b','LineWidth',2);
    else
    plot(1:35,blankResp,'-','LineWidth',0.5,'color',[0.6 0.6 0.6]);
    plot(1:35,stimResp,'-','LineWidth',1.5,'color',[0.6 0.6 0.6]);
    end

    
    title(ch)
    set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[]);
    
end

suptitle({(sprintf('%s %s %s %s %s run %s', dataT.animal, dataT.eye,dataT.array,dataT.programID,dataT.date,dataT.runNum));...
    'blue channels passed both permutation tests'})
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTH_includeChs_',dataT.date2,'_',dataT.runNum,'.pdf'];

print(gcf, figName,'-dpdf','-bestfit')


