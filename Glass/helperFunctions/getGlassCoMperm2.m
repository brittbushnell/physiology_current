function [pVal,sigDif] = getGlassCoMperm2(REdata,LEdata,realCoMdistance,animal,array)
% figure%(2)
% clf
% hold on
% s = suptitle(sprintf('%s %s permuted values (top) and centers of mass (bottom) using best density/dx',animal,array));
% s.Position(2) = s.Position(2)+0.02;
CoMdist = GlassCenterOfTriplotMass_perm2(REdata,LEdata);

% figDir = sprintf('/Users/brittany/Dropbox/Figures/%s/GlassCombo/triplot/ori/perm',animal);
% if ~exist(figDir,'dir')
%     mkdir(figDir)
% end
% cd(figDir)
% 
% figName = [animal,array,'CoMperm_Triplot','.pdf'];
% set(gca,'color','none')
% print(gcf, figName,'-dpdf','-bestfit')
%%
% figure%(18)
% clf
% hold on
% 
% suptitle(sprintf('%s %s permuted centers of mass using best density/dx', REdata.animal, REdata.array))
% triplotter_GlassWithTr_noCBar_oneOri(CoMLE(1:50,:),brewermap(50,'Blues'));
% triplotter_GlassWithTr_noCBar_oneOri(CoMRE(1:50,:),brewermap(50,'Reds'));
%% do permutation test

high = find(CoMdist>realCoMdistance);
pVal = ((length(high)+1)/(length(CoMdist)+1));

if  (pVal < 0.05)
    sigDif = 1;
else
    sigDif = 0;
end
%%
% figure%(3)
% clf
% 
% subplot(2,1,1)
% hold on
% suptitle(sprintf('%s %s permuted distance between LE and RE using best density/dx',animal,array))
% histogram(CoMdist,'Normalization','probability','FaceColor','k','FaceAlpha',1,'EdgeColor','w')
% plot([realCoMdistance, realCoMdistance],[0 0.6],'r-','LineWidth',0.75)
% text(realCoMdistance+0.25,0.4,sprintf('p = %.2f',pVal))
% 
% ylim([0 0.5])
% set(gca,'tickdir','out','box','off')
% 
% figName = [animal,array,'CoMpermDist_Hist','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')

