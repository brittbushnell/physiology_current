function [structKey] = makeGratMwksStructKey()
% [structKey] = makeStructKey(program)
% 
% This program creates a structure that acts as the key for remembering
% what each row and column corresponds to in the  collosal data structures
% made during MWks analysis.
%
% INPUT
%    Program name
%
% OUTPUT
%    structKey: structure with the same pages as the data structures, but
%    populated with text descriptions of the data rather than the data.
%
% Written Nov 7, 2017 Brittany Bushnell


    %% Data structures that come from initial parsing
    structKey.bins = {'row: trial';...
                      'column: responses in 10ms bins from stim onset';...
                      'page: channel #'};
    structKey.files = 'original data file names if concatenated mat';
    structKey.rotation = 'orientation presented on each trial';
    structKey.spatial_frequency = 'sf presented on each trial';
    structKey.stimOff = 'ISI in ms';
    structKey.stimOn = 'how long the stimulus is on in ms';
    structKey.width = 'stimulus diameter in degrees';
    structKey.xoffset = 'x coordinate of stimulus location on each trial';
    structKey.yoffset = 'y coordinate of stimulus location on each trial';
    %% array information
    structKey.aMap = 'array map file name, contains channel mappings';
    structKey.stimTime = {'# bins stimulus is on for','# bins stimulus is off for'};
    
    structKey.goodChannels = 'channels that are visually responsive';
    structKey.goodBins = 'same as data.bins, but limited to the good channels';

    structKey.latency = {'Response latency of each channel using the Matt Smith method',...
       'last bin of response based on latency and amount of time stimulus is on'} ;
%% Spatial frequency information
    structKey.spatialFrequencyResp = {'spatial frequency (collapsed across all oris)';...
                                       '# time sf was presented'; ...
                                       'mean response';...
                                       'baseline subtracted mean response';...
                                       'standard error lower bound';...
                                       'standared error upper bound';...
                                       'standard error'};
                                   
     structKey.maxSF = 'sf with the highest response';
     
     structKey.sfPrefs = 'preferred spatial frequency based on difference of Gaussian fits';
     
     structKey.sfHigh = 'Maximum response: Output from Christophers DifofGausStats function';
     
     structKey.sfBandwidth = 'Bandwidth of fitted spatial frequency response';
     
     structKey.fitParams = 'fitting parameters from FitDifOfGaus';
     
     structKey.sfFitResps = 'estimated responses from FitDifOfGaus';
     %% Orientation information
    structKey.orientationResp = {'orientation (collapsed across all sfs)';...
                                 '# time sf was presented'; ...
                                 'mean response';...
                                 'baseline subtracted mean response';...
                                 'standard error lower bound';...
                                 'standared error upper bound';...
                                 'standard error'};
                             
     structKey.oriTuneResp = {'orientation (limited to SF with max resp)';...
                              '# time sf was presented'; ...
                              'mean response';...
                              'baseline subtracted mean response';...
                              'standard error lower bound';...
                              'standared error upper bound';...
                              'standard error'};   
                          
      structKey.maxOri = 'orientation with highest response when limited to best SF';
      
      structKey.vectAngle = {'orientations 0:150, 0 and 180 are averaged together';...
                             'FR * cos(ori*2)';...
                             'FR * sin(ori*2)'};
                         
      structKey.prefOri = 'preferred orientation based on arc tangent of the sum of the vector angles';
      structKey.oriNdx  = {'orientation tuning index';...
                           'max-null/max+null';...
                           'null = 90 deg away from max ori'};
                       
      structKey. vectAngleSum = {'sum(FR*cos(theta*2))'; 'sum(FR*sin(theta*2))'}; 
      
      structKey.normOri = 'orienations normalized to the preferred orienation, so when they are plotted, the preferred orienation is centered';
      
      structKey.oriResps360 = {'Orientations from 0:360 in 30 degree steps';...
                               'Firing rates';...
                               'Baseline subtracte4d firing rates';
                               'Note: 0, 180 and 360 should all be the same numbers since they are all the same grating'};
      
      structKey.oriFitsVM = {'Orientation fit parameters from Christophers VonMises code';...
                             'If title has 360 in it, then orientations go from 0:360. Otherwise from 0:180'};
                            
      structKey.oriFitRespsVM = {'Estimated firing rates for each orientation from Christophers VonMises code';...
          'If title has 360 in it, then orientations go from 0:360. Otherwise from 0:180'};
      
      structKey.oriBanVM = {'Orientation bandwidth from Christophers VonMises Code';...
          'If title has 360 in it, then orientations go from 0:360. Otherwise from 0:180'};
                               
      structKey.oriParamsTVM = {'Orientation fit parameters from Toms VonMises code';...
          'oriParamsTVM(1) = Estimated baseline firing rate';...
          'oriParamsTVM(3) = peak Orientation';...
          'If title has 360 in it, then orientations go from 0:360. Otherwise from 0:180'};
      
      structKey.oriVarTVM = {'response variance from Toms VonMises code';...
          'If title has 360 in it, then orientations go from 0:360. Otherwise from 0:180'};
      
      structKey.oriStatsTVM = {'rsquare statistic from Toms VonMises code';...
          'If title has 360 in it, then orientations go from 0:360. Otherwise from 0:180'};
      
      structKey.oriFunTVM = {'Fitted function from Toms VonMises Code. Use this for graphing';...
          'If title has 360 in it, then orientations go from 0:360. Otherwise from 0:180'};
      
      structKey.oriBanTVM = {'Bandwidth of fitted orientation data from Toms VonMises Code';...
          'If title has 360 in it, then orientations go from 0:360. Otherwise from 0:180'};
      

          
    
    
    
    
    
    
    
    
    
    
    
    
    
