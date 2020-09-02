function [cleandataT] = GlassRemoveLowDx(dataT)

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
%cleanStimOrder = dataT.stimOrder;

if contains(dataT.programID,'TR')
    cleanRotation = dataT.rotation;
end

%% find the trials where dx == 0.01
dxTrials = find(dataT.dx == 0.01);

%% remove trials 
cleanXpos(dxTrials) = [];
cleanYpos(dxTrials) = [];

cleanType(dxTrials) = [];
cleanNumDots(dxTrials) = [];
cleanDx(dxTrials) = [];
cleanCoh(dxTrials) = [];
cleanSample(dxTrials) = [];
%cleanStimOrder(dxTrials) = [];
cleanBins(dxTrials,:,:) = [];
cleanFile(dxTrials,:) = [];

if contains(dataT.programID,'TR')
    cleanRotation(dxTrials) = [];
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
cleandataT.programID = dataT.programID;
%cleandataT.stimOrder = cleanStimOrder;
% cleandataT.fix_x = dataT.fix_x;
% cleandataT.fix_y = dataT.fix_y;

if contains(dataT.programID,'TR')
    cleandataT.rotation = cleanRotation;
end
