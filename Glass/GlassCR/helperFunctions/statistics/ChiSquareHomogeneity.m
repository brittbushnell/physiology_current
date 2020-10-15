function [dataT] = ChiSquareHomogeneity(dataT,ep)

%%
% dataT = data.LE;
cellChi = nan(3,4);
chChi = nan(1,96);
chiMat = nan(3,4,96);
colSums = nan(4,96);
rowSums = nan(3,96);

for ch = 1:96
    if dataT.goodCh(ch) == 1
        dPrimes(1,:) = reshape(dataT.radBlankDprime(end,:,:,ch),1,4);
        dPrimes(2,:) = reshape(dataT.conBlankDprime(end,:,:,ch),1,4);
        dPrimes(3,:) = reshape(dataT.noiseBlankDprime(1,:,:,ch),1,4);
        dPrimeMats(:,:,ch) = dPrimes;
        condSums = sum(dPrimes);
        typeSums = sum(dPrimes,2);
        matSum = sum(dPrimes(:));
        
        
        for types = 1:size(dPrimes,1)
            for conds = 1:size(dPrimes,2)
                observed = dPrimes(types,conds);
                expected = (condSums(conds) * typeSums(types))/matSum;
                
                cellChi(types,conds) = ((observed - expected)^2)/(abs(expected)+ep);
            end
        end
        chChi(1,ch) = sum(cellChi(:));
        colSums(:,ch) = condSums;
        rowSums(:,ch) = typeSums;
        chiMat(:,:,ch) = cellChi;
    end
    
end

dataT.chiVals = chChi;
dataT.chiColSums = colSums;
dataT.chiRowSums = rowSums;
dataT.chiMats = chiMat;
dataT.dPrimeChiMat = dPrimeMats;