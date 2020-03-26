function [numOris,numDots,numDxs,numCoh,numSamp,oris,dots,dxs,coherences,samples] = getGlassTRParameters(data)


if contains(data.animal,'WU')
    oris = unique(data.rotation);
    
    dots  = unique(data.numDots);
    dots = dots(3:end); % ignore blank stimuli and disk fade
    
    dxs   = unique(data.dx);
    dxs = dxs(2: end-1); % ignore place fillers for blank and disk fade
    
    coherences  = unique(data.coh);
    coherences = coherences(3:end-1);
    
    samples = unique(data.sample);
    
else
    oris = unique(data.rotation);
    
    dots  = unique(data.numDots);
    dots = dots(2:end); % ignore blank stimuli
    
    dxs   = unique(data.dx);
    dxs = dxs(1: end-1); % ignore place fillers for blank
    
    coherences  = unique(data.coh);
    coherences = coherences(2:end-1);
    
    samples = unique(data.sample);
end

numOris = length(oris);
numDots = length(dots);
numDxs  = length(dxs);
numCoh  = length(coherences);
numSamp = length(samples);