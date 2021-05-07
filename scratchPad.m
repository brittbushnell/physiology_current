%        1)   Radial Frequency
%        2)   Amplitude (Weber fraction)
%        3)   Phase (Orientation)
%        4)   Spatial frequency
%        5)   Amplitude
%        6)   Size (mean radius)
%        7)   X position
%        8)   Y position

zScores = dataT.RFzScore;
loc1Zs = cell(1,96);
loc2Zs = cell(1,96);
loc3Zs = cell(1,96);

for ch = 1%:96
   zCh = zScores{ch}; 
   if ch == 1
       loc1Ndx = find(zCh(6,:) == stimLoc(1,1) & zCh(7,:) == stimLoc(1,2));
       loc2Ndx = find(zCh(6,:) == stimLoc(2,1) & zCh(7,:) == stimLoc(2,2));
       loc3Ndx = find(zCh(6,:) == stimLoc(3,1) & zCh(7,:) == stimLoc(3,2));
   end
   loc1Zs{ch} = zCh(8:end,loc1Ndx);
   loc2Zs{ch} = zCh(8:end,loc2Ndx);
   loc3Zs{ch} = zCh(8:end,loc3Ndx);
   
   clear zCh;
end