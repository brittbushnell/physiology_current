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
%%
plotNeuro = 0;
plotLocCh = 1;
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
    %         NOTE: need to adjust to only use preferred location
    if contains(REdata.animal,'WU')
        [REdata.rfMuZ, REdata.rfStErZ, REdata.circMuZ, REdata.circStErZ,...
            REdata.rfMuSc, REdata.rfStErSc, REdata.circMuSc, REdata.circStErSc] = radFreq_getMuSerrSCandZ(REdata,plotNeuro);
        
        [LEdata.rfMuZ, LEdata.rfStErZ, LEdata.circMuZ, LEdata.circStErZ,...
            LEdata.rfMuSc, LEdata.rfStErSc, LEdata.circMuSc, LEdata.circStErSc] = radFreq_getMuSerrSCandZ(LEdata,plotNeuro);
    else
        [REdata.rfMuZ, REdata.rfStErZ, REdata.circMuZ, REdata.circStErZ,...
            REdata.rfMuSc, REdata.rfStErSc, REdata.circMuSc, REdata.circStErSc] = radFreq_getMuSerrSCandZ_WVXT(REdata,plotNeuro);
        
        [LEdata.rfMuZ, LEdata.rfStErZ, LEdata.circMuZ, LEdata.circStErZ,...
            LEdata.rfMuSc, LEdata.rfStErSc, LEdata.circMuSc, LEdata.circStErSc] = radFreq_getMuSerrSCandZ_WVXT(LEdata,plotNeuro);
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
    save(saveName,'data');
    fprintf('%s saved\n\n',saveName)
end