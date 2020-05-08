function []=triplotTests(dataT)
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
%%
figure (7)
clf
clc
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 900]);

% radDps = squeeze(dataT.radBlankDprime(end,:,:,:));
% conDps = squeeze(dataT.conBlankDprime(end,:,:,:));
% nosDps = squeeze(dataT.noiseBlankDprime(:,:,:));

% radMax = max(radDps(:));
% conMax = max(conDps(:));
% nosMax = max(nosDps(:));
% 
% dps = [radMax,conMax,nosMax];

% dpMax = max(dps(:))+0.2;
% dpMin = min(dps(:))-0.2;
% %clim = linspace(0, dpMax, 96);
% cmaplarge = (gray(110));
% cmap = flipud(cmaplarge(1:96,:));

ndx = 1;
for dt = 1:numDots
    for dx = 1:numDxs
        
        radDps = squeeze(dataT.radBlankDprime(end,dt,dx,:));
        conDps = squeeze(dataT.conBlankDprime(end,dt,dx,:));
        nosDps = squeeze(dataT.noiseBlankDprime(dt,dx,:));
        
        dps = abs([radDps,conDps,nosDps]);
        nGoodCh = sum(dataT.goodCh);
        dpSort = sortrows(dps);
        dpNoNan = dpSort(1:nGoodCh,:);
        
%         dpMax = max(dps(:))+0.2;
%         dpMin = min(dps(:))-0.2;
%         %clim = linspace(0, dpMax, 96);
%         cmaplarge = (gray(110));
%         cmap = flipud(cmaplarge(1:96,:));
        
%         sortDPs = sortrows(dps);
%         pointSize = 20.*ones(size(nosDps));        
        
        subplot(2,2,ndx)
        hold on
        triplotter_BNB(dpNoNan(:,1),dpNoNan(:,2),dpNoNan(:,3), 'Radial', 'Concentric','Bipole');
        title(sprintf('%d dots, dx %.2f',dots(dt),dxs(dx)))
       
        ndx = ndx+1;
    end
end
suptitle({'Triplot using triplotter with absolute value'; sprintf('%s %s %s stimulus vs blank dPrime at 100%% coherence',dataT.animal, dataT.eye, dataT.array)})

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_triplot_abs'];
print(gcf, figName,'-dpdf','-fillpage')


%% triplotter_stereo with absolute value
figure(12)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 900]);

% radDps = squeeze(dataT.radBlankDprime(end,:,:,:));
% conDps = squeeze(dataT.conBlankDprime(end,:,:,:));
% nosDps = squeeze(dataT.noiseBlankDprime(:,:,:));
% 
% radMax = max(radDps(:));
% conMax = max(conDps(:));
% nosMax = max(nosDps(:));
% 
% dps = [radMax,conMax,nosMax];
% 
% dpMax = max(dps(:))+0.2;
% dpMin = min(dps(:))-0.2;
% %clim = linspace(0, dpMax, 96);
% cmaplarge = (gray(110));
% cmap = flipud(cmaplarge(1:96,:));

ndx = 1;
for dt = 1:numDots
    for dx = 1:numDxs
        
        radDps = abs(squeeze(dataT.radBlankDprime(end,dt,dx,:)));
        conDps = abs(squeeze(dataT.conBlankDprime(end,dt,dx,:)));
        nosDps = abs(squeeze(dataT.noiseBlankDprime(dt,dx,:)));
        
        dps = [radDps,conDps,nosDps];
%         dpMax = max(dps(:))+0.2;
%         dpMin = min(dps(:))-0.2;
%         %clim = linspace(0, dpMax, 96);
%         cmaplarge = (gray(110));
%         cmap = flipud(cmaplarge(1:96,:));
%         
%         sortDPs = sortrows(dps);
%         pointSize = 20.*ones(size(nosDps));        
        
        subplot(2,2,ndx)
        hold on
        triplotter_stereo_Glass(dps);
        title(sprintf('%d dots, dx %.2f',dots(dt),dxs(dx)))
       
        ndx = ndx+1;
    end
end
suptitle({'Triplot using triplotter stereo absolute value'; sprintf('%s %s %s stimulus vs blank dPrime at 100%% coherence',dataT.animal, dataT.eye, dataT.array)})
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_triplotStereo_abs'];
print(gcf, figName,'-dpdf','-fillpage')