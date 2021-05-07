function [loc1Zs, loc2Zs, loc3Zs] = getRadFreq_zSbyParam(dataT,stimLoc)

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

sfs = unique(dataT.spatialFrequency);
rads = unique(dataT.radius);


for ch = 1:96
   zCh = zScores{ch}; 
   if ch == 1
       loc1Ndx = (zCh(6,:) == stimLoc(1,1) & zCh(7,:) == stimLoc(1,2));
       loc2Ndx = (zCh(6,:) == stimLoc(2,1) & zCh(7,:) == stimLoc(2,2));
       loc3Ndx = (zCh(6,:) == stimLoc(3,1) & zCh(7,:) == stimLoc(3,2));
       
       sf1 = (zCh(4,:) == sfs(1));
       sf2 = (zCh(4,:) == sfs(2));
       
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