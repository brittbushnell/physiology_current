function [locPair] = plotRadFreqLoc_relRFs(dataT)

%% get receptive fields
dataT = callReceptiveFieldParameters(dataT);

if contains(dataT.animal,'XT')
    rfParams = dataT.chReceptiveFieldParamsBE;
else
    rfParams = dataT.chReceptiveFieldParams;
end
%% plot receptive fields relative to stimulus locations
xPoss = unique(dataT.pos_x);
yPoss = unique(dataT.pos_y);
locPair = nan(1,2);

for xs = 1:length(xPoss)
    for ys = 1:length(yPoss)
        flerp = sum((dataT.pos_x == xPoss(xs)) & (dataT.pos_y == yPoss(ys)));
        if flerp >1
            locPair(end+1,:) = [xPoss(xs), yPoss(ys)];
        end
    end
end
locPair = locPair(2:end,:);

figure(2)
% clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 500, 500],'PaperSize',[5,5])

s = suptitle(sprintf('%s %s %s receptive fields relative to radial frequency locations',dataT.animal, dataT.eye, dataT.array));
s.FontSize = 14;
s.FontWeight = 'bold';

hold on

xlim([-10 10])
ylim([-10 10])

set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both')
grid on

for ch = 1:96
    if contains(dataT.eye,'RE') || contains(dataT.eye,'AE')
        scatter(rfParams{ch}(1),rfParams{ch}(2),'r','filled')
    else
        scatter(rfParams{ch}(1),rfParams{ch}(2),'b','filled')
    end
end

viscircles([locPair(1,1),locPair(1,2)],2,...
    'color',[0.2 0.2 0.2],'LineWidth',0.5);
viscircles([locPair(2,1),locPair(2,2)],2,...
    'color',[0.2 0.2 0.2],'LineWidth',0.5);
viscircles([locPair(3,1),locPair(3,2)],2,...
    'color',[0.2 0.2 0.2],'LineWidth',0.5);

plot(0,0,'ko','MarkerFaceColor','k')

%%
location = determineComputer;
if location == 1
    if contains(dataT.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/receptiveFields',dataT.animal,dataT.array);
    elseif contains(dataT.programID,'low','IgnoreCase',true)
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/receptiveFields',dataT.animal,dataT.array);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/receptiveFields',dataT.animal,dataT.array);
    end
elseif location == 0
    if contains(dataT.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/receptiveFields',dataT.animal,dataT.array);
    elseif contains(dataT.programID,'low','IgnoreCase',true)
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/receptiveFields',dataT.animal,dataT.array);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/receptiveFields',dataT.animal,dataT.array);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RFrel_',dataT.programID,'.pdf'];
print(gcf, figName,'-dpdf','-bestfit')