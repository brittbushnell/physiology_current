clear all
close all
clc
%% NOTE
%%
% V1
% file = 'XT_radFreqLowSF_loc1_V1_Oct2018_goodCh';
% newName = 'XT_radFreqLowSF_loc1_V1_Oct2018_RFxAmp';

% file = 'XT_radFreqHighSF_loc1_V1_Nov2018_goodCh';
% newName = 'XT_radFreqHighSF_V1_Oct2018_RFxAmp';

% V4
% array = 'V4';
% file = 'XT_radFreqLowSF_loc1_V4_Oct2018_goodCh';
% newName = 'XT_radFreqLowSF_loc1_V4_Oct2018_RFxAmp';

% file = 'XT_radFreqHighSF_loc1_V4_Nov2018_goodCh';
% newName = 'XT_radFreqHighSF_V4_Oct2018_RFxAmp';
%% 
% file = 'XT_radFreqHighSF_V4_ManualLocs_goodCh';
% newName = 'XT_radFreqHighSF_V4_ManualLocs_RFxAmp';

% file = 'XT_radFreqLowSF_V4_ManualLocs_goodCh';
% newName = 'XT_radFreqLowSF_V4_ManualLocs_RFxAmp';
%% WV
file = 'WV_RadFreqHighSF_V4_cleaned';
newName = 'WV_RadFreqHighSF_V4_Parsed';
%%
array = 'V4';
animal = 'WV';
%%
programRun = 'HighSF'; % options: lowSF lowSF_manual highSF highSF_manual
location = 0; %0 = laptop 1 = desktop 2 = zemina

printAllCh = 0;
doPSTH = 0;
saveData = 1;
numBoot = 10;
startMean = 10;
endMean = 20;
%%
load(file)
numCh = size(LEdata.bins,3);
textName = figTitleName(file);
fprintf('\n analyzing file: %s\n',textName)
%% PSTHs
if doPSTH == 1
    radFreq_basicPSTH(LEcleanData)
    radFreq_LocationResponses(LEcleanData, endBin, saveData, location)
end
%% Define good chs
[LEgoodCh] = getGoodCh_radFreq(LEdata.bins,LEdata.rf,numBoot,startMean,endMean);
[LEgoodChClean] = getGoodCh_radFreq(LEcleanData.bins,LEcleanData.rf,numBoot,startMean,endMean);

[REgoodCh] = getGoodCh_radFreq(REdata.bins,REdata.rf,numBoot,startMean,endMean);
[REgoodChClean] = getGoodCh_radFreq(REcleanData.bins,REcleanData.rf,numBoot,startMean,endMean);


LEdata.goodCh = LEgoodCh;
REdata.goodCh = REgoodCh;
REcleanData.goodCh = REgoodChClean;
LEcleanData.goodCh = LEgoodChClean;
%% Get data collapsed across all channels
[LEcleanData, REcleanData] = radFreq3_stimBreakdown_allChs(LEcleanData, REcleanData,printAllCh);
%% Get blank responses
for ch = 1:numCh
    % Combine blank responses across all channels
    LEblanks = LEcleanData.blankResps{ch};
    REblanks = REcleanData.blankResps{ch};
    
    
    % Get mean of the mean responses, and the mean of the  median responses
    LEbaseMu = nanmean(LEblanks(end-3,:));
    LEbaseMd = nanmean(LEblanks(end-2,:));
    
    REbaseMu = nanmean(REblanks(end-3,:));
    REbaseMd = nanmean(REblanks(end-2,:));
    %% Get responses to RF stimuli
    % Combine cells to get a 3D matrix of each channel's response that's easier
    % to use than cells.
    LEresps = cat(3,LEcleanData.stimResps{ch});
    REresps = cat(3,REcleanData.stimResps{ch});
    
    % take the mean across all channels
    LEresps = nanmean(LEresps,3);
    REresps = nanmean(REresps,3);
    
    % Get the responses to the circles
    circNdx = find(LEresps(1,:) == 32);
    LEcircResps = LEresps(:,circNdx); % matrix of just the responses to a circle
    
    circNdx = find(REresps(1,:) == 32);
    REcircResps = REresps(:,circNdx);
    
    % remove the responses to the circles from the RF response matrices.
    LErfResps = LEresps(:,(LEresps(1,:)~=32));
    RErfResps = REresps(:,(REresps(1,:)~=32));
    %% reshape the matrices so they're split up by radial frequency.
    rfNdx = length(unique(LErfResps(1,:)));
    LErfResps = reshape(LErfResps,size(LErfResps,1),(size(LErfResps,2)/rfNdx),rfNdx); % now RF responses are a 3d matrix: (responses,stim,rf)
    
    rfNdx = length(unique(RErfResps(1,:)));
    RErfResps = reshape(RErfResps,size(RErfResps,1),(size(RErfResps,2)/rfNdx),rfNdx); % now RF responses are a 3d matrix: (responses,stim,rf)
    %% Get stimulus information
    rfs = unique(LErfResps(1,:));
    amps = unique(LErfResps(2,:));
    phase = unique(LErfResps(3,:));
    sfs = unique(LErfResps(4,:));
    rad = unique(LErfResps(5,:));
    xloc = unique(LErfResps(6,:));
    yloc = unique(LErfResps(7,:));
    
    numRFs = length(rfs);
    numAmps = length(amps);
    numPhases = length(phase);
    numSfs = length(sfs);
    numRad = length(rad);
    numXloc = length(xloc);
    numYloc = length(yloc);
    %% sort by phase
    % split different RFs into different matrices for sorting (too hard to do
    % on a 3d matrix without it getting mixed up.
    
    %RE
    RErf4 = RErfResps(:,:,1);
    RErf8 = RErfResps(:,:,2);
    RErf16= RErfResps(:,:,3);
    
    LErf4 = LErfResps(:,:,1);
    LErf8 = LErfResps(:,:,2);
    LErf16= LErfResps(:,:,3);
    
    % sort each matrix by phase and concatenate to create 3d matrix of sorted
    % data.
    [~,indices] = sort(RErf4(3,:));
    RErf4 = RErf4(:,indices);
    
    [~,indices] = sort(RErf8(3,:));
    RErf8 = RErf8(:,indices);
    
    [~,indices] = sort(RErf16(3,:));
    RErf16 = RErf16(:,indices);
    
    [~,indices] = sort(LErf4(3,:));
    LErf4 = LErf4(:,indices);
    
    [~,indices] = sort(LErf8(3,:));
    LErf8 = LErf8(:,indices);
    
    [~,indices] = sort(LErf16(3,:));
    LErf16 = LErf16(:,indices);
    
    % go back to a 3Dimensional matrix, but now sorted by phase.
    RErfSorted = cat(3,RErf4,RErf8,RErf16);
    LErfSorted = cat(3,LErf4,LErf8,LErf16);
    
    % reshape so the 4th dimension is phase
    numRowsRE = size(RErfSorted,1);
    numColsRE = size(RErfSorted,2)/2;
    
    numRowsLE = size(LErfSorted,1);
    numColsLE = size(LErfSorted,2)/2;
    
    RErfPhases = reshape(RErfSorted,numRowsRE,numColsRE,2,3);
    LErfPhases = reshape(LErfSorted,numRowsLE,numColsLE,2,3);
    %% combine phases, and go back down to a 3D matrix
    RErfResps2 = nanmean(RErfPhases,3);
    LErfResps2 = nanmean(LErfPhases,3);
    
    RErfResps2 = squeeze(RErfResps2);
    LErfResps2 = squeeze(LErfResps2);
    %% Separate by location
    % Make matrices split by location for each eye's responses to RF and circles.   
    if length(xloc) > 1
        loc1 = min(xloc);
        useStim = find((LErfResps2(6,:,1) == loc1));
        LERadFreqLoc1 = LErfResps2(:,useStim,:);
        RERadFreqLoc1 = RErfResps2(:,useStim,:);
        
        useStim = find((LEcircResps(6,:,1) == loc1));
        LECircleLoc1 = LEcircResps(:,useStim,:);
        RECircleLoc1 = REcircResps(:,useStim,:);
        
        centerLoc = mean(xloc);
        useStim = find((LErfResps2(6,:,1) == centerLoc));
        LERadFreqCenterLoc = LErfResps2(:,useStim,:);
        RERadFreqCenterLoc = RErfResps2(:,useStim,:);
        
        useStim = find((LEcircResps(6,:,1) == centerLoc));
        LECircleCenterLoc = LEcircResps(:,useStim,:);
        RECircleCenterLoc = REcircResps(:,useStim,:);
        
        loc2 = max(xloc);
        useStim = find((LErfResps2(6,:,1) == loc2));
        LERadFreqLoc2 = LErfResps2(:,useStim,:);
        RERadFreqLoc2 = RErfResps2(:,useStim,:);
        
        useStim = find((LEcircResps(6,:,1) == loc2));
        LECircleLoc2 = LEcircResps(:,useStim,:);
        RECircleLoc2 = REcircResps(:,useStim,:);
    end
    %% add to the cleanData cell structure to save for later use.
    REcleanData.rfResps = RErfResps2;
    REcleanData.circleResps = REcircResps;
    REcleanData.rfPhases = RErfPhases;
    REcleanData.rfLocsMuPhase = cat(4,RERadFreqLoc1, RERadFreqCenterLoc, RERadFreqLoc2);
    REcleanData.circleLocsMuPhase = cat(4, RECircleLoc1, RECircleCenterLoc, RECircleLoc2);
    
    LEcleanData.rfPhases = LErfPhases;
    LEcleanData.rfResps = LErfResps2;
    LEcleanData.circleResps = LEcircResps;
    LEcleanData.rfLocsMuPhase = cat(4,LERadFreqLoc1, LERadFreqCenterLoc, LERadFreqLoc2);
    LEcleanData.circleLocsMuPhase = cat(4, LECircleLoc1, LECircleCenterLoc, LECircleLoc2);
     %% plot (center stimuli only)
%     xdata = [4,8,16,32,64,128];
%     
%     for spf = 1:numSfs
%         for rd = 1:numRad
%             % get the mean responses to the desired SF and size combinations,
%             % and subtract baseline.
%             useStim = find((LERadFreqCenterLoc(4,:,1) == sfs(spf) & (LERadFreqCenterLoc(5,:,1) == rad(rd))));
%             if contains(file,'V1')
%                 tmpL = LERadFreqLoc1(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
%                 tmpR = RERadFreqLoc1(:,useStim,:);
%             else
%                 tmpL = LERadFreqLoc2(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
%                 tmpR = RERadFreqLoc2(:,useStim,:);
%             end
%             
%             muRespsL = tmpL(end-3,:,:) - LEbaseMu;
%             muRespsR = tmpR(end-3,:,:) - REbaseMu;
%             
%             medRespsL = tmpL(end-2,:,:) - LEbaseMd;
%             medRespsR = tmpR(end-2,:,:) - REbaseMd;
%             
%             useStim = find((LECircleCenterLoc(4,:,1) == sfs(spf) & (LECircleCenterLoc(5,:,1) == rad(rd))));
%             tmpLC = LECircleCenterLoc(:,useStim,:);
%             tmpRC = RECircleCenterLoc(:,useStim,:);
%             
%             muRespsLC = tmpLC(end-3) -LEbaseMu;
%             muRespsRC = tmpRC(end-3) -REbaseMu;
%             
%             medRespsLC = tmpLC(end-2) -LEbaseMd;
%             medRespsRC = tmpRC(end-2) -REbaseMd;
%             
%             
%             rm1 = max(RERadFreqCenterLoc(end-3,:));
%             rm2 = max(RERadFreqCenterLoc(end-2,:));
%             lm1 = max(LERadFreqCenterLoc(end-3,:));
%             lm2 = max(LERadFreqCenterLoc(end-2,:));
%             
%             %             rm1 = max(muRespsR(:));
%             %             rm2 = max(medRespsR(:));
%             %
%             %             lm1 = max(muRespsL(:));
%             %             lm2 = max(medRespsR(:));
%             
%             r = round(max(rm1,rm2));
%             l = round(max(lm1,lm2));
%             y = max(r,l) + (max(r,l)./0.85);
%             
%             %% plot
%             
%             figure(1)
%             clf
%             if LEcleanData.goodCh(ch) == 1
%                 subplot(2,3,1)
%                 hold on
%                 plot(xdata, muRespsL(1,:,1),'b-o')
%                 plot(xdata, medRespsL(1,:,1),'k-o')
%                 plot(2,medRespsLC,'ko')
%                 plot(2,muRespsLC,'bo')
%                 set(gca,'color','none','tickdir','out','box','off','XScale','log')
%                 title('rf4')
%                 ylim([0 y]);
%                 axis square
%                 
%                 subplot(2,3,2)
%                 hold on
%                 plot(xdata, muRespsL(1,:,2),'b-o')
%                 plot(xdata, medRespsL(1,:,2),'k-o')
%                 plot(2,medRespsLC,'bo')
%                 plot(2,muRespsLC,'ko')
%                 set(gca,'color','none','tickdir','out','box','off','XScale','log')
%                 title('rf8')
%                 ylim([0 y]);
%                 axis square
%                 
%                 subplot(2,3,3)
%                 hold on
%                 plot(xdata, muRespsL(1,:,3),'b-o')
%                 plot(xdata, medRespsL(1,:,3),'k-o')
%                 plot(2,medRespsLC,'bo')
%                 plot(2,muRespsLC,'ko')
%                 set(gca,'color','none','tickdir','out','box','off','XScale','log')
%                 title('rf16')
%                 ylim([0 y]);
%                 axis square
%             end
%             
%             if REcleanData.goodCh(ch) == 1
%                 subplot(2,3,4)
%                 hold on
%                 plot(xdata, muRespsR(1,:,1),'r-o')
%                 plot(xdata, medRespsR(1,:,1),'k-o')
%                 plot(2,medRespsRC,'ko')
%                 plot(2,muRespsRC,'ro')
%                 set(gca,'color','none','tickdir','out','box','off','XScale','log')
%                 title('rf4')
%                 ylim([0 y]);
%                 axis square
%                 
%                 
%                 subplot(2,3,5)
%                 hold on
%                 plot(xdata, muRespsR(1,:,2),'r-o')
%                 plot(xdata, medRespsR(1,:,2),'k-o')
%                 plot(2,muRespsRC,'ro')
%                 plot(2,medRespsRC,'ko')
%                 set(gca,'color','none','tickdir','out','box','off','XScale','log')
%                 title('rf8')
%                 ylim([0 y]);
%                 axis square
%                 
%                 subplot(2,3,6)
%                 hold on
%                 plot(xdata, muRespsR(1,:,3),'r-o')
%                 plot(xdata, medRespsR(1,:,3),'k-o')
%                 plot(2,muRespsRC,'ro')
%                 plot(2,medRespsRC,'ko')
%                 set(gca,'color','none','tickdir','out','box','off','XScale','log')
%                 title('rf16')
%                 ylim([0 y]);
%                 axis square
%             end
%             
%             annotation('textbox',...
%                 [0.2 0.96 0.65 0.05],...
%                 'LineStyle','none',...
%                 'String',sprintf('%s ch%d sf%d size%d',animal,ch,spf,rd),...
%                 'Interpreter','none',...
%                 'FontSize',14,...
%                 'FontAngle','italic',...
%                 'FontName','Helvetica Neue');
%             
%             pause(0.2)
%             
%             if location == 0
%                 figDir = sprintf('/Users/bbushnell/Dropbox/Figures/%s/RadialFrequency/%s/RFxAmp/%s',animal,array,programRun);
%             elseif location == 1
%                 figDir = sprintf('~/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/RFxAmp/%s',animal,array,programRun);
%             else
%                 error('Need to define figure path for Zemina')
%             end
%             
%             cd(figDir);
%             
%             figName = [animal,'_',array,'_',programRun,'_sf',num2str(spf),'_size',num2str(rd),'_',num2str(ch)];
%             saveas(gcf,figName,'pdf');
%             
%         end
%     end
end
%% Save data structures
%0 = laptop 1 = desktop 2 = zemina
if contains(file,'V4')
    if location == 0
        cd '/Users/bbushnell/Dropbox/ArrayData/matFiles/V4/RadialFrequency/RFxAmp';
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/RFxAmp
    elseif location == 2
        cd /home/bushnell/matFiles/XT/V4/radFreqHighSF/RFxAmp
    else
        error('cannot understand location')
    end
else
    if location == 0
        cd '/Users/bbushnell/Dropbox/ArrayData/matFiles/V1/RadialFrequency/RFxAmp';
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/RFxAmp
    elseif location == 2
        cd /home/bushnell/matFiles/XT/V1/radFreqHighSF/RFxAmp
    else
        error('cannot understand location')
    end
end

if saveData == 1
    save(newName,'LEdata','LEcleanData');
    fprintf('File saved as: %s\n',newName)
end