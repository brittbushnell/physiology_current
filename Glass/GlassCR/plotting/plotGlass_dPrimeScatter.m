function [] = plotGlass_dPrimeScatter(data)

for ch = 1:96
    REgch = data.RE.goodCh(1,ch);
    LEgch =  data.LE.goodCh(1,ch);
    tmp = REgch + LEgch;
    if tmp == 0
        data.RE.radBlankDprime(end,:,:,ch) = nan(2,2);
        data.RE.conBlankDprime(end,:,:,ch) = nan(2,2);
        data.RE.noiseBlankDprime(1,:,:,ch) = nan(2,2);
        
        data.LE.radBlankDprime(end,:,:,ch) = nan(2,2);
        data.LE.conBlankDprime(end,:,:,ch) = nan(2,2);
        data.LE.noiseBlankDprime(1,:,:,ch) = nan(2,2);
        
    else
        if data.RE.goodCh(1,ch) == 0
            data.RE.radBlankDprime(end,:,:,ch) = zeros(2,2);
            data.RE.conBlankDprime(end,:,:,ch) = zeros(2,2);
            data.RE.noiseBlankDprime(1,:,:,ch) = zeros(2,2);
        end
        if data.LE.goodCh(1,ch) == 0
            data.LE.radBlankDprime(end,:,:,ch) = zeros(2,2);
            data.LE.conBlankDprime(end,:,:,ch) = zeros(2,2);
            data.LE.noiseBlankDprime(1,:,:,ch) = zeros(2,2);
        end
    end
end
%%
figure(4)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 700 300])
set(gcf,'PaperOrientation','Landscape');

subplot(1,3,1)

a = reshape(data.LE.radBlankDprime,1,numel(data.LE.radBlankDprime));
b = reshape(data.RE.radBlankDprime,1,numel(data.RE.radBlankDprime));

hold on
plot(a,b,'o','markerfacecolor',[0 0.6 0.2],'markeredgecolor','w','MarkerSize',7)

plot([-2 5],[-2 5],'k')
title('Radial')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
if contains(data.RE.animal,'XT')
    xlabel('LE')
    ylabel('RE')
else
    xlabel('FE')
    ylabel('AE')
end


subplot(1,3,2)
a = reshape(data.LE.conBlankDprime,1,numel(data.LE.conBlankDprime));
b = reshape(data.RE.conBlankDprime,1,numel(data.RE.conBlankDprime));

hold on
plot(a,b,'o','markerfacecolor',[0.7 0 0.7],'markeredgecolor','w','MarkerSize',7)
plot([-2 5],[-2 5],'k')
title('Concentric')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square


subplot(1,3,3)
a = reshape(data.LE.noiseBlankDprime,1,numel(data.LE.noiseBlankDprime));
b = reshape(data.RE.noiseBlankDprime,1,numel(data.RE.noiseBlankDprime));

hold on
plot(a,b,'o','markerfacecolor',[1 0.5 0.1],'markeredgecolor','w','MarkerSize',7)
plot([-2 5],[-2 5],'k')
title('Noise')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square

suptitle(sprintf('%s %s %s dPrimes for all dot, dx, coherence combinations',data.RE.animal, data.RE.programID, data.RE.array))
%%
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/dPrime/',data.RE.animal,data.RE.programID,data.RE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/dPrime/',data.RE.animal,data.RE.programID,data.RE.array);
end

if~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [data.RE.animal '_glassdPrimeScatters_',data.RE.array,'.pdf'];
set(gcf,'InvertHardCopy','off')
print(gcf, figName, '-dpdf', '-fillpage')
    