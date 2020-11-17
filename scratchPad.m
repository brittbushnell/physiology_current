% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%
clear
close all
clc
location = determineComputer;

files = {
%     'WV_LE_MapNoise_nsp2_Jan2019_all_thresh35_info3';
%     'WV_RE_MapNoise_nsp2_Jan2019_all_thresh35_info3';
%     'WV_LE_MapNoise_nsp1_Jan2019_all_thresh35_info3';
%     'WV_RE_MapNoise_nsp1_Jan2019_all_thresh35_info3';
%     
%     'XT_LE_mapNoiseRight_nsp2_Nov2018_all_thresh35';
%     'XT_RE_mapNoiseRight_nsp2_Nov2018_all_thresh35';
%     'XT_LE_mapNoise_nsp1_Oct2018_all_thresh35';
%     'XT_RE_mapNoise_nsp1_Oct2018_all_thresh35';
    
    'WU_LE_GratmapRF_nsp2_April2017_all_thresh35';
    'WU_RE_GratmapRF_nsp2_April2017_all_thresh35';
    'WU_LE_GratmapRF_nsp1_April2017_all_thresh35';
    'WU_RE_GratmapRF_nsp1_April2017_all_thresh35';
};
clear
close all
clc
% location = determineComputer;
%%

for fi = 1:length(files)
    
    dataT =load(files{fi});
    
    locMtx = dataT.stimZscore;
    
    % stim mtx is set up (y,x,ch,rep), but Manu's code assumes x,y
    locZscores = nanmean(locMtx,4); % get mean z score at each location
    locZscores = permute(locZscores,[2,1,3]); % reorganize so it's (x,y,ch)
    %%
    fixX = double(unique(dataT.fix_x));
    fixY = double(unique(dataT.fix_y));
    xPos = double(unique(dataT.pos_x));
    yPos = double(unique(dataT.pos_y));
    
    % adjust locations so they are relative to fixation, not to the center of the monitor (as they were in MWorks)
    % graphically, this will make it so fixation is always at origin, and you can get
    % a better sense of the actual eccentricies of the receptive fields.
    
    if fixX ~= 0
        xPosRelFix = xPos-fixX;
    else
        xPosRelFix = xPos;
    end
    
    if fixY ~= 0
        yPosRelFix = yPos-fixY;
    else
        yPosRelFix = yPos;
    end
    
    %% Get receptive field information
    arrayRF = nanmean(locZscores,3); % want hot spot of the entire array, so mean across channels
    
    saveName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_rfInputs.mat'];
    save(saveName,'xPosRelFix','yPosRelFix','arrayRF','locZscores');
    fprintf('%s saved\n', saveName)
    
%     [params,rhat,errorsum,fullArray] = fit_gaussianrf_z(xPosRelFix,yPosRelFix,arrayRF);
%     %%
%     
%     for ch = 1:96
%         chZs = squeeze(locZscores(:,:,ch));
%         [params,rhat,errorsum,cf] = fit_gaussianrf_z(xPosRelFix,yPosRelFix,chZs);
%         chFit{ch} = cf.paramsadj;
%     end
%     %%
%     dataT.chReceptiveFieldParams = chFit;
%     dataT.arrayReceptiveFieldParams = fullArray.paramsadj;
%     dataT.xPosRelFix = xPosRelFix;
%     dataT.yPosRelFix = yPosRelFix;
end
    %%
    files = {
        
    'WV_LE_glassCohSmall_nsp1_20190425_002_thresh35_ogcorrupt.mat';
    'WV_LE_glassCohSmall_nsp1_20190429_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassCohSmall_nsp1_20190429_002_thresh35_ogcorrupt.mat';
    'WV_LE_glassCoh_nsp1_20190402_002_thresh35_ogcorrupt.mat'  ;
    'WV_LE_glassCoh_nsp1_20190402_003_thresh35_ogcorrupt.mat'  ;
    'WV_LE_glassCoh_nsp1_20190403_002_thresh35_ogcorrupt.mat'  ;
    'WV_LE_glassCoh_nsp1_20190404_001_thresh35_ogcorrupt.mat'  ;
    'WV_LE_glassTRCohSmall_nsp1_20190429_003_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190429_004_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190430_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190430_002_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190430_003_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190411_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190412_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190415_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190416_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190416_002_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190416_003_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190417_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190417_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190405_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190408_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190409_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190409_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190410_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190410_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassCohSmall_nsp1_20190423_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassCohSmall_nsp1_20190423_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassCohSmall_nsp1_20190424_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassCoh_nsp1_20190404_002_thresh35_ogcorrupt.mat'  ;
    'WV_RE_glassCoh_nsp1_20190404_003_thresh35_ogcorrupt.mat'  ;
    'WV_RE_glassCoh_nsp1_20190405_001_thresh35_ogcorrupt.mat'  ;
    'WV_RE_glassTRCoh_nsp1_20190405_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190408_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190409_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190409_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190410_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190410_002_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp2_20190324_005_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp2_20190325_001_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp2_20190325_002_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp2_20190325_004_thresh35_ogcorrupt.mat'  ;
    'XT_LE_Glass_nsp2_20190123_001_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp2_20190124_001_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp2_20190124_002_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp2_20190124_003_thresh35_ogcorrupt.mat'     ;
    'XT_LE_GlassCoh_nsp1_20190324_005_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp1_20190325_001_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp1_20190325_002_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp1_20190325_003_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp1_20190325_004_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190130_001_thresh35_ogcorrupt.mat'   ;
    'XT_LE_GlassTR_nsp1_20190130_002_thresh35_ogcorrupt.mat'   ;
    'XT_LE_GlassTR_nsp1_20190130_003_thresh35_ogcorrupt.mat'   ;
    'XT_LE_GlassTR_nsp1_20190130_004_thresh35_ogcorrupt.mat'   ;
    'XT_LE_GlassTR_nsp1_20190131_001_thresh35_ogcorrupt.mat'   ;
    'XT_LE_Glass_nsp1_20190123_001_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp1_20190123_002_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp1_20190124_001_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp1_20190124_002_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp1_20190124_003_thresh35_ogcorrupt.mat'     ;
    'XT_RE_GlassCoh_nsp2_20190322_001_thresh35_ogcorrupt.mat'  ;
    'XT_RE_GlassTRCoh_nsp2_20190322_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190125_001_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190125_002_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190125_003_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190125_004_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190125_005_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190128_001_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190128_002_thresh35_ogcorrupt.mat'   ;
    'XT_RE_Glass_nsp2_20190123_005_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp2_20190123_006_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp2_20190123_007_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp2_20190123_008_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp2_20190124_005_thresh35_ogcorrupt.mat'     ;
    'XT_LE_GlassCoh_nsp1_20190324_005_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp1_20190325_001_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp1_20190325_002_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp1_20190325_003_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp1_20190325_004_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp2_20190324_005_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp2_20190325_001_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp2_20190325_002_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp2_20190325_003_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassCoh_nsp2_20190325_004_thresh35_ogcorrupt.mat'  ;
    'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTRCoh_nsp2_20190325_005_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190130_001_thresh35_ogcorrupt.mat'   ;
    'XT_LE_GlassTR_nsp1_20190130_002_thresh35_ogcorrupt.mat'   ;
    'XT_LE_GlassTR_nsp1_20190130_003_thresh35_ogcorrupt.mat'   ;
    'XT_LE_GlassTR_nsp1_20190130_004_thresh35_ogcorrupt.mat'   ;
    'XT_LE_GlassTR_nsp1_20190131_001_thresh35_ogcorrupt.mat'   ;
    'XT_LE_Glass_nsp1_20190123_001_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp1_20190123_002_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp1_20190124_001_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp1_20190124_002_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp1_20190124_003_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp2_20190123_001_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp2_20190124_001_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp2_20190124_002_thresh35_ogcorrupt.mat'     ;
    'XT_LE_Glass_nsp2_20190124_003_thresh35_ogcorrupt.mat'     ;
    'XT_RE_GlassCoh_nsp1_20190321_002_thresh35_ogcorrupt.mat'  ;
    'XT_RE_GlassCoh_nsp1_20190322_001_thresh35_ogcorrupt.mat'  ;
    'XT_RE_GlassCoh_nsp2_20190322_001_thresh35_ogcorrupt.mat'  ;
    'XT_RE_GlassTRCoh_nsp1_20190322_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190322_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190324_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190324_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190324_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190324_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp1_20190125_002_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp1_20190125_003_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp1_20190125_005_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp1_20190128_001_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp1_20190128_002_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190125_001_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190125_002_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190125_003_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190125_004_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190125_005_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190128_001_thresh35_ogcorrupt.mat'   ;
    'XT_RE_GlassTR_nsp2_20190128_002_thresh35_ogcorrupt.mat'   ;
    'XT_RE_Glass_nsp1_20190123_003_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp1_20190123_004_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp1_20190123_007_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp1_20190124_005_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp2_20190123_005_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp2_20190123_006_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp2_20190123_007_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp2_20190123_008_thresh35_ogcorrupt.mat'     ;
    'XT_RE_Glass_nsp2_20190124_005_thresh35_ogcorrupt.mat'     ;
    'WU_LE_GlassTR_nsp2_20170824_001_thresh35.mat'             ;
    'WU_LE_GlassTR_nsp2_20170825_002_thresh35.mat'             ;
    'WU_LE_Glass_nsp2_20170817_001_thresh35.mat'               ;
    'WU_LE_Glass_nsp2_20170821_002_thresh35.mat'               ;
    'WU_LE_Glass_nsp2_20170822_001_thresh35.mat'               ;
    'WU_LE_GlassTR_nsp1_20170822_002_thresh35.mat'             ;
    'WU_LE_GlassTR_nsp1_20170824_001_thresh35.mat'             ;
    'WU_LE_GlassTR_nsp1_20170825_002_thresh35.mat'             ;
    'WU_LE_Glass_nsp1_20170817_001_thresh35.mat'               ;
    'WU_LE_Glass_nsp1_20170821_002_thresh35.mat'               ;
    'WU_LE_Glass_nsp1_20170822_001_thresh35.mat'               ;
    'WU_RE_GlassTR_nsp2_20170825_001_thresh35.mat'             ;
    'WU_RE_GlassTR_nsp2_20170828_002_thresh35.mat'             ;
    'WU_RE_GlassTR_nsp2_20170828_003_thresh35.mat'             ;
    'WU_RE_GlassTR_nsp2_20170829_001_thresh35.mat'             ;
    'WU_RE_Glass_nsp2_20170817_002_thresh35.mat'               ;
    'WU_RE_Glass_nsp2_20170818_001_thresh35.mat'               ;
    'WU_RE_Glass_nsp2_20170818_002_thresh35.mat'               ;
    'WU_RE_Glass_nsp2_20170821_001_thresh35.mat'               ;
    'WU_RE_GlassTR_nsp1_20170825_001_thresh35.mat'             ;
    'WU_RE_GlassTR_nsp1_20170828_002_thresh35.mat'             ;
    'WU_RE_GlassTR_nsp1_20170828_003_thresh35.mat'             ;
    'WU_RE_GlassTR_nsp1_20170829_001_thresh35.mat'             ;
    'WU_RE_Glass_nsp1_20170817_002_thresh35.mat'               ;
    'WU_RE_Glass_nsp1_20170818_001_thresh35.mat'               ;
    'WU_RE_Glass_nsp1_20170821_001_thresh35.mat'               ;
    'WV_LE_glassCohSmall_nsp2_20190425_002_thresh35.mat'       ;
    'WV_LE_glassCohSmall_nsp2_20190425_003_thresh35.mat'       ;
    'WV_LE_glassCohSmall_nsp2_20190429_001_thresh35.mat'       ;
    'WV_LE_glassCohSmall_nsp2_20190429_002_thresh35.mat'       ;
    'WV_LE_glassCoh_nsp2_20190402_002_thresh35.mat'            ;
    'WV_LE_glassCoh_nsp2_20190402_003_thresh35.mat'            ;
    'WV_LE_glassCoh_nsp2_20190402_004_thresh35.mat'            ;
    'WV_LE_glassCoh_nsp2_20190403_001_thresh35.mat'            ;
    'WV_LE_glassCoh_nsp2_20190403_002_thresh35.mat'            ;
    'WV_LE_glassCoh_nsp2_20190404_001_thresh35.mat'            ;
    'WV_LE_glassTRCohSmall_nsp2_20190429_003_thresh35.mat'     ;
    'WV_LE_glassTRCohSmall_nsp2_20190429_004_thresh35.mat'     ;
    'WV_LE_glassTRCoh_nsp2_20190411_001_thresh35.mat'          ;
    'WV_LE_glassTRCoh_nsp2_20190412_001_thresh35.mat'          ;
    'WV_LE_glassTRCoh_nsp2_20190415_001_thresh35.mat'          ;
    'WV_LE_glassTRCoh_nsp2_20190415_002_thresh35.mat'          ;
    'WV_LE_glassTRCoh_nsp2_20190416_001_thresh35.mat'          ;
    'WV_LE_glassTRCoh_nsp2_20190416_002_thresh35.mat'          ;
    'WV_LE_glassTRCoh_nsp2_20190416_003_thresh35.mat'          ;
    'WV_LE_glassTRCoh_nsp2_20190417_001_thresh35.mat'          ;
    'WV_LE_glassTRCoh_nsp2_20190417_002_thresh35.mat'          ;
    'WV_LE_glassCohSmall_nsp1_20190425_003_thresh35.mat'       ;
    'WV_LE_glassCoh_nsp1_20190402_004_thresh35.mat'            ;
    'WV_LE_glassCoh_nsp1_20190403_001_thresh35.mat'            ;
    'WV_LE_glassTRCohSmall_nsp1_20190501_001_thresh35.mat'     ;
    'WV_LE_glassTRCohSmall_nsp1_20190501_002_thresh35.mat'     ;
    'WV_LE_glassTRCohSmall_nsp1_20190502_001_thresh35.mat'     ;
    'WV_LE_glassTRCohSmall_nsp1_20190503_001_thresh35.mat'     ;
    'WV_LE_glassTRCoh_nsp1_20190415_002_thresh35.mat'          ;
  
    'WV_RE_glassCohSmall_nsp2_20190423_001_thresh35.mat'       ;
    'WV_RE_glassCohSmall_nsp2_20190423_002_thresh35.mat'       ;
    'WV_RE_glassCohSmall_nsp2_20190424_001_thresh35.mat'       ;
    'WV_RE_glassCoh_nsp2_20190404_002_thresh35.mat'            ;
    'WV_RE_glassCoh_nsp2_20190404_003_thresh35.mat'            ;
    'WV_RE_glassCoh_nsp2_20190405_001_thresh35.mat'            ;

    'WV_RE_glassTRCohSmall_nsp1_20190503_002_thresh35.mat'     ;
    'WV_RE_glassTRCohSmall_nsp1_20190506_001_thresh35.mat'     ;
    'WV_RE_glassTRCohSmall_nsp1_20190506_002_thresh35.mat'     ;
    'WV_RE_glassTRCohSmall_nsp1_20190507_001_thresh35.mat'     ;
    'WV_RE_glassTRCohSmall_nsp1_20190508_001_thresh35.mat'     ;
   
    'XT_LE_GlassTR_nsp2_20190130_001_thresh35.mat'             ;
    'XT_LE_GlassTR_nsp2_20190130_002_thresh35.mat'             ;
    'XT_LE_GlassTR_nsp2_20190130_003_thresh35.mat'             ;
    'XT_LE_GlassTR_nsp2_20190130_004_thresh35.mat'             ;
    'XT_LE_GlassTR_nsp2_20190131_001_thresh35.mat'             ;

    'XT_RE_GlassCoh_nsp2_20190321_002_thresh35.mat'            ;
    'XT_RE_GlassCoh_nsp2_20190321_003_thresh35.mat'            ;
    'XT_RE_GlassTRCoh_nsp2_20190324_001_cleaned35.mat'         ;
    'XT_RE_Glass_nsp2_20190123_003_thresh35.mat'               ;
    'XT_RE_Glass_nsp2_20190123_004_thresh35.mat'               ;

    'XT_LE_GlassTR_nsp2_20190130_001_thresh35.mat'             ;
    'XT_LE_GlassTR_nsp2_20190130_002_thresh35.mat'             ;
    'XT_LE_GlassTR_nsp2_20190130_003_thresh35.mat'             ;
    'XT_LE_GlassTR_nsp2_20190130_004_thresh35.mat'             ;
    'XT_LE_GlassTR_nsp2_20190131_001_thresh35.mat'             ;
    'XT_RE_GlassCoh_nsp2_20190321_002_thresh35.mat'            ;
    'XT_RE_GlassCoh_nsp2_20190321_003_thresh35.mat'            ;
    'XT_RE_GlassTRCoh_nsp1_20190322_003_thresh35.mat'          ;
    'XT_RE_GlassTRCoh_nsp2_20190324_001_cleaned3.5.mat'        ;
    'XT_RE_GlassTR_nsp1_20190125_001_thresh35.mat'             ;
    'XT_RE_GlassTR_nsp1_20190125_004_thresh35.mat'             ;
    'XT_RE_Glass_nsp1_20190123_005_thresh35.mat'               ;
    'XT_RE_Glass_nsp1_20190123_006_thresh35.mat'               ;
    'XT_RE_Glass_nsp1_20190123_008_thresh35.mat'               ;
    'XT_RE_Glass_nsp2_20190123_003_thresh35.mat'               ;
    'XT_RE_Glass_nsp2_20190123_004_thresh35.mat'               ;

};  
%%

wvNdx1 = 1;
xNdx1 = 1;
wuNdx1 = 1;

wvNdx4 = 1;
xNdx4 = 1;
wuNdx4 = 1;

for i = 1:length(files)
    fname = string(files{i});
    if contains(fname,'WV')
        if contains(fname,'nsp1')
            wvFiles1{wvNdx1,1} = fname;
            wvNdx1 = wvNdx1+1;
        else
            wvFiles4{wvNdx4,1} = fname;
            wvNdx4 = wvNdx4+1;
        end
    elseif contains(fname,'WU')
        if contains(fname,'nsp1')
            wuFiles1{wuNdx1,1} = fname;
            wuNdx1 = wuNdx1+1;
        else
            wuFiles4{wuNdx4,1} = fname;
            wuNdx4 = wuNdx4+1;
        end
    elseif contains(fname,'XT')
        if contains(fname,'nsp1')
            xtFiles1{xNdx1,1} = fname;
            xNdx1 = xNdx1+1;
        else
            xtFiles4{xNdx4,1} = fname;
            xNdx4 = xNdx4+1;
        end
    end
end

%% WU

    'WU_LE_GlassTR_nsp1_20170824_001_thresh35.mat';
    'WU_LE_GlassTR_nsp1_20170825_002_thresh35.mat';
    
    'WU_LE_GlassTR_nsp2_20170824_001_thresh35.mat';
    'WU_LE_GlassTR_nsp2_20170825_002_thresh35.mat';
    
    'WU_RE_GlassTR_nsp1_20170825_001_thresh35.mat';
    'WU_RE_GlassTR_nsp1_20170828_002_thresh35.mat';
    'WU_RE_GlassTR_nsp1_20170828_003_thresh35.mat';
    'WU_RE_GlassTR_nsp1_20170829_001_thresh35.mat';
    
    'WU_RE_GlassTR_nsp2_20170825_001_thresh35.mat';
    'WU_RE_GlassTR_nsp2_20170828_002_thresh35.mat';
    'WU_RE_GlassTR_nsp2_20170828_003_thresh35.mat';
    'WU_RE_GlassTR_nsp2_20170829_001_thresh35.mat';
    

    
    
    'WU_LE_Glass_nsp1_20170817_001_thresh35.mat';
    'WU_LE_Glass_nsp1_20170821_002_thresh35.mat';
    'WU_LE_Glass_nsp1_20170822_001_thresh35.mat';

    'WU_LE_Glass_nsp2_20170817_001_thresh35.mat';
    'WU_LE_Glass_nsp2_20170821_002_thresh35.mat';
    'WU_LE_Glass_nsp2_20170822_001_thresh35.mat';
    
    
    'WU_RE_Glass_nsp1_20170817_002_thresh35.mat';
    'WU_RE_Glass_nsp1_20170818_001_thresh35.mat';
    'WU_RE_Glass_nsp1_20170821_001_thresh35.mat';
    
    'WU_RE_Glass_nsp2_20170817_002_thresh35.mat';
    'WU_RE_Glass_nsp2_20170818_001_thresh35.mat';
    'WU_RE_Glass_nsp2_20170821_001_thresh35.mat';
%% WV    
    'WV_LE_glassCoh_nsp2_20190402_002_thresh35.mat';
    'WV_LE_glassCoh_nsp2_20190402_003_thresh35.mat';
    'WV_LE_glassCoh_nsp2_20190402_004_thresh35.mat';
    'WV_LE_glassCoh_nsp2_20190403_001_thresh35.mat';
    'WV_LE_glassCoh_nsp2_20190403_002_thresh35.mat';
    'WV_LE_glassCoh_nsp2_20190404_001_thresh35.mat';
    
    'WV_LE_glassCoh_nsp1_20190402_002_thresh35_ogcorrupt.mat';
    'WV_LE_glassCoh_nsp1_20190402_003_thresh35_ogcorrupt.mat';
    'WV_LE_glassCoh_nsp1_20190403_002_thresh35_ogcorrupt.mat';
    'WV_LE_glassCoh_nsp1_20190404_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassCoh_nsp1_20190402_004_thresh35.mat';
    'WV_LE_glassCoh_nsp1_20190403_001_thresh35.mat';
    

    'WV_RE_glassCoh_nsp1_20190404_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassCoh_nsp1_20190404_003_thresh35_ogcorrupt.mat';
    'WV_RE_glassCoh_nsp1_20190405_001_thresh35_ogcorrupt.mat';

    
    'WV_RE_glassCoh_nsp2_20190404_002_thresh35.mat';
    'WV_RE_glassCoh_nsp2_20190404_003_thresh35.mat';
    'WV_RE_glassCoh_nsp2_20190405_001_thresh35.mat';

    
    'WV_RE_glassTRCoh_nsp2_20190405_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190408_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190409_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190409_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190410_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp2_20190410_002_thresh35_ogcorrupt.mat';
    
    'WV_RE_glassTRCoh_nsp1_20190405_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190408_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190409_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190409_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190410_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassTRCoh_nsp1_20190410_002_thresh35_ogcorrupt.mat';    
    
    
    'WV_LE_glassTRCoh_nsp2_20190411_001_thresh35.mat';
    'WV_LE_glassTRCoh_nsp2_20190412_001_thresh35.mat';
    'WV_LE_glassTRCoh_nsp2_20190415_001_thresh35.mat';
    'WV_LE_glassTRCoh_nsp2_20190415_002_thresh35.mat';
    'WV_LE_glassTRCoh_nsp2_20190416_001_thresh35.mat';
    'WV_LE_glassTRCoh_nsp2_20190416_002_thresh35.mat';
    'WV_LE_glassTRCoh_nsp2_20190416_003_thresh35.mat';
    'WV_LE_glassTRCoh_nsp2_20190417_001_thresh35.mat';
    'WV_LE_glassTRCoh_nsp2_20190417_002_thresh35.mat';
    

    'WV_LE_glassTRCoh_nsp1_20190415_002_thresh35.mat';
    'WV_LE_glassTRCoh_nsp1_20190411_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190412_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190415_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190416_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190416_002_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190416_003_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190417_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCoh_nsp1_20190417_002_thresh35_ogcorrupt.mat';   
 %%   
    'WV_RE_glassTRCohSmall_nsp1_20190503_002_thresh35.mat';
    'WV_RE_glassTRCohSmall_nsp1_20190506_001_thresh35.mat';
    'WV_RE_glassTRCohSmall_nsp1_20190506_002_thresh35.mat';
    'WV_RE_glassTRCohSmall_nsp1_20190507_001_thresh35.mat';
    'WV_RE_glassTRCohSmall_nsp1_20190508_001_thresh35.mat';
    
    
    'WV_LE_glassTRCohSmall_nsp2_20190429_003_thresh35.mat';
    'WV_LE_glassTRCohSmall_nsp2_20190429_004_thresh35.mat';
    

    
    
    'WV_LE_glassTRCohSmall_nsp1_20190501_001_thresh35.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190501_002_thresh35.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190502_001_thresh35.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190503_001_thresh35.mat';
    
    'WV_LE_glassCohSmall_nsp1_20190425_003_thresh35.mat';
    
    'WV_RE_glassCohSmall_nsp1_20190423_001_thresh35_ogcorrupt.mat';
    'WV_RE_glassCohSmall_nsp1_20190423_002_thresh35_ogcorrupt.mat';
    'WV_RE_glassCohSmall_nsp1_20190424_001_thresh35_ogcorrupt.mat';
    
    'WV_LE_glassCohSmall_nsp2_20190425_002_thresh35.mat';
    'WV_LE_glassCohSmall_nsp2_20190425_003_thresh35.mat';
    'WV_LE_glassCohSmall_nsp2_20190429_001_thresh35.mat';
    'WV_LE_glassCohSmall_nsp2_20190429_002_thresh35.mat';
    
    'WV_LE_glassTRCohSmall_nsp1_20190429_003_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190429_004_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190430_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190430_002_thresh35_ogcorrupt.mat';
    'WV_LE_glassTRCohSmall_nsp1_20190430_003_thresh35_ogcorrupt.mat';
    
        'WV_LE_glassCohSmall_nsp1_20190425_002_thresh35_ogcorrupt.mat';
    'WV_LE_glassCohSmall_nsp1_20190429_001_thresh35_ogcorrupt.mat';
    'WV_LE_glassCohSmall_nsp1_20190429_002_thresh35_ogcorrupt.mat';
    
        'WV_RE_glassCohSmall_nsp2_20190423_001_thresh35.mat';
    'WV_RE_glassCohSmall_nsp2_20190423_002_thresh35.mat';
    'WV_RE_glassCohSmall_nsp2_20190424_001_thresh35.mat';
    %% XT
    
    'XT_LE_GlassCoh_nsp1_20190324_005_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp1_20190325_001_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp1_20190325_002_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp1_20190325_003_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp1_20190325_004_thresh35_ogcorrupt.mat';
    
    'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35_ogcorrupt.mat';
    
    'XT_LE_GlassTR_nsp1_20190130_001_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190130_002_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190130_003_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190130_004_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190131_001_thresh35_ogcorrupt.mat';
    
    'XT_LE_Glass_nsp1_20190123_001_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp1_20190123_002_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp1_20190124_001_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp1_20190124_002_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp1_20190124_003_thresh35_ogcorrupt.mat';
    
    'XT_LE_GlassCoh_nsp1_20190324_005_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp1_20190325_001_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp1_20190325_002_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp1_20190325_003_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp1_20190325_004_thresh35_ogcorrupt.mat';
    
    'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35_ogcorrupt.mat';
    
    'XT_LE_GlassTR_nsp1_20190130_001_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190130_002_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190130_003_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190130_004_thresh35_ogcorrupt.mat';
    'XT_LE_GlassTR_nsp1_20190131_001_thresh35_ogcorrupt.mat';
    
    'XT_LE_Glass_nsp1_20190123_001_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp1_20190123_002_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp1_20190124_001_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp1_20190124_002_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp1_20190124_003_thresh35_ogcorrupt.mat';
    
    'XT_RE_GlassCoh_nsp1_20190321_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassCoh_nsp1_20190322_001_thresh35_ogcorrupt.mat';
    
    'XT_RE_GlassTRCoh_nsp1_20190322_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190322_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190324_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190324_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190324_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp1_20190324_004_thresh35_ogcorrupt.mat';
    
    'XT_RE_GlassTR_nsp1_20190125_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp1_20190125_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp1_20190125_005_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp1_20190128_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp1_20190128_002_thresh35_ogcorrupt.mat';
    
    'XT_RE_Glass_nsp1_20190123_003_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp1_20190123_004_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp1_20190123_007_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp1_20190124_005_thresh35_ogcorrupt.mat';
    
    'XT_RE_GlassTRCoh_nsp1_20190322_003_thresh35.mat';
    
    'XT_RE_GlassTR_nsp1_20190125_001_thresh35.mat';
    'XT_RE_GlassTR_nsp1_20190125_004_thresh35.mat';
    
    'XT_RE_Glass_nsp1_20190123_005_thresh35.mat';
    'XT_RE_Glass_nsp1_20190123_006_thresh35.mat';
    'XT_RE_Glass_nsp1_20190123_008_thresh35.mat';
    
    
    'XT_LE_GlassCoh_nsp2_20190324_005_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp2_20190325_001_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp2_20190325_002_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp2_20190325_004_thresh35_ogcorrupt.mat';
    
    'XT_LE_Glass_nsp2_20190123_001_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp2_20190124_001_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp2_20190124_002_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp2_20190124_003_thresh35_ogcorrupt.mat';
    
    'XT_RE_GlassCoh_nsp2_20190322_001_thresh35_ogcorrupt.mat';
    
    'XT_RE_GlassTRCoh_nsp2_20190322_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_004_thresh35_ogcorrupt.mat';
    
    'XT_RE_GlassTR_nsp2_20190125_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190125_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190125_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190125_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190125_005_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190128_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190128_002_thresh35_ogcorrupt.mat';
    
    'XT_RE_Glass_nsp2_20190123_005_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp2_20190123_006_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp2_20190123_007_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp2_20190123_008_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp2_20190124_005_thresh35_ogcorrupt.mat';
    
    'XT_LE_GlassCoh_nsp2_20190324_005_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp2_20190325_001_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp2_20190325_002_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp2_20190325_003_thresh35_ogcorrupt.mat';
    'XT_LE_GlassCoh_nsp2_20190325_004_thresh35_ogcorrupt.mat';
    
    'XT_LE_GlassTRCoh_nsp2_20190325_005_thresh35_ogcorrupt.mat';
    
    'XT_LE_Glass_nsp2_20190123_001_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp2_20190124_001_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp2_20190124_002_thresh35_ogcorrupt.mat';
    'XT_LE_Glass_nsp2_20190124_003_thresh35_ogcorrupt.mat';
    
    'XT_RE_GlassCoh_nsp2_20190322_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190322_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTRCoh_nsp2_20190324_004_thresh35_ogcorrupt.mat';
    
    'XT_RE_GlassTR_nsp2_20190125_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190125_002_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190125_003_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190125_004_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190125_005_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190128_001_thresh35_ogcorrupt.mat';
    'XT_RE_GlassTR_nsp2_20190128_002_thresh35_ogcorrupt.mat';
    
    'XT_RE_Glass_nsp2_20190123_005_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp2_20190123_006_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp2_20190123_007_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp2_20190123_008_thresh35_ogcorrupt.mat';
    'XT_RE_Glass_nsp2_20190124_005_thresh35_ogcorrupt.mat';
    
    'XT_LE_GlassTR_nsp2_20190130_001_thresh35.mat';
    'XT_LE_GlassTR_nsp2_20190130_002_thresh35.mat';
    'XT_LE_GlassTR_nsp2_20190130_003_thresh35.mat';
    'XT_LE_GlassTR_nsp2_20190130_004_thresh35.mat';
    'XT_LE_GlassTR_nsp2_20190131_001_thresh35.mat';
    
    'XT_RE_GlassCoh_nsp2_20190321_002_thresh35.mat';
    'XT_RE_GlassCoh_nsp2_20190321_003_thresh35.mat';
    
    'XT_RE_GlassTRCoh_nsp2_20190324_001_cleaned35.mat';
    
    'XT_RE_Glass_nsp2_20190123_003_thresh35.mat';
    'XT_RE_Glass_nsp2_20190123_004_thresh35.mat';
    
    'XT_LE_GlassTR_nsp2_20190130_001_thresh35.mat';
    'XT_LE_GlassTR_nsp2_20190130_002_thresh35.mat';
    'XT_LE_GlassTR_nsp2_20190130_003_thresh35.mat';
    'XT_LE_GlassTR_nsp2_20190130_004_thresh35.mat';
    'XT_LE_GlassTR_nsp2_20190131_001_thresh35.mat';
    
    'XT_RE_GlassCoh_nsp2_20190321_002_thresh35.mat';
    'XT_RE_GlassCoh_nsp2_20190321_003_thresh35.mat';
    
    'XT_RE_Glass_nsp2_20190123_003_thresh35.mat';
    'XT_RE_Glass_nsp2_20190123_004_thresh35.mat';
    

