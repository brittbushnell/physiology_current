function [LEcorr, REcorr] = radFreq_getNeuroCorr_dPrime(LEdata, REdata)

location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
        end
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/neurometric/dPrime/Ch',LEdata.animal,LEdata.array);
        end
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
% (RF,amp,ch)
REdPrime =  REdata.stimCircDprime;
LEdPrime =  LEdata.stimCircDprime;

% (eye, RF, ch)
stimCorr = nan(2,3,96);
xs = 0:6;
%%
for ch = 1:96
    if LEdata.goodCh(ch) || REdata.goodCh(ch)
        figure(1)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1), pos(2), 600, 450])
        hold on
        
        s = suptitle(sprintf('%s %s %s neurometric curves ch %d',REdata.animal, REdata.array, REdata.programID,ch));
        %         s.Position(2) = s.Position(2)+0.0272;
        
        for foo = 1:2
            subplot(1,2,foo)
            mygca(1,foo) = gca;
            xlim([-0.5 7.5])
            axis square
            if foo == 1
                title(sprintf('%s',LEdata.eye),'FontSize',12,'FontWeight','bold','FontAngle','italic');
            else
                title(sprintf('%s',REdata.eye),'FontSize',12,'FontWeight','bold','FontAngle','italic');
            end
        end
        
        for ey = 1:2
            
            if ey == 1
                dataT = LEdata;
                dpCh = squeeze(LEdPrime(:,:,ch));
            else
                dataT = REdata;
                dpCh = squeeze(REdPrime(:,:,ch));
            end
            
            if dataT.goodCh(ch)
                rfAmps = nan(3,6);
                
                for rf = 1:3
                    rfT = squeeze(dpCh(rf,:)); 
                    rfAmps(rf,:) = rfT;
                    dpZeroAnch = [0, rfT];
                    corMtx = corrcoef(xs,dpZeroAnch);
                    stimCorr(ey,rf,ch) = corMtx(2);
                end %rf
                
                subplot(1,2,ey)
                hold on
                axis square
                rf4 = squeeze(rfAmps(1,:));
                rf8 = squeeze(rfAmps(2,:));
                rf16 = squeeze(rfAmps(3,:));
                
                plot(1,0,'ok')
                plot(2:7,rf4,'-o','Color',[0.7 0 0.7])
                plot(2:7,rf8,'-o','Color',[1 0.5 0.1])
                plot(2:7,rf16,'-o','Color',[0 0.6 0.2])
                
                
                xlim([-0.5 7.5])
                set(gca,'XTick',1:7,'XTickLabel',0:6,'tickdir','out','FontSize',10,'FontAngle','italic')
                
                if ey == 1
                    ylabel('d'' vs circle')
                else
                    l = legend('Circle','RF4','RF8','RF16','Location','Best');
                    l.Box = 'off';
                    l.FontSize = 10;
                end
                xlabel('Amplitude')
                
                mygca(1,ey) = gca;
                b = get(gca,'YLim');
                yMaxs(ey) = b(2);
                yMins(ey) = b(1);
                
            end%goodCh
        end %eye
        minY = min(yMins);
        maxY = max(yMaxs);
        yLimits = ([minY maxY]);
        set(mygca,'YLim',yLimits);
        
        figName = [LEdata.animal,'_BE_',LEdata.array,'_',LEdata.programID,'_neuroCurves_Dprime_ch',num2str(ch),'.pdf'];
        print(gcf, figName,'-dpdf','-bestfit')
    end
end %ch
%%
LEcorr = squeeze(stimCorr(1,:,:));
REcorr = squeeze(stimCorr(2,:,:));
%% plot distribution of slopes
cd ..
figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 600, 700])


s = suptitle(sprintf('%s %s %s distribution of slopes of neurometric curves',REdata.animal, REdata.array, REdata.programID));
s.Position(2) = s.Position(2)+0.0272;

subplot(3,2,1)
hold on
title(sprintf('%s',LEdata.eye))
xlim([-1 1])
ylim([0 0.6])
rfDist = squeeze(stimCorr(1,1,:));
muRF = nanmean(rfDist);
histogram(rfDist,'BinWidth',0.25,'Normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w')
plot([muRF muRF], [0 0.5],'-k')
text(muRF-0.015, 0.5,sprintf('\\mu %.2f',muRF),'FontSize',10,'FontAngle','italic','HorizontalAlignment','right')
set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
ylabel('Proportion of included channels')

text(-1.5, 0.3,'RF4','FontSize',12,'FontWeight','bold','Rotation',90)
clear rfDist muRF

subplot(3,2,3)
hold on
xlim([-1 1])
ylim([0 0.6])
rfDist = squeeze(stimCorr(1,2,:));
muRF = nanmean(rfDist);
histogram(rfDist,'BinWidth',0.25,'Normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w')
plot([muRF muRF], [0 0.5],'-k')
text(muRF-0.015, 0.5,sprintf('\\mu %.2f',muRF),'FontSize',10,'FontAngle','italic','HorizontalAlignment','right')
set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
ylabel('Proportion of included channels')
text(-1.5, 0.3,'RF8','FontSize',12,'FontWeight','bold','Rotation',90)

clear rfDist muRF

subplot(3,2,5)
hold on
xlim([-1 1])
ylim([0 0.6])
rfDist = squeeze(stimCorr(1,3,:));
muRF = nanmean(rfDist);
histogram(rfDist,'BinWidth',0.25,'Normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w')
plot([muRF muRF], [0 0.5],'-k')
text(muRF-0.015, 0.5,sprintf('\\mu %.2f',muRF),'FontSize',10,'FontAngle','italic','HorizontalAlignment','right')
set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
xlabel('Correlation of neurometric curves')
ylabel('Proportion of included channels')
text(-1.5, 0.3,'RF16','FontSize',12,'FontWeight','bold','Rotation',90)

clear rfDist muRF

subplot(3,2,2)
hold on
title(sprintf('%s',REdata.eye))
xlim([-1 1])
ylim([0 0.6])
rfDist = squeeze(stimCorr(2,1,:));
muRF = nanmean(rfDist);
histogram(rfDist,'BinWidth',0.25,'Normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w')
plot([muRF muRF], [0 0.5],'-k')
text(muRF-0.015, 0.5,sprintf('\\mu %.2f',muRF),'FontSize',10,'FontAngle','italic','HorizontalAlignment','right')
set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')

clear rfDist muRF

subplot(3,2,4)
hold on
xlim([-1 1])
ylim([0 0.6])
rfDist = squeeze(stimCorr(2,2,:));
muRF = nanmean(rfDist);
histogram(rfDist,'BinWidth',0.25,'Normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w')
plot([muRF muRF], [0 0.5],'-k')
text(muRF-0.015, 0.5,sprintf('\\mu %.2f',muRF),'FontSize',10,'FontAngle','italic','HorizontalAlignment','right')
set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')

clear rfDist muRF

subplot(3,2,6)
hold on
xlim([-1 1])
ylim([0 0.6])
rfDist = squeeze(stimCorr(2,3,:));
muRF = nanmean(rfDist);
histogram(rfDist,'BinWidth',0.25,'Normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w')
plot([muRF muRF], [0 0.5],'-k')
text(muRF-0.015, 0.5,sprintf('\\mu %.2f',muRF),'FontSize',10,'FontAngle','italic','HorizontalAlignment','right')
set(gca,'tickdir','out','Xtick',[-1 0 1],'FontSize',10,'FontAngle','italic','layer','top')
xlabel('Correlation of neurometric curves')

clear rfDist muRF
%%

figName = [LEdata.animal,'_BE_',LEdata.array,'_',LEdata.programID,'_NeuroSlopeDist_dPrime','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

