function [stimBlankPval,sig] = glassTRGetPermutationStats_coh(realData,permData,dataT,compStr,plotFlag)
% glassGetPermutationStats(realData,permData)
%
% INPUT:
%  data matrices of glass pattern stimuli responses that are organized by (dt,dx,ch)
%
% OUTPUT:
%  stimBlankPval
%     A (2,2,96) matrix of p-values from the permutation test comparing the
%     real d' against the distribution of permuted d's.

%%
stimBlankPval = zeros(4,4,2,2,96);
sig = zeros(4,4,2,2,96);
%%
for ch = 1:96
    if dataT.goodCh(ch) == 1
        for or = 1:size(permData,1)
            for co = 1:size(permData,2)
                for dx = 1:size(permData,3)
                    for dt = 1:size(permData,4)
                        
                        realDataCh = squeeze(realData(or,co,dt,dx,ch));
                        permDataCh = squeeze(permData(or,co,dt,dx,ch,:));
                        
                        permDataCh = sort(permDataCh);
                        firstGreater = find(permDataCh > realDataCh,1);
                        high = length(permDataCh) - firstGreater;
                        if isempty(high)
                            high = 0;
                        end
                        stimBlankPval(or,co,dt,dx,ch) = ((high)+1)/(length(permDataCh)+1);
                        
                        if (stimBlankPval(or,co,dt,dx,ch) <= 0.05) %(stimBlankPval(or,co,dt,dx,ch) >= 0.95) || (stimBlankPval(or,co,dt,dx,ch) <= 0.05)
                            sig(or,co,dt,dx,ch) = 1;
                        end
                        
                        if round(realDataCh,3) == 0
                            sig(or,co,dt,dx,ch) = 0;
                        end
                    end
                end
            end
        end
    end
end
%% figure out where to save figure
if plotFlag == 1
    location = determineComputer;
    
    stim = 'translational';
    
    if contains(compStr,'dPrime','IgnoreCase',true)
        comp = 'stimVblank';
    elseif contains(compStr,'latency','IgnoreCase',true)
        comp = 'latency';
    elseif contains(compStr,'slope','IgnoreCase',true)
        comp = 'slopes';
    elseif contains(compStr,'OSI','IgnoreCase',true)
        comp = 'OSI';
    elseif contains(compStr,'orientation','IgnoreCase',true)
        comp = 'prefOri';
    else
        comp = 'stimVblank';
    end
    
    
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/PermTests/%s/%s/',dataT.animal, dataT.programID,dataT.array,dataT.eye,comp);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/PermTests/%s/%s/',dataT.animal,dataT.programID, dataT.array,dataT.eye,comp);
    end
    if ~exist(figDir,'dir')
        mkdir(figDir)
        cd(figDir)
    end
    %% plot
    [numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
    
    for ch = 1:96
        if dataT.goodCh(ch) == 1
            for co = 1:size(permData,2) % 1:numCoh % new figure for each coherence and orientation
                for or = 1:size(permData,1)
                    figure(6)
                    clf
                    pos = get(gcf,'Position');
                    set(gcf,'Position',[pos(1) pos(2) 900 700]);
                    for dt = 1:size(permData,3)
                        for dx = 1:size(permData,4)
                            realDataCh = squeeze(realData(or,co,dt,dx,ch));
                            permDataCh = squeeze(permData(or,co,dt,dx,ch,:));
                            
                            nsubplot(2,2,dt,dx);
                            
                            hold on
                            if contains(compStr,'latency')
                                histogram(permDataCh,7,'BinWidth',10,'FaceColor',[0 0.6 0.2],'Normalization','probability');
                            else
                                histogram(permDataCh,7,'FaceColor',[0 0.6 0.2],'Normalization','probability');
                            end
                            
                            ylim([0 0.6])
                            plot([realDataCh realDataCh],[0 0.35],'r-','LineWidth',2)
                            mygca(dt,dx) = gca;
                            
                            b = get(gca,'XLim');
                            xMaxs(dt,dx) = max(b);
                            xMins(dt,dx) = min(b);
                            
                            plot(realDataCh,0.5,'rv','markerfacecolor','r','markeredgecolor','w','MarkerSize',10);
                            plot(nanmean(permDataCh),0.5,'v','markerfacecolor',[0 0.6 0.2],'markeredgecolor','w','MarkerSize',10);
                            set(gca,'color','none','tickdir','out','box','off')
                            
                            if sig(or,co,dt,dx,ch) == 1
                                text((xMins(dt,dx)+0.2),0.59,sprintf('p %.3f',stimBlankPval(or,co,dt,dx,ch)),'fontWeight','bold','fontSize',12)
                                text(realDataCh,0.56,sprintf('%.3f',realDataCh),'color',[1 0 0],'fontWeight','bold','fontSize',12)
                                text(nanmean(permDataCh),0.54,sprintf('%.3f',nanmean(permDataCh)),'color',[0 0.6 0.2],'fontWeight','bold','fontSize',12)
                            else
                                text((xMins(dt,dx)+0.2),0.59,sprintf('p %.3f',stimBlankPval(or,co,dt,dx,ch)),'fontSize',9)
                                text(realDataCh,0.56,sprintf('%.3f',realDataCh),'color',[1 0 0],'fontSize',9)
                                text(nanmean(permDataCh),0.54,sprintf('%.3f',nanmean(permDataCh)),'color',[0 0.6 0.2],'fontSize',9)
                            end
                            
                            title(sprintf('%d dots, %.3f dx',dots(dt),dxs(dx)))
                            
                        end
                    end
                    maxX = max(xMaxs(:));
                    minX = min(xMins(:));
                    xLimits = [minX maxX];
                    set(mygca,'XLim',xLimits);
                    suptitle({sprintf('%s %s %s permutation test for %s ch %d',dataT.animal, dataT.eye, dataT.array, compStr, ch);...
                        (sprintf('%d degrees coherence %d%%',(oris(or)),coherences(co)*100))});
                    
                    figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_permTest_',stim,comp,'_coh',num2str(coherences(co)*100),'_or',num2str(oris(or)),'_ch',num2str(ch),'.pdf'];
                    print(gcf, figName,'-dpdf','-fillpage')
                end
            end
        end
    end
end
