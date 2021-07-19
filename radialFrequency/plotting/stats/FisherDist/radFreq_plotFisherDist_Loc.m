function radFreq_plotFisherDist_Loc(REdata, LEdata)
%%
location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
        end
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/',LEdata.animal,LEdata.array);
        end
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
%% plot distributions for each eye and location

figure(2)
clf
s = suptitle(sprintf('%s %s %s Fisher Z distributions by location',REdata.animal, REdata.array, REdata.programID));
s.Position(2) = s.Position(2)+ 0.015;

h = subplot(3,2,1);
hold on

zs = LEzTR(:,:,:,:,1,:);
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')

title(sprintf('%s',LEdata.eye))

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
ylabel('probability','FontSize',11,'FontAngle','italic')

mygca(1) = gca;
b = get(gca,'YLim');
yMaxs(1) = max(b);
yMins(1) = min(b);

b = get(gca,'XLim');
xMaxs(1) = max(b);
xMins(1) = min(b);

h.Position(4) = h.Position(4) - 0.03;
clear zs

h = subplot(3,2,2);
hold on

zs = REzTR(:,:,:,:,1,:);
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')

title(sprintf('%s',REdata.eye))
set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

mygca(2) = gca;
b = get(gca,'YLim');
yMaxs(2) = max(b);
yMins(2) = min(b);

b = get(gca,'XLim');
xMaxs(2) = max(b);
xMins(2) = min(b);
h.Position(4) = h.Position(4) - 0.03;
clear zs
% 

h = subplot(3,2,3);
hold on

zs = LEzTR(:,:,:,:,2,:);
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
ylabel('probability','FontSize',11,'FontAngle','italic')

mygca(3) = gca;
b = get(gca,'YLim');
yMaxs(3) = max(b);
yMins(3) = min(b);

b = get(gca,'XLim');
xMaxs(3) = max(b);
xMins(3) = min(b);
h.Position(4) = h.Position(4) - 0.03;
clear zs

h = subplot(3,2,4);
hold on

zs = REzTR(:,:,:,:,2,:);
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

mygca(4) = gca;
b = get(gca,'YLim');
yMaxs(4) = max(b);
yMins(4) = min(b);

b = get(gca,'XLim');
xMaxs(4) = max(b);
xMins(4) = min(b);
h.Position(4) = h.Position(4) - 0.03;
clear zs
%

h = subplot(3,2,5);
hold on

zs = LEzTR(:,:,:,:,3,:);
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
ylabel('probability','FontSize',11,'FontAngle','italic')
xlabel('Fisher transformed z')

mygca(5) = gca;
b = get(gca,'YLim');
yMaxs(5) = max(b);
yMins(5) = min(b);

b = get(gca,'XLim');
xMaxs(5) = max(b);
xMins(5) = min(b);
h.Position(4) = h.Position(4) - 0.03;
clear zs

h = subplot(3,2,6);
hold on

zs = REzTR(:,:,:,:,3,:);
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')
set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
xlabel('Fisher transformed z')

mygca(6) = gca;
b = get(gca,'YLim');
yMaxs(6) = max(b);
yMins(6) = min(b);

b = get(gca,'XLim');
xMaxs(6) = max(b);
xMins(6) = min(b);
h.Position(4) = h.Position(4) - 0.03;


minY = min(yMins);
maxY = max(yMaxs);
yLimits = ([minY maxY]);

minX = min(xMins);
maxX = max(xMaxs);
xLimits = ([minX maxX]);

set(mygca,'YLim',yLimits,'XLim',xLimits);

th = text(minX+(minX*3.2), (maxY+minY)/2,'Location 3','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
set(th,'Rotation',90)

th = text(minX+(minX*3.2), ((maxY+minY)/2)+(maxY*1.36),'Location 2','FontSize',12,'FontWeight','bold','HorizontalAlignment','left');
set(th,'Rotation',90)

th = text(minX+(minX*3.2), ((maxY+minY)/2)+(maxY*3.25),'Location 1','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
set(th,'Rotation',90)
%%
figName = [REdata.animal,'_BE_',REdata.array,'_',REdata.programID,'_FisherT_location_dist','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')