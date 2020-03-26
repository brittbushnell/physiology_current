function expoDataSet = ReadExpoXML(filename, doSpikeWaveforms, beVerbose)
% function ReadExpoXML(filename, doSpikeWaveforms, beVerbose)
%
% Expo utilty to import exported data from Expo into Matlab.
% This function requires Matlab v7.0 (aka Release 14) or greater
%
% Filename: Reads data from ExpoX data xml file into matrices and cell arrays and saves as mat file
% doSpikeWaveforms: 1 if you want to process waveform data, else 0. [default 0].
% beVerbose: 1 if you want to be display updates while processing data,
%            else 0 (useful while running a batch script). [default 1].
%
% One then loads the mat file to get the following variables:
%
% (Program:)
% blocks - a structure containing information about each block (state) in the program
%   members are
%   (1) vector of BlockIDs
%   (2) vector of Names
%   (3) cell array of Routines, one cell for each block
%
% routines - a structure within blocks containing info about the routines included in each cell of all the blocks
%   members are:
%   (1) vector of routine IDs indexed by blockID
%   (2) vector of routine Names indexed by blockID
%   (3) vector of routine Labels indexed by blockID
%   (4) cell array of parameters
%   (5) routineMap
%   (6) routineEntries
%
% routineMap: a structure within routines useful as a lookup table to see which routines are used in which blocks
%    (1) RoutineID
%    (2) Vector of RountineEntries IDs (see details for Routine Entries table)
%    (3) Routine Name
%    -- Col 4: Routine Label
%
% routineEntries - a structure enumerating every routine entry in all of the blocks
%    (1) RoutineID
%    (2) Position of routine in the block
%    (3) BlockID
%    (4) Position of block in list of sequence of blocks
%
% parameters - each cell within the routines param array contains
%   (1) vector of param Names
%   (2) vector of param VarNames
%   (3) vector of param Ops
%   (4) vector of param Units
%   (5) vector of param Evalues
%
%
% slots: each row describes a slot in the program's flow-control diagram: ID, Name, ID of Block it executes.
%
% (Data:)
% passes: a structure containing information about each pass in the execution of the program.
%         The strucure contains arrays of pass ids, slot ids, block ids, starttimes, endtimes
%         (times are always in .1 msec units) and events.
%         The block ID is included in the pass as well as in the slot because if the pass
%         belongs to Expo's Matrix object the block id is not derivable from the slot.
%
% The events object within passes (ExpoDataSet.passes.events) contains a list of event structures, one for each pass
% Each event structure corresponds to the run routines executed during a pass and contains
%       (1) Array of RoutineIDs
%       (2) Times stamps at which they executed or finished
%       (3) Cellular array of data for the routine parameters.  Each cell corresponds to the data for each routine
%
% analogSampleInterval: a time, e.g. 29 means 2.9 msec, i.e. 1/344 sec.
% analogNumofChannels: total number of analog channels (e.g. eyetraces etc) collected.
% analogSegments: for each segment there are:
%    (1) Number of Samples (2) Start Time (3) character array containing the samples.
%    Within (3) the channels are interleaved.
%    Since there are AnalogNumofChannels, the samples for channel 1 are chars at positions
%       1, 1+AnalogNumofChannels, 1+2*AnalogNumofChannels, ...
%       Use double(analogSegments.Data{1}(m:x:n)) to turn segment 1 into array of doubles for
%       channel m where x is num of channels and n is the last sample in range
%
% spiketimes - a structure containing:
%       (1) an array of spike IDs - each id referring to a spike template or type
%       (2) an array of channel IDs - one entry for each spike id
%       (3) a cell array of spike times; each cell contains a vector array of times for each spike ID.
%
% waveforms [if raw waveforms are loaded]: structure containing
%   Channels - structure containing vector arrays describing compression parameters applied to data received from each electrode
%   Times - vector of start times for each data packet
%   Data - cell array of data packets containing waveform data - different channels are interleaved
%   DataSize - tells you if raw waveform has been recorded with number of bytes (1 or 2)
%   NumOfBuffers - num of data packets or buffers
%   FramesPerBuf - number of samples per buffer
%   NumOfChannels
%   SampleRate in Hz
%
% environment structure containing:
%   Version number of Expo used to export data
%   Filename
%   Conversion parameters
%
% See also GetSlots, GetPasses, GetEvents, GetAnalog, GetSpikeTimes,
% GetSpikeCounts, GetPSTH, PlotPSTH, GetStartTimes, GetEndTimes, GetDuration,
% GetConversionFactor, MergeExpoDataSets, GetTransitionProbabilities.
%
%   Author:        Julian Brown
%	Version:       1.1
%   Last updated:  2005-06-09
%   E-mail:        julian@monkeybiz.stanford.edu
%
%   Author:        Neel Dhruv
%	Version:       1.1.1
%   Last updated:  2008-12-08
%   E-mail:        n.drhuv@ucl.ac.uk
%
%   Author:        Romesh Kumbhani
%	Version:       1.2
%   Last updated:  2011-03-30
%   E-mail:        romesh.kumbhani@nyu.edu
%
%   Author:        Romesh Kumbhani
%	Version:       2.0 (Now 25% faster!)
%   Last updated:  2011-10-04
%   E-mail:        romesh.kumbhani@nyu.edu
%
%   Author:        Romesh Kumbhani
%	Version:       2.1 (supports ExpoXData Version 1.5.14+)
%   Last updated:  2013-05-03
%   E-mail:        romesh.kumbhani@nyu.edu

%% Setup Global Parameters
clear global

global output matrix blocks slots passes analog spiketimes environment waveforms frames
global routineEntries routinesMap doWaveforms verbose textfile tokenlist paramlist eventlist waveformlist segmentlist

%% Process Input Parameters

if ~exist('doSpikeWaveforms','var')
    doWaveforms = 0;
else
    doWaveforms = 0;
    if doSpikeWaveforms ~= 0
        doWaveforms = 1;
    end
end

if ~exist('beVerbose','var')
    verbose = 1;
else
    verbose = 0;
    if beVerbose ~= 0
        verbose = 1;
    end
end

%% Process XML file

% version info
% expoVersion = '2.1';
% the expoVersion # is stored in the CheckExpoVersion routine
% we have a separate matlabImport version # so that changes in the Matlab
% code can be released independently of changes in Expo

output.MatlabImportVersion = '1.5.14';

if verbose, fprintf('ReadExpoXML Version %s\n', output.MatlabImportVersion); end;

if exist(filename,'file')
    temp = dir(filename);
    bufsize = temp.bytes;
else
    error('ExpoMatlab:ReadExpoXML','Could not find filename: %s',filename);
end

try
    fid = fopen(filename);
    textfile = textscan(fid,'%s','delimiter','\n','whitespace','','bufsize',bufsize);
    fclose(fid);
    textfile = textfile{1};
catch ME
    error('ExpoMatlab:ReadExpoXML','Could not load filename: %s',filename);
end

% prerun the major regular expressions for speed
eventRegEx = '\<Event RID=\"([\w.]*)\" Time=\"([\w.]*)\" Data=\"([^"]*)\"';
paramRegEx = '\<Param Name=\"([^\"]*)\" VarName=\"([^\"]*)\" Op=\"([\S]*)\" EUnit=\"([\w.-"]*)\" CUnit=\"([\w.-]*)\" Evalue=\"([\w.-]*)\"';
waveformRegEx = '\<WaveformRecord Time=\"([-\d\.]*)\" Buffer=\"([\S]*)\"';
segmentRegEx = '\<AnalogSegment NumOfSamples=\"([\d]*)\" StartTime=\"([-\d\.]*)\">([^\<]*)';

tokenlist = regexp(textfile,'<(/?\w+).*?/?>','tokens');
paramlist = regexp(textfile,paramRegEx,'tokens');
eventlist = regexp(textfile,eventRegEx,'tokens');

if doWaveforms
    waveformlist = regexp(textfile,waveformRegEx,'tokens');
else
    waveformlist = [];
end
segmentlist = regexp(textfile,segmentRegEx,'tokens');
%%

% count items so we can create space for arrays
CountItems(textfile);

% preallocate arrays
InitializeArrays();

% extract the data
ParseXML(doWaveforms);

%% Ready the final stucture

% assign the routine maps and entries in the block substructure
blocks.routinesMap = routinesMap;
blocks.routinesEntries = routineEntries;

% if Comment and Notes were not found, add a blank field.
if ~isfield(output, 'Comment'),
    output.Comment='';
end

if ~isfield(output, 'Notes'),
    output.Notes = '';
end

% put data into the structure returned by this function
output.matrix      = matrix;
output.blocks      = blocks;
output.slots       = slots;
output.passes      = passes;
output.spiketimes  = spiketimes;
output.waveforms   = waveforms;
output.analog      = analog;
output.environment = environment;
output.frames      = frames;

% setup the conversion table
environment.Conversion.units = InitializeUnitConversionMatrices(output);
output.environment = environment;

% save the data as mat file
% basefilename = strtok(filename, '.'); % removes file extension (eg '.xml')
% save(basefilename, '-struct', 'ExpoDataSet');

% show a little of the data
if verbose,
    DisplaySampleData();
end

% Keep the filename tag consistant between old and new.
truefilename = regexprep(filename,'.*\/([^\.]+).*','$1');
if ~strcmp(output.FileName,truefilename)
    output.FileName = truefilename;
end

% Convert Timestamps to 1/10 ms scale, offset by start time of expo.
if isfield(output,'frames')&&isfield(output.frames,'ExpoStartTime_ns')
    output.frames.Times        = (output.frames.Times        - output.frames.ExpoStartTime_ns)./ 100000;
    output.frames.StartTimes   = (output.frames.StartTimes   - output.frames.ExpoStartTime_ns)./ 100000;
    output.frames.FlushTimes   = (output.frames.FlushTimes   - output.frames.ExpoStartTime_ns)./ 100000;
    output.frames.DisplayTimes = (output.frames.DisplayTimes - output.frames.ExpoStartTime_ns)./ 100000;
    output.frames.ExpoStartTime = (output.frames.ExpoStartTime_ns - output.frames.ExpoStartTime_ns)./ 100000;
    output.frames.ExpoEndTime   = (output.frames.ExpoEndTime_ns   - output.frames.ExpoStartTime_ns)./ 100000;
    output.frames = rmfield(output.frames,'ExpoStartTime_ns');
    output.frames = rmfield(output.frames,'ExpoEndTime_ns');
end
if isfield(output,'frames')&&isfield(output.frames,'TBOs')
        output.frames.TBOs = logical(output.frames.TBOs==1);
        output.passes.nTBOs = histc(output.frames.StartTimes(output.frames.TBOs),[output.passes.StartTimes output.passes.EndTimes(end)])';
end


%% *** Change for m640 experiment. Uncomment after library is done ***
output.MatlabImportVersion = '1.1';
output.ExpoVersion         = '1.1';

% Save the output structure as the output variable and exit
expoDataSet = output;

return


function ProcessMatrix()
global matrix currentLine linenum textfile tokenlist
matrix = [];
matrix = ParseNode(matrix, 0);

dimensionNum = 0;
dimensions = cell(1,1);

while 1
    [token,eof,textfile,tokenlist,currentLine,linenum] = GetNextToken2(textfile,tokenlist,currentLine,linenum);
    %[token eof] = GetNextToken();
    if eof==1, break, end
    
    dimension = [];
    
    switch token
        case 'Dimension'
            dimensionNum = dimensionNum + 1;
            dimension = ParseNode(dimension, 0);
            dimensions{dimensionNum} = dimension;
        case '/Matrix'
            matrix.Dimensions = dimensions;
            break;
    end
end
return


function ProcessBlocksAttributes()
global matrix
blockInfo = [];
blockInfo = ParseNode(blockInfo, 0);

% this is for v1.0 Expo which put the matrixBasedID in the
% block data
if isfield(blockInfo, 'MatrixBaseID')
    matrix.MatrixBaseID = blockInfo.MatrixBaseID;
end
return


function ProcessBlock()
global linenum blocknum blocks currentLine routinesMap routineEntries routineEntryNum routineMapNum routinesHash paramlist textfile tokenlist

blockRegex = '\<Block ID=\"([\d]*)\" Name=\"([^\"]*)\" NumOfRoutines=\"([\d]*)\"';
routineRegex = '\<Routine ID=\"([\d]*)\" Name=\"([^\"]*)\" Label=\"([^\"]*)\" NumOfParams=\"([\d]*)\"';

blocknum = blocknum+1;
blockAttributes = GetAttributes(linenum, currentLine, 'block', blockRegex, 3);
blockID = sscanf(blockAttributes{1},'%i'); %ID
blocks.IDs(blocknum) = blockID;
blocks.Names{blocknum} = blockAttributes{2}; %Name
numOfRoutines = sscanf(blockAttributes{3},'%i'); %NumOfRoutines
routineNum = 0;
routines.IDs =  zeros(1, numOfRoutines, 'int32');

% process routines and params for this block
while 1
    [token,eof,textfile,tokenlist,currentLine,linenum] = GetNextToken2(textfile,tokenlist,currentLine,linenum);
    %[token eof] = GetNextToken();
    if eof==1, break, end
    
    switch token
        case 'Routine'
            routineNum = routineNum + 1; % the routine number within a block
            routineEntryNum = routineEntryNum + 1; % the routine number with a global list of routines
            paramNum = 0;
            
            routineAttributes = GetAttributes(linenum, currentLine, 'routine', routineRegex, 4);
            %numOfParams = sscanf(routineAttributes{4},'%i');
            
            routineID = sscanf(routineAttributes{1},'%i'); % routine ID
            routines.IDs(routineNum) = routineID;
            routineName = routineAttributes{2}; % Name
            routines.Names{routineNum} = routineName; % Name
            routineLabel = routineAttributes{3}; % Label
            routines.Labels{routineNum} = routineLabel; % Label
            
            % add an entry into a global list of routine entries
            % this list keeps pointers to blocks and routine position
            % and is used in conjunction with routinesMap for finding
            % blockIDs and routine entries by routineID
            routineEntries.RoutineIDs(routineEntryNum) = routineID;
            routineEntries.RoutineNums(routineEntryNum) = routineNum;
            routineEntries.BlockIDs(routineEntryNum) = blockID;
            routineEntries.BlockNums(routineEntryNum) = blocknum;
            
            % is this an old routine?
            if routinesHash.containsKey(routineID)
                % not new so add entry to routineMap in an existing row
                routineMapPos = routinesHash.get(routineID);
                routineMapCellSize = size(routinesMap.RoutineNums{routineMapPos});
                routinesMap.RoutineNums{routineMapPos}(routineMapCellSize(2) +1) =  routineEntryNum;
            else
                % No! We have a new routine!
                routineMapNum = routineMapNum + 1;
                % add routine details to the Map
                routinesMap.RoutineIDs(routineMapNum) =  routineID;
                routinesMap.RoutineNums{routineMapNum}(1) =  routineEntryNum;
                routinesMap.RoutineNames{routineMapNum} = routineName;
                routinesMap.RoutineLabels{routineMapNum} = routineLabel;
                
                % add the routineID and map pointer to hashtable
                routinesHash.put(routineID, routineMapNum);
            end
            
            %params = cell(numOfParams, 4); % Params cell
            continue
            
        case '/Routine'
            routines.Params{routineNum} = params;
            clear params; %% OLD CODE FORGOT THIS!
            
        case 'Param'
            paramNum = paramNum + 1;
            paramAttributes = GetAttributesPreAlloc(linenum, 'Param', 6, paramlist);
            params.Names{paramNum} = paramAttributes{1}; % Name
            params.VarNames{paramNum} = paramAttributes{2}; % VarName
            params.Ops{paramNum} = paramAttributes{3}; % Op
            params.EUnits(paramNum) = sscanf(paramAttributes{4}, '%i'); % EUnit
            params.CUnits(paramNum) = sscanf(paramAttributes{5}, '%i'); % CUnit
            params.Evalues{paramNum} = sscanf(paramAttributes{6},'%f'); % Evalue
            continue
            
        case '/Block'
            blocks.routines{blocknum} = routines;
            break;
    end
end
return


function ProcessAnalogData()
global linenum currentLine analognum analog segmentlist textfile tokenlist

analogRegex = '\<AnalogData NumOfSegments=\"([\d]*)\" NumOfChannels=\"([\d]*)\" SampleInterval=\"([\d\.]*)\"';
%segmentRegex = '\<AnalogSegment NumOfSamples=\"([\d]*)\" StartTime=\"([-\d\.]*)\">([^\<]*)';
analogAttributes = GetAttributes(linenum, currentLine, 'analog', analogRegex, 3);
analog.NumOfChannels  =  sscanf(analogAttributes{2},'%i'); %NumOfChannels
analog.SampleInterval =  sscanf(analogAttributes{3},'%f'); %SampleInterval

% process analogSegments
while 1
    [token,eof,textfile,tokenlist,currentLine,linenum] = GetNextToken2(textfile,tokenlist,currentLine,linenum);
    %[token eof] = GetNextToken();
    if eof==1, break, end
    
    switch token
        case 'AnalogSegment'
            analognum = analognum + 1;
            %segmentAttributes = GetAttributes(linenum, currentLine, 'segment', segmentRegex, 3);
            segmentAttributes = GetAttributesPreAlloc(linenum, 'Segment', 3, segmentlist);
            analog.Segments.SampleCounts(analognum) = sscanf(segmentAttributes{1},'%i'); % NumOfSamples
            analog.Segments.StartTimes(analognum) = sscanf(segmentAttributes{2},'%i'); % StartTime
            analog.Segments.Data{analognum} = base64decode(segmentAttributes{3}); % Data
            
        case '/AnalogData'
            break
    end
end
return


function ProcessSlotRecord()
global linenum currentLine slotnum slots textfile tokenlist
slotnum = slotnum+1;

slotRegex = '\<Slot ID=\"([\d]*)\" Label=\"([^\"]*)\" BlockID=\"([^\"]*)\"';
slotAttributes = GetAttributes(linenum, currentLine, 'slot', slotRegex, 3);
slots.IDs(slotnum) = sscanf(slotAttributes{1},'%i'); %IDs
slots.Labels{slotnum} = slotAttributes{2}; %Labels
slots.BlockIDs(slotnum) = sscanf(slotAttributes{3},'%i'); %BlockIDs

% for backward compatibility with Expo v1.0 check to see whether the
% node ended here
if ~isempty(regexp(currentLine, '<Slot.*(?=/>)','once'))
    return % no more info so return
end

while 1
    [token,eof,textfile,tokenlist,currentLine,linenum] = GetNextToken2(textfile,tokenlist,currentLine,linenum);
    %[token eof] = GetNextToken();
    if eof==1
        break;
    end
    
    info = [];
    
    switch token
        case '/Slot'
            break;
        otherwise
            slots.(token)(slotnum) = ParseNode(info, 0);
    end
end

return


function ProcessPassRecord()
global linenum currentLine passnum passes verbose totalpasses
passnum = passnum+1;
passRegex = '\<Pass ID=\"([\d]*)\" SlotID=\"([\d]*)\" BlockID=\"([\d]*)\" StartTime=\"([-\d\.]*)\" EndTime=\"([-\d\.]*)\"';
passAttributes = GetAttributes(linenum, currentLine, 'pass', passRegex, 5);
passes.IDs(passnum) = sscanf(passAttributes{1},'%i'); %IDs
passes.SlotIDs(passnum) = sscanf(passAttributes{2},'%i'); %SlotIDs
passes.BlockIDs(passnum) = sscanf(passAttributes{3},'%i'); %BlockIDs
passes.StartTimes(passnum) = sscanf(passAttributes{4},'%i'); %StartTimes
passes.EndTimes(passnum) = sscanf(passAttributes{5},'%i'); %EndTimes
ProcessEventRecords();

% show progress
if verbose
    if (mod(passnum,1000) == 0) || (passnum == totalpasses)
        fprintf('%6.0f passes processed [%5.1f%%]\n', passnum, 100.0*double(passnum)/double(totalpasses));
    end
end
return


function ProcessEventRecords()
global currentLine linenum passnum passes textfile eventlist

% Event elements contain RID,Time,DataParam1;DataParam2
% where there may be 0 to many DataParams eg.
% 1,0,11620,1;90;65.479353;49.148398;0;0;0;0;0;270
%eventRegex =  '\<Event RID=\"([\w.]*)\" Time=\"([\w.]*)\" Data=\"([^"]*)\"';
eventnum = 0;

while 1
    linenum = linenum + 1;
    currentLine = textfile{linenum,1};
    if ~isempty(strfind(currentLine,'</Pass>'))
        break
    end
    eventnum = eventnum+1;
    %eventAttributes = GetAttributes(linenum, currentLine, 'Event', eventRegex, 3);
    eventAttributes = GetAttributesPreAlloc(linenum, 'Event', 3, eventlist);
    events.RoutineIDs(eventnum) =  sscanf(eventAttributes{1},'%i'); %RoutineIDs
    events.Times(eventnum) = sscanf(eventAttributes{2},'%i'); %Times
    
    %events.Data{eventnum} = str2num(eventAttributes{3});        %the intuitive str2num is slower than
    %events.Data{eventnum} = eval(['[' eventAttributes{3} ']']); %eval which is slower than
    events.Data{eventnum} = sscanf(eventAttributes{3},'%f,')';   %sscanf!
    
end

if eventnum==0
    events.RoutineIDs = [];
    events.Times = [];
    events.Data{1} = [];
end

passes.events{passnum} = events;
return


function ProcessExpoXData()
global output verbose
output = ParseNode(output, 0);
expandversion = inline('x(3)*10000+x(2)*100+x(1)','x');
ExpoVersion   = sscanf(output.ExpoVersion,'%d.%d.%d');
MatlabImportVersion = sscanf(output.MatlabImportVersion,'%d.%d.%d');

% buffer subversions and builds with 0 if not found
ExpoVersion(        size(ExpoVersion,        1)+1:3,1) = 0;
MatlabImportVersion(size(MatlabImportVersion,1)+1:3,1) = 0;

if expandversion(ExpoVersion) < expandversion(MatlabImportVersion)
    %if str2double(output.ExpoVersion) > str2double(output.MatlabImportVersion)
    %warning('ExpoMatlab:ReadExpoXML','\n************\nThis xml file was generated from Expo version %s, whereas this Matlab code was written for version %s. Everything should work (knock on wood).\n************\n',output.ExpoVersion, output.MatlabImportVersion);
    fprintf('\n************\nThis xml file was generated from Expo version %s, whereas this Matlab code was written for version %s. Everything should work (knock on wood).\n************\n',output.ExpoVersion, output.MatlabImportVersion)
end
if verbose, fprintf('\nExpoVersion: %s\nFile name: %s\n', output.ExpoVersion,output.FileName); end
return


function ProcessCommentOrNote(elementName)
global currentLine linenum output textfile;
pos = strfind(currentLine, ['<', elementName, '>']);
pos = pos + length(elementName) + 2;
comment = [currentLine(pos:length(currentLine)) char(10)];

while 1
    linenum = linenum + 1;
    currentLine = textfile{linenum,1};
    if (currentLine == -1)
        return
    end
    pos = strfind(currentLine, ['</', elementName, '>']);
    if isempty(pos) % if the end element wasn't found, keep concatenating...
        comment = cat(2, comment, currentLine, char(10));
    else % found the end element on this line..
        comment = cat(2, comment, currentLine(1:pos-1));
        output.Comment = comment;
        return
    end
end


function ProcessEnvironmentRecord()
global linenum currentLine environment textfile
linenum = linenum + 1;
currentLine = textfile{linenum,1};
environment = ParseNode(environment, 1);
return;


function ProcessTimelineRecord()
global linenum currentLine frames textfile verbose
if strcmp(currentLine,'<timeline/>')
    return;
end

fields = ParseNode([],0);
if ~isempty(fields)
    frames.ExpoStartTime_ns = fields.startTime;
    frames.ExpoEndTime_ns   = fields.endTime;
end
linenum = linenum + 1;
currentLine = textfile{linenum,1};
cnt = 1;
while ~strcmp(currentLine,'</timeline>')
    temp = ParseNode([],0);
    if isfield(temp,'timestamp') % Expo Version 1.5.13 special build
        frames.Times(cnt)        = temp.timestamp;
        frames.StartTimes(cnt)   = nan;
        frames.FlushTimes(cnt)   = nan;
        frames.DisplayTimes(cnt) = temp.timestamp;
        frames.TBOs(cnt)         = nan;
    else                         % Expo Version 1.5.14+
        frames.Times(cnt)        = temp.end;
        frames.StartTimes(cnt)   = temp.start;
        frames.FlushTimes(cnt)   = temp.flush;
        frames.DisplayTimes(cnt) = temp.end;
        frames.TBOs(cnt)         = temp.tbo;
    end
    
    % show progress
    if verbose
        if (mod(cnt,10000) == 0) || (cnt == frames.nticks)
            fprintf('%6.0f ticks processed [%5.1f%%]\n', cnt, 100.0*double(cnt)/double(frames.nticks));
        end
    end
    cnt = cnt + 1;
    linenum = linenum + 1;
    currentLine = textfile{linenum,1};
end

function object = ParseNode(object, useElementName)
global currentLine
% generic regular expression that extracts element and arbitrary number of attributes
genRegex = '\<([\w]*) ([\w]*)=\"([^"]*)\"';


[tok] = regexp(currentLine, genRegex, 'tokens');
if isempty(tok)
    object = [];
    return;
end
numOfItems = size(tok, 2);
elementName = tok{1}(1);

for i=1:numOfItems
    attributeName = tok{i}(2);
    attributeValue = tok{i}(3);
    
    if strcmp(attributeName, 'Version')
        forceString = 1; %special handling for the Version tag
        attributeName{1} = 'ExpoVersion';
    elseif strcmp(attributeName, 'Name')
        forceString = 1;
    else
        forceString = 0;
    end
    
    % dynamically create new members of the object structure
    if useElementName == 1
        if ~forceString && ~isnan(str2double(attributeValue{1}))
            object.(elementName{1}).(attributeName{1}) = str2double(attributeValue{1});
        else
            object.(elementName{1}).(attributeName{1}) = attributeValue{1};
        end
    else
        if ~forceString && ~isnan(str2double(attributeValue{1}))
            object.(attributeName{1}) = str2double(attributeValue{1});
        else
            object.(attributeName{1}) = attributeValue{1};
        end
    end
end
return


function ProcessSpikeTimes()
global linenum currentLine  spikenum spiketimes
spikenum = spikenum +1;
spikeRegex = '\<Spike ID=\"([\d]*)\" Channel=\"([\d]*)\" Times=\"([\d\.,]*)\"';
spikeAttributes = GetAttributes(linenum, currentLine, 'spike times', spikeRegex, 3);
spiketimes.IDs(spikenum) = sscanf(spikeAttributes{1},'%i'); %ID
spiketimes.Channels(spikenum) = sscanf(spikeAttributes{2},'%i'); %Channel
%spiketimes.Times{spikenum} = eval(['[' spikeAttributes{3} ']']); %Times
spiketimes.Times{spikenum} = sscanf(spikeAttributes{3}, '%f,')'; %Times

return


function ProcessSpikeWaveforms()
global linenum currentLine textfile tokenlist waveChannelNum waveformnum waveforms verbose waveformlist

%waveformRegex = '\<WaveformRecord Time=\"([-\d\.]*)\" Buffer=\"([\S]*)\"';
waveformParamsRegex4 = '\<SpikeWaveforms NumBuffers=\"([\d]*)\" FramesPerBuf=\"([\w+=/]*)\" NumChannels=\"([\d]*)\" SampleRate=\"([\d.]*)\"';
waveformParamsRegex5 = '\<SpikeWaveforms NumBuffers=\"([\d]*)\" FramesPerBuf=\"([\w+=/]*)\" NumChannels=\"([\d]*)\" SampleRate=\"([\d.]*)\" DataSize=\"([\d]*)\"';
if isempty(strfind(currentLine,'DataSize'))
    waveformParamsAttributes = GetAttributes(linenum, currentLine, 'spike waveform params', waveformParamsRegex4, 4);
else
    waveformParamsAttributes = GetAttributes(linenum, currentLine, 'spike waveform params', waveformParamsRegex5, 5);
end

waveforms.NumOfBuffers  = sscanf(waveformParamsAttributes{1},'%i');
waveforms.FramesPerBuf  = sscanf(waveformParamsAttributes{2},'%i');
waveforms.NumOfChannels = sscanf(waveformParamsAttributes{3},'%i');
waveforms.SampleRate    = sscanf(waveformParamsAttributes{4},'%f');
if ~isempty(strfind(currentLine,'DataSize'))
    waveforms.DataSize  = sscanf(waveformParamsAttributes{5},'%i');
end

totalwaveforms = double(length(waveforms.Times));

while 1
    [token,eof,textfile,tokenlist,currentLine,linenum] = GetNextToken2(textfile,tokenlist,currentLine,linenum);
    %[token eof] = GetNextToken();
    if eof==1
        break;
    end
    
    switch token
        case 'Channel'
            waveChannelNum = waveChannelNum + 1;
            waveformCompressionParamsRegex = '\<Channel Num=\"([\d]*)\" Scale=\"([-\w\.]*)\" Offset=\"([-\w\.]*)\"';
            waveformCompressionParamAttributes = GetAttributes(linenum, currentLine, 'spike waveform channel params', waveformCompressionParamsRegex, 3);
            
            waveforms.Channels.Scales(waveChannelNum) = sscanf(waveformCompressionParamAttributes{2},'%f'); %Scale
            waveforms.Channels.Offsets(waveChannelNum) = sscanf(waveformCompressionParamAttributes{3},'%f'); %Offset
            
        case 'WaveformRecord'
            waveformnum = waveformnum +1;
            %waveformAttributes = GetAttributes(linenum, currentLine, 'waveform', waveformRegex, 2);
            waveformAttributes = GetAttributesPreAlloc(linenum, 'Waveform', 2, waveformlist);
            waveforms.Times(waveformnum) = sscanf(waveformAttributes{1},'%f'); %Time
            waveforms.Data{waveformnum} = base64decode(waveformAttributes{2}); %Waveform data
            
            % show progress
            if verbose
                if (mod(waveformnum,1000) == 0) || (waveformnum == totalwaveforms)
                    fprintf('%6.0f waveform records processed [%5.1f%%]\n', waveformnum, double(waveformnum)*100/totalwaveforms);
                end
            end
            
        case '/SpikeWaveforms'
            break
    end
    
    
end
return


function [token, eof, textfile, tokenlist, currentLine, linenum] = GetNextToken2(textfile,tokenlist,currentLine,linenum)

%use regex to extract token ELEMENTNAME from tag like <ELEMENTNAME BLAH="123" />
% or <ELEMENTNAME BLAH="123"> or \ELEMENTNAME from </ELEMENTNAME>

currenttoken = [];
while isempty(currenttoken)
    eof = 0;
    if linenum >= size(tokenlist,1)
        eof = 1;
        token = '';
        return;
    end
    
    linenum      = linenum + 1;
    currentLine  = textfile{linenum,1};
    currenttoken = tokenlist{linenum,1};
end
token = currenttoken{1,1}{1,1};


function CountItems(textfile)
global linenum blocknum slotnum passnum analognum spikenum waveChannelNum waveformnum ticknum verbose totalpasses

% cell to string
temp = [textfile{:}];

linenum = size(textfile,1);
blocknum = size(strfind(temp,'<Block '),2);
slotnum = size(strfind(temp,'<Slot '),2);
passnum = size(strfind(temp,'<Pass '),2);
analognum = size(strfind(temp,'<AnalogSegment '),2);
spikenum = size(strfind(temp,'<Spike '),2);
waveChannelNum = size(strfind(temp,'<Channel '),2);
waveformnum = size(strfind(temp,'<WaveformRecord '),2);
ticknum     = size(strfind(temp,'<tick '),2);

if verbose
    fprintf([...
        'Number of blocks:                 %d\n', ...
        'Number of slots:                  %d\n', ...
        'Number of passes:                 %d\n', ...
        'Number of analogs segments:       %d\n', ...
        'Number of spike templates:        %d\n', ...
        'Number of waveform channels:      %d\n', ...
        'Number of spike waveform records: %d\n',...
        'Number of ticks:                  %d\n'],...
        blocknum, slotnum, passnum, analognum, spikenum, waveChannelNum, waveformnum, ticknum);
end

totalpasses = passnum;
return


function InitializeArrays()
global linenum blocknum slotnum passnum analognum spikenum waveChannelNum waveformnum doWaveforms
global routineEntryNum routineMapNum blocks slots passes analog spiketimes waveforms routinesHash
global frames ticknum

blocks.IDs      = zeros(1, blocknum, 'int16');
blocks.Names    = cell(1, blocknum);
blocks.routines = cell(1, blocknum);

slots.IDs       = zeros(1, slotnum, 'int16');
slots.Labels    = cell(1, slotnum);
slots.BlockIDs  = zeros(1, slotnum, 'int16');

passes.IDs        =  zeros(1, passnum, 'int32');
passes.SlotIDs    =  zeros(1, passnum, 'int16');
passes.BlockIDs   =  zeros(1, passnum, 'int16');
passes.StartTimes =  zeros(1, passnum, 'int32');
passes.EndTimes   =  zeros(1, passnum, 'int32');
passes.events     =  cell(1, passnum);
passes.nTBOs      =  nan(1, passnum);

analog.Segments.SampleCounts = zeros(1, analognum, 'int32');
analog.Segments.StartTimes   = zeros(1, analognum, 'int32');
analog.Segments.Data         = cell(1, analognum);

spiketimes.IDs      = zeros(1, spikenum, 'int16');
spiketimes.Channels = zeros(1, spikenum, 'int16');
spiketimes.Times    = cell(1, spikenum);

frames.nticks       = ticknum;
frames.Times        = zeros(ticknum,1);
frames.StartTimes   = zeros(ticknum,1);
frames.FlushTimes   = zeros(ticknum,1);
frames.DisplayTimes = zeros(ticknum,1);
frames.TBOs         = zeros(ticknum,1);

doWaveforms = doWaveforms && (waveformnum>0);

if doWaveforms
    waveforms.Channels.Scales = zeros(waveChannelNum, 1, 'double');
    waveforms.Channels.Offsets = zeros(waveChannelNum, 1, 'double');
    waveforms.Times = zeros(waveformnum, 1, 'double');
    waveforms.Data = cell(waveformnum, 2); % why?!?
end

routinesHash = java.util.HashMap();

linenum = 0;
blocknum = 0;
slotnum = 0;
passnum = 0;
analognum = 0;
spikenum = 0;
waveChannelNum = 0;
waveformnum = 0;
routineEntryNum = 0;
routineMapNum = 0;
return


function attributes = GetAttributes(linenum, currentLine, elementName, regex, numOfTokens)
[tok] = regexp(currentLine, regex, 'tokens');
numOfItems = int32(size(tok{1,1},2));
if (numOfItems~=numOfTokens)
    error('ExpoMatlab:ReadExpoXML','Incorrect number of attributes found for %s at line %d', elementName, linenum);
end

attributes = tok{1,1};
return


function attributes = GetAttributesPreAlloc(linenum, elementName, numOfTokens, prealloctokenlist)

[tok] = prealloctokenlist{linenum,1};
numOfItems = size(tok{1,1},2);
if (numOfItems~=numOfTokens)
    error('ExpoMatlab:ReadExpoXML','Incorrect number of attributes found for %s at line %d', elementName, linenum);
end

attributes = tok{1,1};
return


function ParseXML(doWaveforms)
global textfile tokenlist currentLine linenum;

while 1
    [token,eof,textfile,tokenlist,currentLine,linenum] = GetNextToken2(textfile,tokenlist,currentLine,linenum);
    
    if eof==1
        break;
    end
    %fprintf('%d: %s\n',linenum,token);
    switch token
        case 'Matrix'
            ProcessMatrix();
        case 'Blocks'
            ProcessBlocksAttributes();
        case 'Block'
            ProcessBlock();
        case 'Slot'
            ProcessSlotRecord();
        case 'Pass'
            ProcessPassRecord();
        case 'Comment'
            ProcessCommentOrNote('Comment')
        case 'Note'
            ProcessCommentOrNote('Note')
        case 'Environment'
            ProcessEnvironmentRecord();
        case 'timeline'
            ProcessTimelineRecord();
        case 'Spike'
            ProcessSpikeTimes();
        case 'SpikeWaveforms'
            if doWaveforms
                ProcessSpikeWaveforms()
            else
                linenum = linenum + str2double(regexprep(currentLine,'.+NumBuffers="(\d+)".+','$1'))+5; % Plus 4 for Compression Paramaters & CompressedData
            end
        case 'AnalogData'
            ProcessAnalogData();
        case 'ExpoXData'
            ProcessExpoXData();
    end
end
return


function DisplaySampleData()
global blocks slots passes routinesMap
global blocknum slotnum analognum analog spikenum passnum spiketimes
global waveforms waveformnum waveChannelNum doWaveforms

disp(' ')

%display sample of block data
if blocknum >0
    for i=1:min(2,blocknum)
        fprintf('Block ID=%d\tName=%s\n',blocks.IDs(i), blocks.Names{i});
        disp(blocks.routines{i})
    end
end


%display slot data
if slotnum>0
    for i=1:min(3,slotnum)
        fprintf('Slot ID=%d\t Label=%s \tBlockID=%d\n',slots.IDs(i), slots.Labels{i}, slots.BlockIDs(i));
    end
    
    disp(' ')
end

disp('Routine Map')
disp(routinesMap);

disp(' ')

%display sample of pass data
if passnum > 1
    for i=1:2
        fprintf('Pass ID=%d\t SlotID=%d\t BlockID=%d\t StartTime=%d\t EndTime=%d\n',passes.IDs(i), passes.SlotIDs(i), passes.BlockIDs(i), passes.StartTimes(i), passes.EndTimes(i));
        
        %display the event data for this pass
        for j=1:length(passes.events{i}.RoutineIDs)
            fprintf('Event %2.0f\t RoutineID=%2.0f\t Time=%5.0f\t Data=%s\n',j, passes.events{i}.RoutineIDs(j), passes.events{i}.Times(j), mat2str(passes.events{i}.Data{j}'));
        end
        disp(' ')
    end
end

%display a sample of the analog data
if analognum > 0
    fprintf('Analog NumOfChannels=%d\t SampleInterval=%d\n',analog.NumOfChannels, analog.SampleInterval);
    
    %for i=1:1
    fprintf('Segment 1 NumOfSamples=%d\t StartTime=%d\n',analog.Segments.SampleCounts(1), analog.Segments.StartTimes(1));
    disp(int2str(analog.Segments.Data{1}(1:16)))
    %end
    
    disp(' ')
end

%display a sample of spike times data
if spikenum > 0
    j = 1; %pick first template
    fprintf('Spike\t TemplateID=%d\t ChannelID=%d\n', spiketimes.IDs(j), spiketimes.Channels(j));
    if length(spiketimes.Times{j, 1}) >= 5
        for i=1:5
            fprintf('Time=%5.0f\n', spiketimes.Times{j, 1}(i));
        end
    end
end

if ~doWaveforms, return, end;
% display a spike waveform record
if waveformnum>0
    if isfield(waveforms,'DataSize')
        dataSize = waveforms.DataSize;
    else
        dataSize = 1;
    end
    
    fprintf('Waveforms NumBuffers=%d\tFramesPerBuf=%d NumChannels=%d SampleRate=%d DataSize=%d\n',waveforms.NumOfBuffers, waveforms.FramesPerBuf, waveforms.NumOfChannels, waveforms.SampleRate, dataSize);
    
    for i=1:waveChannelNum
        fprintf('Channel Num=%d Scale=%d Offset=%d\n', i, waveforms.Channels.Scales(i), waveforms.Channels.Offsets(i));
    end
    
    if (size(waveforms.Data,1) >= 500)
        raw_y = [waveforms.Data{1:500}];
    else
        raw_y = [waveforms.Data{1}];
    end
    y = reshape(raw_y,dataSize,[]);
    if (dataSize == 2)% 16 bit, little endian
        y = y(1,:) + (256.* y(2,:));
    end
    y = double(reshape(y,waveforms.NumOfChannels,[]));
    
    for i=1:waveforms.NumOfChannels
        y(i,:) = waveforms.Channels.Offsets(i) + y(i,:)./waveforms.Channels.Scales(i);
    end
    x = 1:size(y,2);
    time = (0:length(x)-1).*1000/waveforms.SampleRate;
    figure(1);
    stairs(time,y');
    xlabel('Time [ms]');
    ylabel('Normalized Volts');
    title('Spike waveform record 1')
end
return
