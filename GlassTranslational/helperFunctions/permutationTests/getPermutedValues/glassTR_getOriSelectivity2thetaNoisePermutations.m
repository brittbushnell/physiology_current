function [dataT] = glassTR_getOriSelectivity2thetaNoisePermutations(dataT,numPerm,holdout)

%% permutation version of OSI and preferred orientation

[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
radOri = deg2rad(oris);
%%
SIPerm = nan(numCoh,numDots,numDxs,96,numPerm);
prefOriPerm = nan(numCoh,numDots,numDxs,96,numPerm);
%%
linNdx = dataT.type == 3;
noiseNdx = dataT.type == 0;
dtNdx = (dataT.numDots == dots(1));
dxNdx = (dataT.dx == dxs(1));
coNdx = (dataT.coh == coherences(1));
orNdx = (dataT.rotation == oris(1));
numStimTrials = round(length(find(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,1)))*holdout);
numNoiseTrials = round(length(find(dataT.bins((noiseNdx & dtNdx & dxNdx),5:25,1)))*holdout);

trials = 1:size(dataT.bins,1);

for ch = 1:96
    if dataT.goodCh(ch) == 1
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    oriTmp = nan(numPerm,1);
                    SItmp = nan(numPerm,1);
                    
                    for nb = 1:numPerm
                        respVect = nan(numOris,21);
                        denomVect = nan(numOris,21);
                        prefNum = nan(numOris,21);
                        prefDenom = nan(numOris,21);
                        
                        % on each permutation, want to compute a OSI and
                        % preferred orientation. To do this, go through
                        % every orientation used and get the baseline
                        % subtracted firing rate, then do the maths.
                        for or = 1:numOris
                            
                            % randomly assign trials to noise or
                            % stimulus trials, making sure that none of
                            % the trials are assigned to both.
                            [noiseNdx, unusedNdxs] = subsampleBlanks((trials), numNoiseTrials);
                            stimNdx = subsampleStimuli((unusedNdxs), numStimTrials);
                            
                            linResp = mean(mean(squeeze(dataT.bins((stimNdx),5:25,ch))))./0.01;
                            noiseResp = mean(mean(squeeze(dataT.bins(noiseNdx,5:25,ch))))./0.01;
                            baseSub = linResp - noiseResp;
                            
                            ori2 = 2*(radOri(or));
                            
                            % selectivity
                            exVar = exp(1i*(ori2));
                            respVect(or,:) = baseSub .* exVar;
                            denomVect(or,:) = baseSub;
                            
                            % preferred orientation
                            prefNum(or,:) = baseSub .* (sin(ori2));
                            prefDenom(or,:) = baseSub .* (cos(ori2));
                            
                            clear noiseResp; clear linResp; clear baseSub;
                            
                        end
                        v = sum(respVect);
                        denom = sum(abs(denomVect));
                        SItmp(nb,1) = abs(v) / denom;
                        
                        sumPrefNum = sum(prefNum);
                        sumPrefDenom = sum(prefDenom);
                        fra = sumPrefNum/sumPrefDenom;
                        ot = (atan(fra))/2;
                        
                        if ot < 0
                            oriTmp(nb,1) = ot +180;
                        else
                            oriTmp(nb,1) = ot;
                        end
                        
                    end
                    prefOriPerm(co,dt,dx,ch,:) = oriTmp;
                    SIPerm(co,dt,dx,ch,:) = SItmp;
                end
            end
        end
    end
end
%% save to data structure
dataT.OriSelectIndex2thetaNoisePerm = SIPerm;
dataT.prefOri2thetaNoisePerm = prefOriPerm;