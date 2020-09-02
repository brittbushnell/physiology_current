function [passLength, stimOffset, stimOnLength] = StimReadExpoIn(ExpoIn)
% Input: 
%    - ExpoIn = output of ReadExpoXML.
%               Structure containing block/pass info parsed from Expo XML
%               file.
% Output:
%     - passLength = length of pass in seconds. a pass is a trial,
%               essentially.
%     - stimOffset = length of time in seconds that the stimulus on is
%               offset from the beginning of the pass.  
%     - stimOnLength = length of time stimulus is on in seconds (assuming
%               stimulus is on from beginning of pass). 

%fs = 120;               % Expo frame rate is at 120 Hz.
%fsExpo = 10000;         % Expo sampling rate.

startTimes = GetStartTimes(ExpoIn, ExpoIn.passes.IDs,  'msec');
endTimes = GetEndTimes(ExpoIn, ExpoIn.passes.IDs, 'msec');

passDurations = endTimes - startTimes;
passLength = mode(passDurations) / 1000;

%%
% passTimes = ExpoIn.passes.events{1,1}.Data{1};
% stimOffset = passTimes(2) / fs;
% stimOnLength =  ( passTimes(3)-passTimes(2) ) / fs;
% 
% passLength = ExpoIn.passes.events{1,1}.Times(1);        % This is stored in microseconds
% passLength = ceil(passLength/100);
% passLength = passLength / 100;
