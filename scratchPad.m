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