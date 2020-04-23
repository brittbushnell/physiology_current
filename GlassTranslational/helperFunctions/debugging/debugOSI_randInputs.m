load('WU_LE_GlassTR_nsp2_20170825_002_s1_perm2k')
dataT = data.LE;
close all
clc
%%
%oris_rand = dataT.rotation;
oris_rand = 0:15:150;
oris_randRadial = deg2rad(oris_rand);

figure (1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
ttl = suptitle({'Distribtions of permuted OSI values using different random inputs orientations every 15deg';'blue: all ori resps = 20 red: only one ori = 40'});
ttl.Position = [0.5,-0.025,0];
%% noise near 0, flat ori tuning (all 20)
resp_rand = rand(size(dataT.rotation));
or_rad = [0 pi/4 pi/2 pi*3/4];
or_resp = [20 20 20 20];


for or = 1:(length(unique(or_rad)))
    dipole = resp_rand(randi(length(resp_rand),1)); % random val near zero
    stim = or_resp(or);
    baseSub = stim - dipole;
    
    ori2 = 2*(or_rad(or));
    expon = 1i*(ori2);
    exVar = exp(expon);
    respVect(or,:) = baseSub*exVar;
    denomVect(or,:) = (abs(baseSub));
end

v = sum(respVect);
denom = sum((denomVect));
SItmp10 = abs(v) / denom;
%% noise near 0, only one orientation >0
or_rad = [0 pi/4 pi/2 pi*3/4];
or_resp = [0 0 0 40];


for or = 1:(length(unique(or_rad)))
    dipole = resp_rand(randi(length(resp_rand),1)); % random val near zero
    stim = or_resp(or);
    baseSub = stim - dipole;
    
    ori2 = 2*(or_rad(or));
    expon = 1i*(ori2);
    exVar = exp(expon);
    respVect(or,:) = baseSub*exVar;
    denomVect(or,:) = (abs(baseSub));
end

v = sum(respVect);
denom = sum((denomVect));
SItmp1Ori = abs(v) / denom;
%% test using values near zero 
for nb = 1:2000
    for or = 1:(length(unique(oris_rand)))
        %randTrial = randi(length(resp_randZero),1);
        
        dipole = resp_rand(randi(length(resp_rand),1));
        stim = resp_rand(randi(length(resp_rand),1));
        baseSub = stim - dipole;
        
        ori2 = 2*(oris_randRadial(randi(length(oris_randRadial))));
        expon = 1i*(ori2);
        exVar = exp(expon);
        respVect(or,:) = baseSub*exVar;
        denomVect(or,:) = (abs(baseSub));
    end
    
    v = sum(respVect);
    denom = sum((denomVect));
    SItmp1(nb,1) = abs(v) / denom;
end

subplot(2,2,1)
hold on
histogram(SItmp1,7,'BinWidth',0.1,'FaceColor',[0 0.6 0.2],'Normalization','probability');
plot(nanmean(SItmp1),0.51,'v','markerfacecolor','k','markeredgecolor','k','MarkerSize',11)
text(nanmean(SItmp1),0.57,sprintf('mu %.3f',nanmean(SItmp1)),'fontWeight','bold','fontSize',12)

plot(nanmedian(SItmp1),0.51,'v','MarkerFaceColor',[0.4 0.4 0.4],'markeredgecolor',[0.4 0.4 0.4],'MarkerSize',10)
text(nanmedian(SItmp1),0.54,sprintf('md %.3f',nanmedian(SItmp1)),'color',[0.4 0.4 0.4],'fontWeight','bold','fontSize',12)

plot([SItmp10, SItmp10], [0, 0.4],'color',[0 0 0.8])
plot([SItmp1Ori, SItmp1Ori], [0, 0.4],'color',[1 0 0])

ylim([0 0.6])
xlim([-0.1 1.2])
set(gca,'tickdir','out','color','none','XTick',0:0.2:1)

title('Random values between 0 and 1')
%% test with 1/4 values negative
numNeg = length(resp_rand)/4;
negNdx = randi(length(resp_rand),[1,numNeg]);
resp_randNeg = resp_rand;
resp_randNeg(negNdx) = resp_randNeg(negNdx) *-1;

for nb = 1:2000
    for or = 1:(length(unique(oris_rand)))
        %randTrial = randi(length(resp_randZero),1);
        
        dipole = resp_rand(randi(length(resp_randNeg),1));
        stim = resp_rand(randi(length(resp_randNeg),1));
        baseSub = stim - dipole;
        
        ori2 = 2*(oris_randRadial(randi(length(oris_randRadial),1)));
        expon = 1i*(ori2);
        exVar = exp(expon);
        respVect(or,:) = baseSub*exVar;
        denomVect(or,:) = (abs(baseSub));
    end
    
    v = sum(respVect);
    denom = sum((denomVect));
    SItmp2(nb,1) = abs(v) / denom;
end

subplot(2,2,2)
hold on
histogram(SItmp2,7,'BinWidth',0.1,'FaceColor',[0 0.6 0.2],'Normalization','probability');
plot(nanmean(SItmp2),0.51,'v','markerfacecolor','k','markeredgecolor','k','MarkerSize',11)
text(nanmean(SItmp2),0.57,sprintf('mu %.3f',nanmean(SItmp2)),'fontWeight','bold','fontSize',12)

plot(nanmedian(SItmp2),0.51,'v','MarkerFaceColor',[0.4 0.4 0.4],'markeredgecolor',[0.4 0.4 0.4],'MarkerSize',10)
text(nanmedian(SItmp2),0.54,sprintf('md %.3f',nanmedian(SItmp2)),'color',[0.4 0.4 0.4],'fontWeight','bold','fontSize',12)

plot([SItmp10, SItmp10], [0, 0.4],'color',[0 0 0.8])
plot([SItmp1Ori, SItmp1Ori], [0, 0.4],'color',[1 0 0])

ylim([0 0.6])
xlim([-0.1 1.2])
set(gca,'tickdir','out','color','none','XTick',0:0.2:1)

title('Random values between 0 and 1, 1/4 randomly negative')
%% test with random values between 0 and 100
resp_rand100 = randi(100,size(resp_rand));

for nb = 1:2000
    for or = 1:(length(unique(oris_rand)))
        %randTrial = randi(length(resp_randZero),1);
        
        dipole = resp_rand100(randi(length(resp_rand100),1));
        stim = resp_rand100(randi(length(resp_rand100),1));
        baseSub = stim - dipole;
        
        ori2 = 2*(oris_randRadial(randi(length(oris_randRadial),1)));
        expon = 1i*(ori2);
        exVar = exp(expon);
        respVect(or,:) = baseSub*exVar;
        denomVect(or,:) = (abs(baseSub));
    end
    
    v = sum(respVect);
    denom = sum((denomVect));
    SItmp3(nb,1) = abs(v) / denom;
end

subplot(2,2,3)
hold on
histogram(SItmp3,7,'BinWidth',0.1,'FaceColor',[0 0.6 0.2],'Normalization','probability');
plot(nanmean(SItmp3),0.51,'v','markerfacecolor','k','markeredgecolor','k','MarkerSize',11)
text(nanmean(SItmp3),0.57,sprintf('mu %.3f',nanmean(SItmp3)),'fontWeight','bold','fontSize',12)

plot(nanmedian(SItmp3),0.51,'v','MarkerFaceColor',[0.4 0.4 0.4],'markeredgecolor',[0.4 0.4 0.4],'MarkerSize',10)
text(nanmedian(SItmp3),0.54,sprintf('md %.3f',nanmedian(SItmp3)),'color',[0.4 0.4 0.4],'fontWeight','bold','fontSize',12)

plot([SItmp10, SItmp10], [0, 0.4],'color',[0 0 0.8])
plot([SItmp1Ori, SItmp1Ori], [0, 0.4],'color',[1 0 0])

ylim([0 0.6])
xlim([-0.1 1.2])
set(gca,'tickdir','out','color','none','XTick',0:0.2:1)

title('Random values between 0 and 100')
%% test with 1/4 values 50:80, rest near 0
numBig = length(resp_rand)/4;
bigNdx = randi(length(resp_rand),[1,numBig]);
resp_randBig = resp_rand;
resp_randBig(negNdx) = resp_randBig(bigNdx) + (randi([50,80],1));

for nb = 1:2000
    for or = 1:(length(unique(oris_rand)))
        %randTrial = randi(length(resp_randZero),1);
        
        dipole = resp_rand(randi(length(resp_randBig),1));
        stim = resp_rand(randi(length(resp_randBig),1));
        baseSub = stim - dipole;
        
        ori2 = 2*(oris_randRadial(randi(length(oris_randRadial),1)));
        expon = 1i*(ori2);
        exVar = exp(expon);
        respVect(or,:) = baseSub*exVar;
        denomVect(or,:) = (abs(baseSub));
    end
    
    v = sum(respVect);
    denom = sum((denomVect));
    SItmp4(nb,1) = abs(v) / denom;
end

subplot(2,2,4)
hold on
histogram(SItmp4,7,'BinWidth',0.1,'FaceColor',[0 0.6 0.2],'Normalization','probability');
plot(nanmean(SItmp4),0.51,'v','markerfacecolor','k','markeredgecolor','k','MarkerSize',11)
text(nanmean(SItmp4),0.57,sprintf('mu %.3f',nanmean(SItmp4)),'fontWeight','bold','fontSize',12)

plot(nanmedian(SItmp4),0.51,'v','MarkerFaceColor',[0.4 0.4 0.4],'markeredgecolor',[0.4 0.4 0.4],'MarkerSize',10)
text(nanmedian(SItmp4),0.54,sprintf('md %.3f',nanmedian(SItmp4)),'color',[0.4 0.4 0.4],'fontWeight','bold','fontSize',12)

plot([SItmp10, SItmp10], [0, 0.4],'color',[0 0 0.8])
plot([SItmp1Ori, SItmp1Ori], [0, 0.4],'color',[1 0 0])

ylim([0 0.6])
xlim([-0.1 1.2])
set(gca,'tickdir','out','color','none','XTick',0:0.2:1)

title('3/4 random values between 0 and 1, 1/4 randomly between 50:80')




