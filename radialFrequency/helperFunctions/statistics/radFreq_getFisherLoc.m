function  [prefLoc] = radFreq_getFisherLoc(dataT,plotAll)
%%
location = determineComputer;

if location == 1
    if contains(dataT.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/location',dataT.animal,dataT.array,dataT.eye);
    elseif contains(dataT.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/location',dataT.animal,dataT.array,dataT.eye);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/location',dataT.animal,dataT.array,dataT.eye);
    end
elseif location == 0
    if contains(dataT.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/location',dataT.animal,dataT.array,dataT.eye);
    elseif contains(dataT.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/location',dataT.animal,dataT.array,dataT.eye);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/location',dataT.animal,dataT.array,dataT.eye);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)
%%
%(RF,ori,amp,sf,radius,location, ch)
spikes = dataT.RFspikeCount;
locPair = dataT.locPair;
zTr = nan(3,96);
prefLoc = nan(1,96);

amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 1:6;
%%
for ch = 1:96
    scCh = spikes{ch};
    if dataT.goodCh == 1
        if plotAll == 1
            figure(1)
            clf
            pos = get(gcf,'Position');
            set(gcf,'Position',[pos(1), pos(2), 300, 700])
            
            s = suptitle(sprintf('%s %s %s Fisher r to z ch %d',dataT.animal, dataT.eye, dataT.array, ch));
            s.Position(2) = s.Position(2)+0.0272;
        end
        
        for loc = 1:3
            muSc = nan(1,6);
            for amp = 1:6
                
                noCircNdx = (scCh(1,:) < 32);
                circNdx = (scCh(1,:) == 32);
                locNdx = (scCh(6,:) == locPair(loc,1)) & (scCh(7,:) == locPair(loc,2));
                ampNdx = (scCh(2,:) == amps48(amp)) | (scCh(2,:) == amps16(amp));
                stimSpikes = squeeze(scCh(8:end,locNdx & ampNdx & noCircNdx));
                circSpikes = squeeze(scCh(8:end,locNdx & circNdx));
                
                muSc(1,amp) = (nanmean(stimSpikes,'all')) - (nanmean(circSpikes,'all'));
            end
            sCorr = corr2(xs,muSc);
            zTr(loc,ch) = atanh(sCorr);
            if abs(zTr) > 2
                
            
            [~,prefLoc(ch)] = max(zTr(:,ch));
            
            if plotAll == 1
                h = subplot(3,1,loc);
                hold on
                plot(muSc,'o-')
                
                xlim([0.5 6.5])
                title({sprintf('location %d (%.1f, %.1f)',loc,locPair(loc,1),locPair(loc,2));...
                    sprintf('r %.2f   Fisher z %.2f',sCorr, zTr(loc,ch))}, 'FontSize',12,'FontWeight','normal');

                if loc == 2
                    ylabel('mean spike count circle subtracted')
                end
                
                if loc == 3
                    xlabel('amplitude')
                end
                set(gca,'XTick',1:6,'XTickLabel',1:6,'tickdir','out','FontSize',10,'FontAngle','italic')
                
                mygca(loc) = gca;
                b = get(gca,'YLim');
                yMaxs(loc) = max(b);
                yMins(loc) = min(b);
                
                h.Position(1) = h.Position(1) + 0.05;
                h.Position(2) = h.Position(2) - 0.02;
            end
        end
        if plotAll == 1
            minY = min(yMins);
            maxY = max(yMaxs);
            yLimits = ([minY maxY]);
            set(mygca,'YLim',yLimits);

            if prefLoc(ch) == 1
                text(1,maxY*4.25,'*','FontSize',24)
            elseif prefLoc(ch) == 2
                text(1,maxY*2.5,'*','FontSize',24)
           else
                text(1,maxY - 0.5,'*','FontSize',24)
            end
            figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_FisherT_location_ch',num2str(ch),'.pdf'];
            print(gcf, figName,'-dpdf','-bestfit')
        end
    end
end

%% plot distribition
cd ../

figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), pos(3), 750])
hold on

s = suptitle({sprintf('%s %s %s Fisher transformed correlations by location', dataT.animal, dataT.array, dataT.eye);...
    'spike counts with circle response subtracted'});
s.Position(2) = s.Position(2) +0.02;


for l = 1:3
    subplot(3,1,l)
    hold on
    trCh = zTr(l,:);
    allZs = reshape(trCh,1,numel(trCh));
    zm1 = abs(max(allZs));
    zm2 = abs(min(allZs));
    
    zmax = max(zm1,zm2)+0.5;
    xlim([-1*(zmax), zmax])
    
    histogram(allZs,'Normalization','probability','BinWidth',0.25,'FaceColor','k','EdgeColor','w');
    yScale = get(gca,'ylim');
    xScale = get(gca,'xlim');
    
    ylim([0, yScale(2)+0.02])
    
    plot(nanmean(allZs),yScale(2)+0.02,'v','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',9)
    text(nanmean(allZs)+0.15,yScale(2)+0.02,sprintf('\\mu %.2f',nanmean(allZs)))
    title(sprintf('location %d (%.1f, %.1f)',l,locPair(l,1),locPair(l,2)))
    
    
    set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
    
    if l == 1
        text(xScale(1)+ 0.5, yScale(2)+0.01, sprintf('n ch: %d',sum(dataT.goodCh)))
    end
    
    text(xScale(1)+ 0.5, yScale(2), sprintf('# ch prefer this location: %d',sum(prefLoc == l)))
    
    ylabel('probability','FontSize',11,'FontAngle','italic')
    xlabel('Fisher transformed r to z','FontSize',11,'FontAngle','italic')
    
    mygca(l) = gca;
    b = get(gca,'YLim');
    yMaxs(l) = max(b);
    yMins(l) = min(b);
end
minY = min(yMins);
maxY = max(yMaxs);
yLimits = ([minY maxY]);
set(mygca,'YLim',yLimits);

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_FisherT_location_dist','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
