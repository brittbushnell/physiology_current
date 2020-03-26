function [stimOrder] = getStimPresentationOrder(data, varargin)
% getStimPresentationOrder is a function that takes in the stimulus time information from mWorks, and 
% determines the stimulus presentation order within a single trial. 
%
% INPUT:
%    DATA - standard data structure for mWorks and Blackrock data
%    PLOTFLAG - Default is off, set to 1 if you want to see a histogram of the distribution of
%    stimulus order numbers.
%
% OUTPUT
%    STIMORDER - 1 dimensional vector with the number for when a stimulus
%    was shown within a trial.
%
% 6/24/19 Brittany Bushnell
%%
if nargin == 1
    plotFlag = 0;
end
%%
times = data.t_stim;
stimOrder = nan(1,length(times));
isi = double(diff(times)-1); % get the difference in time for subsequent stimulus presentations
isi(end+1) = nan(1,1); % add a nan to the end so the vector is the same length as the others, makes everything much easier

modeTime = mode(isi); % Since stimulus presentation time is hard coded, it should be the most common isi.

buffer = modeTime/20; % allow for a little bit of wiggle room
maxTime = modeTime+buffer;
minTime = modeTime-buffer;

stimNdx = 2;
stimOrder(1) = 1;

for i = 2:length(isi) % The first stimulus is always #1, so hard code that and move forward from there.  
    if isi(i)>minTime && isi(i)<maxTime
        stimOrder(i) = stimNdx;
        stimNdx = stimNdx+1;
    else
        stimNdx = 1;
        stimOrder(i) = stimNdx;
    end
end
%% sanity check figure
if plotFlag == 1
    figure
    set(gca,'Color','none','tickdir','out');
    histogram(stimOrder)
    xlabel('Stimulus order')
    ylabel('instances')
    title('Number of stimuli per trial')
end
