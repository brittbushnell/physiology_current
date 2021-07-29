clear
%%
files = {
    'WU_BE_radFreqLoc1_V4_LocSize_oriSF'
    'WU_BE_radFreqLoc1_V1_LocSize_oriSF'
    
    'WV_BE_radFreqHighSF_V4_LocSize_oriSF';
    'WV_BE_radFreqHighSF_V1_LocSize_oriSF';
    'WV_BE_radFreqLowSF_V4_LocSize_oriSF';
    'WV_BE_radFreqLowSF_V1_LocSize_oriSF';

    'XT_BE_radFreqLowSF_V1_LocSize_oriSF';
    'XT_BE_radFreqHighSF_V1_LocSize_oriSF';
    'XT_BE_radFreqLowSFV4_V4_LocSize_oriSF';
    'XT_BE_radFreqHighSFV4_V4_LocSize_oriSF';
};
tic
%%
for fi = 1:length(files)
    %%
    filename = files{fi};
    fparts = strsplit(filename,'_');
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
    
    load(filename);
    REdata = data.RE;
    LEdata = data.LE;
    %% get neurometric correlations
    [LEdata.stimCorrs, REdata.stimCorrs] =  radFreq_getNeuroCorr(LEdata, REdata);
    %% permutation test for neuro curve correlations
    %      CHANGE TO USE D' INSTEAD OF SPIKE COUNT
    [LEdata.stimCorrSig, LEdata.stimCorrPerm] = radFreq_prefStimCorrPerm(LEdata,1000,LEdata.stimCorrs);
    [REdata.stimCorrSig, REdata.stimCorrPerm] = radFreq_prefStimCorrPerm(REdata,1000,REdata.stimCorrs);
    %%  get stim v circle d'
    close all
    LEdata = StimVsCirclePermutations_allStim_zScore2(LEdata,1000);
    REdata = StimVsCirclePermutations_allStim_zScore2(REdata,1000);  
    
    plotRadFreq_DprimeVsCorr(LEdata,REdata)
    %%
    fprintf('\n %.2f minutes to complete %s analysis\n',toc/60,filename)
end
