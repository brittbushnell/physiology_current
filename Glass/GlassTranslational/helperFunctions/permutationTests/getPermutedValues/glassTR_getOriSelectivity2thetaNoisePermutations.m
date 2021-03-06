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

%trials = 1:size(dataT.bins,1);


for ch = 1:96
    if dataT.goodCh(ch) == 1
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = numCoh %1:numCoh
                    oriTmp = nan(numPerm,1);
                    SItmp = nan(numPerm,1);
                    
                    
                    for nb = 1:numPerm                        
                        % on each permutation, want to compute a OSI and
                        % preferred orientation. To do this, go through
                        % every orientation used and get the baseline
                        % subtracted firing rate, then do the maths.
                        for or = 1:numOris
                            dtNdx = (dataT.numDots == dots(dt));
                            dxNdx = (dataT.dx == dxs(dx));
                            coNdx = (dataT.coh == coherences(co));
                            % randomly assign trials to noise or
                            % stimulus trials, making sure that none of
                            % the trials are assigned to both.
                            
                            noiseNdx2 = subsampleBlanks((noiseNdx & dtNdx & dxNdx), numNoiseTrials);
                            stimNdx = subsampleBlanks((linNdx & dtNdx & dxNdx & coNdx), numStimTrials);
                            
                            noiseResp = mean(mean(squeeze(dataT.bins(noiseNdx2,5:25,ch))))./0.01;
                            linResp = mean(mean(squeeze((dataT.bins((stimNdx),5:25,ch)))))./0.01;
                            baseSub = linResp;% - noiseResp;
                            
                            % get inputs for calculating orientation
                            % selectivity
                            ori2 = 2*(radOri(or));
                            expon = 1i*(ori2);
                            exVar = exp(expon);
                            respVect(or,1) = baseSub*exVar;
                            denomVect(or,1) = (abs(baseSub));
                            
                            % preferred orientation
                            prefNum(or,1) = baseSub .* (sin(ori2));
                            prefDenom(or,1) = baseSub .* (cos(ori2));
                            
                           % clear noiseResp; clear linResp; clear baseSub;
                            
                        end
                        v = sum(respVect);
                        denom = sum((denomVect));
                        SItmp(nb,1) = abs(v) / denom;
                        
                        sumPrefNum = sum(prefNum);
                        sumPrefDenom = sum(prefDenom);
                        %fra = sumPrefNum/sumPrefDenom;
                        oriTmp(nb,1) = (atan2d(sumPrefNum,sumPrefDenom))/2;
                        
                        %                         ot = ot/2;
                        %                         ot = mod(rad2deg(ot),180); % convert back to degrees, and bring back to being between 0 and 180
                        %
                        %                         if ot < 0
                        %                             oriTmp(nb,1) = ot +180;
                        % %                         elseif ot > 160 % 135 was the highest orientation actually run, so choosing just beyond halfway between there and 180 as the fold point to make 0 and 180the same
                        % %                             oriTmp(nb,1) = ot-180;
                        %                         else
                        %                             oriTmp(nb,1) = ot;
                        %                         end
                        
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