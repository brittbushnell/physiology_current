% This function merges and synchronizes Blackrock .NEV and MWorks .MWK files
% based on the EXPO version of a similar program.
clear all
close all
clc
tic
%%
% MWKfile = '/volumes/BBArrayData/TestData/WU_gratmap_test_20170110_003.mwk';
cd /mnt/vnlstorage/bushnell_arrays/nsp1/mworks/
MWKfile = 'test_Gratmap_20170220_001.mwk';

%% Verify inputs


if ~exist(MWKfile, 'file')
    error ('MwksMergeMWKandNEV:MWKfile', 'File: %s was not found.\n', MWKfile)
else
    
    [pm,nm,em] = fileparts(MWKfile);
    if ~strcmpi(em, '.mwk')
        error ('MwksMergeMWKandNEV:MWKfile', 'File: %s is not an MWK file.\n', MWKfile)
    end
    
    if isempty(pm)
        pm = pwd;
    end
    MWKfile = cat(2,pm,filesep,nm,em);
end

%% Get info from .mwks file

disp ('Getting information from MWorks file')

timeCodecs = getCodecs(MWKfile);
codecs     = struct2cell(timeCodecs.codec);

% pull out the codes that correspond to the desired tag
windx   = 1;
dispndx = 1;
for i = 1:length(codecs)
    if strcmp('wordout_var',codecs(11,:,i))
        wordCode(windx,1)  = codecs(1,:,i);
        windx = windx+1;
    end
    if strcmp('#stimDisplayUpdate',codecs(11,:,i))
        dispCode(dispndx,1) = codecs(1,:,i);
        dispndx = dispndx+1;
    end
end
wordCode = cell2mat(wordCode);
dispCode = cell2mat(dispCode);

% NOTE: ALL TIMESTAMPS ARE IN MICROSECONDS (us)

% get the information on when the event occurred. Returs a structure with
% the code, time stamps, and relevent data.
wordEvents = getEvents(MWKfile,wordCode);
wordTime   = {wordEvents.time_us};
wordTime   = cell2mat(wordTime);

% get stimulus information note: for blank stimulus in RF all RF parameters
% are set to 0.
[stimInfo,fix_times] = getStimInfo(MWKfile, dispCode);

toc