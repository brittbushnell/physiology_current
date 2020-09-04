clear all
close all
clc
location = 0; %0 = laptop 1 = desktop 2 = zemina
%% NOTE
% use find and replace to use either RE or LE as needed.
%%
file = 'XT_RE_radFreqHighSF_V1_Dec2018_goodCh';
animal = 'XT';
date = 'Dec 2018'; % Whatever is put in here will be in figure titles
newName = 'XT_RE_radFreqHighSF_V1_Dec2018_rfxamp';
array = 'V1';
program = 'radFreqHighSF';
saveData = 1;
eye = 'RE';
%%
load(file)
numCh = size(data.bins,3);
%% Get data collapsed across all channels
[cleanData] = radFreq_stimBreakdown_1eye(cleanData);
%% Get blank responses
for ch = 1:numCh
    % Combine blank responses across all channels
    blanks = cleanData.blankResps{ch};
    
    % Get mean of the mean responses, and the mean of the  median responses
    baseMu = nanmean(blanks(end-3,:));
    baseMd = nanmean(blanks(end-2,:));
    %% Get responses to RF stimuli
    % Combine cells to get a 3D matrix of each channel's response that's easier
    % to use than cells.
    resps = cat(3,cleanData.stimResps{ch});
    
    % take the mean across all channels
    resps = nanmean(resps,3);
    
    % Get the responses to the circles
    circNdx = find(resps(1,:) == 32);
    circResps = resps(:,circNdx); % matrix of just the responses to a circle
    
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
    
    [~,indices] = sort(rf4(3,:));
    rf4 = rf4(:,indices);
    
    [~,indices] = sort(rf8(3,:));
    rf8 = rf8(:,indices);
    
    [~,indices] = sort(rf16(3,:));
    rf16 = rf16(:,indices);
    
    % go back to a 3Dimensional matrix, but now sorted by phase.
    rfSorted = cat(3,rf4,rf8,rf16);
    
    % reshape so the 4th dimension is phase
    
    numRowsRE = size(rfSorted,1);
    numColsRE = size(rfSorted,2)/2;
    
    rfPhases = reshape(rfSorted,numRowsRE,numColsRE,2,3);
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
    cleanData.rfPhases = rfPhases;
    cleanData.rfResps = rfResps2;
    cleanData.circleResps = circResps;
    cleanData.rfLocsMuPhase = cat(4,RadFreqLoc1, RadFreqCenterLoc, RadFreqLoc2);
    cleanData.circleLocsMuPhase = cat(4, CircleLoc1, CircleCenterLoc, CircleLoc2);
    %% plot (center stimuli only)
    xdata = [4,8,16,32,64,128];
    
    for spf = 1:numSfs
        for rd = 1:numRad
            % get the mean responses to the desired SF and size combinations,
            % and subtract baseline.
            if contains(file,'V4')
                useStim = find((RadFreqCenterLoc(4,:,1) == sfs(spf) & (RadFreqCenterLoc(5,:,1) == rad(rd))));
                tmpL = RadFreqCenterLoc(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
                
                muRespsL = tmpL(end-3,:,:) - baseMu;
                medRespsL = tmpL(end-2,:,:) - baseMd;
                
                useStim = find((CircleCenterLoc(4,:,1) == sfs(spf) & (CircleCenterLoc(5,:,1) == rad(rd))));
                tmpLC = CircleCenterLoc(:,useStim,:);
                
                muRespsLC = tmpLC(end-3) -baseMu;
                medRespsLC = tmpLC(end-2) -baseMd;
                
                lm1 = max(RadFreqCenterLoc(end-3,:));
                lm2 = max(RadFreqCenterLoc(end-2,:));
            else
                useStim = find((RadFreqLoc1(4,:,1) == sfs(spf) & (RadFreqLoc1(5,:,1) == rad(rd))));
                tmpL = RadFreqLoc1(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
                
                muRespsL = tmpL(end-3,:,:) - baseMu;
                medRespsL = tmpL(end-2,:,:) - baseMd;
                
                useStim = find((CircleLoc1(4,:,1) == sfs(spf) & (CircleLoc1(5,:,1) == rad(rd))));
                tmpLC = CircleLoc1(:,useStim,:);
                
                muRespsLC = tmpLC(end-3) -baseMu;
                medRespsLC = tmpLC(end-2) -baseMd;
                
                lm1 = max(RadFreqLoc1(end-3,:));
                lm2 = max(RadFreqLoc1(end-2,:));
            end
            
            l = round(max(lm1,lm2));
            y = l;
            
            %% plot
            figure(2)
            clf;
            if cleanData.goodCh(ch) == 1
                subplot(1,3,1)
                hold on
                plot(xdata, muRespsL(1,:,1),'b-o')
                %                plot(xdata, medRespsL(1,:,1),'k-o')
                %                plot(2,medRespsLC,'ko')
                plot(2,muRespsLC,'bo')
                set(gca,'color','none','tickdir','out','box','off','XScale','log')
                title('rf4')
                ylim([0 y]);
                axis square
                
                subplot(1,3,2)
                hold on
                plot(xdata, muRespsL(1,:,2),'b-o')
                %                plot(xdata, medRespsL(1,:,2),'k-o')
                %                plot(2,medRespsLC,'ko')
                plot(2,muRespsLC,'bo')
                set(gca,'color','none','tickdir','out','box','off','XScale','log')
                title('rf8')
                ylim([0 y]);
                axis square
                
                subplot(1,3,3)
                hold on
                plot(xdata, muRespsL(1,:,3),'b-o')
                %                plot(xdata, medRespsL(1,:,3),'k-o')
                %                plot(2,medRespsLC,'ko')
                plot(2,muRespsLC,'bo')
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
            
            if location == 0
                figDir = sprintf('/Users/bbushnell/Dropbox/Figures/%s/RadialFrequency/%s/RFxAmp/%s/%s',data.animalID,data.arrayID,eye,program);
            elseif location == 1
                figDir = sprintf('~/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/RFxAmp/%s/%s',data.animalID,data.arrayID,eye,program);
            else
                error('Need to define figure path for Zemina')
            end
            cd(figDir)
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
    save(newName,'data','cleanData');
    fprintf('File saved as: %s\n',newName)
end