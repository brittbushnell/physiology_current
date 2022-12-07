function [dataT] = radFreq_getSpikeCountCondMtx_allCh(dataT)
%%
spikes = dataT.RFspikeCount;
blSpikes = dataT.blankSpikeCount;
%%
foo = spikes{1};
numRFreps = size(foo,1) - 7;
%(RF,ori,amp,sf,radius,location, ch)
rfSc = nan(numRFreps,3,2,6,2,2,3,96);

% (sf,radius,location, ch)
circSc = nan(numRFreps,2,2,3,96);

foo = blSpikes{1};
numBlankReps = size(foo,1) - 7;
% (reps,ch)
blankSc = nan(numBlankReps,96);

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
for ch = 1:96
    if dataT.goodCh(ch)
        bT = blSpikes{ch};
        blankSc(:,ch) = bT(8:end);
        
        scCh = spikes{ch};
        for loc = 1:3
            for sf = 1:2
                for sz = 1:2
                    circNdx = (scCh(1,:) == 32);
                    sfNdx  = (scCh(4,:) == sf);
                    radNdx = (scCh(5,:) == sf);
                    locNdx = (scCh(6,:) == locPair(loc,1)) & (scCh(7,:) == locPair(loc,2));
                    
                    rf4Ndx0  = (scCh(1,:) == 4) & (scCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                    rf4Ndx2  = (scCh(1,:) == 4) & (scCh(3,:) == 45);
                    rf8Ndx0  = (scCh(1,:) == 8) & (scCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                    rf8Ndx2  = (scCh(1,:) == 8) & (scCh(3,:) == 22.5);
                    rf16Ndx0  = (scCh(1,:) == 16) & (scCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                    rf16Ndx2  = (scCh(1,:) == 16) & (scCh(3,:) == 11.25);
                    
                    rf4rot0 = scCh(8:end,rf4Ndx0 & sfNdx & radNdx & locNdx);
                    rf4rot2 = scCh(8:end,rf4Ndx2 & sfNdx & radNdx & locNdx);
                    rf8rot0 = scCh(8:end,rf8Ndx0 & sfNdx & radNdx & locNdx);
                    rf8rot2 = scCh(8:end,rf8Ndx2 & sfNdx & radNdx & locNdx);
                    rf16rot0 = scCh(8:end,rf16Ndx0 & sfNdx & radNdx & locNdx);
                    rf16rot2 = scCh(8:end,rf16Ndx2 & sfNdx & radNdx & locNdx);
                    
                    circSCs = scCh(8:end,circNdx & sfNdx & radNdx & locNdx);
                    circSc(:,sf,sz,loc,ch) = mean(circSCs);
                    
                    for amp = 1:6
                        
                        rf4a = rf4rot0(:,amp);
                        rf4b = rf4rot2(:,amp);
                        
                        rf8a = rf8rot0(:,amp);
                        rf8b = rf8rot2(:,amp);
                        
                        rf16a = rf16rot0(:,amp);
                        rf16b = rf16rot2(:,amp);
                        
                        rfSc(:,1,1,amp,sf,sz,loc,ch) = (rf4a)';
                        rfSc(:,1,2,amp,sf,sz,loc,ch) = (rf4b)';
                        rfSc(:,2,1,amp,sf,sz,loc,ch) = (rf8a)';
                        rfSc(:,2,2,amp,sf,sz,loc,ch) = (rf8b)';
                        rfSc(:,3,1,amp,sf,sz,loc,ch) = (rf16a)';
                        rfSc(:,3,2,amp,sf,sz,loc,ch) = (rf16b)';
                    end
                end
            end
        end
    end
end
%% get the mean response across all channels
% (RF,ori,amp,sf,radius,location, ch)
rfSc_ch = nanmedian(rfSc,8);
% (sf,radius,location, ch)
circSc_ch = nanmedian(circSc,5);
% (reps,ch)
blankSc_ch = nanmedian(blankSc,2);
%% commit to data structure
dataT.locPair = locPair;
dataT.rfSpikeCountMtx_ch  = rfSc_ch;
dataT.circSpikeCountMtx_ch = circSc_ch;
dataT.blankSpikeCountMtx_ch = blankSc_ch;
%%