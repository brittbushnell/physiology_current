function [] = plotGlass_GlassRankingsDistBlank(dataT)
%%
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/prefStim/%s/',dataT.animal,dataT.programID, dataT.array, dataT.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/prefStim/%s/',dataT.animal, dataT.programID, dataT.array, dataT.eye);
end
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
[~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(dataT);

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 900]);

for dt = 1:numDots
    for dx = 1:numDxs
        
        ranks = dataT.dPrimeRankBlank{dt,dx};
        
        con1st = sum(ranks(1,:) == 1);
        rad1st = sum(ranks(2,:) == 1);
        noise1st = sum(ranks(3,:) == 1);
        numSig = (con1st+rad1st+noise1st);
        
        conProp = con1st/numSig;
        radProp = rad1st/numSig;
        noiseProp = noise1st/numSig;
        
        nsubplot(2,2,dt,dx);
        
        hold on
        bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
        bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
        bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')
        
        ylim([0 0.8])
        xlim([0.5, 3])
        
        set(gca,'XTick',[1, 1.75 2.5],'XTickLabel',{'concentric','radial','dipole'})
        xtickangle(45)
        
        ylabel('proportion of channels')
        title({sprintf('%d dots, %.2f dx',dots(dt),dxs(dx));sprintf('%d significant channels',numSig)})
    end
end
suptitle(sprintf('%s %s %s preferred Glass patterns vs blank',dataT.animal, dataT.eye, dataT.array))
%%
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_prefGlassVblank'];
print(gcf, figName,'-dpdf','-fillpage')
%%
% [~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(dataT);
%
% figure(2)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 1000 900]);
%
% for dt = 1:numDots
%     for dx = 1:numDxs
%
%         ranks = dataT.dPrimeRankBlank{dt,dx};
%
%         con1st = sum(ranks(1,:) == 1);
%         rad1st = sum(ranks(2,:) == 1);
%         noise1st = sum(ranks(3,:) == 1);
%         numSig = (con1st+rad1st+noise1st);
%
%         conProp = con1st/numSig;
%         radProp = rad1st/numSig;
%         noiseProp = noise1st/numSig;
%
%         conSig2 = squeeze(dataT.numConSigComps(dt,dx,:));
%         radSig2 = squeeze(dataT.numRadSigComps(dt,dx,:));
%         nosSig2 = squeeze(dataT.numNoiseSigComps(dt,dx,:));
%
%         numCon = sum(conSig2);
%         numRad = sum(radSig2);
%         numNos = sum(nosSig2);
%
%         stimProps(1,:) = conSig2;%./numCon;
%         stimProps(2,:) = radSig2;%./numRad;
%         stimProps(3,:) = nosSig2;%./numNos;
%
%         nsubplot(2,2,dt,dx);
%
%         hold on
%         grays = colormap(gray(4));
%         nsubplot(2,2,dt,dx);
%         hold on
%
%         b = bar(stimProps,0.95,'stacked');
%         for i = 1:length(b)
%             b(i).FaceColor = grays(i,:);
%         end
%
%         bar(1,con1st,0.95,'FaceColor','none','EdgeColor','k')
%         bar(2,rad1st,0.95,'FaceColor','none','EdgeColor','k')
%         bar(3,noise1st,0.95,'FaceColor','none','EdgeColor','k')
%
%         legend('0','1','2','3')
%         legend('boxoff')
%
%         ylim([0 sum(dataT.goodCh)])
%         %xlim([0.5, 3])
%
%         set(gca,'XTick',[1 2 3],'XTickLabel',{'concentric','radial','dipole'})
%         xtickangle(45)
%
%         ylabel('number of channels')
%         title({sprintf('%d dots, %.2f dx',dots(dt),dxs(dx));sprintf('%d significant channels',numSig)})
%     end
% end
% suptitle(sprintf('%s %s %s preferred Glass patterns vs blank and number of significant comparisons',dataT.animal, dataT.eye, dataT.array))
% %
% figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_prefGlassVblank_numSigComps'];
% print(gcf, figName,'-dpdf','-fillpage')