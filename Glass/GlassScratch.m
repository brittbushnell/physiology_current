% load('WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info3_goodRuns_stimPerm');
load('XT_LE_GlassTR_nsp1_Jan2019_all_thresh35_info3_goodRuns_stimPerm');
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
                    
                    clear SItmp oriTmp denom v sumPrefNum sumPrefDenom prefNum prefDenom
                end % coherence
            end
        end
    % end
end

% figure(1)
% clf
% hold on
% title('preferred orientations 100% coh all dots and dx','FontSize',14)
% a = squeeze(prefOri(4,:,:,:));
% a = reshape(a,[1, numel(a)]);
% histogram(a,20)
% xlim([-100 100])
% set(gca,'tickdir','out','box','off')
%%


figure(12)
clf

subplot(3,1,1);
hold on
ylim([0 0.15])
xlim([-100 100])
a = squeeze(dataT.prefOri(end,:,:,:));
a = reshape(a,[1, numel(a)]);
title('preferred ori all parameters 100% coherence','FontSize',14)
histogram(a,'BinWidth',10,'Normalization','probability');
set(gca,'tickdir','out','box','off')

subplot(3,1,2);
hold on
ylim([0 0.15])
xlim([-10 190])
a = squeeze(dataT.prefOri(end,:,:,:));
a = reshape(a,[1, numel(a)]);
a(a<0) = a(a<0)+180;
title('preferred ori all parameters 100% coherence 0:180','FontSize',14)
histogram(a,'BinWidth',10,'Normalization','probability');
set(gca,'tickdir','out','box','off')


subplot(3,1,3);
hold on
title('preferred ori preferred parameters 100% coherence','FontSize',14)
histogram(dataT.prefParamsPrefOri,'BinWidth',10,'Normalization','probability');
ylim([0 0.15])
xlim([-10 190])
set(gca,'tickdir','out','box','off')


