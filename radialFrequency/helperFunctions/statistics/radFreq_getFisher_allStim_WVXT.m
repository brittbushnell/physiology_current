function [zTr,sCorr,zTr_ch,sCorr_ch] = radFreq_getFisher_allStim_WVXT(dataT)
%zTr = (RF,phase,sf,radius,location, ch)
% zTr contains the fisher transformed correlations based on spike counts
% with the response to a circle subtracted from it.
%%
%(RF,ori,amp,radius,location, ch) 
spikes = dataT.rfMuSc;

% (sf,radius,location, ch) 
circSpks = dataT.circMuSc;

%(RF,ori,radius,location, ch) no dimension for amplitude b/c the
%correlations are computed across the amplitudes.
zTr = nan(3,2,2,3,96);
sCorr = nan(3,2,2,3,96);
%%
xVals = 1:size(spikes,3);
xVals = log2(xVals);

for ch = 1:96
    if dataT.goodCh(ch) == 1
        for rf = 1:size(spikes,1)
            for or = 1:size(spikes,2)
                for rad = 1:size(spikes,4)
                    for loc = 1:size(spikes,5)
                        spikeCh = squeeze(spikes(rf,or,:,rad,loc,ch));
                        circCh  = squeeze(circSpks(rad,loc,ch));
                        
                        circSubSpikes = spikeCh - circCh;
                        sCorrT = corr2(xVals, circSubSpikes');
                        sCorr(rf,or,rad,loc,ch) = sCorrT;
                        zTr(rf,or,rad,loc,ch)  = atanh(sCorrT);
                        
                    end
                end
            end
        end
    end
end
%% 
zTr_ch = nanmedian(zTr,7);
sCorr_ch = nanmedian(sCorr,7);