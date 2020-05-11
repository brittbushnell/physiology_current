function [] = plotGlass_triplotStereo_Black(dataT)
location = determineComputer;

if contains(dataT.animal,'WV')
    if location == 1
        if contains(dataT.programID,'Small')
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/4Deg/prefStim/%s/triplot',dataT.animal, dataT.array, dataT.eye);
        else
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/8Deg/prefStim/%s/triplot',dataT.animal, dataT.array, dataT.eye);
        end
    elseif location == 0
        if contains(dataT.programID,'Small')
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/4Deg/prefStim/%s/triplot',dataT.animal, dataT.array, dataT.eye);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/8Deg/prefStim/%s/triplot',dataT.animal, dataT.array, dataT.eye);
        end
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/prefStim/%s/triplot',dataT.animal, dataT.array, dataT.eye);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/prefStim/%s/triplot',dataT.animal, dataT.array, dataT.eye);
    end
end
cd(figDir)
%%
[~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(dataT);
%%
figure(7)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1000]);

ndx = 1;
for dt = 1:numDots
    for dx = 1:numDxs
        
        radDps = abs(squeeze(dataT.radBlankDprime(end,dt,dx,:)));
        conDps = abs(squeeze(dataT.conBlankDprime(end,dt,dx,:)));
        nosDps = abs(squeeze(dataT.noiseBlankDprime(dt,dx,:)));
        
        dps = [radDps,conDps,nosDps];     
        
        subplot(2,2,ndx)
        hold on
        triplotter_stereo_Glass(dps);
        title(sprintf('%d dots, dx %.2f',dots(dt),dxs(dx)))
       
        ndx = ndx+1;
    end
end
suptitle({'Relative dPrimes against blank for concentric, radial, and random dipole Glass patterns'; sprintf('%s %s %s stimulus vs blank dPrime at 100%% coherence',dataT.animal, dataT.eye, dataT.array)})
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_triplotStereo_abs'];
print(gcf, figName,'-dpdf','-fillpage')
