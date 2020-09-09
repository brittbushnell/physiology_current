clear all
close all
clc
location = 1; %0 = laptop 1 = desktop 2 = zemina
%% NOTE
% use find and replace to use either RE or LE as needed.
%%
file = 'XT_RE_radFreqLowSF_loc1_V4_Oct2018_goodCh';
animal = 'XT';
date = 'Oct 2018'; % Whatever is put in here will be in figure titles
newName = 'XT_RE_radFreqHighSF_V4_Oct2018_RFxAmp';
array = 'V4';
program = 'RadFreqLowSF';
saveData = 1;
%%
load(file)
numCh = size(REdata.bins,3);
%% Get data collapsed across all channels
[REcleanData] = radFreq3_stimBreakdown_allChs(REcleanData);
%% Get blank responses
for ch = 1:numCh
    % Combine blank responses across all channels
    REblanks = REcleanData.blankResps{ch};
    
    % Get mean of the mean responses, and the mean of the  median responses
    REbaseMu = nanmean(REblanks(end-3,:));
    REbaseMd = nanmean(REblanks(end-2,:));
    %% Get responses to RF stimuli
    % Combine cells to get a 3D matrix of each channel's response that's easier
    % to use than cells.
    REresps = cat(3,REcleanData.stimResps{ch});
    
    % take the mean across all channels
    REresps = nanmean(REresps,3);
    
    % Get the responses to the circles
    circNdx = find(REresps(1,:) == 32);
    REcircResps = REresps(:,circNdx); % matrix of just the responses to a circle
    
    % remove the responses to the circles from the RF response matrices.
    RErfResps = REresps(:,(REresps(1,:)~=32));
    %% reshape the matrices so they're split up by radial frequency.
    rfNdx = length(unique(RErfResps(1,:)));
    RErfResps = reshape(RErfResps,size(RErfResps,1),(size(RErfResps,2)/rfNdx),rfNdx); % now RF responses are a 3d matrix: (responses,stim,rf)
    %% Get stimulus information
    rfs = unique(RErfResps(1,:));
    amps = unique(RErfResps(2,:));
    phase = unique(RErfResps(3,:));
    sfs = unique(RErfResps(4,:));
    rad = unique(RErfResps(5,:));
    xloc = unique(RErfResps(6,:));
    yloc = unique(RErfResps(7,:));
    
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
    
    RErf4 = RErfResps(:,:,1);
    RErf8 = RErfResps(:,:,2);
    RErf16= RErfResps(:,:,3);
    
    % sort each matrix by phase and concatenate to create 3d matrix of sorted
    % data.
    [~,indices] = sort(RErf4(3,:));
    RErf4 = RErf4(:,indices);
    
    [~,indices] = sort(RErf8(3,:));
    RErf8 = RErf8(:,indices);
    
    [~,indices] = sort(RErf16(3,:));
    RErf16 = RErf16(:,indices);
    
    [~,indices] = sort(RErf4(3,:));
    RErf4 = RErf4(:,indices);
    
    [~,indices] = sort(RErf8(3,:));
    RErf8 = RErf8(:,indices);
    
    [~,indices] = sort(RErf16(3,:));
    RErf16 = RErf16(:,indices);
    
    % go back to a 3Dimensional matrix, but now sorted by phase.
    RErfSorted = cat(3,RErf4,RErf8,RErf16);
    
    % reshape so the 4th dimension is phase
    
    numRowsRE = size(RErfSorted,1);
    numColsRE = size(RErfSorted,2)/2;
    
    RErfPhases = reshape(RErfSorted,numRowsRE,numColsRE,2,3);
    %% combine phases, and go back down to a 3D matrix
    RErfResps2 = nanmean(RErfPhases,3);
    RErfResps2 = squeeze(RErfResps2);
    %% Separate by location
    % Make matrices split by location for each eye's responses to RF and circles.
    
    if length(xloc) > 1
        loc1 = min(xloc);
        useStim = find((RErfResps2(6,:,1) == loc1));
        RERadFreqLoc1 = RErfResps2(:,useStim,:);
        
        useStim = find((REcircResps(6,:,1) == loc1));
        RECircleLoc1 = REcircResps(:,useStim,:);
        
        centerLoc = mean(xloc);
        useStim = find((RErfResps2(6,:,1) == centerLoc));
        RERadFreqCenterLoc = RErfResps2(:,useStim,:);
        
        useStim = find((REcircResps(6,:,1) == centerLoc));
        RECircleCenterLoc = REcircResps(:,useStim,:);
        
        loc2 = max(xloc);
        useStim = find((RErfResps2(6,:,1) == loc2));
        RERadFreqLoc2 = RErfResps2(:,useStim,:);
        
        useStim = find((REcircResps(6,:,1) == loc2));
        RECircleLoc2 = REcircResps(:,useStim,:);
    end
    %% add to the cleanData cell structure to save for later use.
    REcleanData.rfPhases = RErfPhases;
    REcleanData.rfResps = RErfResps2;
    REcleanData.circleResps = REcircResps;
    REcleanData.rfLocsMuPhase = cat(4,RERadFreqLoc1, RERadFreqCenterLoc, RERadFreqLoc2);
    REcleanData.circleLocsMuPhase = cat(4, RECircleLoc1, RECircleCenterLoc, RECircleLoc2);
    %% plot (center stimuli only)
    xdata = [4,8,16,32,64,128];
    
    for spf = 1:numSfs
        for rd = 1:numRad
            % get the mean responses to the desired SF and size combinations,
            % and subtract baseline.
            useStim = find((RERadFreqCenterLoc(4,:,1) == sfs(spf) & (RERadFreqCenterLoc(5,:,1) == rad(rd))));
            tmpL = RERadFreqCenterLoc(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
            
            muRespsL = tmpL(end-3,:,:) - REbaseMu;            
            medRespsL = tmpL(end-2,:,:) - REbaseMd;
            
            useStim = find((RECircleCenterLoc(4,:,1) == sfs(spf) & (RECircleCenterLoc(5,:,1) == rad(rd))));
            tmpLC = RECircleCenterLoc(:,useStim,:);
            
            muRespsLC = tmpLC(end-3) -REbaseMu;            
            medRespsLC = tmpLC(end-2) -REbaseMd;
            
            lm1 = max(RERadFreqCenterLoc(end-3,:));
            lm2 = max(RERadFreqCenterLoc(end-2,:));

            l = round(max(lm1,lm2)); 
            y = l;
            
            %% plot
            figure
            
            if REcleanData.goodCh(ch) == 1
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
            end
                        
            annotation('textbox',...
                [0.2 0.96 0.65 0.05],...
                'LineStyle','none',...
                'String',sprintf('ch%d %s sf%d size%d',ch,date,spf,rd),...
                'Interpreter','none',...
                'FontSize',14,...
                'FontAngle','italic',...
                'FontName','Helvetica Neue');
            pause(0.2)
            
            if contains(file,'V4')
                if location == 0
                    cd '/Users/bbushnell/Dropbox/Figures/wu_arrays/RF/V4/RFxAmp';
                elseif location == 1
                    cd '/Local/Users/bushnell/Dropbox/Figures/WU_Arrays/RF/V4/RFxAmp';
                elseif location == 2
                    cd '/home/bushnell/Figures/V4/RadFreq/RFxAmp/XT'
                else
                    error('cannot understand location')
                end
            else
                if location == 0
                    cd '/Users/bbushnell/Dropbox/Figures/wu_arrays/RF/V1/RFxAmp';
                elseif location == 1
                    cd '/Local/Users/bushnell/Dropbox/Figures/WU_Arrays/RF/V4/RFxAmp';
                elseif location == 2
                    cd '/home/bushnell/Figures/V1/RadFreq/RFxAmp/XT'
                else
                    error('cannot understand location')
                end
            end
            figName = [animal,'_',array,'_',program,'_ch',num2str(ch),'_sf',num2str(spf),'_size',num2str(rd)];
            saveas(gcf,figName,'pdf');
        end
    end
end
%% Save data structures
%0 = laptop 1 = desktop 2 = zemina
if contains(file,'V4')
    if location == 0
        cd '/Users/bbushnell/Dropbox/ArrayData/matFiles/V4/RadialFrequency/RFxAmp';
    elseif location == 1
        cd '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/V4/RadialFrequency/RFxAmp';
    elseif location == 2
        cd
    else
        error('cannot understand location')
    end
else
    if location == 0
        cd '/Users/bbushnell/Dropbox/ArrayData/matFiles/V1/RadialFrequency/RFxAmp';
    elseif location == 1
        cd '/Local/Users/bushnellDropbox/ArrayData/matFiles/V1/RadialFrequency/RFxAmp';
    elseif location == 2
        cd
    else
        error('cannot understand location')
    end
end

if saveData == 1
    save(newName,'REdata','REcleanData');
    fprintf('File saved as: %s\n',newName)
end