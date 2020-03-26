function expoData = MergeExpoData(expoData,varargin)
% function expoDataSet = MergeExpoData(expoData, ...)
%
% Expo utility to combine the data sets in the cell array expoData and
% return the combined expoData structure.
%
% The input expoData must come from the same Expo program, using the same
% Environment settings. Each of the expoData can be specified as an
% expoDataSet structure or as the name of a file containing an expoData
% set.
%
% The Comment and Notes fields of the combined structure are not merged --
% rather, they contain the Comment and Notes from the first of the expoData
% sets.
%
% See also ReadExpoXML, GetSlots, GetPasses, GetEvents, GetSpikeTimes, GetAnalog,
% GetPSTH, PlotPSTH, GetStartTimes, GetEndTimes, GetDuration,
% GetConversionFactor.
%
%   Author:      Romesh Kumbhani
%	Version:     2.0
%   Last updated:  2011-10-04
%   E-mail:      romesh.kumbhani@nyu.edu
%
%   Based on MergeExpoDataSets 1.1 by Julian Brown
%   (julian@monkeybiz.stanford.edu)
%

% inline functions
iseven = inline('logical(mod(x+1,2))');

% Default values
doSpikeWaveforms = 0;
beVerbose        = 0;

% Parse Input variables
if ~exist('expoData','var') || isempty(expoData)
    error('ExpoMatlab:MergeExpoData','No data sets provided. See "help MergeExpoData" for syntax.');
else % expoData exists!
    if ~iscell(expoData) % if not a cell array
        expoData = {expoData}; % make it one!
    end
end

nvarargin = nargin-1;
if ~iseven(nvarargin) % if not a positive even number of variable arguments
    error('ExpoMatlab:MergeExpoData','Incorrect number of additional arguments. See "help MergeExpoData" for syntax.');
end
for ii=1:2:nvarargin
    switch lower(varargin{ii})
        case 'spikewaveforms'
            doSpikeWaveforms = logical(varargin{ii+1});
        case 'verbose'
            beVerbose        = logical(varargin{ii+1});
        case 'filename'
            savefilename     = varargin{ii+1};
    end
end


% Count & validate data sets
expoDataTemp = expoData;
validData = 0;
for ii=1:length(expoData)
    if isempty(expoData{ii})
        fprintf('Found an empty data set at index %d. Removing it from the list.\n',ii);
    else
        validData = validData + 1;
        expoDataTemp{validData} = expoData{ii};
    end
end
expoData = expoDataTemp(1:validData);
nDatasets = validData;

if (nDatasets < 2)
    error('ExpoMatlab:MergeExpoData','You need to specify two or more valid data sets to merge. See "help MergeExpoData" for syntax.');
end

% see if data sets is a filename, make it into a data structure
for ii = 1:nDatasets
    if ~isstruct(expoData{ii}) % if not a structure
        if ~ischar(expoData{ii}) % if not a string
            error('ExpoMatlab:MergeExpoData','One of the data sets is neither a valid filename nor data structure. See "help MergeExpoData" for syntax.');
        end
        % expoData{ii} is a string
        if ~exist(expoData{ii},'file') % if the string doesn't point to a valid file
            error('ExpoMatlab:MergeExpoData','Filename "%s" was not found.',expoData{ii});
        end
        % expoData{ii} points to a valid file!
        expoData{ii} = ReadExpoXML(expoData{ii},doSpikeWaveforms,beVerbose);
    end
end

if exist('savefilename','var')
    if isempty(savefilename)
        savefilename = expoData{1}.FileName;
    end
end

expoDataTemp = expoData{1};
for ii=2:nDatasets
    expoDataTemp = Merge2ExpoDataSets(expoDataTemp, expoData{ii}, beVerbose);
end
expoData = expoDataTemp;

if exist('savefilename','var')
    save(savefilename,'-struct','expoData');
end

end


function ds = Merge2ExpoDataSets(ds1, ds2, beVerbose)

%MatlabImportVersion
if beVerbose
    fprintf('Processing MatlabImportVersion.\n');
end
if ~strcmp(ds1.MatlabImportVersion,ds2.MatlabImportVersion)
    error('ExpoMatlab:MergeExpoData','The two datasets have different MatlabImportVersion numbers. Cannot merge.');
end
ds.MatlabImportVersion = ds1.MatlabImportVersion;

%ExpoVersion
if beVerbose
    fprintf('Processing ExpoVersion.\n');
end
if ~strcmp(ds1.ExpoVersion,ds2.ExpoVersion)
    error('ExpoMatlab:MergeExpoData','The two datasets have different ExpoVersion numbers. Cannot merge.');
end
ds.ExpoVersion = ds1.ExpoVersion;

matlabImportVersion = '1.1';
CheckExpoVersion(ds1, matlabImportVersion);

%FileName
if beVerbose
    fprintf('Processing filename.\n');
end
if ~strcmp(ds1.FileName,ds2.FileName)
    error('ExpoMatlab:MergeExpoData','The two datasets have different FileNames. Cannot merge.');
end
ds.FileName = ds1.FileName;

%Comment
if beVerbose
    fprintf('Processing comments.\n');
end
if ~strcmp(ds1.Comment,ds2.Comment)
    warning('ExpoMatlab:MergeExpoData','The two datasets have different Comment fields. The new dataset will have the Comment of the first dataset.');
end
ds.Comment = ds1.Comment;

%Notes
if beVerbose
    fprintf('Processing notes.\n');
end
if ~strcmp(ds1.Notes,ds2.Notes)
    warning('ExpoMatlab:MergeExpoData','The two datasets have different Notes fields. The new dataset will have the Notes of the first dataset.');
end
ds.Notes = ds1.Notes;

% Matrix
if beVerbose
    fprintf('Processing matrix.\n');
end
ds.matrix = ds1.matrix;

% Check the datasets have similar block structures
if beVerbose
    fprintf('Processing blocks.\n');
end
if length(ds1.blocks.IDs) ~= length(ds2.blocks.IDs)
    error('ExpoMatlab:MergeExpoData','The two datasets have different numbers of blocks. Cannot merge.');
end
ds.blocks = ds1.blocks;

%slots
if beVerbose
    fprintf('Processing slots.\n');
end
if length(ds1.slots.IDs) ~= length(ds2.slots.IDs)
    error('ExpoMatlab:MergeExpoData','The two datasets have different numbers of slots. Cannot merge');
end
ds.slots = ds1.slots;

% passes
if beVerbose
    fprintf('Processing passes.\n');
end

numOfPassesInds1          = length(ds1.passes.IDs);
startTimeForSecondDataSet = ds1.passes.EndTimes(numOfPassesInds1) + 1;

passFieldNames            = fieldnames(ds1.passes);

for ii=1:length(passFieldNames)
    field = passFieldNames{ii};
    switch field
        case 'IDs'
            ds.passes.IDs = [ds1.passes.IDs (ds2.passes.IDs + numOfPassesInds1)];
        case 'StartTimes'
            ds.passes.StartTimes = [ds1.passes.StartTimes (ds2.passes.StartTimes + startTimeForSecondDataSet)];
        case 'EndTimes'
            ds.passes.EndTimes = [ds1.passes.EndTimes (ds2.passes.EndTimes + startTimeForSecondDataSet)];
        otherwise
            ds.passes.(field) = [ds1.passes.(field) ds2.passes.(field)];
    end
end

%spiketimes
if beVerbose
    fprintf('Processing spiketimes.\n');
end
numOfSpikeIDs = length(ds1.spiketimes.IDs);

if numOfSpikeIDs ~= length(ds1.spiketimes.IDs)
    error('ExpoMatlab:MergeExpoData','The two datasets have different numbers of spike IDs. Cannot merge.');
end

ds.spiketimes.IDs      = ds1.spiketimes.IDs;
ds.spiketimes.Channels = ds1.spiketimes.Channels;

for i=1:numOfSpikeIDs
    ds.spiketimes.Times{i} = [ds1.spiketimes.Times{i} (ds2.spiketimes.Times{i} + double(startTimeForSecondDataSet))];
end

%waveforms
if beVerbose
    fprintf('Processing waveforms.\n');
end
if isfield(ds1.waveforms, 'NumOfChannels') && isfield(ds2.waveforms, 'NumOfChannels')
    waveformFieldNames = fieldnames(ds1.waveforms);
    
    for i=1:length(waveformFieldNames)
        field = waveformFieldNames{i};
        
        switch field
            case 'NumOfChannels'
                if length(ds1.waveforms.NumOfChannels) ~= length(ds2.waveforms.NumOfChannels)
                    error('ExpoMatlab:MergeExpoData','The two datasets have different numbers of waveform channels. Cannot merge.');
                end
                ds.waveforms.NumOfChannels = ds1.waveforms.NumOfChannels;
            case 'FramesPerBuf'
                if length(ds1.waveforms.FramesPerBuf) ~= length(ds2.waveforms.FramesPerBuf)
                    error('ExpoMatlab:MergeExpoData','The two datasets differ in the FramesPerBuf for the waveforms. Cannot merge.');
                end
                ds.waveforms.FramesPerBuf = ds1.waveforms.FramesPerBuf;
            case 'SampleRate'
                if length(ds1.waveforms.SampleRate) ~= length(ds2.waveforms.SampleRate)
                    error('ExpoMatlab:MergeExpoData','The two datasets differ in the SampleRate for the waveforms. Cannot merge.');
                end
                ds.waveforms.SampleRate = ds1.waveforms.SampleRate;
            case 'NumOfBuffers'
                ds.waveforms.NumOfBuffers = ds1.waveforms.NumOfBuffers + ds2.waveforms.NumOfBuffers;
            case 'Times'
                %ds.waveforms.Times = ds1.waveforms.Times + ds2.waveforms.Times;
                ds.waveforms.Times = [ds1.waveforms.Times;ds1.waveforms.Times(end)+ds2.waveforms.Times];
            case 'Data'
                for j=1:ds1.waveforms.NumOfChannels
                    o1 = ds1.waveforms.Channels.Offsets(j);
                    o2 = ds2.waveforms.Channels.Offsets(j);
                    s1 = ds1.waveforms.Channels.Scales(j);
                    s2 = ds2.waveforms.Channels.Scales(j);
                    boundaries = [o1 o1 + 255/s1 o2 o2 + 255/s2];
                    
                    o3 = min(boundaries);
                    s3 = 255/(max(boundaries) - o3);
                    
                    ds.waveforms.Channels.Offsets(j) = o3;
                    ds.waveforms.Channels.Scales(j)  = s3;
                    
                    arrayEndPoint = size(ds1.waveforms.Data,1);
                    for k = 1:arrayEndPoint
                        bytes = floor(s3 * (o1 - o3 + double(ds1.waveforms.Data{k,j}/s1)));
                        if isempty(bytes)
                            ds.waveforms.Data{k,j} = [];
                        else
                            if min(bytes)<0 || max(bytes)>255
                                error('ExpoMatlab:MergeExpoData','An unexpected error occurred in combining waveform data. Byte data went out of range');
                            end
                            ds.waveforms.Data{k,j} = char(bytes);
                        end
                    end
                    
                    for k = 1:size(ds2.waveforms.Data,1)
                        bytes = floor(s3 * (o2 - o3 + double(ds2.waveforms.Data{k,j}/s2)));
                        if isempty(bytes)
                            ds.waveforms.Data{arrayEndPoint + k,j} = [];
                        else
                            if min(bytes)<0 || max(bytes)>255
                                error('ExpoMatlab:MergeExpoData','An unexpected error occurred in combining waveform data. Byte data went out of range');
                            end
                            ds.waveforms.Data{arrayEndPoint + k,j} = char(bytes);
                        end
                    end
                end
            case 'DataSize'
                if ds1.waveforms.DataSize ~= ds2.waveforms.DataSize
                    error('ExpoMatlab:MergeExpoData','The two datasets differ in the DataSize for the waveforms. Cannot merge.');
                end
                ds.waveforms.DataSize = ds1.waveforms.DataSize;
        end
    end
    ds.waveforms.Data{end,2} = [];
elseif isfield(ds1.waveforms, 'NumOfChannels') || isfield(ds2.waveforms, 'NumOfChannels')
    error('ExpoMatlab:MergeExpoData','One of the datasets has waveform data while the other does not. Cannot merge');
else
    ds.waveforms = [];
end

%analog data
if beVerbose
    fprintf('Processing analog.\n');
end
if ds1.analog.NumOfChannels ~= ds2.analog.NumOfChannels
    error('ExpoMatlab:MergeExpoData','The two datasets have different numbers of analog channels. Cannot merge');
end
ds.analog.NumOfChannels  = ds1.analog.NumOfChannels;

if ds1.analog.SampleInterval ~= ds2.analog.SampleInterval
    error('ExpoMatlab:MergeExpoData','The two datasets have different analog sample intervals. Cannot merge');
end
ds.analog.SampleInterval = ds1.analog.SampleInterval;

ds.analog.Segments.SampleCounts = [ds1.analog.Segments.SampleCounts ds2.analog.Segments.SampleCounts];
ds.analog.Segments.StartTimes   = [ds1.analog.Segments.StartTimes (ds2.analog.Segments.StartTimes + startTimeForSecondDataSet)];
ds.analog.Segments.Data         = [ds1.analog.Segments.Data ds2.analog.Segments.Data];

%environment
if beVerbose
    fprintf('Processing environment.\n');
end
envFieldNames = fieldnames(ds1.environment.Conversion);

for i=1:length(envFieldNames)
    field = envFieldNames{i};
    switch field
        case 'units'
            ds.environment.Conversion.units = ds1.environment.Conversion.units;
        otherwise
            if ds1.environment.Conversion.(field) ~= ds2.environment.Conversion.(field)
                error('ExpoMatlab:MergeExpoData','The two datasets have different values for the conversion property %s. Cannot merge.', field);
            end
            ds.environment.Conversion.(field) = ds1.environment.Conversion.(field);
    end
end

%sort field names
if beVerbose
    fprintf('Sorting fields.\n');
end
ds = recursivesortfieldnames(ds,ds1);
end


function S1 = recursivesortfieldnames(S1,S2)
S1 = orderfields(S1,S2);
curfieldnames = fieldnames(S1);
for ii = 1:size(curfieldnames,1)
    cur = curfieldnames{ii};
    T1  = S1.(cur);
    if isstruct(T1)
        T2  = S2.(cur);
        if numel(T1) == 1
            T1 = recursivesortfieldnames(T1,T2);
        else
            for jj = 1:size(T1,1)
                for kk = 1:size(T1,2)
                    T1(jj,kk) = recursivesortfieldnames(T1(jj,kk),T2(jj,kk));
                end
            end
        end
        S1.(cur) = T1;
    end
end
end


