function [] = plotGlass_GlassRankingsDistBlank(dataT)
%%
location = determineComputer;

if contains(dataT.animal,'WV')
    if location == 1
        if contains(dataT.programID,'Small')
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/4Deg/prefStim/%s/',dataT.animal, dataT.array, dataT.eye);
        else
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/8Deg/prefStim/%s/',dataT.animal, dataT.array, dataT.eye);
        end
    elseif location == 0
        if contains(dataT.programID,'Small')
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/4Deg/prefStim/%s/',dataT.animal, dataT.array, dataT.eye);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/8Deg/prefStim/%s/',dataT.animal, dataT.array, dataT.eye);
        end
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/prefStim/%s/',dataT.animal, dataT.array, dataT.eye);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/prefStim/%s/',dataT.animal, dataT.array, dataT.eye);
    end
end
cd(figDir)
%%
[~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(dataT);

figure(6)
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
