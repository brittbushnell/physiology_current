function [dataT] = plotArrayReceptiveFields(dataT)

%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Mapping/%s/PSTH/',dataT.animal,dataT.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/Mapping/%s/PSTH/',dataT.animal,dataT.array);
end
cd(figDir)

% go to date specific folder, if it doesn't exist, make it
folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))
%%
xPos = unique(dataT.pos_x);
yPos = unique(dataT.pos_y);
%yPos = sort(yPos,'descend');

numXs = length(xPos);
numYs = length(yPos);
%%
stimNdx = (dataT.stimulus == 1);
blankNdx = (dataT.stimulus == 0);

for ch = 1:96
    for y = 1:numYs
        for x = 1:numXs
            xNdx = (dataT.pos_x == xPos(x));
            yNdx = (dataT.pos_y == yPos(y));
            blankResp(y,x,ch,:) = mean(smoothdata(dataT.bins(blankNdx, 1:35 ,ch),'gaussian',3))./0.01;
            stimResp(y,x,ch,:) = mean(smoothdata(dataT.bins(stimNdx & xNdx & yNdx, 1:35 ,ch),'gaussian',3))./0.01;
        end
    end
end

%%
arrayRF = mean(dataT.locStimResps,3);
goodChA = mean(dataT.locStimResps(:,:,dataT.goodCh == 1),3);
[params,rhat,errorsum,fullArray] = fit_gaussianrf(xPos,yPos,arrayRF);
[params,rhat,errorsum,goodChArray] = fit_gaussianrf(xPos,yPos,goodChA);
for ch = 1:96
    chResps = squeeze(dataT.locStimResps(:,:,ch));
    [params,rhat,errorsum,cf] = fit_gaussianrf(xPos,yPos,chResps);
    chFit{ch} = cf.paramsadj;
end
%%
figure(6)
clf
hold on

for ch = 1:96
    if contains(dataT.eye,'LE')
        draw_ellipse(chFit{ch},[.4 .6 .7])
    else
        draw_ellipse(chFit{ch},[.8 .2  .5])
   end
end

draw_ellipse(fullArray.paramsadj)
plot(dataT.fix_x,dataT.fix_y,'r.','MarkerSize',16)
set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
    'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
axis square
title(sprintf('%s %s %s receptive field locations all channels',dataT.animal, dataT.eye, dataT.array),'FontSize',14,'FontAngle','italic')   

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_receptiveFieldLocations_allCh'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(7)
clf
hold on

for ch = 1:96
    if dataT.goodCh(ch) == 1
        if contains(dataT.eye,'LE')
            draw_ellipse(chFit{ch},[.4 .6 .7])
        else
            draw_ellipse(chFit{ch},[.8 .2  .5])
        end
    end
end
draw_ellipse(goodChArray.paramsadj)
plot(dataT.fix_x,dataT.fix_y,'r.','MarkerSize',16)
set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
    'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
axis square
title(sprintf('%s %s %s receptive field locations visually responsive channels',dataT.animal, dataT.eye, dataT.array),'FontSize',14,'FontAngle','italic')   

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_receptiveFieldLocations_goodCh'];
print(gcf, figName,'-dpdf','-fillpage')
%%
dataT.chrReceptiveFieldParams = chFit;
dataT.arrayReceptiveFieldParams = fullArray.paramsadj;