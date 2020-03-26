 function [amblyNdx] = AmblyIndx(AEfile,FEfile)

% AmblyIndx is a function that will compute the amblyopia index for any 
% animal.
%
% INPUT: .csf files where the first column is the sf run, the second is the
% contrast threshold, and the third is standard error. 
%
% OUTPUT: Amblyopia index is the difference between the area under the
% contrast sensitivity curves for each eye.
AE = dlmread(AEfile);
FE = dlmread(FEfile);

[AEparams, AEerror] = CSFit(AE);
[FEparams, FEerror] = CSFit(FE);

AEarea = integral(@(xdata) ((AEparams(1)).*(xdata.^(AEparams(2))).*(exp(-(AEparams(3)).*xdata))),(AE(1,1)),(AE(end,1)));
FEarea = integral(@(xdata) ((FEparams(1)).*(xdata.^(FEparams(2))).*(exp(-(FEparams(3)).*xdata))),(FE(1,1)),(FE(end,1)));

[AExs, AEys] = CSCurves(AEparams);
[FExs, FEys] = CSCurves(FEparams);


figure
plot (log10(AExs),(AEys),'k')
hold on
errorbar ((log10(AE(:,1))),((AE(:,2))),((AE(:,3))),'ok')
plot (log10(FExs),(FEys),'r')
errorbar (log10(FE(:,1)),(FE(:,2)),((FE(:,3))),'or')
box off
axis square
xl = [0.3 1 3 10 30 100];
yl = [1 3 10 30 100 300];
set(gca,'tickdir','out','color','none')
set(gca,'ylim',log10([min(yl) max(yl)]));
set(gca,'ytick',log10(yl))
set(gca,'yticklabel',log10(yl))
set(gca,'yticklabel',(yl))
set(gca,'xlim',log10([min(xl) max(xl)]));
set(gca,'xtick',log10(xl));
set(gca,'xticklabel',(xl));
ylabel ('Contrast Threshold')
xlabel ('Spatial Frequency')
legend('amblyopic eye', '', 'fellow eye','','Location','NorthEastOutside')


amblyNdx = abs((FEarea-AEarea)/FEarea);
% can't be negative. 




