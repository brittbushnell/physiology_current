function [dataT] = glassTR_getOriSelectivity2thetaBlank(dataT,numBoot,numPerm,holdout)
%{
orientation analysis process from Smith et al 2002

1) get baseline subtracted responses to each stimulus
3) compute selectivity
4) convert to selectivity index
%}
%%
% load 'WU_LE_GlassTR_nsp2_20170824_001_s1_Permutations500';
% dataT = data.LE;
%%
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
radOri = deg2rad(oris);
%%
SI = nan(numCoh,numDots,numDxs,96);
prefOri = nan(numCoh,numDots,numDxs,96);
%%
linNdx = dataT.type == 3;
blankNdx = dataT.numDots == 0;
dtNdx = (dataT.numDots == dots(1));
dxNdx = (dataT.dx == dxs(1));
coNdx = (dataT.coh == coherences(1));
orNdx = (dataT.rotation == oris(1));
numStimTrials = round(length(find(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,1)))*holdout);
numBlankTrials = round(length(find(dataT.bins((blankNdx),5:25,1)))*holdout);

for ch = 1:96
    if dataT.goodCh(ch) == 1
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    
                    SItmp = nan(numBoot,1);
                    oriTmp = nan(numBoot,1);
                    for nb = 1:numBoot
                        for or = 1:numOris
                            
                            dtNdx = (dataT.numDots == dots(dt));
                            dxNdx = (dataT.dx == dxs(dx));
                            coNdx = (dataT.coh == coherences(co));
                            orNdx = (dataT.rotation == oris(or));
                            
                            blankNdx2 = subsampleBlanks((blankNdx), numBlankTrials);
                            stimNdx = subsampleStimuli((linNdx & dtNdx & dxNdx & coNdx & orNdx), numStimTrials);
                            
                            blankResp = mean(mean(squeeze(dataT.bins(blankNdx2,5:25,ch))))./0.01;
                            linResp = mean(mean(squeeze((dataT.bins((stimNdx),5:25,ch)))))./0.01;
                            baseSub = linResp - blankResp;
                            
                            % get inputs for calculating orientation
                            % selectivity
                            ori2 = 2*(radOri(or));
                            expon = 1i*(ori2);
                            exVar = exp(expon);
                            respVect(or,:) = baseSub*exVar;
                            denomVect(or,:) = (abs(baseSub));
                            
                            % preferred orientation
                            prefNum(or,:) = baseSub .* (sin(ori2));
                            prefDenom(or,:) = baseSub .* (cos(ori2));
                            
                        end
                        v = sum(respVect);
                        denom = sum((denomVect));
                        SItmp(nb,1) = abs(v) / denom;
                        
                        sumPrefNum = sum(prefNum);
                        sumPrefDenom = sum(prefDenom);
                        fra = sumPrefNum/sumPrefDenom;
                        ot = (atand(fra))/2;
                        
                        if ot < 0
                            oriTmp(nb,1) = ot +180;
                        end
                    end
                    prefOri(co,dt,dx,ch) = mean(oriTmp);
                    SI(co,dt,dx,ch) = mean(SItmp);
                    clear oriTmp
                    clear SItmp
                end
            end
        end
    end
end
dataT.prefOri2theta = prefOri;
dataT.OriSelectIndex2theta = SI;
%% permutation version
trials = 1:size(dataT.bins,1);

for ch = 1:96
    if dataT.goodCh(ch) == 1
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    baseSub = nan(numOris,21);
                    respVect = nan(numOris,21);
                    denomVect = nan(numOris,21);
                    
                    for nb = 1:numPerm
                        for or = 1:numOris
                            
                            [blankNdx, unusedNdxs] = subsampleBlanks((trials), numBlankTrials);
                            stimNdx = subsampleStimuli((unusedNdxs), numStimTrials);
                            
                            linResp = mean(mean(squeeze(dataT.bins((stimNdx),5:25,ch))))./0.01;
                            blankResp = mean(mean(squeeze(dataT.bins(blankNdx,5:25,ch))))./0.01;
                            baseSub = linResp - blankResp;
                            
                            ori2 = 2*(radOri(or));
                            
                            % selectivity
                            exVar = exp(1i*(ori2));
                            respVect(or,:) = baseSub .* exVar;
                            denomVect(or,:) = baseSub;
                            
                            % preferred orientation
                            prefNum(or,:) = baseSub .* (sin(ori2));
                            prefDenom(or,:) = baseSub .* (cos(ori2));
                            
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
                        end
               
                    end
                    prefOriPerm(co,dt,dx,ch) = mean(oriTmp);
                    SIPerm(co,dt,dx,ch) = mean(SItmp);
                    clear oriTmp
                    clear SItmp
                end
            end
        end
    end
end
%% save to data structure
dataT.OriSelectIndexPerm2theta = SIPerm;
dataT.prefOriPerm2theta = prefOriPerm;