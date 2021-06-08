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
    xPoss = unique(dataT.pos_x);
    yPoss = unique(dataT.pos_y);
    locPair = nan(1,2);
    
    for xs = 1:length(xPoss)
        for ys = 1:length(yPoss)
            flerp = sum((dataT.pos_x == xPoss(xs)) & (dataT.pos_y == yPoss(ys)));
            if flerp >1
                locPair(end+1,:) = [xPoss(xs), yPoss(ys)];
            end
        end
    end
    dataT.locPair = locPair(2:end,:);
    %% get spike count matrices
    % rfSCmtx: (repeats, RF, ori, amp, sf, radius, location, ch)
    % blankSCmtx: (repeats, ch)
    % circSCmtx: (repeats, sf, radius, location, ch)
    
    dataT = radFreq_getSpikeCountCondMtx(dataT);
    %% plot neurometric curves
    [dataT.rfMuZ, dataT.rfStErZ, dataT.circMuZ, dataT.circStErZ,...
        dataT.rfMuSc, dataT.rfStErSc, dataT.circMuSc, dataT.circStErSc] = radFreq_getMuSerrSCandZ(dataT,plotNeuro);
    %% get fisher transformed correlations
    dataT.FisherTrCorr = radFreq_getFisher_allStim(dataT);
    %% find preferred location
    dataT.prefLoc = radFreq_getFisherLoc(dataT,plotLocCh);
    %% find preferred RF and phase pairing
    
    %% find preferred spatial frequency
end