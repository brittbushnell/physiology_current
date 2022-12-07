clear
close all
clc
tic
%%

files = {
%     'WU_BE_radFreqLoc1_V4';
%     'WU_BE_radFreqLoc1_V1';
    
    'WV_BE_radFreqHighSF_V4';
    'WV_BE_radFreqHighSF_V1';
    'WV_BE_radFreqLowSF_V4';
    'WV_BE_radFreqLowSF_V1';
    
    'XT_BE_radFreqLowSF_V4';
    'XT_BE_radFreqLowSF_V1';
    'XT_BE_radFreqHighSF_V4';
    'XT_BE_radFreqHighSF_V1';
    'XT_BE_radFreqLowSFV4_V4';
    'XT_BE_radFreqLowSFV4_V1';
    'XT_BE_radFreqHighSFV4_V4';
    'XT_BE_radFreqHighSFV4_V1';
    };
nameEnd = 'LocSize';

saveData = 0; % set to 1 if doing new analyses, or not previously saved. set to 0 if just redoing figures.
%%
for fi = 1:length(files)
    %%
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
        REdata = radFreq_getSpikeCountCondMtx(REdata);
        LEdata = radFreq_getSpikeCountCondMtx(LEdata);
    else
        REdata = radFreq_getSpikeCountCondMtx_XTWV(REdata);
        LEdata = radFreq_getSpikeCountCondMtx_XTWV(LEdata);
    end
    %% plot neurometric curve
    if contains(REdata.animal,'WU')
        REdata = radFreq_getMuSerrSCandZ(REdata);
        
        LEdata = radFreq_getMuSerrSCandZ(LEdata);
    else
        REdata = radFreq_getMuSerrSCandZ_WVXT(REdata);
        
        LEdata = radFreq_getMuSerrSCandZ_WVXT(LEdata);
    end
    %% get fisher transformed correlations
    if contains(REdata.animal,'WU')
        REdata.FisherTrCorr = radFreq_getFisher_allStim(REdata);
        LEdata.FisherTrCorr = radFreq_getFisher_allStim(LEdata);
    else
        REdata.FisherTrCorr = radFreq_getFisher_allStim_WVXT(REdata);
        LEdata.FisherTrCorr = radFreq_getFisher_allStim_WVXT(LEdata);        
    end
    radFreq_plotAllFisherZs(REdata,LEdata);
    %% find preferred location
    radFreq_plotFisherDist_Loc(REdata, LEdata)
    [REdata.prefLoc, LEdata.prefLoc] = radFreq_getFisherLoc_BE(REdata, LEdata);
    %% find preferred stimulus size
    [REdata.sigSize, LEdata.sigSize, REdata.sizeCorrDiff, LEdata.sizeCorrDiff, REdata.prefSize, LEdata.prefSize, REdata.sizeCorr, LEdata.sizeCorr] = radFreq_getFisherRFsize_BE(REdata, LEdata,1000);
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
    if saveData == 1
        save(saveName,'data');
    end
    fprintf('%s saved\n\n',saveName)
end