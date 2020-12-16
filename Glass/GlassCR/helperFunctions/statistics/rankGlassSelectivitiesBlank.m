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
                if contains(dataT.animal,'XT')
                    conSelective = dataT.conBlankDprimeSig(1,dt,dx,ch);
                    radSelective = dataT.radBlankDprimeSig(1,dt,dx,ch);
                    noiseSelective = dataT.noiseBlankDprimeSig(1,dt,dx,ch);
                else
                    conSelective = dataT.conBlankDprimeSig(end,dt,dx,ch);
                    radSelective = dataT.radBlankDprimeSig(end,dt,dx,ch);
                    noiseSelective = dataT.noiseBlankDprimeSig(1,dt,dx,ch);
                end
                
                if conSelective == 0
                    conDprime = nan;
                else
                    if contains(dataT.animal,'XT')
                        conDprime = abs(dataT.conBlankDprime(1,dt,dx,ch));
                    else
                        conDprime = abs(dataT.conBlankDprime(end,dt,dx,ch));
                    end
                end
                if radSelective == 0
                    radDprime = nan;
                else
                    if contains(dataT.animal,'XT')
                        radDprime = abs(dataT.radBlankDprime(1,dt,dx,ch));
                    else
                        radDprime = abs(dataT.radBlankDprime(end,dt,dx,ch));
                    end
                end
                if noiseSelective == 0
                    noiseDprime = nan;
                else
                    noiseDprime = abs(dataT.noiseBlankDprime(1,dt,dx,ch));
                end
                
               [~, rankOrder(:,ch)] = sort([conDprime,radDprime,noiseDprime],'descend');   
            else
                rankOrder(:,ch) = nan(3,1); % adding this in to make sure that channels that aren't signficant don't end up counted later. 
            end
            dPrimeRank{dt,dx} = rankOrder;
        end
    end
end
dataT.dPrimeRankBlank = dPrimeRank;
%%

