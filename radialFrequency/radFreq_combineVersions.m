% combine radial frequency programs (locations and SFs)

    %% get receptive field parameters
    dataT = callReceptiveFieldParameters(dataT);
    %% find receptive fields relative to stimulus locations
    [dataT.rfQuadrant, dataT.rfParams, dataT.inStim] = getRFsinRadFreqStim(dataT);