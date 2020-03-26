function [data] = getGlassODI(data)
ODI = zeros(1,96);
REDprime = zeros(1,96);
LEDprime = zeros(1,96);

for ch = 1:96
    REdata = data.RE;
    LEdata = data.LE;
    if REdata.goodCh(1,ch) == 0
        REDprime(1,ch) = 0;
    else
        REDprime(1,ch) = abs(REdata.allStimBlankDprime(1,ch));
    end
    
    if LEdata.goodCh(1,ch) == 0
        LEDprime(1,ch) = 0;
    else
        LEDprime(1,ch) = abs(LEdata.allStimBlankDprime(1,ch));
    end
    
    ODI(1,ch) = (LEDprime(1,ch) - REDprime(1,ch)) / (LEDprime(1,ch) + REDprime(1,ch));
end
data.RE.ODI = ODI;
data.LE.ODI = ODI;
%%
location = determineComputer;

if contains(REdata.animal,'WV')
    if location == 1
        if contains(REdata.programID,'Small')
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/4Deg/EyeComps',REdata.animal, REdata.array);
        else
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/8Deg/EyeComps',REdata.animal, REdata.array);
        end
    elseif location == 0
        if contains(REdata.programID,'Small')
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/4Deg/EyeComps',REdata.animal, REdata.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/8Deg/EyeComps',REdata.animal, REdata.array);
        end
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/EyeComps',REdata.animal, REdata.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/EyeComps',REdata.animal, REdata.array);
    end
end
cd(figDir)
%%
figure
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 500 400])
set(gcf,'PaperOrientation','Landscape');

subplot(2,1,1)
hold on
histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

if contains(REdata.animal,'XT')
    set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})
else
    set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})
end

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.4,'vk')
plot(nanmedian(ODI),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w')
text(nanmedian(ODI+0.1),0.4,sprintf('%.2f',nanmedian(ODI)))
xlim([-1.3 1.3])

xlabel('ODI')
ylabel('Probability')

title(sprintf('%s %s',REdata.animal, REdata.array))
figName = [REdata.animal,'_',REdata.array,'_GlassODI_raw','.pdf'];

print(gcf,figName,'-dpdf','-fillpage')