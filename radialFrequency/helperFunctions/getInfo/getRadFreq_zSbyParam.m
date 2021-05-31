function [loc1Zs, loc2Zs, loc3Zs, loc1Spikes, loc2Spikes, loc3Spikes] = getRadFreq_zSbyParam(dataT,stimLoc)

%        1)   Radial Frequency
%        2)   Amplitude (Weber fraction)
%        3)   Phase (Orientation)
%        4)   Spatial frequency
%        5)   Size (mean radius)
%        6)   X position
%        7)   Y position
%%

zScores = dataT.RFzScore;
loc1Zs = cell(1,96);
loc2Zs = cell(1,96);
loc3Zs = cell(1,96);

% sfs = unique(dataT.spatialFrequency);
rads = unique(dataT.radius);


for ch = 1:96
   zCh = zScores{ch}; 
   
   if ch == 1
       loc1Ndx = (zCh(6,:) == stimLoc(1,1) & zCh(7,:) == stimLoc(1,2));
       loc2Ndx = (zCh(6,:) == stimLoc(2,1) & zCh(7,:) == stimLoc(2,2));
       loc3Ndx = (zCh(6,:) == stimLoc(3,1) & zCh(7,:) == stimLoc(3,2));
       
       sf1 = (zCh(4,:) == 1);
       sf2 = (zCh(4,:) == 2);
       
       rad1 = (zCh(5,:) == rads(1));
       rad2 = (zCh(5,:) == rads(2));
   end
   
   loc1Zs{ch}.sf1Rad1 = zCh(:,loc1Ndx & sf1 & rad1);
   loc1Zs{ch}.sf1Rad2 = zCh(:,loc1Ndx & sf1 & rad2);
   
   loc1Zs{ch}.sf2Rad1 = zCh(:,loc1Ndx & sf2 & rad1);
   loc1Zs{ch}.sf2Rad2 = zCh(:,loc1Ndx & sf2 & rad2);
   
   loc2Zs{ch}.sf1Rad1 = zCh(:,loc2Ndx & sf1 & rad1);
   loc2Zs{ch}.sf1Rad2 = zCh(:,loc2Ndx & sf1 & rad2);
   
   loc2Zs{ch}.sf2Rad1 = zCh(:,loc2Ndx & sf2 & rad1);
   loc2Zs{ch}.sf2Rad2 = zCh(:,loc2Ndx & sf2 & rad2);
   
   loc3Zs{ch}.sf1Rad1 = zCh(:,loc3Ndx & sf1 & rad1);
   loc3Zs{ch}.sf1Rad2 = zCh(:,loc3Ndx & sf1 & rad2);
   
   loc3Zs{ch}.sf2Rad1 = zCh(:,loc3Ndx & sf2 & rad1);
   loc3Zs{ch}.sf2Rad2 = zCh(:,loc3Ndx & sf2 & rad2);

   
   clear zCh;
end
%%
spikeCounts = dataT.RFspikeCount;
loc1Spikes = cell(1,96);
loc2Spikes = cell(1,96);
loc3Spikes = cell(1,96);

sfs = unique(dataT.spatialFrequency);
rads = unique(dataT.radius);


for ch = 1:96
   sCh = spikeCounts{ch}; 
   
   if ch == 1
       loc1Ndx = (sCh(6,:) == stimLoc(1,1) & sCh(7,:) == stimLoc(1,2));
       loc2Ndx = (sCh(6,:) == stimLoc(2,1) & sCh(7,:) == stimLoc(2,2));
       loc3Ndx = (sCh(6,:) == stimLoc(3,1) & sCh(7,:) == stimLoc(3,2));
       
       sf1 = (sCh(4,:) == 1);
       sf2 = (sCh(4,:) == 2);
       
       rad1 = (sCh(5,:) == rads(1));
       rad2 = (sCh(5,:) == rads(2));
   end
   
   loc1Spikes{ch}.sf1Rad1 = sCh(:,loc1Ndx & sf1 & rad1);
   loc1Spikes{ch}.sf1Rad2 = sCh(:,loc1Ndx & sf1 & rad2);
   loc1Spikes{ch}.sf2Rad1 = sCh(:,loc1Ndx & sf2 & rad1);
   loc1Spikes{ch}.sf2Rad2 = sCh(:,loc1Ndx & sf2 & rad2);
   
   loc2Spikes{ch}.sf1Rad1 = sCh(:,loc2Ndx & sf1 & rad1);
   loc2Spikes{ch}.sf1Rad2 = sCh(:,loc2Ndx & sf1 & rad2);
   loc2Spikes{ch}.sf2Rad1 = sCh(:,loc2Ndx & sf2 & rad1);
   loc2Spikes{ch}.sf2Rad2 = sCh(:,loc2Ndx & sf2 & rad2);
   
   loc3Spikes{ch}.sf1Rad1 = sCh(:,loc3Ndx & sf1 & rad1);
   loc3Spikes{ch}.sf1Rad2 = sCh(:,loc3Ndx & sf1 & rad2);
   loc3Spikes{ch}.sf2Rad1 = sCh(:,loc3Ndx & sf2 & rad1);
   loc3Spikes{ch}.sf2Rad2 = sCh(:,loc3Ndx & sf2 & rad2);

   
   clear sCh;
end