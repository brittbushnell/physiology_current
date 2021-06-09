clear
close all
clc
tic
%%

files = {
    'WU_BE_radFreqLoc1_V4';
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
    %% get stimulus locations
    xPoss = unique(LEdata.pos_x);
    yPoss = unique(LEdata.pos_y);
    locPair = nan(1,2);
    
    for xs = 1:length(xPoss)
        for ys = 1:length(yPoss)
            flerp = sum((LEdata.pos_x == xPoss(xs)) & (LEdata.pos_y == yPoss(ys)));
            if flerp >1
                locPair(end+1,:) = [xPoss(xs), yPoss(ys)];
            end
        end
    end
    locPair = locPair(2:end,:);
    REdata.locPair = locPair;
    LEdata.locPair = locPair;
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
    %% find preferred RF/Phase combo
    radFreq_plotFisherDist_RFphase(REdata, LEdata)
    
%     REdata.prefLoc = radFreq_getFisherLoc(REdata,plotLocCh);
%     LEdata.prefLoc = radFreq_getFisherLoc(LEdata,plotLocCh);
    %% find preferred RF and phase pairing
    
    %% find preferred spatial frequency
end