function expoDataSets = BatchReadExpoXML(doSpikeWaveforms,beVerbose)
% function BatchReadExpoXML(doSpikeWaveforms)
%
% Filename: Reads data from ExpoX data xml files in directory into struct arrays and saves as mat file (by passing each file to ReadExpoXML).
% doSpikeWaveforms: 1 if you want to process waveform data for every file in directory, else 0. [default 0].
% Relies on: ReadExpoXML (matlabImportVersion 1.0)
% 
% shs 02/2005
% rdk 10/2011

%expoVersion = '1.0';
%matlabImportVersion = '1.0';

% check if user wants to process spikewave data, if not set to 0
if ~exist('doSpikeWaveforms','var')
    doSpikeWaveforms = 0;
end

% check if user wants to be verbose, if not set to 0
if ~exist('beVerbose','var')
    beVerbose = 0;
end

% find XML files to port into MatLab
[files pathname] = uigetfile('*.xml','Choose files for import','MultiSelect','on');
% wiggly fix for when there is only one entry in 'files'
if iscellstr(files) == 0
    files = {files};
end

% pass each file to ReadExpoXML to be saved and append in 'expoDataSets'
expoDataSets = cell(1,size(files,2));
disp('Batch processing files: '); 
disp(files');

for n = 1:size(files,2)
	fprintf('\n===> Processing file "%s" ... ', files{n});
	tic;
    expoDataSets{n} = ReadExpoXML(sprintf([pathname files{n}]),doSpikeWaveforms,beVerbose);
    timeElapsed = toc;
    fprintf('Done! [%.2f secs]\n',timeElapsed);
end

return

