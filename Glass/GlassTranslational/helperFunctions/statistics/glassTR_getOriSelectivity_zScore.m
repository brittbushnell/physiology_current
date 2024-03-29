function [prefOri, SI] = glassTR_getOriSelectivity_zScore(dataT)%,numBoot,holdout)
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
[numOris,numDots,numDxs,numCoh,~,oris,~,~,coherences,~] = getGlassTRParameters(dataT);
radOri = deg2rad(oris);
%%
SI = nan(numCoh,numDots,numDxs,96);
prefOri = nan(numCoh,numDots,numDxs,96);
%%

for ch = 1:96
    % if dataT.goodCh(ch) == 1
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    % for nb = 1:numBoot
                    for or = 1:numOris
                        
                        linTrials = squeeze(dataT.GlassTRZscore(or,co,dt,dx,ch,:));
                        linTrials(isnan(linTrials)) = [];
                        linResp = mean(linTrials); 
                        % numTrials = round(length(linTrials)*holdout);
                        % linNdx = randi(length(linTrials),[1,numTrials]);
                        % linResp = mean(linTrials(linNdx));
                        
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
                        
                        clear linTrials linResp
                    end % orientation
                    v = sum(respVect);
                    denom = sum((denomVect));   
                    SItmp = abs(v) / denom;
                    %  SItmp(nb,1) = abs(v) / denom;
                     
                    sumPrefNum = sum(prefNum);
                    sumPrefDenom = sum(prefDenom);
                    % oriTmp(nb,1) = (atan2d(sumPrefNum,sumPrefDenom))/2;
                    oriTmp = (atan2d(sumPrefNum,sumPrefDenom))/2;
                    % end %boot strap
                    prefOri(co,dt,dx,ch) = oriTmp; %mean(oriTmp);
                    SI(co,dt,dx,ch) = SItmp; %mean(SItmp);
                    
                    clear SItmp oriTmp denom v sumPrefNum sumPrefDenom prefNum prefDenom
                end % coherence
            end
        end
    % end
end

figure 
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2), 500, 350])

title(sprintf('%s %s %s preferred orientations 100% coh max dots max dens',dataT.animal, dataT.eye, dataT.array))
a = squeeze(prefOri(end,:,:,:));
a = reshape(a,[1, numel(a)]);
histogram(a,20)
