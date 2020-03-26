function [data captureUnit blockIDs blockNames] = GetEvents(expoDataSet, passIDs, routineName, routineLabel, routineInstance, parameterName, unit)
% function [data captureUnit blockIDs blockNames] = GetEvents(expoDataSet, passIDs, routineName, routineLabel, routineInstance, parameterName, unit)
%
% This Expo utilty extracts data from Expo events specified by parameterName,
% routine name and/or label and passIDs.  The data are returned as a vector of values one for each passID.  
% Also returned are the capture unit (the unit in which the data was stored)
% and shortlists of blockIDs and blockNames associated with the passes.  
% The lists typically contain just one or two blocks and are provided for
% debugging purposes.
%
% Set routineName='' or routineLabel='' to ignore either parameter.
%
% The passIDs typically reference one or two slots that contain the
% routine specified by name and/or label.  The routine in turn should include the specified parameter name.
% routineInstance resolves any ambiguity over which instance of the routine in a slot should be used.
% Like all of Expo's ID arrays routineInstance is 0 based so use 0 to choose the first routine match.
%
% The optional unit parameter defines what units you would like to have the
% event data returned in. The unit should be a name such as degrees,
% seconds, milliseconds, pixels etc.  If no unit is specified values are
% returned in the capture unit as stored by Expo.
%
% Available unit types and groups are:
%               ticks                 sec            1/10msec                msec
%                 pix                  cm                 deg               volts          norm volts
%                 deg                 rad
%        period ticks          period sec             cyc/sec
%          period pix           period cm          period deg             cyc/deg              cyc/cm
%          period deg             cyc/deg
%             deg/sec            deg/tick             pix/sec            pix/tick
%
%
% See also ReadExpoXML, GetSlots, GetPasses, GetSpikeTimes, GetAnalog, 
% GetPSTH, PlotPSTH, GetWaveforms, GetStartTimes, GetEndTimes, GetDuration,
% GetConversionFactor.
%
%   Author:      Julian Brown
%	Version:     1.1
%   Last updated:  2005-03-28
%   E-mail:      julianb@stanford.edu
%
%   Author:      Romesh Kumbhani
%	Version:     1.2
%   Last updated:  2008-10-21
%   E-mail:      romesh.kumbhani@nyu.edu

captureUnit = '';

matlabImportVersion = '1.1';
CheckExpoVersion(expoDataSet, matlabImportVersion);

if ~isnumeric(routineInstance)
    error('The routineInstance parameter must be numeric and set to 0 or more');
elseif routineInstance < 0
    error('The routineInstance parameter must be set to 0 or more');
end

[numOfPasses passIDs] = TransformToColumnVector(passIDs);

if ~isnumeric(passIDs)
    error('passIDs should be a vector of numbers.  It appears to be non numeric.');
end

% get unique set of block IDs and Names corresponding to the slots
blockIDs = unique(expoDataSet.passes.BlockIDs(passIDs + 1));
blockNames = expoDataSet.blocks.Names(blockIDs + 1);

numOfBlocks = size(blockIDs,2);

if numOfBlocks < 1
    error('No matching blocks found.  Aborting');
end

% get the routines for the blocks
blockRoutines = expoDataSet.blocks.routines(blockIDs + 1);

% preallocate type for routineNums
routineNums  = cell(numOfBlocks,1);
routineNums2 = cell(numOfBlocks,1);
routineNums3 = cell(numOfBlocks,1);

if ~isempty(routineName)
    foundName = 0;
    for i=1:numOfBlocks
        % routineNums refers to position of routine in the block
        routineNums{i} = strmatch(routineName, blockRoutines{i}.Names, 'exact');
        if ~isempty(routineNums{i}) 
            foundName = 1;
        end
    end
    
    if foundName == 0
        disp(sprintf('Unable to find the routine name "%s"', routineName));
        for i=1:numOfBlocks
            disp(sprintf('Available routine names for block "%s" are:', blockNames{i}));
            for j=1:length(blockRoutines{i}.Names)
                disp(blockRoutines{i}.Names{j});
            end
            disp('');
        end
        error('Aborting');
    end
    
else
    % no routine Name was provided so just get all of the Routine indices
    routineNums = cell(numOfBlocks,1);
    for i=1:numOfBlocks
        routineNums{i} = strmatch('', blockRoutines{i}.Names);
    end
end
        
if ~isempty(routineLabel)
    % routineNums refers to position of routine in the block
    foundLabel = 0;
    for i=1:numOfBlocks
        routineNums2{i} = strmatch(routineLabel, blockRoutines{i}.Labels, 'exact');
        if ~isempty(routineNums2{i}) 
            foundLabel = 1;
        end
    end
    
    if foundLabel == 0
        disp(sprintf('Unable to find the routine label "%s"', routineLabel));
        for i=1:numOfBlocks
            disp(sprintf('Available labels for block "%s" are:', blockNames{i}));
            for j=1:length(blockRoutines{i}.Labels)
                disp(blockRoutines{i}.Labels{j});
            end
            disp('')
        end
        error('Aborting')
    end
    
else
    % no routine Name was provided so just get all of the Routine indices
    for i=1:numOfBlocks
        routineNums2{i} = strmatch('', blockRoutines{i}.Labels);
    end
end

% get intersection of the two vectors
for i=1:numOfBlocks
    % each i'th entry of blockRoutines is a set of routines belonging to the
    % i'th block that matched our criterior for passIDs
    % so routineNums3{i} is an array of positions within the i'th block for the routines that
    % match routineName and Label
    routineNums3{i} = intersect(routineNums{i},routineNums2{i});
end

units = expoDataSet.environment.Conversion.units;

if exist('unit','var')
    unitNum = GetUnitNumFromName(units, unit);
else
    unitNum = -1;
end

% preallocate type for paramNums
paramNums  = cell(numOfBlocks,1);
data = zeros(numOfPasses,1);

for i=1:numOfBlocks
    if isempty(routineNums3{i}) % size(routineNums3{i}, 1) < 1
        disp(['Warning: no instance of "', routineName, '" routine with label "', routineLabel, '" found in "', blockNames{i}, '" block']);
        disp(sprintf('Valid routine labels for routines with name "%s" in block "%s" are:', routineName, blockNames{i}));
        disp(blockRoutines{i}.Labels{routineNums{i}});
    elseif size(routineNums3{i}, 1) < routineInstance + 1
        disp(['Warning: instance #', num2str(routineInstance), ' of "', routineName, '" routine out of range.']);
        disp(['There are ', num2str(size(routineNums3{i}, 1)), ' instances in "', blockNames{i}, '" block.']);
        disp('Remember routine instances are 0 based so choose 0 for first instance, 1 for second and so on.');
    else
        routineNum = routineNums3{i}(routineInstance + 1);
        routineID = blockRoutines{i}.IDs(routineNum);
        paramNums{i} = strmatch(parameterName, blockRoutines{i}.Params{routineNum}.Names, 'exact');

        % should only be one paramNum per block but check anyway
        if size(paramNums{i}, 1) > 1
            disp(['Error: hmmmm ... multiple matches found for "', parameterName, '" parameter in "', routineName, '" routine in "', blockNames{i}, '" block. Sorry unable to evaluate this block.']);
            data = [];
        elseif isempty(paramNums{i}) %size(paramNums{i}, 1) < 1
            warning('EXPO:GetEvents','Warning: could not find "%s" parameter in "%s" routine in "%s" block',parameterName,routineName,blockNames{i});
            disp('Valid parameter names for this routine are:');
            disp(blockRoutines{i}.Params{routineNum}.Names);
            data = [];
        else
            paramNum = paramNums{i};
            
            % loop thru the passes in which the current block was run
            for j=find(expoDataSet.passes.BlockIDs(passIDs+1) == blockIDs(i))
               
                event = expoDataSet.passes.events{passIDs(j)+1};
                
                %sanity test - check we still have right routineID
                if routineID ~= event.RoutineIDs(routineNum)
                    error('Failed assertion!  Something is screwy with the routineIDs.');
                end
                
                % determine the capture unit of the parameter
                captureUnitNum = expoDataSet.blocks.routines{1, blockIDs(i)+1}.Params{1,routineNum}.CUnits(paramNum);
                
                % get the event data for the requested routine and parameter
                data(j) = ConvertNum(units, event.Data{1,routineNum}(paramNum), captureUnitNum, unitNum);
                if j == 1
                    captureUnit = GetUnitNameFromNum(units, captureUnitNum);
                end
            end
        end                
    end
end

return