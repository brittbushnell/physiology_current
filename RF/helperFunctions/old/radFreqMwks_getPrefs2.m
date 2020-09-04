function [SfPrefRE,SfPrefLE, sizePrefRE, sizePrefLE, phasePrefRE, phasePrefLE] = radFreqMwks_getPrefs2(file)
% radFreqMwks_getPrefs will return the preferred responses to various
% parameters for the radial frequency stimuli to be plotted. This version
% uses data with each channel's mean response subtracted from each stim's
% response.
%
% May 8, 2018 Brittany Bushnell



%%
% clear all
% close all
% clc
% tic
% % file = 'WU_V1_RadFreq_combined';
% % array = 'V1';
% file ='WU_V4_RadFreq_combined';
% array = 'V4';
%% Extract information
load(file);

numCh = size(LEdata.bins,3);

RFs   = unique(LEdata.rf);
amps  = unique(LEdata.amplitude);
phase = unique(LEdata.orientation);
sfs   = unique(LEdata.spatialFrequency);
xLocs = unique(LEdata.pos_x);
yLocs = unique(LEdata.pos_y);
rads  = unique(LEdata.radius);
%% Get best SF
for ch = 1:numCh
    for sf = 1:length(sfs)
        LEndx = find((LEdata.stimResps{ch}(7,:) == sfs(sf)) & (LEdata.stimResps{ch}(9,:) == -3));
        REndx = find((REdata.stimResps{ch}(7,:) == sfs(sf)) & (REdata.stimResps{ch}(9,:) == -3));
        for i = 1:length(LEndx)
            LEndx2(1,i) = LEdata.stimResps{ch}(11,LEndx(i));
            REndx2(1,i) = REdata.stimResps{ch}(11,REndx(i));
        end
        sfL(1,sf) = mean(LEndx2,2);
        sfR(1,sf) = mean(REndx2,2);
    end
    [mx,Idx] = max(sfL);
    SfPrefLE(1,ch) = sfs(Idx);
    SfPrefLE(2,ch) = mx;
    
    [mx,Idx] = max(sfR);
    SfPrefRE(1,ch) = sfs(Idx);
    SfPrefRE(2,ch) = mx;
    %% get best size
    
    for z = 1:length(rads)
        LEndx = find((LEdata.stimResps{ch}(8,:) == rads(z)) & (LEdata.stimResps{ch}(9,:) == -3));
        REndx = find((REdata.stimResps{ch}(8,:) == rads(z)) & (REdata.stimResps{ch}(9,:) == -3));
        for i = 1:length(LEndx)
            LEndx2(1,i) = LEdata.stimResps{ch}(11,LEndx(i));
            REndx2(1,i) = REdata.stimResps{ch}(11,REndx(i));
        end
        rdL(1,z) = mean(LEndx2,2);
        rdR(1,z) = mean(REndx2,2);
    end
    [mx,Idx] = max(rdL);
    sizePrefLE(1,ch) = rads(Idx);
    sizePrefLE(2,ch) = mx;
    
    [mx,Idx] = max(rdR);
    sizePrefRE(1,ch) = rads(Idx);
    sizePrefRE(2,ch) = mx;
    %% get best orientation
    for r = 1:3
        if r == 1
            ph2 = 45;
        elseif r == 2
            ph2 = 22.5;
        elseif r == 3
            ph2 = 11.25;
        end
        
        LEndx1 = find((LEdata.stimResps{ch}(4,:) == RFs(r)) & (LEdata.stimResps{ch}(6,:) == 0) & (LEdata.stimResps{ch}(9,:) == -3));
        LEndx2 = find((LEdata.stimResps{ch}(4,:) == RFs(r)) & (LEdata.stimResps{ch}(6,:) == ph2) & (LEdata.stimResps{ch}(9,:) == -3));
        
        REndx1 = find((REdata.stimResps{ch}(4,:) == RFs(r)) & (REdata.stimResps{ch}(6,:) == 0) & (REdata.stimResps{ch}(9,:) == -3));
        REndx2 = find((REdata.stimResps{ch}(4,:) == RFs(r)) & (REdata.stimResps{ch}(6,:) == ph2) & (REdata.stimResps{ch}(9,:) == -3));
        
        LEResps(1,:) = LEdata.stimResps{ch}(11,LEndx1);
        LEResps(2,:) = LEdata.stimResps{ch}(11,LEndx2);
        
        REResps(1,:) = REdata.stimResps{ch}(11,REndx1);
        REResps(2,:) = REdata.stimResps{ch}(11,REndx2);
        
        orL(1,:) = mean(LEResps,2);
        orR(1,:) = mean(REResps,2);
        
        [mx,Idx] = max(orL);
        if Idx == 1
            phasePrefLE{r}(1,ch) = ph2;
        else
            phasePrefLE{r}(1,ch) = 0;
        end
        phasePrefLE{r}(2,ch) = mx;
        
        [mx,Idx] = max(orR);
        if Idx == 1
            phasePrefRE{r}(1,ch) = ph2;
        else
            phasePrefRE{r}(1,ch) = 0;
        end
        phasePrefRE{r}(2,ch) = mx;
        
    end
end