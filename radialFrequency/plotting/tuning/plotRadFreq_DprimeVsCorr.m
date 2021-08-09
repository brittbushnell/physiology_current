function plotRadFreq_DprimeVsCorr(LEdata,REdata)
%%
% x: corr
% y: d'

LEmax = max(abs(LEdata.stimCircDprime),[],'all');
REmax = max(abs(REdata.stimCircDprime),[],'all');

yMax = max([LEmax,REmax]) + 0.5;
%%
figure(3)
clf

s = suptitle(sprintf('%s %s max |d''| versus best stimulus correlation', REdata.animal, REdata.array));
s.Position(2) = s.Position(2) + 0.022;

subplot(3,2,1)
hold on
axis square
ylabel('max |d''|')

if contains(LEdata.animal,'XT')
    title('LE')
else
    title('FE')
end

xlim([-1 1])
ylim([0, yMax])
%text( -2.3, (0+yMax)/2, 'RF4','FontSize',12,'FontWeight','bold')

for ch = 1:96
    if LEdata.goodCh(ch)
        [y, maxAmp] = max(abs(LEdata.stimCircDprime(1,:,ch)));
        x = LEdata.stimCorrs(1,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(LEdata.stimCircDprimeSig(1,maxAmp,ch));
        corrSig   = squeeze(LEdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

dPmedian = nanmedian(dps);
corMedian = nanmedian(cors);

plot([-1 1], [dPmedian dPmedian],':k')
plot([corMedian corMedian], [0 yMax],':k')

%text(-0.8, dPmedian+0.15, sprintf('median d'' %.2f',dPmedian))
%text(corMedian-0.05,yMax-1.5, sprintf('median correlation %.2f',corMedian),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

subplot(3,2,3)
hold on
axis square
ylabel('max |d''|')

if contains(LEdata.animal,'XT')
    title('LE')
else
    title('FE')
end

xlim([-1 1])
ylim([0, yMax])
%text( -2.3, (0+yMax)/2, 'RF8','FontSize',12,'FontWeight','bold')

for ch = 1:96
    if LEdata.goodCh(ch)
        [y, maxAmp] = max(abs(LEdata.stimCircDprime(2,:,ch)));
        x = LEdata.stimCorrs(1,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(LEdata.stimCircDprimeSig(2,maxAmp,ch));
        corrSig   = squeeze(LEdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[1 0.5 0.1], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

dPmedian = nanmedian(dps);
corMedian = nanmedian(cors);

plot([-1 1], [dPmedian dPmedian],':k')
plot([corMedian corMedian], [0 yMax],':k')

%text(-0.8, dPmedian+0.15, sprintf('median d'' %.2f',dPmedian))
%text(corMedian-0.05,yMax-1.5, sprintf('median correlation %.2f',corMedian),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

subplot(3,2,5)
hold on
axis square
ylabel('max |d''|')

if contains(LEdata.animal,'XT')
    title('LE')
else
    title('FE')
end

xlim([-1 1])
ylim([0, yMax])
%text( -2.3, (0+yMax)/2, 'RF16','FontSize',12,'FontWeight','bold')

for ch = 1:96
    if LEdata.goodCh(ch)
        [y, maxAmp] = max(abs(LEdata.stimCircDprime(3,:,ch)));
        x = LEdata.stimCorrs(1,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(LEdata.stimCircDprimeSig(3,maxAmp,ch));
        corrSig   = squeeze(LEdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0 0.6 0.2], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

dPmedian = nanmedian(dps);
corMedian = nanmedian(cors);

plot([-1 1], [dPmedian dPmedian],':k')
plot([corMedian corMedian], [0 yMax],':k')

%text(-0.8, dPmedian+0.15, sprintf('median d'' %.2f',dPmedian))
%text(corMedian-0.05,yMax-1.5, sprintf('median correlation %.2f',corMedian),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)


subplot(3,2,2)
hold on
axis square
ylabel('max |d''|')

if contains(REdata.animal,'XT')
    title('RE')
else
    title('FE')
end

xlim([-1 1])
ylim([0, yMax])

for ch = 1:96
    if REdata.goodCh(ch)
        [y, maxAmp] = max(abs(REdata.stimCircDprime(1,:,ch)));
        x = REdata.stimCorrs(1,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(REdata.stimCircDprimeSig(1,maxAmp,ch));
        corrSig   = squeeze(REdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

dPmedian = nanmedian(dps);
corMedian = nanmedian(cors);

plot([-1 1], [dPmedian dPmedian],':k')
plot([corMedian corMedian], [0 yMax],':k')

%text(-0.8, dPmedian+0.15, sprintf('median d'' %.2f',dPmedian))
%text(corMedian-0.05,yMax-1.5, sprintf('median correlation %.2f',corMedian),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

subplot(3,2,4)
hold on
axis square
ylabel('max |d''|')

if contains(REdata.animal,'XT')
    title('RE')
else
    title('FE')
end

xlim([-1 1])
ylim([0, yMax])

for ch = 1:96
    if REdata.goodCh(ch)
        [y, maxAmp] = max(abs(REdata.stimCircDprime(2,:,ch)));
        x = REdata.stimCorrs(1,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(REdata.stimCircDprimeSig(2,maxAmp,ch));
        corrSig   = squeeze(REdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[1 0.5 0.1], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

dPmedian = nanmedian(dps);
corMedian = nanmedian(cors);

plot([-1 1], [dPmedian dPmedian],':k')
plot([corMedian corMedian], [0 yMax],':k')

%text(-0.8, dPmedian+0.15, sprintf('median d'' %.2f',dPmedian))
%text(corMedian-0.05,yMax-1.5, sprintf('median correlation %.2f',corMedian),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

subplot(3,2,6)
hold on
axis square
ylabel('max |d''|')

if contains(REdata.animal,'XT')
    title('RE')
else
    title('FE')
end

xlim([-1 1])
ylim([0, yMax])

for ch = 1:96
    if REdata.goodCh(ch)
        [y, maxAmp] = max(abs(REdata.stimCircDprime(3,:,ch)));
        x = REdata.stimCorrs(1,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(REdata.stimCircDprimeSig(3,maxAmp,ch));
        corrSig   = squeeze(REdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0 0.6 0.2], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

dPmedian = nanmedian(dps);
corMedian = nanmedian(cors);

plot([-1 1], [dPmedian dPmedian],':k')
plot([corMedian corMedian], [0 yMax],':k')

%text(-0.8, dPmedian+0.15, sprintf('median d'' %.2f',dPmedian))
%text(corMedian-0.05,yMax-1.5, sprintf('median correlation %.2f',corMedian),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
%%

location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
        end
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
        end
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)


set(gcf,'InvertHardcopy','off','Color','w')
figName = [LEdata.animal,'_BE_',LEdata.array,'_',LEdata.programID,'_dPrimeVsCorr','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')