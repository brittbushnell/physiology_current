function [stimBlankPval,sig] = glassGetPermutationStats_coh(realData,permData,dataT,compStr,plotFlag)
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
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences,~] = getGlassParameters(dataT);
stimBlankPval = zeros(4,2,2,96);
sig = zeros(4,2,2,96);
%%
for ch = 1:96
    if dataT.goodCh(ch) == 1
        for co = 1:numCoh
            for dx = 1:numDxs
                for dt = 1:numDots
                    realDataCh = squeeze(realData(co,dt,dx,ch));
                    permDataCh = squeeze(permData(co,dt,dx,ch,:));
                    
                    permDataCh = sort(permDataCh);
                    firstGreater = find(permDataCh > realDataCh,1);
                    high = length(permDataCh) - firstGreater;
                    if isempty(high)
                        high = 0;
                    end
                    stimBlankPval(co,dt,dx,ch) = ((high)+1)/(length(permDataCh)+1);
                    
                    if (stimBlankPval(co,dt,dx,ch) >= 0.95) || (stimBlankPval(co,dt,dx,ch) <= 0.05)
                        sig(co,dt,dx,ch) = 1;
                    end
                    
                    if round(realDataCh,3) == 0
                        sig(co,dt,dx,ch) = 0;
                    end
                end
            end
        end
    end
end
%% figure out where to save figure
if plotFlag == 1
    location = determineComputer;
    
    if contains(compStr,'rad','IgnoreCase',true)
        stim = 'radial';
    elseif contains(compStr,'con','IgnoreCase',true)
        stim = 'concentric';
    elseif contains(compStr,'noise','IgnoreCase',true)
        stim = 'noise';
    elseif contains(compStr,'translational','IgnoreCase',true)
        stim = 'translational';
    elseif contains(compStr,'allStim','IgnoreCase',true)
        stim = 'allStim';
    end
    
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
    
    if ~contains(dataT.programID,'TR')
        if contains(dataT.animal,'WV')
            if location == 1
                if contains(dataT.programID,'Small')
                    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/4Deg/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
                else
                    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/8Deg/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
                end
            elseif location == 0
                if contains(dataT.programID,'Small')
                    figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/4Deg/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
                else
                    figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/8Deg/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
                end
            end
        else
            if location == 1
                figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
            elseif location == 0
                figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
            end
        end
    else
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/PermTests/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/PermTests/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp);
        end
    end
    cd(figDir)
    % go to date specific folder, if it doesn't exist, make it
    folder = dataT.date2;
    mkdir(folder)
    cd(sprintf('%s',folder))
    %% plot
    for ch = 1:96
        if dataT.goodCh(ch) == 1
            for co = 1:numCoh % new figure for each coherence
                figure(6)
                clf   
                pos = get(gcf,'Position');
                set(gcf,'Position',[pos(1) pos(2) 900 700]);
                
                for dt = 1:numDots
                    for dx = 1:numDxs
                        realDataCh = squeeze(realData(co,dt,dx,ch));
                        permDataCh = squeeze(permData(co,dt,dx,ch,:));
                        
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
                        
                        plot(realDataCh,0.56,'rv','markerfacecolor','r','markeredgecolor','w','MarkerSize',10);
                        plot(nanmean(permDataCh),0.56,'v','markerfacecolor',[0 0.6 0.2],'markeredgecolor','w','MarkerSize',10);
                        set(gca,'color','none','tickdir','out','box','off')
                        
                        if sig(co,dt,dx,ch) == 1
                            text((xMins(dt,dx)+0.2),0.58,sprintf('p %.2f',stimBlankPval(co,dt,dx,ch)),'fontWeight','bold')
                            text(realDataCh,0.59,sprintf('%.2f',realDataCh),'color',[1 0 0],'fontWeight','bold')
                            text(nanmean(permDataCh),0.58,sprintf('%.2f',nanmean(permDataCh)),'color',[0 0.6 0.2],'fontWeight','bold')
                        else
                            text((xMins(dt,dx)+0.2),0.58,sprintf('p %.2f',stimBlankPval(co,dt,dx,ch)))
                            text(realDataCh,0.59,sprintf('%.2f',realDataCh),'color',[1 0 0])
                            text(nanmean(permDataCh),0.58,sprintf('%.2f',nanmean(permDataCh)),'color',[0 0.6 0.2])
                        end
                        
                        title(sprintf('%d dots, %.2f dx',dots(dt),dxs(dx)))
                        
                    end
                end
                maxX = max(xMaxs(:));
                minX = min(xMins(:));
                xLimits = [minX maxX];
                set(mygca,'XLim',xLimits);
                suptitle({sprintf('%s %s %s permutation test for %s ch %d',dataT.animal, dataT.eye, dataT.array, compStr, ch);...
                    (sprintf('coherence %d%%',coherences(co)*100))});
                
                figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_permTest_',stim,comp,'_coh',coherences(co)*100,'_ch',num2str(ch),'.pdf'];
                print(gcf, figName,'-dpdf','-fillpage')
            end
        end
    end
end
