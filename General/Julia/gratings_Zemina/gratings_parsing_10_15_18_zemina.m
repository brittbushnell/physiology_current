%% Preprocess blackrock array data (gratings program run at beginning of each day) for each recording session.
%  PATHS SET UP TO RUN OFF ZEMINA.
%  (AKA, for each file -- there may be multiple sessions for one day). 
%  Marry blackrock/mworks data, and parse responses according to stimulus. 

%% Set up directories and lists of files to analyze.
clearvars 

addpath(genpath('/Volumes/BIGZINGY/BlackrockData'))
addpath(genpath('/u/vnl/users/julia'))
addpath(genpath('/Library/Application Support/MWorks/Scripting/Matlab'))   % necessary to run parser. 

dataDir     = '/Volumes/BIGZINGY/BlackRockData/';

% WU specs:
%   - nsp1  = V1/V2
%   - nsp2  = V4
%   - LE    = fellow eye
%   - RE    = amblyopic eye
arrayID     = 'nsp2';       
eye         = 'LE';
experiment  = 'Gratings';

nChan       = 96;
binStart    = 5;            
binEnd      = 15;

% List of blackrock/recording files
fileList    = getBlackrockRecFileList(dataDir,arrayID,eye,experiment);