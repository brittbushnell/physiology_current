function plotGlassCRSpikeCounts(dataT)

[numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(dataT);
%
(co,ndot,dx,ch)
for ch = 1:96
    for co = 1:numCoh
        figure(1)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 800 700])
        ndx = 1;
        for dt = 1:numDots
            for dx = 1:numDxs
                
                subplot(2,2,ndx)
                hold on
                histogram(dataT.
            end
        end
    end
end
