load('WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info3_goodRuns_stimPerm');
dataT = data.LE;
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
                    clear oriTmp
                    clear SItmp
                end % coherence
            end
        end
    % end
end

figure(1)
clf

title('preferred orientations 100% coh max dots max dens')
a = squeeze(prefOri(4,:,:,:));
a = reshape(a,[1, numel(a)]);
histogram(a)
set(gca,'tickdir','out','box','off')
