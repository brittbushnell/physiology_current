figDir = '/Users/brittany/Dropbox/Thesis/Glass/figures/coh/origFig';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

%%
figure(3)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1),pos(2),650,900]);

s = suptitle('Number of significant correlations per channel');
s.FontSize = 20;
s.FontWeight = 'bold';
s.FontAngle = 'italic';

LEV1Sig = WUV1.NumSigCohCorrLE;
REV1Sig = WUV1.NumSigCohCorrRE;
LEV4Sig = WUV4.NumSigCohCorrLE;
REV4Sig = WUV4.NumSigCohCorrRE;

t = subplot(4,2,1);
hold on
LEV1Sig(isnan(LEV1Sig)) = [];
histogram(LEV1Sig,'FaceColor','k','EdgeColor','w','FaceAlpha',1,'Normalization','probability')
set(gca,'tickDir','out','Layer','top','FontSize',11,'FontAngle','italic','Xtick',0:6,'Ytick',0:0.25:0.75)
ylabel('% of channels','FontSize',12,'FontAngle','italic')
text(-4.2,0.75/2,'V1/V2','FontSize',18,'FontWeight','bold')
text(-4,1.3,'WU','FontSize',18,'FontWeight','bold')
title('FE')
xlim([-1 6])
ylim([0 .75])
t.Position(1) = t.Position(1) + 0.03;
t.Position(4) = t.Position(4) - 0.08;

t = subplot(4,2,2);
hold on
REV1Sig(isnan(REV1Sig)) = [];
histogram(REV1Sig,'FaceColor','k','EdgeColor','w','FaceAlpha',1,'Normalization','probability')
set(gca,'tickDir','out','Layer','top','FontSize',11,'FontAngle','italic','Xtick',0:6,'Ytick',0:0.25:0.75)

title('AE')
xlim([-1 6])
ylim([0 .75])
t.Position(1) = t.Position(1) + 0.03;
t.Position(4) = t.Position(4) - 0.08;

t = subplot(4,2,3);
hold on
LEV4Sig(isnan(LEV4Sig)) = [];
histogram(LEV4Sig,'FaceColor','k','EdgeColor','w','FaceAlpha',1,'Normalization','probability')
set(gca,'tickDir','out','Layer','top','FontSize',11,'FontAngle','italic','Xtick',0:6,'Ytick',0:0.25:0.75)
xlabel('Number of significant correlations','FontSize',12,'FontAngle','italic')
ylabel('% of channels','FontSize',12,'FontAngle','italic')
text(-3.5,0.75/2,'V4','FontSize',18,'FontWeight','bold')
xlim([-1 6])
ylim([0 .75])
t.Position(4) = t.Position(4) - 0.08;
t.Position(2) = t.Position(2) + 0.1;
t.Position(1) = t.Position(1) + 0.03;

t = subplot(4,2,4);
hold on
REV4Sig(isnan(REV4Sig)) = [];
histogram(REV4Sig,'FaceColor','k','EdgeColor','w','FaceAlpha',1,'Normalization','probability')
set(gca,'tickDir','out','Layer','top','FontSize',11,'FontAngle','italic','Xtick',0:6,'Ytick',0:0.25:0.75)
xlim([-1 6])
ylim([0 .75])
xlabel('Number of significant correlations','FontSize',12,'FontAngle','italic')
t.Position(4) = t.Position(4) - 0.08;
t.Position(2) = t.Position(2) + 0.1;
t.Position(1) = t.Position(1) + 0.03;


LEV1Sig = WVV1.NumSigCohCorrLE;
REV1Sig = WVV1.NumSigCohCorrRE;
LEV4Sig = WVV4.NumSigCohCorrLE;
REV4Sig = WVV4.NumSigCohCorrRE;

t = subplot(4,2,5);
hold on
LEV1Sig(isnan(LEV1Sig)) = [];
histogram(LEV1Sig,'FaceColor','k','EdgeColor','w','FaceAlpha',1,'Normalization','probability')
set(gca,'tickDir','out','Layer','top','FontSize',11,'FontAngle','italic','Xtick',0:6,'Ytick',0:0.25:0.75)
ylabel('% of channels','FontSize',12,'FontAngle','italic')
text(-4.2,0.75/2,'V1/V2','FontSize',18,'FontWeight','bold')
text(-4,1.3,'WV','FontSize',18,'FontWeight','bold')
title('FE')
xlim([-1 6])
ylim([0 .75])
t.Position(1) = t.Position(1) + 0.03;
t.Position(4) = t.Position(4) - 0.08;

t = subplot(4,2,6);
hold on
REV1Sig(isnan(REV1Sig)) = [];
histogram(REV1Sig,'FaceColor','k','EdgeColor','w','FaceAlpha',1,'Normalization','probability')
set(gca,'tickDir','out','Layer','top','FontSize',11,'FontAngle','italic','Xtick',0:6,'Ytick',0:0.25:0.75)

title('AE')
xlim([-1 6])
ylim([0 .75])
t.Position(1) = t.Position(1) + 0.03;
t.Position(4) = t.Position(4) - 0.08;

t = subplot(4,2,7);
hold on
LEV4Sig(isnan(LEV4Sig)) = [];
histogram(LEV4Sig,'FaceColor','k','EdgeColor','w','FaceAlpha',1,'Normalization','probability')
set(gca,'tickDir','out','Layer','top','FontSize',11,'FontAngle','italic','Xtick',0:6,'Ytick',0:0.25:0.75)
xlabel('Number of significant correlations','FontSize',12,'FontAngle','italic')
ylabel('% of channels','FontSize',12,'FontAngle','italic')
text(-3.5,0.75/2,'V4','FontSize',18,'FontWeight','bold')
xlim([-1 6])
ylim([0 .75])
t.Position(4) = t.Position(4) - 0.08;
t.Position(2) = t.Position(2) + 0.1;
t.Position(1) = t.Position(1) + 0.03;

t = subplot(4,2,8);
hold on
REV4Sig(isnan(REV4Sig)) = [];
histogram(REV4Sig,'FaceColor','k','EdgeColor','w','FaceAlpha',1,'Normalization','probability')
set(gca,'tickDir','out','Layer','top','FontSize',11,'FontAngle','italic','Xtick',0:6,'Ytick',0:0.25:0.75)
xlim([-1 6])
ylim([0 .75])
xlabel('Number of significant correlations','FontSize',12,'FontAngle','italic')
t.Position(4) = t.Position(4) - 0.08;
t.Position(2) = t.Position(2) + 0.1;
t.Position(1) = t.Position(1) + 0.03;

figName = ['WU_WV_cohDist','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')