clear
close all
clc
tic
%%

files = {
    'WU_BE_radFreqLoc1_V4';
    %     'WU_BE_radFreqLoc1_V1';
    %     'WV_BE_radFreqHighSF_V4';
    %     'WV_BE_radFreqHighSF_V1';
    };
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
    
    REdata = radFreq_getSpikeCountCondMtx(REdata);
    LEdata = radFreq_getSpikeCountCondMtx(LEdata);
    %% plot neurometric curves
    [REdata.rfMuZ, REdata.rfStErZ, REdata.circMuZ, REdata.circStErZ,...
        REdata.rfMuSc, REdata.rfStErSc, REdata.circMuSc, REdata.circStErSc] = radFreq_getMuSerrSCandZ(REdata,plotNeuro);
    
    [LEdata.rfMuZ, LEdata.rfStErZ, LEdata.circMuZ, LEdata.circStErZ,...
        LEdata.rfMuSc, LEdata.rfStErSc, LEdata.circMuSc, LEdata.circStErSc] = radFreq_getMuSerrSCandZ(LEdata,plotNeuro);
    %% get fisher transformed correlations
    REdata.FisherTrCorr = radFreq_getFisher_allStim(REdata);
    LEdata.FisherTrCorr = radFreq_getFisher_allStim(LEdata);
    radFreq_plotAllFisherZs(REdata,LEdata);
    %% find preferred location
    radFreq_plotFisherDist_Loc(REdata, LEdata)
    [REdata.prefLoc, LEdata.prefLoc] = radFreq_getFisherLoc_BE(REdata, LEdata);
    %% find preferred stimulus size
    
    %% find preferred RF/Rotation combo
    %     radFreq_plotFisherDist_RFphase(REdata, LEdata)
    close all
    [REdata.sigOri, LEdata.sigOri, REdata.stimCorr, LEdata.stimCorr, REdata.prefRot, LEdata.prefRot, REdata.corrPerm, LEdatacorrPerm] = radFreq_getFisherRFrot_BE(REdata, LEdata,0,1000);
    plotRF_SigOriBars(LEdata,REdata) 
    %% find preferred spatial frequency

end