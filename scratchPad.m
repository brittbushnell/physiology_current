allFiles = dir('/Users/brittany/Dropbox/ArrayData/matFiles/V4/RadialFrequency/info');
ndx = 1;
for fi = 1:length(allFiles)
    if contains(allFiles(fi).name,'WU') && contains(allFiles(fi).name,'LE') && contains(allFiles(fi).name,'RadFreqLoc1')
        fname{ndx} = allFiles(fi).name;
        ndx = ndx+1;
    end
end

