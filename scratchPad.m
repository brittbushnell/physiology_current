allFiles = dir('/Users/brittany/Dropbox/ArrayData/matFiles/V4/RadialFrequency/info');
ndx = 1;
for fi = 1:length(allFiles)
    if contains(allFiles(fi).name,'WU') && contains(allFiles(fi).name,'LE') && contains(allFiles(fi).name,'RadFreqLoc1')
        fname{ndx} = allFiles(fi).name;
        ndx = ndx+1;
    end
end
%%
rf16Ndx0  = (zCh(1,:) == 16) & (zCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
rf16Ndx2  = (zCh(1,:) == 16) & (zCh(3,:) == 11.25);


rf16rot0 = zCh(8:end,rf16Ndx0 & sfNdx & radNdx & locNdx);
rf16rot2 = zCh(8:end,rf16Ndx2 & sfNdx & radNdx & locNdx);

chMuZ(3,1,:,sf,sz,loc,ch) = mean(rf16rot0);
chMuZ(3,2,:,sf,sz,loc,ch) = mean(rf16rot2);


chErrorZ(3,1,:,sf,sz,loc,ch) = std(rf16rot0)/sqrt(length(rf16rot0));
chErrorZ(3,2,:,sf,sz,loc,ch) = std(rf16rot0)/sqrt(length(rf16rot2));

