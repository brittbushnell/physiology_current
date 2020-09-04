function  [data] = radFreq_stimBreakdown_1eye(data)
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
blanks = cell2mat(data.blankResps);


% Get mean of the mean responses, and the mean of the  median response

baseMu = nanmean(blanks(end-3,:));
baseMd = nanmean(blanks(end-2,:));
%% Get responses to RF stimuli
% Combine cells to get a 3D matrix of each channel's response that's easier 
% to use than cells.
resps = cat(3,data.stimResps{:});

% take the mean across all channels
resps = nanmean(resps,3);

% Get the responses to the circles 
circNdx = find(resps(1,:) == 32);
circResps = resps(:,circNdx);

 % remove the responses to the circles from the RF response matrices. 
rfResps = resps(:,(resps(1,:)~=32));
%% reshape the matrices so they're split up by radial frequency. 
rfNdx = length(unique(rfResps(1,:)));
rfResps = reshape(rfResps,size(rfResps,1),(size(rfResps,2)/rfNdx),rfNdx); % now RF responses are a 3d matrix: (responses,stim,rf)
%% Get stimulus information
rfs = unique(rfResps(1,:));
amps = unique(rfResps(2,:));
phase = unique(rfResps(3,:));
sfs = unique(rfResps(4,:));
rad = unique(rfResps(5,:));
xloc = unique(rfResps(6,:));
yloc = unique(rfResps(7,:));

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
rf4 = rfResps(:,:,1);
rf8 = rfResps(:,:,2);
rf16= rfResps(:,:,3);

% sort each matrix by phase and concatenate to create 3d matrix of sorted
% data.
[~,indices] = sort(rf4(3,:));
rf4 = rf4(:,indices);

[~,indices] = sort(rf8(3,:));
rf8 = rf8(:,indices);

[~,indices] = sort(rf16(3,:));
rf16 = rf16(:,indices);
% go back to a 3Dimensional matrix, but now sorted by phase.
rfSorted = cat(3,rf4,rf8,rf16);

% reshape so the 4th dimension is phase
numRows = size(rfSorted,1);
numCols = size(rfSorted,2)/2;

rfPhases = reshape(rfSorted,numRows,numCols,2,3);
%% combine phases, and go back down to a 3D matrix
rfResps2 = nanmean(rfPhases,3);
rfResps2 = squeeze(rfResps2);
%% Separate by location
% Make matrices split by location for each eye's responses to RF and circles.

if length(xloc) > 1
    loc1 = min(xloc);
    useStim = find((rfResps2(6,:,1) == loc1));
    RadFreqLoc1 = rfResps2(:,useStim,:);
    
    useStim = find((circResps(6,:,1) == loc1));
    CircleLoc1 = circResps(:,useStim,:);
    
    centerLoc = mean(xloc);
    useStim = find((rfResps2(6,:,1) == centerLoc));
    RadFreqCenterLoc = rfResps2(:,useStim,:);
    
    useStim = find((circResps(6,:,1) == centerLoc));
    CircleCenterLoc = circResps(:,useStim,:);
    
    loc2 = max(xloc);
    useStim = find((rfResps2(6,:,1) == loc2));
    RadFreqLoc2 = rfResps2(:,useStim,:);
    
    useStim = find((circResps(6,:,1) == loc2));
    CircleLoc2 = circResps(:,useStim,:);
end
%% add to the cleanData cell structure to save for later use.
data.rfResps_allCh = rfResps2;
data.circleResps_allCh = circResps;
data.rfPhases_allCh = rfPhases;
data.rfLocsMuPhase_allCh = cat(4,RadFreqLoc1, RadFreqCenterLoc, RadFreqLoc2);
data.circleLocsMuPhase_allCh = cat(4, CircleLoc1, CircleCenterLoc, CircleLoc2);
%% plot (center stimuli only)
xdata = [4,8,16,32,64,128];

for spf = 1:numSfs
    for rd = 1:numRad
        % get the mean responses to the desired SF and size combinations,
        % and subtract baseline.
        useStim = find((RadFreqCenterLoc(4,:,1) == sfs(spf) & (RadFreqCenterLoc(5,:,1) == rad(rd))));
        tmp = RadFreqCenterLoc(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
        
        muResps = tmp(end-3,:,:) - baseMu;
        medResps = tmp(end-2,:,:) - baseMd;  

        useStim = find((CircleCenterLoc(4,:,1) == sfs(spf) & (CircleCenterLoc(5,:,1) == rad(rd))));
        tmpC = CircleCenterLoc(:,useStim,:);
        
        muRespsC = tmpC(end-3) -baseMu;
        medRespsC = tmpC(end-2) -baseMd;
        
        l = max(muResps(:));
        y = l;% max(r,l);
        
        %% plot
        figure
        
        subplot(1,3,1)
        hold on
        plot(xdata, muResps(1,:,1),'b-o')
        plot(2,medRespsC,'ko')
        plot(2,muRespsC,'bo')
        set(gca,'color','none','tickdir','out','box','off','XScale','log')
        title('rf4')
        ylim([0 y]);
        axis square
        
        
        subplot(1,3,2)
        hold on
        plot(xdata, muResps(1,:,2),'b-o')
        plot(xdata, medResps(1,:,2),'k-o')
        plot(2,medRespsC,'bo')
        plot(2,muRespsC,'ko')
        set(gca,'color','none','tickdir','out','box','off','XScale','log')
        title('rf8')
        ylim([0 y]);
        axis square
        
        subplot(1,3,3)
        hold on
        plot(xdata, muResps(1,:,3),'b-o')
        plot(xdata, medResps(1,:,3),'k-o')
        plot(2,medRespsC,'bo')
        plot(2,muRespsC,'ko')
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
