function makeFig_triplotGlass_multiColorWs(WUsortDps,WVsortDps)
%%
cmapWU =  flipud(brewermap(length(WUsortDps),'Blues'));
WUsortDps(:,6:8) = cmapWU; 

cmapWV =  flipud(brewermap(length(WVsortDps),'Reds'));
WVsortDps(:,6:8) = cmapWV; 
%%
WUv1LEsort = WUsortDps(WUsortDps(:,5) == 1,:);
WUv1REsort = WUsortDps(WUsortDps(:,5) == 2,:);
WUv4LEsort = WUsortDps(WUsortDps(:,5) == 3,:);
WUv4REsort = WUsortDps(WUsortDps(:,5) == 4,:);

WVv1LEsort = WVsortDps(WVsortDps(:,5) == 1,:);
WVv1REsort = WVsortDps(WVsortDps(:,5) == 2,:);
WVv4LEsort = WVsortDps(WVsortDps(:,5) == 3,:);
WVv4REsort = WVsortDps(WVsortDps(:,5) == 4,:);
%% use for debugging
% figure(5)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 800 600]); 
% set(gcf,'PaperOrientation','landscape')
%% determine center of mass

%%
s = subplot(2,2,3);
hold on

rcdWU = WUv4LEsort(:,1:3);
cmpWU = WUv4LEsort(:,6:8);
triplotter_Glass_allMonk_multiColor(rcdWU,cmpWU);

rcdWV = WVv4LEsort(:,1:3);
cmpWV = WVv4LEsort(:,6:8);
ax = triplotter_Glass_allMonk_multiColor(rcdWV,cmpWV);

colormap(ax,flipud(cmpWV));
c2 = colorbar(ax,'Position',[0.07 0.11 0.018 0.35]);
c2.TickDirection = 'out';
c2.Ticks = 0:0.25:1;
c2.FontAngle = 'italic';
c2.FontSize = 12;
c2.TickLabels = round(linspace(0,WVsortDps(1,4),5),1);
c2.Label.String = 'WV Vector sum of dPrimes';
c2.Label.FontSize = 14;

text(-0.9,0.5,sprintf('WU %d',length(WUv4LEsort)),'FontSize',14,'Color',[0 0.02 0.85],'FontWeight','bold')
text(-0.9,0.375,sprintf('WV %d',length(WVv4LEsort)),'FontSize',14,'Color',[0.7, 0.02, 0.07],'FontWeight','bold')
text(-1.4,0.3,'V4','FontSize',30,'FontWeight','bold')

s.Position(1) = s.Position(1) - 0.0;
s.Position(2) = s.Position(2) - 0.078;
s.Position(3) = s.Position(3)+ 0.085;
s.Position(4) = s.Position(4)+ 0.085;
%
s = subplot(2,2,1);
hold on

rcdWU = WUv1LEsort(:,1:3);
cmpWU = WUv1LEsort(:,6:8);
ax = triplotter_Glass_allMonk_multiColor(rcdWU,cmpWU);

rcdWV = WVv1LEsort(:,1:3);
cmpWV = WVv1LEsort(:,6:8);
triplotter_Glass_allMonk_multiColor(rcdWV,cmpWV);

colormap(ax,flipud(cmpWU));
c1 = colorbar(ax,'Position',[0.07 0.58 0.018 0.35]);
c1.TickDirection = 'out';
c1.Ticks = 0:0.25:1;
c1.TickLabels = round(linspace(0,WUsortDps(1,4),5),1);
c1.Label.String = 'WU Vector sum of dPrimes';
c1.FontAngle = 'italic';
c1.FontSize = 12;
c1.Label.FontSize = 14;

t = title('FE','FontSize',30,'FontAngle','italic');
t.Position(2) = t.Position(2) +0.023;

text(-0.9,0.5,sprintf('WU %d',length(WUv1LEsort)),'FontSize',14,'Color',[0 0.02 0.85],'FontWeight','bold')
text(-0.9,0.375,sprintf('WV %d',length(WVv1LEsort)),'FontSize',14,'Color',[0.7, 0.02, 0.07],'FontWeight','bold')
text(-1.4,0.3,'V1','FontSize',30,'FontWeight','bold')

s.Position(1) = s.Position(1) - 0.0;
s.Position(2) = s.Position(2) - 0.076;
s.Position(3) = s.Position(3)+ 0.085;
s.Position(4) = s.Position(4)+ 0.085;

s = subplot(2,2,2);
hold on

rcdWU = WUv1REsort(:,1:3);
cmpWU = WUv1REsort(:,6:8);
triplotter_Glass_allMonk_multiColor(rcdWU,cmpWU);

rcdWV = WVv1REsort(:,1:3);
cmpWV = WVv1REsort(:,6:8);
triplotter_Glass_allMonk_multiColor(rcdWV,cmpWV);

t = title('AE','FontSize',30,'FontAngle','italic');
t.Position(2) = t.Position(2) +0.023;

text(-0.9,0.5,sprintf('WU %d',length(WUv1REsort)),'FontSize',14,'Color',[0 0.02 0.85],'FontWeight','bold')
text(-0.9,0.375,sprintf('WV %d',length(WVv1REsort)),'FontSize',14,'Color',[0.7, 0.02, 0.07],'FontWeight','bold')

s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.076;
s.Position(3) = s.Position(3)+ 0.085;
s.Position(4) = s.Position(4)+ 0.085;

s = subplot(2,2,4);
hold on

rcdWU = WUv4REsort(:,1:3);
cmpWU = WUv4REsort(:,6:8);
triplotter_Glass_allMonk_multiColor(rcdWU,cmpWU);

rcdWV = WVv4REsort(:,1:3);
cmpWV = WVv4REsort(:,6:8);
triplotter_Glass_allMonk_multiColor(rcdWV,cmpWV);

text(-0.9,0.5,sprintf('WU %d',length(WUv4REsort)),'FontSize',14,'Color',[0 0.02 0.85],'FontWeight','bold')
text(-0.9,0.375,sprintf('WV %d',length(WVv4REsort)),'FontSize',14,'Color',[0.7, 0.02, 0.07],'FontWeight','bold')

s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.078;
s.Position(3) = s.Position(3)+ 0.085;
s.Position(4) = s.Position(4)+ 0.085;
