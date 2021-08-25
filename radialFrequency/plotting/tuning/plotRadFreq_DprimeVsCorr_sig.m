function plotRadFreq_DprimeVsCorr_sig(data1,data2, data1Label, data2Label, corSigPerm, dPsigPerm, figName)
% this plotting function is set to work with whatever two data sets are
% sent in: LE vs RE, V1 vs V4, etc. The output will be two columns of
% scatterplots for max |d'| vs amplitude correlation for all three RFs 
%%
% x: corr
% y: d'

d1max = max(abs(data1.stimCircDprime),[],'all');
d2max = max(abs(data2.stimCircDprime),[],'all');

yMax = max([d1max,d2max]) + 0.5;
%% 
% median correlation across channels
d1RealCor = nanmedian(squeeze(data1.stimCorrs(:,:)),2);
d2RealCor = nanmedian(squeeze(data2.stimCorrs(:,:)),2);

corr1 = d1RealCor;
corr2 = d2RealCor;
trueCor = corr1 - corr2;
%%
figure
clf
figTitle = strrep(figName,'.pdf','');
figTitle = strrep(figTitle,'_',' ');
s = suptitle(figTitle);

% if ~contains(data1Label,'LE') || ~contains(data1Label,'FE')
%     s = suptitle(sprintf('%s %s %s max |d''| versus best stimulus correlation', data2.animal, data2.array, data2.eye));
% elseif contains(data1label,'V1') || contains(data1label,'V4')
%     s = suptitle(sprintf('%s max |d''| versus best stimulus correlation', data2.animal));
% else
%     s = suptitle(sprintf('%s %s max |d''| versus best stimulus correlation', data2.animal, data2.array));  
% end
s.Position(2) = s.Position(2) + 0.025;

subplot(3,2,1)
hold on
axis square
ylabel('max |d''|')


title(data1Label)

xlim([-1 1])
ylim([0, yMax])
text( -2.3, (0+yMax)/2, 'RF4','FontSize',12,'FontWeight','bold')

for ch = 1:96
    if data1.goodCh(ch)
        [y, maxAmp] = max(abs(data1.stimCircDprime(1,:,ch)));
        x = data1.stimCorrs(1,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(data1.stimCircDprimeSig(1,maxAmp,ch));
        corrSig   = squeeze(data1.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
        clear x y
    end
end
dPmedian1 = nanmedian(dps);

plot([-1 1], [dPmedian1 dPmedian1],':k')
plot([corr1(1) corr1(1)], [0 yMax],':k')

text(-0.8, dPmedian1+0.15, sprintf('%.2f',dPmedian1))
text(corr1(1)-0.05,yMax-(yMax/5), sprintf('%.2f',corr1(1)),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
% clear dps cors dPmedian trueCor

subplot(3,2,2)
hold on
axis square
ylabel('max |d''|')

title(data2Label)

xlim([-1 1])
ylim([0, yMax])

for ch = 1:96
    if data2.goodCh(ch)
        [y, maxAmp] = max(abs(data2.stimCircDprime(1,:,ch)));
        x = data2.stimCorrs(1,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(data2.stimCircDprimeSig(1,maxAmp,ch));
        corrSig   = squeeze(data2.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
        clear x y
    end
end

dPmedian2 = nanmedian(dps);

plot([-1 1], [dPmedian2 dPmedian2],':k')
plot([corr2(1) corr2(1)], [0 yMax],':k')

text(-0.8, dPmedian2+0.15, sprintf('%.2f',dPmedian2))
text(corr2(1)-0.05,yMax-(yMax/5), sprintf('%.2f',corr2(1)),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
% clear dps cors dPmedian trueCor( 

if dPsigPerm(1) == 1
    text(-3.25,yMax/2,sprintf('d'' difference %.2f*',dPmedian1 - dPmedian2),'FontWeight','bold','FontSize',10)
else
    text(-3.25,yMax/2,sprintf('d'' difference %.2f',dPmedian1 - dPmedian2),'FontSize',10)
end

if corSigPerm(1) == 1
    text(-3.25,yMax/2-0.5,sprintf('corr difference %.2f*',trueCor(1)),'FontWeight','bold','FontSize',10)
else
    text(-3.25,yMax/2-0.5,sprintf('corr difference %.2f',trueCor(1)),'FontSize',10)
end

% clear trueCor(1 trueCor(2 dPmedian1 dPmedian2

subplot(3,2,3)
hold on
axis square
ylabel('max |d''|')


xlim([-1 1])
ylim([0, yMax])
text( -2.3, (0+yMax)/2, 'RF8','FontSize',12,'FontWeight','bold')

for ch = 1:96
    if data1.goodCh(ch)
        [y, maxAmp] = max(abs(data1.stimCircDprime(2,:,ch)));
        x = data1.stimCorrs(2,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(data1.stimCircDprimeSig(2,maxAmp,ch));
        corrSig   = squeeze(data1.stimCorrSig(2,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[1 0.5 0.1], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
        clear x y
    end
end

dPmedian1 = nanmedian(dps);

plot([-1 1], [dPmedian1 dPmedian1],':k')
plot([corr1(2) corr1(2)], [0 yMax],':k')

text(-0.8, dPmedian1+0.15, sprintf('%.2f',dPmedian1))
text(corr1(2)-0.05,yMax-(yMax/5), sprintf('%.2f',corr1(2)),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

subplot(3,2,4)
hold on
axis square
ylabel('max |d''|')

xlim([-1 1])
ylim([0, yMax])

for ch = 1:96
    if data2.goodCh(ch)
        [y, maxAmp] = max(abs(data2.stimCircDprime(2,:,ch)));
        x = data2.stimCorrs(2,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(data2.stimCircDprimeSig(2,maxAmp,ch));
        corrSig   = squeeze(data2.stimCorrSig(2,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[1 0.5 0.1], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
        clear x y
    end
end

dPmedian2 = nanmedian(dps);

plot([-1 1], [dPmedian2 dPmedian2],':k')
plot([corr2(2) corr2(2)], [0 yMax],':k')

text(-0.8, dPmedian2+0.15, sprintf('%.2f',dPmedian2))
text(corr2(2)-0.05,yMax-(yMax/5), sprintf('%.2f',corr2(2)),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)



if dPsigPerm(2) == 1
    text(-3.25,yMax/2,sprintf('d'' difference %.2f*',dPmedian1 - dPmedian2),'FontWeight','bold','FontSize',10)
else
    text(-3.25,yMax/2,sprintf('d'' difference %.2f',dPmedian1 - dPmedian2),'FontSize',10)
end

if corSigPerm(2) == 1
    text(-3.25,yMax/2-0.5,sprintf('corr difference %.2f*',trueCor(2)),'FontWeight','bold','FontSize',10)
else
    text(-3.25,yMax/2-0.5,sprintf('corr difference %.2f',trueCor(2)),'FontSize',10)
end

% clear trueCor(1 trueCor(2 dPmedian1 dPmedian2

subplot(3,2,5)
hold on
axis square
ylabel('max |d''|')
xlabel('correlation')

xlim([-1 1])
ylim([0, yMax])
text( -2.3, (0+yMax)/2, 'RF16','FontSize',12,'FontWeight','bold')

for ch = 1:96
    if data1.goodCh(ch)
        [y, maxAmp] = max(abs(data1.stimCircDprime(3,:,ch)));
        x = data1.stimCorrs(3,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(data1.stimCircDprimeSig(3,maxAmp,ch));
        corrSig   = squeeze(data1.stimCorrSig(3,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0 0.6 0.2], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
        clear x y
    end
end

dPmedian1 = nanmedian(dps);

plot([-1 1], [dPmedian1 dPmedian1],':k')
plot([corr1(3) corr1(3)], [0 yMax],':k')

text(-0.8, dPmedian1+0.15, sprintf('%.2f',dPmedian1))
text(corr1(3)-0.05,yMax-(yMax/5), sprintf('%.2f',corr1(3)),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
% clear dps cors dPmedian  


subplot(3,2,6)
hold on
axis square
ylabel('max |d''|')
xlabel('correlation')
xlim([-1 1])
ylim([0, yMax])

for ch = 1:96
    if data2.goodCh(ch)
        [y, maxAmp] = max(abs(data2.stimCircDprime(3,:,ch)));
        x = data2.stimCorrs(3,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(data2.stimCircDprimeSig(3,maxAmp,ch));
        corrSig   = squeeze(data2.stimCorrSig(3,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0 0.6 0.2], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
        clear x y
    end
end

dPmedian2 = nanmedian(dps);

plot([-1 1], [dPmedian2 dPmedian2],':k')
plot([corr2(3) corr2(3)], [0 yMax],':k')

text(-0.8, dPmedian2+0.15, sprintf('%.2f',dPmedian2))
text(corr2(3)-0.05,yMax-(yMax/5), sprintf('%.2f',corr2(3)),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

if dPsigPerm(3) == 1
    text(-3.25,yMax/2,sprintf('d'' difference %.2f*',dPmedian1 - dPmedian2),'FontWeight','bold','FontSize',10)
else
    text(-3.25,yMax/2,sprintf('d'' difference %.2f',dPmedian1 - dPmedian2),'FontSize',10)
end

if corSigPerm(3) == 1
    text(-3.25,yMax/2-0.5,sprintf('corr difference %.2f*',trueCor(3)),'FontWeight','bold','FontSize',10)
else
    text(-3.25,yMax/2-0.5,sprintf('corr difference %.2f',trueCor(3)),'FontSize',10)
end

clear dPmedian1 dPmedian2
%%

location = determineComputer;

if location == 1
    figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/',data1.animal,data1.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/',data1.animal,data1.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

set(gcf,'InvertHardcopy','off','Color','w')
print(gcf, figName,'-dpdf','-bestfit')