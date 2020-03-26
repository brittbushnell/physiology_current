function [regressionResutls, regressionStats] = regressTimeMWorksNEV(mworksFile, NEV)

load(mworksFile, 'wordout_varEvents');

% [~, ~, ext] = fileparts(nevFile);
% if strcmp(ext, '.nev')
%     NEV = openNEV(nevFile);
% elseif strcmp(ext, '.mat')
%     load(nevFile, 'NEV');
% end

mworks_words = double(cell2mat({wordout_varEvents(cell2mat({wordout_varEvents.data})~=0).data}));
mworks_words_time = double(cell2mat({wordout_varEvents(cell2mat({wordout_varEvents.data})~=0).time_us}));
nev_words = double(NEV.Data.SerialDigitalIO.UnparsedData);
nev_words_time = double(NEV.Data.SerialDigitalIO.TimeStampSec);

[mworks_words_out, mworks_words_time_out, nev_words_out, nev_words_time_out] =...
    wordAlignVodnik(mworks_words, mworks_words_time, nev_words, nev_words_time);

if sum(nev_words_out - mworks_words_out) ~= 0
    disp('Problems with word alignment');
end
    

[regressionResutls, ~, ~, ~, regressionStats] = regress(nev_words_time_out',...
    [ones(size(nev_words_time_out)); mworks_words_time_out./(10^6)]');
regressionResutls(1) = regressionResutls(1).*(10^6);