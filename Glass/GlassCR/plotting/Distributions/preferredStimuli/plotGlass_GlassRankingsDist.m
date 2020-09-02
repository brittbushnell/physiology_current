function [] = plotGlass_GlassRankingsDist(dataT)
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

figure(5)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 900]);

for dt = 1:numDots 
    for dx = 1:numDxs

        ranks = dataT.dPrimeRank{dt,dx};
        
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
suptitle(sprintf('%s %s %s preferred Glass pattern distributions',dataT.animal, dataT.eye, dataT.array))

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_prefGlass'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(4)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 700]);

% {1,1} 
subplot(6,2,1);
% get data
ranks = dataT.dPrimeRank{1,1};

con1st = sum(ranks(1,:) == 1);
rad1st = sum(ranks(2,:) == 1);
noise1st = sum(ranks(3,:) == 1);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.08 0.847 0.35 0.12]) %[left bottom width height]
title({sprintf('%d dots, %.2f dx',dots(dt),dxs(dx));...
    (sprintf('%d significant channels',numSig))})
ylabel('1st')
 
subplot(6,2,3);
% get data
con1st = sum(ranks(1,:) == 2);
rad1st = sum(ranks(2,:) == 2);
noise1st = sum(ranks(3,:) == 2);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'color','none','tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.08 0.71 0.35 0.12]) %[left bottom width height]
ylabel('proportion of channels')
ylabel({'Proportion of channels by rank','2nd'})

subplot(6,2,5);
% get data
con1st = sum(ranks(1,:) == 3);
rad1st = sum(ranks(2,:) == 3);
noise1st = sum(ranks(3,:) == 3);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.08 0.575 0.35 0.12]) %[left bottom width height]
ylabel('3rd')

% {1,2} 
subplot(6,2,2);
% get data
ranks = dataT.dPrimeRank{1,2};

con1st = sum(ranks(1,:) == 1);
rad1st = sum(ranks(2,:) == 1);
noise1st = sum(ranks(3,:) == 1);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.6 0.847 0.35 0.12]) %[left bottom width height]
title({sprintf('%d dots, %.2f dx',dots(dt),dxs(dx));...
    (sprintf('%d significant channels',numSig))})
ylabel('1st')
 
subplot(6,2,4);
% get data
con1st = sum(ranks(1,:) == 2);
rad1st = sum(ranks(2,:) == 2);
noise1st = sum(ranks(3,:) == 2);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.6 0.71 0.35 0.12]) %[left bottom width height]
ylabel('proportion of channels')
ylabel({'Proportion of channels by rank','2nd'})

subplot(6,2,6);
% get data
con1st = sum(ranks(1,:) == 3);
rad1st = sum(ranks(2,:) == 3);
noise1st = sum(ranks(3,:) == 3);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.6 0.575 0.35 0.12]) %[left bottom width height]
ylabel('3rd')

% {2,1} 
subplot(6,2,7);
% get data
ranks = dataT.dPrimeRank{2,1};

con1st = sum(ranks(1,:) == 1);
rad1st = sum(ranks(2,:) == 1);
noise1st = sum(ranks(3,:) == 1);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.08 0.357 0.35 0.12]) %[left bottom width height]
title({sprintf('%d dots, %.2f dx',dots(dt),dxs(dx));...
    (sprintf('%d significant channels',numSig))})
ylabel('1st')
 
subplot(6,2,9);
% get data
con1st = sum(ranks(1,:) == 2);
rad1st = sum(ranks(2,:) == 2);
noise1st = sum(ranks(3,:) == 2);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.08 0.213 0.35 0.12]) %[left bottom width height]
ylabel('proportion of channels')
ylabel({'Proportion of channels by rank','2nd'})

subplot(6,2,11);
% get data
con1st = sum(ranks(1,:) == 3);
rad1st = sum(ranks(2,:) == 3);
noise1st = sum(ranks(3,:) == 3);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',{'concentric','radial','dipole'},...
    'layer','top','Position',[0.08 0.068 0.35 0.12]) %[left bottom width height]
ylabel('3rd')

% {2,2} 
subplot(6,2,8);
% get data
ranks = dataT.dPrimeRank{2,2};

con1st = sum(ranks(1,:) == 1);
rad1st = sum(ranks(2,:) == 1);
noise1st = sum(ranks(3,:) == 1);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.6 0.357 0.35 0.12]) %[left bottom width height]
title({sprintf('%d dots, %.2f dx',dots(dt),dxs(dx));...
    (sprintf('%d significant channels',numSig))})
ylabel('1st')
 
subplot(6,2,10);
% get data
con1st = sum(ranks(1,:) == 2);
rad1st = sum(ranks(2,:) == 2);
noise1st = sum(ranks(3,:) == 2);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',[],'layer','top','Position',[0.6 0.213 0.35 0.12]) %[left bottom width height]
ylabel('proportion of channels')
ylabel('2nd')

subplot(6,2,12);
% get data
con1st = sum(ranks(1,:) == 3);
rad1st = sum(ranks(2,:) == 3);
noise1st = sum(ranks(3,:) == 3);
numSig = (con1st+rad1st+noise1st);

conProp = con1st/numSig;
radProp = rad1st/numSig;
noiseProp = noise1st/numSig;

% plot
hold on
bar(1,conProp,0.75,'FaceColor','k','EdgeColor','w')
bar(1.75,radProp,0.75,'FaceColor','k','EdgeColor','w')
bar(2.5,noiseProp,0.75,'FaceColor','k','EdgeColor','w')

ylim([0 0.8])
xlim([0.5, 3])

set(gca,'tickdir','out','YTick',0:0.4:0.8,'XTick',[1, 1.75 2.5],'XTickLabel',{'concentric','radial','dipole'},...
    'layer','top','Position',[0.6 0.068 0.35 0.12]) %[left bottom width height]
ylabel('3rd')

%
suptitle(sprintf('%s %s %s preferred Glass pattern distributions',dataT.animal, dataT.eye, dataT.array))
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_GlassRankings'];
    print(gcf, figName,'-dpdf','-fillpage')