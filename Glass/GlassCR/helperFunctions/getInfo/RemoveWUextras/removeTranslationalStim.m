function cleanData = removeTranslationalStim(data)
% this is a function to be used on data collected on WU where translational
% glass patterns were intermixed with rotational and concnetric. It will
% remove all trials that a translational stimulus was shown.
%% setup cleaned variables
cleanXpos = double(data.pos_x);
cleanYpos = double(data.pos_y);
cleanFile = data.filename;
cleanOn = data.stimOn;
cleanOff = data.stimOff;
cleanBins = double(data.bins); % note, if you don't make it a double, cannot set things to nan.

cleanType = data.type;
cleanNumDots = data.numDots;
cleanDx = data.dx;
cleanCoh = data.coh;
cleanSample = data.sample;
%cleanStimOrder = data.stimOrder;

%% find the trials where  the translational stimulus was used.
trlTrials = zeros(1,size(data.filename,1));

% typeTrials = find(data.type == 3);

for t = 1:size(data.filename,1)
    fn = string(data.filename);
    if contains(fn,'T_')
        trlTrials(1,t) = 1;
    end
end

%trlTrials = (typeTrials & cohTrials);

%% remove them
cleanXpos(trlTrials == 1) = [];
cleanYpos(trlTrials == 1) = [];

cleanType(trlTrials == 1) = [];
cleanNumDots(trlTrials == 1) = [];
cleanDx(trlTrials == 1) = [];
cleanCoh(trlTrials == 1) = [];
cleanSample(trlTrials == 1) = [];
%cleanStimOrder(trlTrials == 1) = [];
cleanBins(trlTrials == 1,:,:) = [];
cleanFile(trlTrials == 1,:) = [];
%% re-establish clean Data structure
cleanData.bins = cleanBins;
cleanData.pos_x = cleanXpos;
cleanData.pos_y = cleanYpos;
cleanData.filename = cleanFile;
cleanData.stimOn = cleanOn;
cleanData.stimOff = cleanOff;

cleanData.type = cleanType;
cleanData.numDots = cleanNumDots;
cleanData.dx = cleanDx;
cleanData.coh = cleanCoh;
cleanData.sample = cleanSample;
cleanData.programID = data.programID;
cleanData.animal = data.animal;

if ~contains(data.animal, 'WU')
    cleanData.fix_x = data.fix_x;
    cleanData.fix_y = data.fix_y;
end
