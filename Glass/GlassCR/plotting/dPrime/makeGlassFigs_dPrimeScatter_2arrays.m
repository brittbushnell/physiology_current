function makeGlassFigs_dPrimeScatter_2arrays(V1data, V4data)
%% V1
v1ConRE = nan(2,2,96);
v1RadRE = nan(2,2,96);
v1NozRE = nan(2,2,96);

v1ConLE = nan(2,2,96);
v1RadLE = nan(2,2,96);
v1NozLE = nan(2,2,96);
% identify channels that are responsive  and in stimuli with both eyes
binocCh = V1data.conRadRE.inStim & V1data.conRadRE.goodCh & V1data.conRadLE.inStim & V1data.conRadLE.goodCh;
LEV1chs = V1data.conRadLE.inStim & V1data.conRadLE.goodCh;
REV1chs = V1data.conRadRE.inStim & V1data.conRadRE.goodCh;

for ch = 1:96
    if binocCh(ch) == 1
        v1ConLE(:,:,ch) = squeeze(V1data.conRadLE.conBlankDprime(end,:,:,ch));
        v1ConRE(:,:,ch) = squeeze(V1data.conRadRE.conBlankDprime(end,:,:,ch));
        
        v1RadLE(:,:,ch) = squeeze(V1data.conRadLE.radBlankDprime(end,:,:,ch));
        v1RadRE(:,:,ch) = squeeze(V1data.conRadRE.radBlankDprime(end,:,:,ch));
        
        v1NozLE(:,:,ch) = squeeze(V1data.conRadLE.noiseBlankDprime(1,:,:,ch));
        v1NozRE(:,:,ch) = squeeze(V1data.conRadRE.noiseBlankDprime(1,:,:,ch));
    elseif LEV1chs(ch) == 1 && REV1chs(ch) == 0
        v1ConLE(:,:,ch) = squeeze(V1data.conRadLE.conBlankDprime(end,:,:,ch));
        v1ConRE(:,:,ch) = zeros(2,2,1);
        
        v1RadLE(:,:,ch) = squeeze(V1data.conRadRE.radBlankDprime(end,:,:,ch));
        v1RadRE(:,:,ch) = zeros(2,2,1);
        
        v1NozLE(:,:,ch) = squeeze(V1data.conRadLE.noiseBlankDprime(1,:,:,ch));
        v1NozRE(:,:,ch) =  zeros(2,2,1);
    elseif LEV1chs(ch) == 0 && REV1chs(ch) == 1
        v1ConLE(:,:,ch) = zeros(2,2,1);
        v1ConRE(:,:,ch) = squeeze(V1data.conRadRE.conBlankDprime(end,:,:,ch));
        
        v1RadLE(:,:,ch) = zeros(2,2,1);
        v1RadRE(:,:,ch) = squeeze(V1data.conRadRE.radBlankDprime(end,:,:,ch));
        
        v1NozLE(:,:,ch) =  zeros(2,2,1);
        v1NozRE(:,:,ch) = squeeze(V1data.conRadRE.noiseBlankDprime(1,:,:,ch));
    end 
end
%% V4
v4ConRE = nan(2,2,96);
v4RadRE = nan(2,2,96);
v4NozRE = nan(2,2,96);

v4ConLE = nan(2,2,96);
v4RadLE = nan(2,2,96);
v4NozLE = nan(2,2,96);
% identify channels that are responsive  and in stimuli with both eyes
binocCh = V4data.conRadRE.inStim & V4data.conRadRE.goodCh & V4data.conRadLE.inStim & V4data.conRadLE.goodCh;
LEV4chs = V4data.conRadLE.inStim & V4data.conRadLE.goodCh;
REV4chs = V4data.conRadRE.inStim & V4data.conRadRE.goodCh;

for ch = 1:96
    if binocCh(ch) == 1
        v4ConLE(:,:,ch) = squeeze(V4data.conRadLE.conBlankDprime(end,:,:,ch));
        v4ConRE(:,:,ch) = squeeze(V4data.conRadRE.conBlankDprime(end,:,:,ch));
        
        v4RadLE(:,:,ch) = squeeze(V4data.conRadLE.radBlankDprime(end,:,:,ch));
        v4RadRE(:,:,ch) = squeeze(V4data.conRadRE.radBlankDprime(end,:,:,ch));
        
        v4NozLE(:,:,ch) = squeeze(V4data.conRadLE.noiseBlankDprime(1,:,:,ch));
        v4NozRE(:,:,ch) = squeeze(V4data.conRadRE.noiseBlankDprime(1,:,:,ch));
    elseif LEV4chs(ch) == 1 && REV4chs(ch) == 0
        v4ConLE(:,:,ch) = squeeze(V4data.conRadLE.conBlankDprime(end,:,:,ch));
        v4ConRE(:,:,ch) = zeros(2,2,1);
        
        v4RadLE(:,:,ch) = squeeze(V4data.conRadRE.radBlankDprime(end,:,:,ch));
        v4RadRE(:,:,ch) = zeros(2,2,1);
        
        v4NozLE(:,:,ch) = squeeze(V4data.conRadLE.noiseBlankDprime(1,:,:,ch));
        v4NozRE(:,:,ch) =  zeros(2,2,1);
    elseif LEV4chs(ch) == 0 && REV4chs(ch) == 1
        v4ConLE(:,:,ch) = zeros(2,2,1);
        v4ConRE(:,:,ch) = squeeze(V4data.conRadRE.conBlankDprime(end,:,:,ch));
        
        v4RadLE(:,:,ch) = zeros(2,2,1);
        v4RadRE(:,:,ch) = squeeze(V4data.conRadRE.radBlankDprime(end,:,:,ch));
        
        v4NozLE(:,:,ch) =  zeros(2,2,1);
        v4NozRE(:,:,ch) = squeeze(V4data.conRadRE.noiseBlankDprime(1,:,:,ch));
    end 
end
%%

figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 600]);
set(gcf,'PaperOrientation','landscape')

s = suptitle(sprintf('%s d prime values between eyes for stumuli and arrays',V1data.conRadRE.animal));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.025;

s = subplot(2,3,1);
le =  reshape(v1ConLE,numel(v1ConLE),1);
re = reshape(v1ConRE,numel(v1ConRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,~,~,conReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.5, 4.5,sprintf('R2 %.3f',conReg(1)),'FontSize',12) 
% text(-0.5, 4,sprintf('p %.3f',conReg(3)),'FontSize',12) 

title('Concentric')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
if contains(V1data.conRadRE.animal,'XT')
    xlabel('LE d''')
    ylabel('RE d''')
else
    xlabel('FE d''')
    ylabel('AE d''')
end

text(4,-0.4,sprintf('LE %d',sum(LEV1chs)),'FontSize',12)
text(4,-0.75,sprintf('RE %d',sum(REV1chs)),'FontSize',12)

text(-3.5,2,'V1','FontSize',20,'FontWeight','bold') 
clear le; clear re; clear regX;

s = subplot(2,3,2);
le = reshape(v1RadLE,numel(v1RadLE),1);
re = reshape(v1RadRE,numel(v1RadRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,~,~,radReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.5, 4.5,sprintf('R2 %.3f',radReg(1)),'FontSize',12) 
% text(-0.5, 4,sprintf('p %.3f',radReg(3)),'FontSize',12) 

title('Radial')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
text(4,-0.4,sprintf('LE %d',sum(LEV1chs)),'FontSize',12)
text(4,-0.75,sprintf('RE %d',sum(REV1chs)),'FontSize',12)
clear le; clear re; clear regX;

s = subplot(2,3,3);
le =  reshape(v1NozLE,numel(v1NozLE),1);
re = reshape(v1NozRE,numel(v1NozRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,~,~,nozReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.5, 4.5,sprintf('R2 %.3f',nozReg(1)),'FontSize',12) 
% text(-0.5, 4,sprintf('p %.3f',nozReg(3)),'FontSize',12) 

title('Dipole')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
text(4,-0.4,sprintf('LE %d',sum(LEV1chs)),'FontSize',12)
text(4,-0.75,sprintf('RE %d',sum(REV1chs)),'FontSize',12)
axis square
clear le; clear re; clear regX;

s = subplot(2,3,4);
le =  reshape(v4ConLE,numel(v4ConLE),1);
re = reshape(v4ConRE,numel(v4ConRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,~,~,conReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.5, 4.5,sprintf('R2: %.3f',conReg(1)),'FontSize',12) 
% text(-0.5, 4,sprintf('p %.3f',conReg(3)),'FontSize',12) 

title('Concentric')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
if contains(V4data.conRadRE.animal,'XT')
    xlabel('LE d''')
    ylabel('RE d''')
else
    xlabel('FE d''')
    ylabel('AE d''')
end

text(-3.5,2,'V4','FontSize',20,'FontWeight','bold') 
text(4,-0.4,sprintf('LE %d',sum(LEV4chs)),'FontSize',12)
text(4,-0.75,sprintf('RE %d',sum(REV4chs)),'FontSize',12)
clear le; clear re; clear regX;

s = subplot(2,3,5);
le = reshape(v4RadLE,numel(v4RadLE),1);
re = reshape(v4RadRE,numel(v4RadRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,~,~,radReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.5, 4.5,sprintf('R2: %.3f',radReg(1)),'FontSize',12)
% text(-0.5, 4,sprintf('p %.3f',radReg(3)),'FontSize',12)

title('Radial')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
text(4,-0.4,sprintf('LE %d',sum(LEV4chs)),'FontSize',12)
text(4,-0.75,sprintf('RE %d',sum(REV4chs)),'FontSize',12)
clear le; clear re; clear regX;

s = subplot(2,3,6);
le =  reshape(v4NozLE,numel(v4NozLE),1);
re = reshape(v4NozRE,numel(v4NozRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,~,~,nozReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.5, 4.5,sprintf('R2: %.3f',nozReg(1)),'FontSize',12) 
% text(-0.5, 4,sprintf('p %.3f',nozReg(3)),'FontSize',12)

text(4,-0.4,sprintf('LE %d',sum(LEV4chs)),'FontSize',12)
text(4,-0.75,sprintf('RE %d',sum(REV4chs)),'FontSize',12)
title('Dipole')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
clear le; clear re; clear regX;
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/arrayComp/',V1data.conRadRE.animal,V1data.conRadRE.programID);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/arrayComp/',V1data.conRadRE.animal,V1data.conRadRE.programID);
end

if~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [V1data.conRadRE.animal '_glassdPrimeScatters_botArrays','.pdf'];
set(gcf,'InvertHardCopy','off')
print(gcf, figName, '-dpdf', '-fillpage')
