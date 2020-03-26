function dirSetup
% Set up directories that most of Julia's data and analysis files are stored on.
% Adds path to:
% '/u/vnl/users/julia/'
% '/Volumes/BIGZINGY/JuliaDATA'
% '/e/3.3/p3/jpai/Documents/MATLAB'
% '/u/vnl/matlab/ExpoMatlab/'
% '/u/vnl/matlab/open-ephys/'

addpath(genpath('/u/vnl/users/julia/'))                         % where analysis files are stored
addpath(genpath('/Volumes/BIGZINGY/JuliaDATA'))                 % data storage
addpath(genpath('/e/3.3/p3/jpai/Documents/MATLAB'))             % local storage
addpath(genpath('/u/vnl/matlab/ExpoMatlab/'))                   % Expo functions
addpath(genpath('/u/vnl/matlab/open-ephys/'))                   % OpenEphys functions