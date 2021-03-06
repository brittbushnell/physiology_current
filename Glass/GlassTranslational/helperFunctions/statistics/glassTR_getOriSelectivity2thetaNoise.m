%function [dataT] = glassTR_getOriSelectivity2thetaNoise(dataT,numBoot,holdout)
%{
orientation analysis process from Smith et al 2002

1) get baseline subtracted responses to each stimulus
3) compute selectivity
4) convert to selectivity index

April 21, 2020 edit
output of preferred orientation is in degrees and should be limited to
being between 0 and 160 degrees - anything over 160 degrees is reflected
back to be near zero. 

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
noiseNdx = dataT.type == 0;
dtNdx = (dataT.numDots == dots(1));
dxNdx = (dataT.dx == dxs(1));
coNdx = (dataT.coh == coherences(1));
orNdx = (dataT.rotation == oris(1));

numStimTrials = round(length(find(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,1)))*holdout);
numNoiseTrials = round(length(find(dataT.bins((noiseNdx & dtNdx & dxNdx),5:25,1)))*holdout);

for ch = 1:96
    if dataT.goodCh(ch) == 1
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh 
                    
                    for nb = 1:numBoot                       
                        for or = 1:numOris
                            
                            dtNdx = (dataT.numDots == dots(dt));
                            dxNdx = (dataT.dx == dxs(dx));
                            coNdx = (dataT.coh == coherences(co));
                            orNdx = (dataT.rotation == oris(or));
                            
                            noiseNdx2 = subsampleBlanks((noiseNdx & dtNdx & dxNdx), numNoiseTrials);
                            stimNdx = subsampleBlanks((linNdx & dtNdx & dxNdx & coNdx & orNdx), numStimTrials);
                            
                            noiseResp = mean(mean(squeeze(dataT.bins(noiseNdx2,5:25,ch))))./0.01;
                            linResp = mean(mean(squeeze((dataT.bins((stimNdx),5:25,ch)))))./0.01;
                            baseSub = linResp;
                            
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
                    prefOri(co,dt,dx,ch) = mean(oriTmp);
                    SI(co,dt,dx,ch) = mean(SItmp);
                    clear oriTmp
                    clear SItmp
                end
            end
        end
    end
end
dataT.prefOri2thetaNoise = prefOri;
dataT.OriSelectIndex2thetaNoise = SI;
