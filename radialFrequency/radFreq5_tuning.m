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
nameEnd = 'tuning';
%%
numBoot = 1000;
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
    %%  get stim v circle d'
    LEdata = StimVsCirclePermutations_allStim_zScore2(LEdata,numBoot);
    REdata = StimVsCirclePermutations_allStim_zScore2(REdata,numBoot);
    %% get neurometric correlations
    [LEdata.stimCorrs, REdata.stimCorrs] =  radFreq_getNeuroCorr_dPrime(LEdata, REdata);
    %% permutation test for neuro curve correlations
    %      CHANGE TO USE D' INSTEAD OF SPIKE COUNT
    [LEdata.stimCorrSig, LEdata.stimCorrPerm] = radFreq_prefStimCorrPerm_dPrime(LEdata,numBoot,LEdata.stimCorrs);
    [REdata.stimCorrSig, REdata.stimCorrPerm] = radFreq_prefStimCorrPerm_dPrime(REdata,numBoot,REdata.stimCorrs);
    %% plot d' vs correlation
    plotRadFreq_DprimeVsCorr(LEdata,REdata)
    %% d' IODs
    plotRadFreq_dPrimeEyeDiffs(LEdata,REdata)
    %%
    location = determineComputer;
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',REdata.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',REdata.array);
    end
    
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
    end
    
    data.RE = REdata;
    data.LE = LEdata;
    
    fname2 = strrep(filename,'.mat','');
    saveName = [outputDir fname2 '_' nameEnd '.mat'];
    save(saveName,'data');
    fprintf('%s saved\n\n',saveName)
    
    
    fprintf('%.2f minutes to complete %s analysis\n',toc/60,filename)
end
