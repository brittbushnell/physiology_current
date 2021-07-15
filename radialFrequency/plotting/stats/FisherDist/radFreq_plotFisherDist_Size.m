function radFreq_plotFisherDist_Size(REdata, LEdata)
%%
location = determineComputer;

if location == 1
    if contains(REdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    elseif contains(REdata.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    end
elseif location == 0
    if contains(REdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    elseif contains(REdata.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)
%%
% (RF,phase,sf,radius,location, ch)
REzTR = REdata.FisherTrCorr;
LEzTR = LEdata.FisherTrCorr;

LEprefLoc = LEdata.prefLoc;
REprefLoc = REdata.prefLoc;
%% plot distributions for each eye and location

figure(5)
clf
s = suptitle(sprintf('%s %s Fisher Z distributions by size at preferred location',REdata.animal, REdata.array));
s.Position(2) = s.Position(2)+ 0.015;

h = subplot(2,2,1);
hold on

zs1 = LEzTR(:,:,:,1,:,(LEprefLoc == 1));
zs1 = reshape(zs1,1,numel(zs1));
zs2 = LEzTR(:,:,:,1,:,(LEprefLoc == 2));
zs2 = reshape(zs2,1,numel(zs2));
zs3 = LEzTR(:,:,:,1,:,(LEprefLoc == 3));
zs3 = reshape(zs3,1,numel(zs3));
zs = [zs1 zs2 zs3];


histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.4,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,0.4,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.43],'-k')

title(sprintf('%s',LEdata.eye))

ylim([0 0.5])
xlim([-3 3])

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
ylabel('probability','FontSize',11,'FontAngle','italic')

h.Position(4) = h.Position(4) - 0.03;
t = text(-4.25, 0.15,'mean radius 1','FontSize',12,'FontWeight','bold','FontAngle','italic');
t.Rotation = 90;
clear zs1 zs2 zs3 zs

h = subplot(2,2,2);
hold on

zs1 = REzTR(:,:,:,1,:,(REprefLoc == 1));
zs1 = reshape(zs1,1,numel(zs1));
zs2 = REzTR(:,:,:,1,:,(REprefLoc == 2));
zs2 = reshape(zs2,1,numel(zs2));
zs3 = REzTR(:,:,:,1,:,(REprefLoc == 3));
zs3 = reshape(zs3,1,numel(zs3));
zs = [zs1 zs2 zs3];

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.4,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,0.4,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.43],'-k')
ylim([0 0.5])
xlim([-3 3])

title(sprintf('%s',REdata.eye))
set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

h.Position(4) = h.Position(4) - 0.03;
clear zs1 zs2 zs3 zs
% 

h = subplot(2,2,3);
hold on

zs1 = LEzTR(:,:,:,2,:,(LEprefLoc == 1));
zs1 = reshape(zs1,1,numel(zs1));
zs2 = LEzTR(:,:,:,2,:,(LEprefLoc == 2));
zs2 = reshape(zs2,1,numel(zs2));
zs3 = LEzTR(:,:,:,2,:,(LEprefLoc == 3));
zs3 = reshape(zs3,1,numel(zs3));
zs = [zs1 zs2 zs3];

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)

plot(nanmean(zs),0.4,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,0.4,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.43],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
ylabel('probability','FontSize',11,'FontAngle','italic')

t = text(-4.25, 0.15,'mean radius 2','FontSize',12,'FontWeight','bold','FontAngle','italic');
t.Rotation = 90;

ylim([0 0.5])
xlim([-3 3])

clear zs1 zs2 zs3 zs

h = subplot(2,2,4);
hold on

zs1 = REzTR(:,:,:,2,:,(REprefLoc == 1));
zs1 = reshape(zs1,1,numel(zs1));
zs2 = REzTR(:,:,:,2,:,(REprefLoc == 2));
zs2 = reshape(zs2,1,numel(zs2));
zs3 = REzTR(:,:,:,2,:,(REprefLoc == 3));
zs3 = reshape(zs3,1,numel(zs3));
zs = [zs1 zs2 zs3];

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)

plot(nanmean(zs),0.4,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,0.4,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.43],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

ylim([0 0.5])
xlim([-3 3])
%%
figName = [REdata.animal,'_BE_',REdata.array,'_FisherT_size_dist','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')