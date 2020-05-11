function [] = plotGlass3D_dPrimesVblank_grayScale(dataT)
%%
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
%% plot absolute value of d' on cartesian 3d axes with gray scaled markers
[~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(dataT);

radDpsAll = squeeze(dataT.radBlankDprime(end,:,:,:));
conDpsAll = squeeze(dataT.conBlankDprime(end,:,:,:));
nosDpsAll = squeeze(dataT.noiseBlankDprime(:,:,:));

radMax = max(radDpsAll(:));
conMax = max(conDpsAll(:));
nosMax = max(nosDpsAll(:));

dpMaxsAll = [conMax,radMax,nosMax];

dpMaxAll = max(dpMaxsAll(:))+0.2;
%dpMinAll = min(dpMaxsAll(:))-0.2;
%clim = linspace(0, dpMax, 96);

cmaplarge = (gray(110));
cmap = flipud(cmaplarge(1:96,:));



figure(8)
clf
pause(0.02)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1000]);
ndx = 1;

for dt = 1:numDots
    for dx = 1:numDxs
        radDps = abs(squeeze(dataT.radBlankDprime(end,dt,dx,:)));
        conDps = abs(squeeze(dataT.conBlankDprime(end,dt,dx,:)));
        nosDps = abs(squeeze(dataT.noiseBlankDprime(dt,dx,:)));
        
        dps = [conDps,radDps,nosDps];
        dpMax = max(dps(:))+0.2;
        dpMin = min(dps(:))-0.2;
        cmaplarge = (gray(110));
        cmap = flipud(cmaplarge(1:96,:));
        
        sortDPs = sortrows(dps);
        pointSize = 30.*ones(size(nosDps));
        
        subplot(2,2,ndx)
        hold on
        scatter3(sortDPs(:,2),sortDPs(:,3),sortDPs(:,1),pointSize,cmap,'filled'); % organized to match axes of the triplot figs
        colormap(cmap)
        %         colorbar('Ticks',0:0.25:1,'TickLabels',{'0','0.57','1.15','1.72','2.3'})
%        h = colorbar('Ticks',[],'Location','north');
%         h.Position
%         h.Position(3) = h.Position(3)-0.001;
%         h.Position(4) = h.Position(4)-0.05;
%         h2 = h.Position
        
        zlabel('Concentric')
        xlabel('Radial')
        ylabel('Dipole')
        title(sprintf('%d dots, dx %.2f',dots(dt),dxs(dx)))
        
        xlim([0 dpMaxAll])
        ylim([0 dpMaxAll])
        zlim([0 dpMaxAll])
        
        set(gca,'XTick',0:1:round(dpMax),'YTick',0:1:round(dpMaxAll),'ZTick',0:1:round(dpMaxAll),...
         'XGrid','on','YGrid','on','ZGrid','on')
        
        view(3)
        axis square
        
        ndx = ndx+1;
    end
end
suptitle({'Relative dPrimes against blank for concentric, radial, and random dipole Glass patterns';...
    sprintf('%s %s %s stimulus vs blank dPrime at 100%% coherence',dataT.animal, dataT.eye, dataT.array)})

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_triplot_abs'];
print(gcf, figName,'-dpdf','-fillpage')