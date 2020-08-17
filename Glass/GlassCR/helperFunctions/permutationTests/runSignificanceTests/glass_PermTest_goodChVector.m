function [stimBlankPval,cohSelectiveCh] = glass_PermTest_goodChVector(realData,permData,dataT,compStr,plotFlag)
% glassGetPermutationStats(realData,permData)
%
% INPUT:
%  data matrices of glass pattern stimuli responses that are organized by (dt,dx,ch)
%
% OUTPUT:
%  stimBlankPval
%     A (2,2,96) matrix of p-values from the permutation test comparing the
%     real d' against the distribution of permuted d's.
%
%  gCh
%    A (1,96) vector of logicals that indicates if a channel is visually
%    responsive or not.
%    Responsive channel decision is based on a two tailed test of p-value
%    from the permutation test. If the real d' is >0.95 or <0.05, then the
%    channel is called visually responsive. %%
%%
stimBlankPval = zeros(1,96);
cohSelectiveCh = zeros(1,96);
%%
for ch = 1:96
    if dataT.goodCh(ch) == 1
        realDataCh = squeeze(realData(ch));
        
        if ndims(permData) == 4
            permDataCh = squeeze(permData(:,:,ch,:));
        else
            permDataCh = squeeze(permData(ch,:));
        end
        
        permDataCh = sort(permDataCh);
        firstGreater = find(permDataCh > realDataCh,1);
        high = length(permDataCh) - firstGreater;
        if isempty(high)
            high = 0;
        end
        stimBlankPval(ch) = ((high)+1)/(length(permDataCh)+1);
        
        if (stimBlankPval(ch) > 0.95) || (stimBlankPval(ch) < 0.05)
            cohSelectiveCh(ch) = 1;
        end
        
        if round(realDataCh,2) == 0
            cohSelectiveCh(ch) = 0;
        end
    end
end
%% figure out where to save figure
location = determineComputer;

if contains(compStr,'rad','IgnoreCase',true)
    stim = 'radial';
elseif contains(compStr,'con','IgnoreCase',true)
    stim = 'con';
elseif contains(compStr,'noise','IgnoreCase',true)
    stim = 'noise';
elseif contains(compStr,'all','IgnoreCase',true)
    stim = 'allStim';
end

if contains(compStr,'dPrime','IgnoreCase',true)
    comp = 'stimVblank';
elseif contains(compStr,'latency','IgnoreCase',true)
    comp = 'latency';
elseif contains(compStr,'slope','IgnoreCase',true)
    comp = 'slope';
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
    if contains(dataT.animal,'WV')
        if location == 1
            if contains(dataT.programID,'Small')
                figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/4Deg/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
            else
                figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/8Deg/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
            end
        elseif location == 0
            if contains(dataT.programID,'Small')
                figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/4Deg/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/8Deg/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
            end
        end
    else
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/PermTests/%s/%s/%s/',dataT.animal, dataT.array,dataT.eye,comp,stim);
        end
    end
end

cd(figDir)
% go to date specific folder, if it doesn't exist, make it
folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))
%% plot the data
if plotFlag == 1
    for ch = 1:96
        if dataT.goodCh(ch) == 1
            figure(4)
            clf
            
            hold on
            realDataCh = squeeze(realData(ch));
            if ndims(permData) == 4
                permDataCh = squeeze(permData(:,:,ch,:));
            else
                permDataCh = squeeze(permData(ch,:));
            end
            histogram(permDataCh,7,'FaceColor',[0 0.6 0.2],'Normalization','probability');
            
            ylim([0 0.5])
            plot([realDataCh realDataCh],[0 0.35],'r-','LineWidth',2)
            x = get(gca,'XLim');
            xMin = min(x);
            
            plot(realDataCh,0.4,'rv','markerfacecolor','r','markeredgecolor','w','MarkerSize',10);
            plot(nanmean(permDataCh),0.4,'v','markerfacecolor',[0 0.6 0.2],'markeredgecolor','w','MarkerSize',10);
            set(gca,'color','none','tickdir','out','box','off')
            if cohSelectiveCh(ch) == 1
                text(realDataCh,0.42,sprintf('%.2f',realDataCh),'color',[1 0 0],'fontWeight','bold')
                text(nanmean(permDataCh),0.42,sprintf('mean %.2f',nanmean(permDataCh)),'color',[0 0.6 0.2],'fontWeight','bold')
                text((xMin+(xMin/10)),0.45,sprintf('p %.2f',stimBlankPval(ch)),'fontWeight','bold')
            else
                text(realDataCh,0.42,sprintf('%.2f',realDataCh),'color',[1 0 0])
                text(nanmean(permDataCh),0.42,sprintf('mean %.2f',nanmean(permDataCh)),'color',[0 0.6 0.2])
                text((xMin+(xMin/10)),0.45,sprintf('p %.2f',stimBlankPval(ch)))
            end
            
            title(sprintf('%s %s %s permutation test for %s ch %d',dataT.animal, dataT.eye, dataT.array, compStr, ch));
            
            figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_permTest_',compStr,num2str(ch),'.pdf'];
            print(gcf, figName,'-dpdf','-fillpage')
        end
    end
end