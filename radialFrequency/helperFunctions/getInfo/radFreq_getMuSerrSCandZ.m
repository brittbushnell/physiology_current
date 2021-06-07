function [rfMuZ, rfStErZ,circMuZ, circStErZ,...
    rfMuSc, rfStErSc,circMuSc, circStErSc] = radFreq_getMuSerrSCandZ(dataT,plotFlag)

%% separate zscores into RF and phase matrices
% phases per RF:
%   4: 0 & 45
%   8: 0 & 22.5
%   16: 0 & 11.25

zScores = dataT.RFzScore;
sCount  = dataT.RFspikeCount;

xPoss = unique(dataT.pos_x);
yPoss = unique(dataT.pos_y);
locPair = nan(1,2);

for xs = 1:length(xPoss)
    for ys = 1:length(yPoss)
        flerp = sum((dataT.pos_x == xPoss(xs)) & (dataT.pos_y == yPoss(ys)));
        if flerp >1
            locPair(end+1,:) = [xPoss(xs), yPoss(ys)];
        end
    end
end
locPair = locPair(2:end,:);
%%
%(RF,ori,amp,sf,radius,location, ch) 
rfMuZ = nan(3,2,6,2,2,3,96);
rfStErZ= nan(3,2,6,2,2,3,96);

% (sf,radius,location, ch) 
circMuZ = nan(2,2,3,96);
circStErZ = nan(2,2,3,96);

%(RF,ori,amp,sf,radius,location, ch) 
rfMuSc = nan(3,2,6,2,2,3,96);
rfStErSc= nan(3,2,6,2,2,3,96);

% (sf,radius,location, ch) 
circMuSc = nan(2,2,3,96);
circStErSc = nan(2,2,3,96);
%%
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/%s/tuningCurves/byCh/',dataT.animal,dataT.array,dataT.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/%s/tuningCurves/byCh/',dataT.animal,dataT.array,dataT.eye);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)
%%
if contains(dataT.animal,'XT')
    if contains(dataT.eye,'LE')
        eye = 'LE';
    else
        eye = 'RE';
    end
else
    if contains(dataT.eye,'LE')
        eye = 'FE';
    else
        eye = 'AE';
    end
end

for ch = 1:96
    ndx = 1;
    if plotFlag == 1
    figure (2)
    clf
    hold on
    pos = get(gcf,'Position');
    set(gcf, 'Position',[pos(1) pos(2) 850 900])
    
    s = suptitle(sprintf('%s %s %s mean zscores as a funciton of amplitude ch %d',dataT.animal, dataT.array, eye,ch));
    s.Position(2) = s.Position(2) + 0.02;
    
    fillCirc = sprintf('\x25CF');
    openCirc = sprintf('\x25CB');      
    end
    %%
    for loc = 1:3
        for sf = 1:2
            for rad = 1:2
                zCh = zScores{ch};
                
                sfNdx  = (zCh(4,:) == sf);
                radNdx = (zCh(5,:) == rad);
                locNdx = (zCh(6,:) == locPair(loc,1)) & (zCh(7,:) == locPair(loc,2));
                circNdx = (zCh(1,:) == 32);
                
                rf4Ndx0  = (zCh(1,:) == 4) & (zCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                rf4Ndx2  = (zCh(1,:) == 4) & (zCh(3,:) == 45);
                rf8Ndx0  = (zCh(1,:) == 8) & (zCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                rf8Ndx2  = (zCh(1,:) == 8) & (zCh(3,:) == 22.5);
                rf16Ndx0  = (zCh(1,:) == 16) & (zCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                rf16Ndx2  = (zCh(1,:) == 16) & (zCh(3,:) == 11.25);
                
                rf4rot0 = zCh(8:end,rf4Ndx0 & sfNdx & radNdx & locNdx);
                rf4rot2 = zCh(8:end,rf4Ndx2 & sfNdx & radNdx & locNdx);
                rf8rot0 = zCh(8:end,rf8Ndx0 & sfNdx & radNdx & locNdx);
                rf8rot2 = zCh(8:end,rf8Ndx2 & sfNdx & radNdx & locNdx);
                rf16rot0 = zCh(8:end,rf16Ndx0 & sfNdx & radNdx & locNdx);
                rf16rot2 = zCh(8:end,rf16Ndx2 & sfNdx & radNdx & locNdx);
                
                rfMuZ(1,1,:,sf,rad,loc,ch) = mean(rf4rot0);
                rfMuZ(1,2,:,sf,rad,loc,ch) = mean(rf4rot2);
                rfMuZ(2,1,:,sf,rad,loc,ch) = mean(rf8rot0);
                rfMuZ(2,2,:,sf,rad,loc,ch) = mean(rf8rot2);
                rfMuZ(3,1,:,sf,rad,loc,ch) = mean(rf16rot0);
                rfMuZ(3,2,:,sf,rad,loc,ch) = mean(rf16rot2);
                
                rfStErZ(1,1,:,sf,rad,loc,ch) = std(rf4rot0)/sqrt(length(rf4rot0));
                rfStErZ(1,2,:,sf,rad,loc,ch) = std(rf4rot0)/sqrt(length(rf4rot2));
                rfStErZ(2,1,:,sf,rad,loc,ch) = std(rf8rot0)/sqrt(length(rf8rot0));
                rfStErZ(2,2,:,sf,rad,loc,ch) = std(rf8rot0)/sqrt(length(rf8rot2));
                rfStErZ(3,1,:,sf,rad,loc,ch) = std(rf16rot0)/sqrt(length(rf16rot0));
                rfStErZ(3,2,:,sf,rad,loc,ch) = std(rf16rot0)/sqrt(length(rf16rot2));
                
                circZs = zCh(8:end,circNdx & sfNdx & radNdx & locNdx);
                circMuZ(sf,rad,loc,ch) = mean(circZs);
                circStErZ(sf,rad,loc,ch) = std(circZs)/sqrt(length(circZs));
                %% spike counts
                spikeCh =  sCount{ch};
                
                rf4Ndx0Sc  = (spikeCh(1,:) == 4) & (spikeCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                rf4Ndx2Sc  = (spikeCh(1,:) == 4) & (spikeCh(3,:) == 45);
                rf8Ndx0Sc  = (spikeCh(1,:) == 8) & (spikeCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                rf8Ndx2Sc  = (spikeCh(1,:) == 8) & (spikeCh(3,:) == 22.5);
                rf16Ndx0Sc  = (spikeCh(1,:) == 16) & (spikeCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                rf16Ndx2Sc  = (spikeCh(1,:) == 16) & (spikeCh(3,:) == 11.25);
                
                rf4rot0Sc = spikeCh(8:end,rf4Ndx0Sc & sfNdx & radNdx & locNdx);
                rf4rot2Sc = spikeCh(8:end,rf4Ndx2Sc & sfNdx & radNdx & locNdx);
                rf8rot0Sc = spikeCh(8:end,rf8Ndx0Sc & sfNdx & radNdx & locNdx);
                rf8rot2Sc = spikeCh(8:end,rf8Ndx2Sc & sfNdx & radNdx & locNdx);
                rf16rot0Sc = spikeCh(8:end,rf16Ndx0Sc & sfNdx & radNdx & locNdx);
                rf16rot2Sc = spikeCh(8:end,rf16Ndx2Sc & sfNdx & radNdx & locNdx);

                rfMuSc(1,1,:,sf,rad,loc,ch) = mean(rf4rot0Sc);
                rfMuSc(1,2,:,sf,rad,loc,ch) = mean(rf4rot2Sc);
                rfMuSc(2,1,:,sf,rad,loc,ch) = mean(rf8rot0Sc);
                rfMuSc(2,2,:,sf,rad,loc,ch) = mean(rf8rot2Sc);
                rfMuSc(3,1,:,sf,rad,loc,ch) = mean(rf16rot0Sc);
                rfMuSc(3,2,:,sf,rad,loc,ch) = mean(rf16rot2Sc);
                
                rfStErSc(1,1,:,sf,rad,loc,ch) = std(rf4rot0Sc)/sqrt(length(rf4rot0Sc));
                rfStErSc(1,2,:,sf,rad,loc,ch) = std(rf4rot0Sc)/sqrt(length(rf4rot2Sc));
                rfStErSc(2,1,:,sf,rad,loc,ch) = std(rf8rot0Sc)/sqrt(length(rf8rot0Sc));
                rfStErSc(2,2,:,sf,rad,loc,ch) = std(rf8rot0Sc)/sqrt(length(rf8rot2Sc));
                rfStErSc(3,1,:,sf,rad,loc,ch) = std(rf16rot0Sc)/sqrt(length(rf16rot0Sc));
                rfStErSc(3,2,:,sf,rad,loc,ch) = std(rf16rot0Sc)/sqrt(length(rf16rot2Sc));
                
                circSCs = spikeCh(8:end,circNdx & sfNdx & radNdx & locNdx);
                circMuSc(sf,rad,loc,ch) = mean(circSCs);
                circStErSc(sf,rad,loc,ch) = std(circSCs)/sqrt(length(circSCs));               
                %% verify spike count and zscore parameters are identical 
                rf4ParamsZ  = zCh(1:7,rf4Ndx0 & sfNdx & radNdx & locNdx);
                rf8ParamsZ  = zCh(1:7,rf8Ndx0 & sfNdx & radNdx & locNdx);
                rf16ParamsZ = zCh(1:7,rf16Ndx0 & sfNdx & radNdx & locNdx);
                
                rf4ParamsSc  = spikeCh(1:7,rf4Ndx0 & sfNdx & radNdx & locNdx);
                rf8ParamsSc  = spikeCh(1:7,rf8Ndx0 & sfNdx & radNdx & locNdx);
                rf16ParamsSc = spikeCh(1:7,rf16Ndx0 & sfNdx & radNdx & locNdx);
                
                if size(rf4ParamsZ) ~= size(rf4ParamsSc)
                    error('z score and spike count matrices are different sizes')
                end
                
                rf4ParamDiff = rf4ParamsZ - rf4ParamsSc;
                rf8ParamDiff = rf8ParamsZ - rf8ParamsSc;
                rf16ParamDiff = rf16ParamsZ - rf16ParamsSc;
                
                if sum(rf4ParamDiff) > 0
                    error('There is a difference in RF 4 parameters between Zscores and spike counts')
                end
                
                 if sum(rf8ParamDiff) > 0
                    error('There is a difference in RF 8 parameters between Zscores and spike counts')
                 end
                
                if sum(rf16ParamDiff) > 0
                    error('There is a difference in RF 16 parameters between Zscores and spike counts')
                end
                %% plot curves
                if plotFlag == 1
                subplot(3,4,ndx)
                
                rf4a = squeeze(rfMuZ(1,1,:,sf,rad,loc,ch));
                rf4b = squeeze(rfMuZ(1,2,:,sf,rad,loc,ch));
                
                rf8a = squeeze(rfMuZ(2,1,:,sf,rad,loc,ch));
                rf8b = squeeze(rfMuZ(2,2,:,sf,rad,loc,ch));
                
                rf16a = squeeze(rfMuZ(3,1,:,sf,rad,loc,ch));
                rf16b = squeeze(rfMuZ(3,2,:,sf,rad,loc,ch));
                
                circ = squeeze(circMuZ(sf,rad,loc,ch));
                
                hold on
                plot(1,circ,'ok','MarkerFaceColor','k','MarkerSize',4)
                plot(2:7,rf4a,'o-','Color',[0 0.6 0.2],'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor',[0 0.6 0.2],'MarkerSize',4)
                plot(2:7,rf4b,'o--','Color',[0 0.6 0.2],'MarkerFaceColor','w','MarkerEdgeColor',[0 0.6 0.2],'MarkerSize',4)
                
                plot(2:7,rf8a,'o-','Color',[1 0.5 0.1],'MarkerFaceColor',[1 0.5 0.1],'MarkerEdgeColor',[1 0.5 0.1],'MarkerSize',4)
                plot(2:7,rf8b,'o--','Color',[1 0.5 0.1],'MarkerFaceColor','w','MarkerEdgeColor',[1 0.5 0.1],'MarkerSize',4)
                
                plot(2:7,rf16a,'o-','Color',[0.7 0 0.7],'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor',[0.7 0 0.7],'MarkerSize',4)
                plot(2:7,rf16b,'o--','Color',[0.7 0 0.7],'MarkerFaceColor','w','MarkerEdgeColor',[0.7 0 0.7],'MarkerSize',4)
                
                xlim([0.75 10])
                
                mygca(ndx) = gca;
                
                b = get(gca,'YLim');
                yMaxs(ndx) = max(b);
                yMins(ndx) = min(b);
                
                title(sprintf('sf %d rad %d loc %d',sf,rad,loc))
                set(gca,'Box','off','XScale','log','tickdir','out','TickLength',[0.03 0.025],'XTickLabel',[])
                axis square
                
                if ndx == 1 || ndx == 5 || ndx == 9
                    ylabel('zscore')
                end
                
                if ndx >= 9
                    xlabel('amplitude')
                end
                %%
                ndx = ndx+1;
                end
            end
        end
    end
    if plotFlag == 1
    minY = min(yMins);
    maxY = max(yMaxs);
    yLimits = ([minY maxY]);
    set(mygca,'YLim',yLimits);
    %%
    subplot(3,4,9)
    hold on
    text(20, minY - 1, 'RF4','Color',[0 0.6 0.2],'FontWeight','bold','FontSize',12)
    text(80, minY - 1, 'RF8','Color',[1 0.5 0.1],'FontWeight','bold','FontSize',12)
    text(200, minY - 1, 'RF16','Color',[0.7 0 0.7],'FontWeight','bold','FontSize',12)
    text(500, minY - 1, 'Circle','FontWeight','bold','FontSize',12)
    
    text(30, minY - 1.35, fillCirc,'FontWeight','bold','FontSize',20);    
    text(40, minY - 1.4,'0 deg','FontWeight','bold','FontSize',12)
    text(150, minY - 1.35, openCirc,'FontWeight','bold','FontSize',20);
    text(200, minY - 1.4, 'alternate phase','FontWeight','bold','FontSize',12)

    
    %%
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_radFreqTuningCurves_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
    end
end



