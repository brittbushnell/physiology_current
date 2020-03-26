function [goodChannels,badChannels] = MwksGetGoodCh(data, filename, suppression)
% [goodChannels] = MwksGetGoodCh(data)
% MWKSGETGOODCH is a function that determines what channels in an array are
% visually responsive by comparing the responses half way through the
% stimulus display period with responses to a blank at the same point in a
% trial.
%
% INPUT
% DATA  is the data structure created by parsing files
% FILENAME is the filename you're running.
% SUPPRESSION determines whether or not to ignore suppressive channels.
% If set to 1, any channel that is suppressed is ignored. If set to 0, good
% channels are defined by any significant change from baseline.
%
% OUTPUT
% goodChannels is a vector of the channel IDs of visually responsive
% channels
%
% Created July 17, 2017 Brittany Bushnell
%
% OCT 9, 2017 to include different standard reference values for
%  different stimuli
%
% Jan 11, 2018 added suppression variable - still needs
%
% March 20, 2018 added bad channels

%% Define parameters of the experiment
stimOn  = unique(data.stimOn);
stimOff = unique(data.stimOff);
numChannels = size(data.bins,3);

goodChannels = [];
badChannels = [];
gc = 1;
bc = 1;
binStimOn  = round(stimOn/10);
binStimOff = round(stimOff/10);
%% Define what is a stimulus and what is a blank screen
if exist('data.rf')
    blankNdx  = find(data.rf > 999);
    circleNdx = find(data.rf == 32);
    rfNdx     = find(data.rf < 32);
    stimNdx    = find(data.rf <50);
end

if strfind(filename,'grat')
    blankNdx = find(data.spatial_frequency == 0);
    stimNdx  = find(data.spatial_frequency > 0);
elseif strfind(filename,'Pasupathy')
    blankNdx = find(data.stimID == 100);
    stimNdx = find(data.stimID < 100 & data.stimID > -1);
elseif strfind(filename,'Freq')
    blankNdx  = find(data.rf > 999);
    circleNdx = find(data.rf == 32);
    rfNdx     = find(data.rf < 32);
    stimNdx   = find(data.rf <50);
end
%%
for ch = 1:numChannels
    for i = 1:size(data.bins,2)
        % Get the mean resposnse for all blanks, then all stimuli at time
        % i.
        testRespsT(1,i) = mean(data.bins(blankNdx,i,ch));
        testRespsT(2,i) = mean(data.bins(stimNdx,i,ch));
    end
    
    if suppression == 0  % want to ignore any channels with suppression
        if mean(testRespsT(1,5:15)) < mean(testRespsT(2,5:15))
            
            % Do a ttest on the mean responses that occur within
            [testRespsT(3,1), testRespsT(4,1)] = ttest(testRespsT(1,1:(binStimOn+binStimOff)),testRespsT(2,1:(binStimOn+binStimOff)));
            
            % Build matix of good channel IDs
            if testRespsT(3,1) == 1
                goodChannels(gc,1) = ch;
                gc = gc+1;
            else
                badChannels(bc,1) = ch;
                bc = bc+1;
            end
        end
    end
end







