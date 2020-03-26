function [cleandataT] = GlassRemoveLowCohs(dataT)

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

%% find trials run with dots == 100;
dotsTrials = find((dataT.coh ~= 0) | (dataT.coh == 1));
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
cleandataT.animal = dataT.animal;
cleandataT.eye = dataT.eye;
cleandataT.programID = dataT.programID;
cleandataT.array = dataT.array;
cleandataT.date = dataT.date;
cleandataT.date2 = dataT.date2;
cleandataT.stimOrder = cleanStimOrder;
cleandataT.runNum = dataT.runNum;
