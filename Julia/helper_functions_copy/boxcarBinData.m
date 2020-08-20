function binnedData = boxcarBinData(data, winLength, winOverlap, dim);
% Bin the input data with a sliding boxcar window.
% Inputs:
%   - data = matrix of values to be binned.
%   - winLength = number of samples to be included in one window.
%   - winOverlap = number of samples that windows are overlapped by.
%   - dim = dimension to bin over. Default is 2.
dim = 2;
nBins = size(data,2)/winOverlap - 1;

binnedData = NaN(size(data,1), nBins);
for iB = 1:nBins
    binnedData(:,iB) = sum(data(:, winOverlap*(iB-1)+1:winOverlap*(iB-1)+1+winLength),dim);
end