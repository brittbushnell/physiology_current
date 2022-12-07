%  radFreq3_selectivity_allCh
%%
clear
close all
clc
tic
%%
files = {
    'WU_BE_radFreqLoc1_V4';
    'WU_BE_radFreqLoc1_V1';
    
    'WV_BE_radFreqHighSF_V4';
    'WV_BE_radFreqHighSF_V1';
    
    'XT_BE_radFreqLowSF_V1';
    'XT_BE_radFreqLowSFV4_V4';
    };
nameEnd = 'LocSize';

saveData = 1;
%%
for fi = 1%:length(files)
    filename = files{fi};
    fparts = strsplit(filename,'_');
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
    
    load(filename);
    REdata = data.RE;
    LEdata = data.LE;
    %% get spike count matrices
    % rfSCmtx: (repeats, RF, ori, amp, sf, radius, location, ch)
    % blankSCmtx: (repeats, ch)
    % circSCmtx: (repeats, sf, radius, location, ch)
    if contains(REdata.animal,'WU')
        REdata = radFreq_getSpikeCountCondMtx_allCh(REdata);
        LEdata = radFreq_getSpikeCountCondMtx_allCh(LEdata);
    else
        REdata = radFreq_getSpikeCountCondMtx_XTWV_allCh(REdata);
        LEdata = radFreq_getSpikeCountCondMtx_XTWV_allCh(LEdata);
    end
    %% get mean and standard errors
    if contains(REdata.animal,'WU')
        REdata = radFreq_getMuSerrSCandZ(REdata);
        LEdata = radFreq_getMuSerrSCandZ(LEdata);
    else
        REdata = radFreq_getMuSerrSCandZ_WVXT(REdata);       
        LEdata = radFreq_getMuSerrSCandZ_WVXT(LEdata);
    end
    %% get fisher transformed correlations
    if contains(REdata.animal,'WU')
        [REdata.FisherTrCorr,~,REdata.FisherTrCorr_ch] = radFreq_getFisher_allStim(REdata);
        [LEdata.FisherTrCorr,~,LEdata.FisherTrCorr_ch] = radFreq_getFisher_allStim(LEdata);
    else
       [REdata.FisherTrCorr,~,REdata.FisherTrCorr_ch] = radFreq_getFisher_allStim_WVXT(REdata);
       [LEdata.FisherTrCorr,~,LEdata.FisherTrCorr_ch] = radFreq_getFisher_allStim_WVXT(LEdata);        
    end
   
    
    
    
end