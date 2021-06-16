
% files = {'WU_RE_RadFreqLoc1_nsp2_20170627_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc1_nsp2_20170628_002_thresh35_info.mat'};
% newName = 'WU_RE_radFreqLoc1_nsp2_June2017_info';


filename = 'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info_goodCh';

load(filename)
if contains(filename,'RE')
    dataT = data.RE;
else
    dataT = data.LE;
end
%%
spikes = dataT.RFspikeCount;
zTr = nan(3,96);
prefLoc = nan(1,96);

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

amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 0:6;
%%
testChs = [13, 19, 28, 62];
for chx = 1:length(testChs)
    ch = testChs(chx);
    for ey = 1:2
        if ey == 1
%             dataT = dataT;
            scCh = spikes{ch};
            ndx = 1;
        else
%             dataT = dataT;
            scCh = spikes{ch};
            ndx = 2;
        end
        
%         figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/checks/ch%d',dataT.animal,dataT.array, dataT.eye,ch);
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/checks/',dataT.animal,dataT.array, dataT.eye);
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
        
        cd(figDir)
        
        if dataT.goodCh(ch) == 1
            
            muSc = nan(size(locPair,1)+1,7);
            muSc(:,1) = 0;
            corrP = nan(3,2);
            
            for loc = 2%1:size(locPair,1)
                for amp = 1%:6
                    % get spike counts for the applicable stimuli
                    noCircNdx = (scCh(1,:) < 32);
                    circNdx = (scCh(1,:) == 32);
                    locNdx = (scCh(6,:) == locPair(loc,1)) & (scCh(7,:) == locPair(loc,2));
                    amp48Ndx = (scCh(2,:) == amps48(amp) & (scCh(1,:) < 16));
                    amp16Ndx = (scCh(2,:) == amps16(amp)& (scCh(1,:) == 16));
                    stim48Spikes = squeeze(scCh(8:end,locNdx & amp48Ndx & noCircNdx));
                    stim16Spikes = squeeze(scCh(8:end,locNdx & amp16Ndx & noCircNdx));
                    stimSpikes = [stim48Spikes, stim16Spikes];
                    circSpikes = squeeze(scCh(8:end,locNdx & circNdx));
                    
                    % get mean spike count for each amplitude and subtract
                    % response to circle from that.
                    muSc(loc,amp+1) = (nanmean(stimSpikes,'all')) - (nanmean(circSpikes,'all'));
                    
                    stim4Spikes = stim48Spikes(:,1:(size(stim48Spikes,2)/2));
                    stim8Spikes = stim48Spikes(:,(size(stim48Spikes,2)/2)+1:end);
                    
                    figure%(13)
                    clf
                    s = suptitle(sprintf('%s %s %s spike counts per repeat ch %d amplitude %d location %d',dataT.animal, dataT.eye, dataT.array, ch, amp, loc));
                    s.Position(2) = s.Position(2) + 0.02;
                    
                    subplot(2,2,1)
                    plot(circSpikes)
                    title('circle')
                    ylabel('spike count')
                    set(gca,'box','off')
                    
                    subplot(2,2,2)
                    plot(stim4Spikes)
                    title('RF4')
                    set(gca,'box','off')
                    
                    subplot(2,2,3)
                    plot(stim8Spikes)
                    title('RF8')
                    ylabel('spike count')
                    xlabel('repeat')
                    set(gca,'box','off')
                    
                    subplot(2,2,4)
                    plot(stim16Spikes)
                    title('RF16')
                    xlabel('repeat')
                    set(gca,'box','off')
                    
                    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_spikesByRep_location',num2str(loc),'_amp',num2str(amp),'_ch',num2str(ch),'.pdf'];
%                     print(gcf, figName,'-dpdf','-bestfit')
                end
            end
        end
    end
end