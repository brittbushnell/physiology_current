function  [LEcleanData, REcleanData] = radFreq3_stimBreakdown_allChs(LEcleanData, REcleanData,print)
% clear all
% close all
% clc
% location = 0; %0 = laptop 1 = desktop 2 = zemina
%% NOTE
%Fix plotting code to work with newly setup data structures.
%%
% file = 'WU_RadFreqLoc2_V4_20170706_goodCh';
% date = '07/06 cleaned'; % Whatever is put in here will be in figure titles
% newName = 'WU_RadFreqLoc2_V4_20170706_RFxAmp';
% %%
% load(file)
%% Get blank responses

% Combine blank responses across all channels
LEblanks = cell2mat(LEcleanData.blankResps);
REblanks = cell2mat(REcleanData.blankResps);


% Get mean of the mean responses, and the mean of the  median responses
LEbaseMu = nanmean(LEblanks(end-3,:));
LEbaseMd = nanmean(LEblanks(end-2,:));

REbaseMu = nanmean(REblanks(end-3,:));
REbaseMd = nanmean(REblanks(end-2,:));
%% Get responses to RF stimuli
% Combine cells to get a 3D matrix of each channel's response that's easier
% to use than cells.
LEresps = cat(3,LEcleanData.stimResps{:});
REresps = cat(3,REcleanData.stimResps{:});

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
REcleanData.rfResps_allCh = RErfResps2;
REcleanData.circleResps_allCh = REcircResps;
REcleanData.rfPhases_allCh = RErfPhases;
REcleanData.rfLocsMuPhase_allCh = cat(4,RERadFreqLoc1, RERadFreqCenterLoc, RERadFreqLoc2);
REcleanData.circleLocsMuPhase_allCh = cat(4, RECircleLoc1, RECircleCenterLoc, RECircleLoc2);

LEcleanData.rfPhases_allCh = LErfPhases;
LEcleanData.rfResps_allCh = LErfResps2;
LEcleanData.circleResps_allCh = LEcircResps;
LEcleanData.rfLocsMuPhase_allCh = cat(4,LERadFreqLoc1, LERadFreqCenterLoc, LERadFreqLoc2);
LEcleanData.circleLocsMuPhase_allCh = cat(4, LECircleLoc1, LECircleCenterLoc, LECircleLoc2);
%% plot (center stimuli only)
if print == 1
    xdata = [4,8,16,32,64,128];
    
    for spf = 1:numSfs
        for rd = 1:numRad
            % get the mean responses to the desired SF and size combinations,
            % and subtract baseline.
            useStim = find((LERadFreqCenterLoc(4,:,1) == sfs(spf) & (LERadFreqCenterLoc(5,:,1) == rad(rd))));
            tmpL = LERadFreqCenterLoc(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
            tmpR = RERadFreqCenterLoc(:,useStim,:);
            
            muRespsL = tmpL(end-3,:,:) - LEbaseMu;
            muRespsR = tmpR(end-3,:,:) - REbaseMu;
            
            medRespsL = tmpL(end-2,:,:) - LEbaseMd;
            medRespsR = tmpR(end-2,:,:) - REbaseMd;
            
            useStim = find((LECircleCenterLoc(4,:,1) == sfs(spf) & (LECircleCenterLoc(5,:,1) == rad(rd))));
            tmpLC = LECircleCenterLoc(:,useStim,:);
            tmpRC = RECircleCenterLoc(:,useStim,:);
            
            muRespsLC = tmpLC(end-3) -LEbaseMu;
            muRespsRC = tmpRC(end-3) -REbaseMu;
            
            medRespsLC = tmpLC(end-2) -LEbaseMd;
            medRespsRC = tmpRC(end-2) -REbaseMd;
            
            r = max(muRespsR(:));
            l = max(muRespsL(:));
            y = max(r,l);
            
            %% plot
            figure
            
            subplot(2,3,1)
            hold on
            plot(xdata, muRespsL(1,:,1),'b-o')
            plot(xdata, medRespsL(1,:,1),'k-o')
            plot(2,medRespsLC,'ko')
            plot(2,muRespsLC,'bo')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf4')
            ylim([0 y]);
            axis square
            
            
            
            subplot(2,3,2)
            hold on
            plot(xdata, muRespsL(1,:,2),'b-o')
            plot(xdata, medRespsL(1,:,2),'k-o')
            plot(2,medRespsLC,'bo')
            plot(2,muRespsLC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf8')
            ylim([0 y]);
            axis square
            
            subplot(2,3,3)
            hold on
            plot(xdata, muRespsL(1,:,3),'b-o')
            plot(xdata, medRespsL(1,:,3),'k-o')
            plot(2,medRespsLC,'bo')
            plot(2,muRespsLC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf16')
            ylim([0 y]);
            axis square
            
            subplot(2,3,4)
            hold on
            plot(xdata, muRespsR(1,:,1),'r-o')
            plot(xdata, medRespsR(1,:,1),'k-o')
            plot(2,medRespsRC,'ko')
            plot(2,muRespsRC,'ro')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf4')
            ylim([0 y]);
            axis square
            
            subplot(2,3,5)
            hold on
            plot(xdata, muRespsR(1,:,2),'r-o')
            plot(xdata, medRespsR(1,:,2),'k-o')
            plot(2,muRespsRC,'ro')
            plot(2,medRespsRC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf8')
            ylim([0 y]);
            axis square
            
            subplot(2,3,6)
            hold on
            plot(xdata, muRespsR(1,:,3),'r-o')
            plot(xdata, medRespsR(1,:,3),'k-o')
            plot(2,muRespsRC,'ro')
            plot(2,medRespsRC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf16')
            ylim([0 y]);
            axis square
            
            annotation('textbox',...
                [0.2 0.96 0.65 0.05],...
                'LineStyle','none',...
                'String',sprintf('%s sf%d size%d',date,spf,rd),...
                'Interpreter','none',...
                'FontSize',14,...
                'FontAngle','italic',...
                'FontName','Helvetica Neue');
        end
    end
end
