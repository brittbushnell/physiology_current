function [mworks_words_out, mworks_words_time_out, nev_words_out, nev_words_time_out] =...
    wordAlignVodnik(mworks_words, mworks_words_time, nev_words, nev_words_time)

% Find the first non-idential words:
mworks_words_original = mworks_words;
mworks_words_time_original = mworks_words_time;
aux = diff(mworks_words_original);
mworks_words = mworks_words_original(find(aux ~= 0, 1, 'first'):end);
mworks_words_time = mworks_words_time_original(find(aux ~= 0, 1, 'first'):end);
clear aux;

% Convert the words from binary into decimal.
nev_wordout_16bits = dec2bin(nev_words);
% We are only using the 8 lower bits of a 16 digit word to send info
% (remove the rest).
nev_wordout_8dec = bin2dec(nev_wordout_16bits(:, 9:16))';

% Convert to micro seconds to match MWorks times.
nev_wordout_times = double(nev_words_time).*(10^6);
%find the smallest interval between words in an mworks file
minimum_interword_interval = min(diff(mworks_words_time));
%locate times in nev file when interword interval is less than half the
%minimum interword interval detected above and remove (by convention
%choose the later of the two close values as the starting point
%find nev inter_word_intervals that are too short
bad_nev_times = find(diff(nev_wordout_times)<minimum_interword_interval/2);
nev_wordout_times(bad_nev_times) = []; %remove these times

% Remove from the word part also the non-possible/probable entries.
nev_wordout_8decFinal = nev_wordout_8dec(setdiff(1:length(nev_wordout_8dec), bad_nev_times));

% Make sure that the words are aligned and matching.
maxLengthTest = min([length(mworks_words), length(nev_wordout_8decFinal)]);
diffTest = 1;
numIterations = 0;
k = 1;
while diffTest > 0 && numIterations < 10
    diffTest = abs(sum(nev_wordout_8decFinal(k:maxLengthTest) - mworks_words(1:(maxLengthTest-k+1))));
    k = k + 1;
    numIterations = numIterations + 1;
end

if diffTest == 0
    nev_wordout_8dec_Final = nev_wordout_8decFinal(k-1:end);
    nev_wordout_times_Final = nev_wordout_times(k-1:end);
    clear maxLengthTest diffTest numIterations k;
    
    maxLengthTestNew = min([length(mworks_words), length(nev_wordout_8dec_Final)]);
    mworks_words_time_out = mworks_words_time(1:maxLengthTestNew);
    mworks_words_out = mworks_words(1:maxLengthTestNew);
    nev_words_time_out = nev_wordout_times_Final(1:maxLengthTestNew)./(10^6);
    nev_words_out = nev_wordout_8dec_Final(1:maxLengthTestNew);
    
    clear maxLengthTestNew;
else
    diffTest = 1;
    numIterations = 0;
    k = 1;
    while diffTest > 0 && numIterations < 10
        % swap the order of the comparison
        diffTest = abs(sum(mworks_words(k:maxLengthTest) - nev_wordout_8decFinal(1:(maxLengthTest-k+1))));
        k = k + 1;
        numIterations = numIterations + 1;
    end
    if diffTest == 0
        mworks_words_Final = mworks_words(k-1:end);
        mworks_words_time_Final = mworks_words_time(k-1:end);
        clear maxLengthTest diffTest numIterations k;
        
        maxLengthTestNew = min([length(mworks_words_Final), length(nev_wordout_8decFinal)]);
        mworks_words_time_out = mworks_words_time_Final(1:maxLengthTestNew);
        mworks_words_out = mworks_words_Final(1:maxLengthTestNew);
        nev_words_time_out = nev_wordout_times(1:maxLengthTestNew)./(10^6);
        nev_words_out = nev_wordout_8decFinal(1:maxLengthTestNew);
        
        clear maxLengthTestNew;
    else
        disp(['Either the nev words are still leading but some word got ',...
            'dropped, or there might be a bigger problem.']);
        keyboard
    end
end
