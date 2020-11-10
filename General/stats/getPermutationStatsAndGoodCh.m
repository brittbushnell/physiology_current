function [stimBlankPval,gCh] = getPermutationStatsAndGoodCh(varargin)
% glassGetPermutationStats(realData,permData)
%
% INPUT:
%  realData: 96 element vector of measured values
%  permData: 96xboot matrix where the columns are the bootstrapped values
%  numTails: optional input that specifies if you want to run a one or two tailed significance test.
%     The default is two-tailed.
%
% OUTPUT:
%  stimBlankPval
%     A vector of p-values from the permutation test comparing the
%     real value against the distribution of permuted va;ues.
%
%  gCh
%    A (1,96) vector of logicals that indicates if a channel is visually
%    responsive or not.
%    Responsive channel decision is based on a two tailed test of p-value
%    from the permutation test. If the real d' is >0.95 or <0.05, then the
%    channel is called visually responsive. %%
%%
switch nargin
    case 0
        error ('Must pass in at least the real and permuted data')
    case 1
        error ('Must pass in at least the real and permuted data')
    case 2
        realData = varargin{1};
        permData = varargin{2};
        numTails = 2;
        plotFlag = 0;
    case 3
        realData = varargin{1};
        permData = varargin{2};
        numTails = varargin{3};
        plotFlag = 0;
    case 4
        realData = varargin{1};
        permData = varargin{2};
        numTails = varargin{3};
        plotFlag = varargin{4};
end
%%
stimBlankPval = zeros(1,96);
gCh = zeros(1,96);
%%
if plotFlag == 1
    fprintf('\n permutation distribution figures are automatically saved\n')
    
    location = determineComputer;
    if location == 0
        figDir =   '/Users/brittany/Dropbox/Figures/goodChPermTempStorage/';
    else
        figDir =  '/Local/Users/bushnell/Dropbox/Figures/goodChPermTempStorage/';
    end
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    cd(figDir)
end
for ch = 1:96
    realDataCh = squeeze(realData(ch));
    permDataCh = squeeze(permData(ch,:));
    high = find(permDataCh>realDataCh);
    stimBlankPval(ch) = round((length(high)+1)/(length(permDataCh)+1),3);
    
    if numTails == 2
        if (stimBlankPval(ch) > 0.95) || (stimBlankPval(ch) < 0.05) % two tailed test
            gCh(ch) = 1;
        end
    else
        if (stimBlankPval(ch) < 0.05) % one tailed test
            gCh(ch) = 1;
        end
    end
    if plotFlag == 1
        figure(1)
        clf
        hold on
        histogram(permDataCh,7,'FaceColor',[0 0.6 0.2],'Normalization','probability');
        ylim([0 0.6])
        plot([realDataCh realDataCh],[0 0.35],'r-','LineWidth',2)
        
        plot(realDataCh,0.5,'rv','markerfacecolor','r','markeredgecolor','w','MarkerSize',10);
        plot(nanmean(permDataCh),0.5,'v','markerfacecolor',[0 0.6 0.2],'markeredgecolor','w','MarkerSize',10);
        set(gca,'color','none','tickdir','out','box','off')

%         xlim([ -0.5 3])
        text((-0.2),0.59,sprintf('p %.3f',stimBlankPval(ch)),'fontSize',9)
        text(realDataCh,0.56,sprintf('%.3f',realDataCh),'color',[1 0 0],'fontSize',9)
        text(nanmean(permDataCh),0.54,sprintf('%.3f',nanmean(permDataCh)),'color',[0 0.6 0.2],'fontSize',9)
        
        title(sprintf('ch %d',ch))
        
        figName = ['allStimPermTest_ch',num2str(ch),'.pdf'];
        print(gcf, figName,'-dpdf','-bestfit')
    end
end



