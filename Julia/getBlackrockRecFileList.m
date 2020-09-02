function fileList = getBlackrockRecFileList(dataDir, arrayID, eye, experiment, animal)
% Returns list of files for which there are .nev recordings (minus the .nev
% file extension.
% Input:
%           - dataDir = parent directory where blackrock data is stored.
%           - arrayID = ie, 'nsp1'
%           - eye = 'LE' or 'RE'
%           - experiment name = case sensitive, ie, 'Gratings', or
%           'ContourIntegration'
%
% Edited 10/12/18 to add animal name, and remove all files that are not
% .nev

%fileList    = dir([dataDir arrayID '/' arrayID '_blackrock' '/' animal  '/']);
fileList     = dir(dataDir); 
fileList    = extractfield(fileList, 'name');
strToFind   = {arrayID ; eye; experiment; 'nev'};
fun         = @(s)~cellfun('isempty',strfind(fileList, s));
temp        = cellfun(fun, strToFind, 'UniformOutput', 0);
temp        = [temp{1}; temp{2}; temp{3}];
temp        = sum(temp,1);
idx         = find(temp == max(temp));
fileList    = fileList(idx);
fileList(contains(fileList, '._')) = [];  % Remove spurious file names resulting from copying over files 
fileList(contains(fileList, ' ')) = [];   % Remove files that have extra copies (unclear what for/from)
fileList(contains(fileList, 'BE')) = [];  % For now, ignore sessions that were run binocularly.
%fileList(~contains(fileList, 'nev')) = []; % Remove anything that is not a .nev file (ex: .ns2)
fileList(~contains(fileList,'gratings_')) = []; % Ignore other stimulus files
fileList(~contains(fileList,animal)) = []; % ignore data from other animals

fileList    = cellfun(@(x) x(1:end-4), fileList, 'UniformOutput', 0); % Remove .nev extension