function [prefOriPerm, SIperm, prefOriPermBoot, SIpermBoot] = glassTR_getOriSelectivityPerm_zScore(dataT,numBoot,holdout)
%{
orientation analysis process from Smith et al 2002

1) get baseline subtracted responses to each stimulus
3) compute selectivity
4) convert to selectivity index

April 21, 2020 edit
output of preferred orientation is in degrees and should be limited to
being between 0 and 160 degrees - anything over 160 degrees is reflected
back to be near zero. 

October 19, 2020 edit
Changed name and now using zscores to compute everything with the merged
and cleaned data.
%}
%%
% load 'WU_LE_GlassTR_nsp2_20170824_001_s1_Permutations500';
% dataT = data.LE;
%%
[numOris,numDots,numDxs,numCoh,~,oris] = getGlassTRParameters(dataT);
radOri = deg2rad(oris);
%%
SIpermBoot = nan(numCoh,numDots,numDxs,96,numBoot);
prefOriPermBoot = nan(numCoh,numDots,numDxs,96,numBoot);

SIperm = nan(numCoh,numDots,numDxs,96);
prefOriPerm = nan(numCoh,numDots,numDxs,96);
%%

for ch = 1:96
    if dataT.goodCh(ch) == 1
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    for nb = 1:numBoot
                        respVect = nan(numOris,1);
                        denomVect = nan(numOris,1);
                        
                        prefNum = nan(numOris,1);
                        prefDenom = nan(numOris,1);
                        for or = 1:numOris
                            linTrials = squeeze(dataT.GlassTRZscore(:,co,dt,dx,ch,:));
                            noiseTrials = squeeze(dataT.GlassTRZscore(1,1,dt,dx,ch,:));
                            
                            stimTrials = [linTrials;noiseTrials'];
                            stimTrials(isnan(stimTrials)) = [];  
                            
                            numTrials = round(length(stimTrials)*holdout);
                            
                            linSamp = datasample(stimTrials, numTrials);  %randi(length(stimTrials),[1,numTrials]);
                            linResp = mean(linSamp);
            
                            % get inputs for calculating orientation
                            % selectivity
                            ori2 = 2*(radOri(or));
                            expon = 1i*(ori2);
                            exVar = exp(expon);
                            respVect(or,1) = linResp*exVar;
                            denomVect(or,1) = (abs(linResp));
                            
                            % preferred orientation
                            prefNum(or,1) = linResp .* (sin(ori2));
                            prefDenom(or,1) = linResp .* (cos(ori2));
                            
                        end
                        v = sum(respVect);
                        denom = sum((denomVect));
                        SItmp(nb,1) = abs(v) / denom;
                        
                        sumPrefNum = sum(prefNum);
                        sumPrefDenom = sum(prefDenom);
                        oriTmp(nb,1) = (atan2d(sumPrefNum,sumPrefDenom))/2;

                    end
                    prefOriPerm(co,dt,dx,ch) = mean(oriTmp);
                    SIperm(co,dt,dx,ch) = mean(SItmp);
                    
                    prefOriPermBoot(co,dt,dx,ch,:) = oriTmp;
                    SIpermBoot(co,dt,dx,ch,:) = SItmp;
                    clear oriTmp SItmp prefNum prefDenom respVect denomVect
                end
            end
        end
    end
end
