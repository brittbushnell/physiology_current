function [dataT] = rankGlassSelectivitiesBlank(dataT)
%%
[~,numDots,numDxs] = getGlassParameters(dataT);
%%
% row1 = concentric
% row2 = radial
% row3 = noise
dPrimeRank{2,2} = [];
for dt = 1:numDots
    for dx = 1:numDxs
        rankOrder = nan(3,96);
        for ch = 1:96
            if dataT.goodCh(ch) == 1
                conSelective = dataT.conBlankDprimeSig(end,dt,dx,ch);
                radSelective = dataT.radBlankDprimeSig(end,dt,dx,ch);
                noiseSelective = dataT.noiseBlankDprimeSig(dt,dx,ch);
                
                if conSelective == 0
                    conDprime = nan;
                else
                    conDprime = abs(dataT.conBlankDprime(end,dt,dx,ch));
                end
                if radSelective == 0
                    radDprime = nan;
                else
                    radDprime = abs(dataT.radBlankDprime(end,dt,dx,ch));
                end
                if noiseSelective == 0
                    noiseDprime = nan;
                else
                    noiseDprime = abs(dataT.noiseBlankDprime(dt,dx,ch));
                end
                
               [~, rankOrder(:,ch)] = sort([conDprime,radDprime,noiseDprime]);    
            end
            dPrimeRank{dt,dx} = rankOrder;
        end
    end
end
dataT.dPrimeRankBlank = dPrimeRank;
%%
f
