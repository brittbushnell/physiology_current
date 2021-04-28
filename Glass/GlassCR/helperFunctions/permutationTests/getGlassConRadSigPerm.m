function [pVal,conRadNdx,conRad,sigDif] = getGlassConRadSigPerm(conRadData,animal,array,eye)
%%
% input: matrix where each row is a different channel, column 1 are radial
% d', column 2 are concentric d'.
%%
numBoot = 100;
shuffData = nan(size(conRadData));
crNdxShuffle = nan(numBoot,1);
%%
conRad = (conRadData(:,2) - conRadData(:,1))./ (conRadData(:,2) + conRadData(:,1));
conRadNdx = mean(conRad);  
conRadVect = reshape(conRadData,[numel(conRadData),1]);

for nb = 1:numBoot
    r = randperm(length(conRadVect));
    shuffData(:,1) = conRadVect(r(1:size(conRadData,1)));
    shuffData(:,2) = conRadVect(r(size(conRadData,1)+1:end));
    
    crNdxShuffle(nb,1) = mean((shuffData(:,2) - shuffData(:,1))./ (shuffData(:,2) + shuffData(:,1)));  
end
%%
high = find(crNdxShuffle>conRadNdx);
pVal = ((length(high)+1)/(length(crNdxShuffle)+1));

if  (pVal <= 0.05) || (pVal >= 0.95)
    sigDif = 1;
    if pVal  >= 0.95
        pVal = 1-pVal;
    end
else
    sigDif = 0;
end
%%
figDir =  sprintf('~/Dropbox/Figures/%s/Glass/stats/conRadNdx/',animal,array);
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
figure %(1)
clf
s = suptitle(sprintf('%s %s %s permutations for concentric/radial index',animal, array,eye));
s.Position(2) = s.Position(2) +0.02;
s.FontSize = 20;

subplot(2,1,1)
hold on
histogram(crNdxShuffle,'Normalization','probability','FaceColor','k','EdgeColor','w','FaceAlpha',1,'NumBins',12)
plot([conRadNdx, conRadNdx],[0 0.5],'r-')

if sigDif == 1
    text(conRadNdx+0.01,0.5,sprintf('p = %.2f*',pVal))
else
    text(conRadNdx+0.01,0.5,sprintf('p = %.2f',pVal))
end

ylim([0 0.6])
set(gca,'tickdir','out','layer','top')
xlabel('permuted mean conRad index')
ylabel('proportion of channels')

figName = [animal,'_',array,'_',eye,'_conRadNdx_hist'];
print(gcf, figName,'-dpdf','-bestfit')
