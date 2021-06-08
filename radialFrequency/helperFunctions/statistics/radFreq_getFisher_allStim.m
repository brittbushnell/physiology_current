function [zTr] = radFreq_getFisher_allStim(dataT)
%zTr = (RF,phase,sf,radius,location, ch)
% zTr contains the fisher transformed correlations based on spike counts
% with the response to a circle subtracted from it.
%%
%(RF,ori,amp,sf,radius,location, ch) 
spikes = dataT.rfMuSc;

% (sf,radius,location, ch) 
circSpks = dataT.circMuSc;

%(RF,phase,sf,radius,location, ch) no dimension for amplitude b/c the
%correlations are computed across the amplitudes.
zTr = nan(3,2,2,2,3,96);
%%
xVals = 1:size(spikes,3);
xVals = log2(xVals);

for ch = 1:96
    if dataT.goodCh(ch) == 1
        for rf = 1:size(spikes,1)
            for ph = 1:size(spikes,2)
                for sf = 1:size(spikes,4)
                    for rad = 1:size(spikes,5)
                        for loc = 1:size(spikes,6)
                            spikeCh = squeeze(spikes(rf,ph,:,sf,rad,loc,ch));
                            circCh  = squeeze(circSpks(sf,rad,loc,ch));
                            
                            circSubSpikes = spikeCh - circCh;
                            sCorr = corr2(xVals, circSubSpikes');
                            zTr(rf,ph,sf,rad,loc,ch)  = atanh(sCorr); 
                            
                        end
                    end
                end
            end
        end
    end
end
%% plot distribution of everything
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), pos(3), 350],'PaperOrientation','landscape')
hold on

title({sprintf('%s %s %s Fisher transformed correlations for all parameters in included channels', dataT.animal, dataT.array, dataT.eye);...
    'spike counts with circle response subtracted'});


allZs = reshape(zTr,1,numel(zTr));
zm1 = abs(max(allZs));
zm2 = abs(min(allZs));

zmax = max(zm1,zm2)+0.5;
xlim([-1*(zmax), zmax])

histogram(allZs,'Normalization','probability','BinWidth',0.125,'FaceColor','k','EdgeColor','w');
yScale = get(gca,'ylim');
xScale = get(gca,'xlim');

ylim([0, yScale(2)+0.02])

plot(nanmean(allZs),yScale(2),'v','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(allZs)+0.15,yScale(2),sprintf('\\mu %.2f',nanmean(allZs)))

pos = get(gca,'Position');
set(gca,'tickdir','out', 'Position',[pos(1), pos(2), pos(3), pos(4) - 0.15],'Layer','top','FontSize',10,'FontAngle','italic');

text(xScale(1)+ 0.5, yScale(2)+0.01, sprintf('n ch: %d',sum(dataT.goodCh)))
ylabel('probability','FontSize',11,'FontAngle','italic')
xlabel('Fisher transformed r to z','FontSize',11,'FontAngle','italic')

%%
location = determineComputer;

if location == 1
    if contains(dataT.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/',dataT.animal,dataT.array,dataT.eye);
    elseif contains(dataT.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/',dataT.animal,dataT.array,dataT.eye);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/',dataT.animal,dataT.array,dataT.eye);
    end
elseif location == 0
    if contains(dataT.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/',dataT.animal,dataT.array,dataT.eye);
    elseif contains(dataT.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/',dataT.animal,dataT.array,dataT.eye);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/',dataT.animal,dataT.array,dataT.eye);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)

    %%
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_FisherTransform_Everything','.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')

