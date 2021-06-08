function [prefRFphase] = radFreq_getFisherRFphase(dataT)
%%

location = determineComputer;

if location == 1
    if contains(dataT.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/RFphase',dataT.animal,dataT.array,dataT.eye);
    elseif contains(dataT.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/RFphase',dataT.animal,dataT.array,dataT.eye);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/RFphase',dataT.animal,dataT.array,dataT.eye);
    end
elseif location == 0
    if contains(dataT.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/RFphase',dataT.animal,dataT.array,dataT.eye);
    elseif contains(dataT.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/RFphase',dataT.animal,dataT.array,dataT.eye);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/RFphase',dataT.animal,dataT.array,dataT.eye);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)
%%
%(RF,ori,amp,sf,radius,location, ch)
spikes = dataT.RFspikeCount;
pLoc   = dataT.prefLoc;
locPair = dataT.locPair;

zTr = nan(3,96);
prefRFphase = nan(1,96);

amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
rfs = [4 8 16];
xs = 1:6;
%%
for ch = 1%:96
    scCh = spikes{ch};
    if dataT.goodCh == 1
        figure(1)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1), pos(2), 450, 700])
        
        s = suptitle(sprintf('%s %s %s Fisher r to z ch %d',dataT.animal, dataT.eye, dataT.array, ch));
        s.Position(2) = s.Position(2)+0.025;
        ndx = 1;
        
        circNdx = (scCh(1,:) == 32);
        locNdx = (scCh(6,:) == locPair(pLoc,1)) & (scCh(7,:) == locPair(pLoc,2));
        for rf = 1%:3
            rfNdx  = scCh(1,:) == rfs(rf);
            for ph = 1%:2
                if ph == 1
                    phNdx = scCh(3,:) == 0;
                elseif rf == 1
                    phNdx = scCh(3,:) == 45;
                elseif rf == 2
                    phNdx = scCh(3,:) == 22.5;
                else
                    phNdx = scCh(3,:) == 11.25;
                end
                
                muSc = nan(1,6);
                
                for amp = 1:6
                    if rf == 3
                        ampNdx = (scCh(2,:) == amps16(amp));
                    else
                        ampNdx = (scCh(2,:) == amps48(amp));
                    end
                    stimSpikes = squeeze(scCh(8:end,locNdx & ampNdx & phNdx & rfNdx));
                    circSpikes = squeeze(scCh(8:end,locNdx & circNdx));
                    
                    muSc(1,amp) = (nanmean(stimSpikes,'all')) - (nanmean(circSpikes,'all'));
                end
                sCorr = corr2(xs,muSc);
                zTr(rf,ph,ch) = atanh(sCorr);
                
                h = subplot(3,2,ndx);
                hold on
                plot(muSc,'o-')
                
                xlim([0.5 6.5])
                title({sprintf('RF %d phase %.2d',rf,ph);...
                    sprintf('r %.2f   Fisher z %.2f',sCorr, zTr(rf,ph,ch))})
                if rf == 2
                    ylabel('mean spike count circle subtracted')
                end
                
                if rf == 3
                    xlabel('amplitude')
                end
                set(gca,'XTick',1:6,'XTickLabel',1:6,'tickdir','out','FontSize',10,'FontAngle','italic')
                
                mygca(ndx) = gca;
                b = get(gca,'YLim');
                yMaxs(ndx) = max(b);
                yMins(ndx) = min(b);
                
                h.Position(1) = h.Position(1) + 0.05;
                ndx = ndx+1;
            end
        end
        minY = min(yMins);
        maxY = max(yMaxs);
        yLimits = ([minY maxY]);
        set(mygca,'YLim',yLimits);
        
        [~,prefRFphase(ch)] = max(zTr(:,ch));
        
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_FisherT_location_ch',num2str(ch),'.pdf'];
        %         print(gcf, figName,'-dpdf','-bestfit')
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
    
    text(xScale(1)+ 0.5, yScale(2), sprintf('# ch prefer this location: %d',sum(prefRFphase == l)))
    
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
% print(gcf, figName,'-dpdf','-bestfit')
