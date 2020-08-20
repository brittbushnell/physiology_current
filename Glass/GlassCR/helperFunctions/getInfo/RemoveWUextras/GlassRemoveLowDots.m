function [cleandataT] = GlassRemoveLowDots(dataT)

% this is a function to be used on data collected on WU where translational
% glass patterns were intermixed with rotational and concnetric. It will
% remove all trials that a translational stimulus was shown.
%% setup cleaned variables
cleanXpos = double(dataT.pos_x);
cleanYpos = double(dataT.pos_y);
cleanFile = dataT.filename;
cleanOn = dataT.stimOn;
cleanOff = dataT.stimOff;
cleanBins = double(dataT.bins); % note, if you don't make it a double, cannot set things to nan.

cleanType = dataT.type;
cleanNumDots = dataT.numDots;
cleanDx = dataT.dx;
cleanCoh = dataT.coh;
cleanSample = dataT.sample;
cleanStimOrder = dataT.stimOrder;

if contains(dataT.programID,'TR')
    cleanRotation = dataT.rotation;
end

%% find trials run with dots == 100;
dotsTrials = find((dataT.numDots == 100));
%% remove trials where number of dots == 100;
cleanXpos(dotsTrials) = [];
cleanYpos(dotsTrials) = [];

cleanType(dotsTrials) = [];
cleanNumDots(dotsTrials) = [];
cleanDx(dotsTrials) = [];
cleanCoh(dotsTrials) = [];
cleanSample(dotsTrials) = [];
cleanStimOrder(dotsTrials) = [];
cleanBins(dotsTrials,:,:) = [];
cleanFile(dotsTrials,:) = [];
if contains(dataT.programID,'TR')
    cleanRotation(dotsTrials) = [];
end
%% re-establish clean Data structure
cleandataT.bins = cleanBins;
cleandataT.pos_x = cleanXpos;
cleandataT.pos_y = cleanYpos;
cleandataT.filename = cleanFile;
cleandataT.stimOn = cleanOn;
cleandataT.stimOff = cleanOff;

cleandataT.type = cleanType;
cleandataT.numDots = cleanNumDots;
cleandataT.dx = cleanDx;
cleandataT.coh = cleanCoh;
cleandataT.sample = cleanSample;
cleandataT.stimOrder = cleanStimOrder;
cleandataT.fix_x = dataT.fix_x;
cleandataT.fix_y = dataT.fix_y;

if contains(dataT.programID,'TR')
    cleandataT.rotation = cleanRotation;
end
