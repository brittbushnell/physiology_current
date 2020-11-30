% Glass3f_MakeFigs
% Once everything has gone through Glass3 and statistics are done, this is
% just fidgeting with the resulting figures.
clear 
close all
clc

%%
files = {

    'XT_LE_Glass_nsp2_Jan2019_all_thresh35_info3_goodRuns_dPrime';
    'XT_LE_Glass_nsp1_Jan2019_all_thresh35_info3_goodRuns_dPrime';
    'XT_RE_Glass_nsp2_Jan2019_all_thresh35_info3_goodRuns_dPrime';
    'XT_RE_Glass_nsp1_Jan2019_all_thresh35_info3_goodRuns_dPrime';
    
    'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns_dPrime';
    'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns_dPrime';
    'WV_LE_glassCoh_nsp2_April2019_all_thresh35_info3_goodRuns_dPrime';
    'WV_LE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns_dPrime';
    
    'WU_RE_Glass_nsp2_Aug2017_all_thresh35_info3_goodRuns_dPrime';
    'WU_RE_Glass_nsp1_Aug2017_all_thresh35_info3_goodRuns_dPrime';
    'WU_LE_Glass_nsp2_Aug2017_all_thresh35_info3_goodRuns_dPrime';
    'WU_LE_Glass_nsp1_Aug2017_all_thresh35_info3_goodRuns_dPrime';
    };
%%
for fi = 1:length(files)
    fname = files{fi};
    load(fname);
    
    if contains(fname,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    
    
   %% 
    plotResponsePvalsVSreliabilityPvals(dataT)
    plotGlass_GlassRankingsDistBlank(dataT) % figure 1 and 2
    plotGlassPSTHs_stimParams_allCh(dataT)
    plotGlass_callTriplotGray(dataT)
    if ~contains(fname,'XT')
        plotGlass_CoherenceResps(dataT)
    end
end