function [dataT] = getReceptiveFields_zScore1(dataT)
%%
locMtx = dataT.stimZscore;
% stim mtx is set up (y,x,ch,rep), but Manu's code assumes x,y
locZscores = nanmean(locMtx,4); % get mean z score at each location
locZscores = permute(locZscores,[2,1,3]); % reorganize so it's (x,y,ch)
xPos = double(unique(dataT.pos_x));
yPos = double(unique(dataT.pos_y));
%% Get receptive field information
arrayRF = nanmean(locZscores,3); % want hot spot of the entire array, so mean across channels
saveName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_rfInputs.mat'];
save(saveName,'xPos','yPos','arrayRF','locZscores');
fprintf('%s saved\n', saveName)
[params,rhat,errorsum,fullArray] = fit_gaussianrf_z(xPos,yPos,arrayRF);
%% get receptive field information for each channel
for ch = 1:96
    chZs = squeeze(locZscores(:,:,ch));
    [params,rhat,errorsum,cf] = fit_gaussianrf_z(xPos,yPos,chZs);
    chFit{ch} = cf.paramsadj;
end
%%
dataT.chReceptiveFieldParams = chFit;
dataT.arrayReceptiveFieldParams = fullArray.paramsadj;
%% plot results
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/%s/ch/',dataT.animal,dataT.programID, dataT.array,dataT.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/%s/ch/',dataT.animal, dataT.programID,dataT.array, dataT.eye);
end
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
figure%(6)
clf
hold on
for ch = 1:96
    if contains(dataT.eye,'RE')
       scatter(chFit{ch}(1),chFit{ch}(2),35,[0.8 0 0.4],'filled','MarkerFaceAlpha',0.7);
%        text(chFit{ch}(1),chFit{ch}(2),num2str(ch),'FontWeight','bold','Color',[0.8 0 0.4])
    else
         scatter(chFit{ch}(1),chFit{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
%        text(chFit{ch}(1),chFit{ch}(2),num2str(ch),'FontWeight','bold','Color',[0.2 0.4 1])
    end
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end
if contains(dataT.animal,'WU')
    viscircles([0,0],1.5, 'color',[0.2 0.2 0.2]);
else
    viscircles([0,0],0.75, 'color',[0.2 0.2 0.2]);
end
plot(dataT.fix_x, dataT.fix_y,'ok','MarkerFaceColor','k','MarkerSize',8)
title(sprintf('%s %s %s recepive field centers',dataT.animal, dataT.array, dataT.eye),'FontSize',14,'FontWeight','Bold')