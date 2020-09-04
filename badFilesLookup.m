function [badFiles] = badFilesLookup()
% lookup table of recording files that have fatal flaws and should be
% ignored.  This document will be continually updated.

badFiles = {
    %% glass patterns
    %'WU_LE_GlassTR_nsp2_20170822_002_thresh35.mat'; % for some reason the orienations are 0 and 1 - look into it in the parser.
  % Glass patterns that need to be re-aligned  
    'WV_LE_glassCoh_nsp1_20190402_002_thresh35'
    'WV_LE_glassCoh_nsp1_20190402_003_thresh35'
    'WV_LE_glassCoh_nsp1_20190403_002_thresh35'
    'WV_LE_glassCoh_nsp1_20190404_001_thresh35'
    
    'WV_RE_glassCoh_nsp1_20190404_002_thresh35'
    'WV_RE_glassCoh_nsp1_20190404_003_thresh35'
    'WV_RE_glassCoh_nsp1_20190405_001_thresh35'
    
    'WV_LE_glassCohSmall_nsp1_20190425_002_thresh35'
    'WV_LE_glassCohSmall_nsp1_20190429_001_thresh35'
    'WV_LE_glassCohSmall_nsp1_20190429_002_thresh35'
    'WV_RE_glassCohSmall_nsp1_20190423_001_thresh35'
    'WV_RE_glassCohSmall_nsp1_20190423_002_thresh35'
    'WV_RE_glassCohSmall_nsp1_20190424_001_thresh35'
    
    'WV_LE_glassTRCoh_nsp1_20190411_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190412_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190415_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190415_003_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190416_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190416_002_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190416_003_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190417_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190417_002_thresh35'
    
    'WV_RE_glassTRCoh_nsp2_20190405_002_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190408_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190409_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190409_002_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190410_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190410_002_thresh35'
    
    'WV_LE_glassTRCohSmall_nsp1_20190429_003_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190429_004_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190430_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190430_002_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190430_003_thresh35'

    
    'XT_LE_Glass_nsp2_20190123_001_thresh35'
    'XT_LE_Glass_nsp2_20190124_001_thresh35'
    'XT_LE_Glass_nsp2_20190124_002_thresh35'
    'XT_LE_Glass_nsp2_20190124_003_thresh35'
    
    'XT_RE_Glass_nsp2_20190123_005_thresh35'
    'XT_RE_Glass_nsp2_20190123_006_thresh35'
    'XT_RE_Glass_nsp2_20190123_007_thresh35'
    'XT_RE_Glass_nsp2_20190123_008_thresh35'
    'XT_RE_Glass_nsp2_20190124_005_thresh35'
    
    'XT_RE_GlassCoh_nsp1_20190321_002_thresh35'
    
    'XT_LE_GlassCoh_nsp2_20190324_005_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_001_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_002_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_004_thresh35'
    
    'XT_RE_GlassCoh_nsp2_20190322_001_thresh35'
    
    'XT_LE_GlassTR_nsp1_20190130_001_thresh35'
    'XT_LE_GlassTR_nsp1_20190130_002_thresh35'
    'XT_LE_GlassTR_nsp1_20190130_003_thresh35'
    'XT_LE_GlassTR_nsp1_20190130_004_thresh35'
    
    'XT_RE_GlassTR_nsp2_20190125_001_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_002_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_003_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_004_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_005_thresh35'
    'XT_RE_GlassTR_nsp2_20190128_001_thresh35'
    'XT_RE_GlassTR_nsp2_20190128_002_thresh35'
    
    'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35'
    
    'XT_RE_GlassTRCoh_nsp2_20190322_002_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190322_003_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190322_004_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_002_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_003_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_004_thresh35'
    
    % Radial frequency files that need to be realigned
     'WV_LE_RadFreqLowSF_nsp2_20190328_002_thresh35';
    'WV_LE_RadFreqHighSF_nsp2_20190313_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190329_001_thresh35';
    'WV_LE_RadFreqHighSF_nsp2_20190313_002_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190329_002_thresh35';
    'WV_LE_RadFreqHighSF_nsp2_20190314_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190401_001_thresh35';
    'WV_LE_RadFreqHighSF_nsp2_20190315_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190402_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190328_001_thresh35';
    
    'WV_RE_RadFreqHighSF_nsp1_20190315_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190321_002_thresh35';
    'WV_RE_RadFreqHighSF_nsp1_20190318_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190322_001_thresh35';
    'WV_RE_RadFreqHighSF_nsp1_20190318_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190325_001_thresh35';
    'WV_RE_RadFreqHighSF_nsp1_20190319_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190325_002_thresh35';
    'WV_RE_RadFreqHighSF_nsp1_20190319_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190325_003_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190320_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190327_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190321_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190327_002_thresh35';
    
    'WV_RE_RadFreqLowSF_nsp2_20190322_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190325_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190325_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190325_003_thresh35';
    
    
    'XT_LE_RadFreqHighSFV4_nsp1_20190306_003_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181211_001_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp1_20190307_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181211_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190226_002_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181213_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190226_003_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181213_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_001_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190102_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_002_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190102_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_003_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190103_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181210_002_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190103_002_thresh35'; 
    'XT_LE_RadFreqHighSFV4_nsp1_20190306_003_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181211_001_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp1_20190307_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181211_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190226_002_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181213_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190226_003_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181213_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_001_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190102_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_002_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190102_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_003_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190103_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181210_002_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190103_002_thresh35';
    };