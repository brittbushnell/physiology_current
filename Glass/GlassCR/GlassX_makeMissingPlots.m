clear all
close all
clc
%%
files = {
'WV_BE_V4_Glass_Aug2017_clean_merged'
    };
%%

for fi = 1:size(files,1)
    %% Get basic information about experiments
    load(files{fi});
    filename = files{fi};    
    
    REdata = data.RE;    
    LEdata = data.LE;
 %%
%     plotGlass_GlassRankingsDistBlank(REdata) % figure 1 and 2
%     plotGlassPSTHs_stimParams_allCh(REdata)
%     plotGlass_callTriplotGray(REdata)

    plotGlass_CoherenceResps(REdata) 
      %%
    plotResponsePvalsVSreliabilityPvals_inStim(REdata)
    
    plotGlass_GlassRankingsDistBlank(LEdata) % figure 1 and 2
    plotGlassPSTHs_stimParams_allCh(LEdata)
    plotGlass_callTriplotGray(LEdata)
    plotGlass_CoherenceResps(LEdata)
    plotResponsePvalsVSreliabilityPvals_inStim(LEdata)
    %% binocular 
    plotGlassChiSquareDistribution(data)
    plotGlassPSTHs_visualResponses(data)
    plotGlass_dPrimeScatter(data)
    
    if contains(REdata.animal,'XT')
        triplotter_stereo_Glass_BE(data,5.5)
    else
        triplotter_stereo_Glass_BE(data,3.5)
    end
    close all
    clear data; clear REdata; clear LEdata;
end