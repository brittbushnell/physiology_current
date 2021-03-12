figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1300 900]);
%% XT V1 vs blank
s = subplot(6,7,1);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.045;
ylabel('RE d''')
text(-7,2,'V1','FontSize',14,'FontWeight','bold')
text(9, 8.5, 'd'' versus blank','FontSize',18,'FontWeight','bold');
text(-5, 7.5,'A','FontSize',18,'FontWeight','bold');

set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,2);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.06;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,3);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.075;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,4);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.09;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
%% XT V1 vs noise
s = subplot(6,7,7);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.04;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,6);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.055;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,5);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1 2.5])
ylim([-1 2.5])
s.Position(1) = s.Position(1)+0.072;
ylabel('RE d''')
text(-4.5,0.75,'V1','FontSize',14,'FontWeight','bold')
text(2.75, 4.5, 'd'' versus random dipole','FontSize',18,'FontWeight','bold');
text(-3.5, 4, 'B','FontSize',18,'FontWeight','bold');
text(-8,-2,'XT','FontSize',18,'FontWeight','bold');
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

%% XT V4 blank
s = subplot(6,7,8);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.045;
ylabel('RE d''')
text(-7,2,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,9);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.06;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,10);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.075;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,11);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.09;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
%% XT V4 vs noise
s = subplot(6,7,14);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.04;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,13);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.055;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,12);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1 2.5])
ylim([-1 2.5])
s.Position(1) = s.Position(1)+0.072;
ylabel('RE d''')
text(-4.5,0.75,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})
%% WU V1 blank
s = subplot(6,7,15);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.045;
s.Position(2) = s.Position(2)-0.035;
ylabel('AE d''')
text(-7,2,'V1','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,16);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)-0.035;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,17);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.075;
s.Position(2) = s.Position(2)-0.035;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,18);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.09;
s.Position(2) = s.Position(2)-0.035;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
%% WU V1 vs Noise
s = subplot(6,7,21);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.04;
s.Position(2) = s.Position(2)-0.035;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,20);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.055;
s.Position(2) = s.Position(2)-0.035;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,19);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1 2.5])
ylim([-1 2.5])
s.Position(1) = s.Position(1)+0.072;
s.Position(2) = s.Position(2)-0.035;
ylabel('RE d''')
text(-4.5,0.75,'V1','FontSize',14,'FontWeight','bold')
text(-8,-2,'WU','FontSize',18,'FontWeight','bold');
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})
%% WV V4 blank
s = subplot(6,7,36);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.045;
s.Position(2) = s.Position(2)-0.065;
ylabel('AE d''')
xlabel('FE d''')
text(-7,2,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,37);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlabel('FE d''')
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)-0.065;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,38);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlabel('FE d''')
s.Position(1) = s.Position(1)-0.075;
s.Position(2) = s.Position(2)-0.065;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,39);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlabel('FE d''')
s.Position(1) = s.Position(1)-0.09;
s.Position(2) = s.Position(2)-0.065;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
%% WV V4 vs Noise
s = subplot(6,7,42);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.04;
s.Position(2) = s.Position(2)-0.065;
xlabel('FE d''')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,41);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.055;
s.Position(2) = s.Position(2)-0.065;
xlabel('FE d''')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,40);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1 2.5])
ylim([-1 2.5])
s.Position(1) = s.Position(1)+0.072;
s.Position(2) = s.Position(2)-0.065;
ylabel('RE d''')
xlabel('FE d''')
text(-4.5,0.75,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})
%% WU V4 vs Noise
s = subplot(6,7,28);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.04;
s.Position(2) = s.Position(2)-0.035;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,27);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.055;
s.Position(2) = s.Position(2)-0.035;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,26);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1 2.5])
ylim([-1 2.5])
s.Position(1) = s.Position(1)+0.072;
s.Position(2) = s.Position(2)-0.035;
ylabel('RE d''')
text(-4.5,0.75,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})
%% WV V1
s = subplot(6,7,29);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.045;
s.Position(2) = s.Position(2)-0.07;
ylabel('AE d''')
text(-7,2,'V1','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,30);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)-0.07;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,31);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.075;
s.Position(2) = s.Position(2)-0.07;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,32);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.09;
s.Position(2) = s.Position(2)-0.07;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
%% WV V1 vs Noise
s = subplot(6,7,35);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.04;
s.Position(2) = s.Position(2)-0.07;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,34);
hold on
xlim([-1 2.5])
ylim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)+0.055;
s.Position(2) = s.Position(2)-0.07;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,7,33);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1 2.5])
ylim([-1 2.5])
s.Position(1) = s.Position(1)+0.072;
s.Position(2) = s.Position(2)-0.07;
ylabel('RE d''')
text(-4.5,0.75,'V1','FontSize',14,'FontWeight','bold')
text(-8,-2,'WV','FontSize',18,'FontWeight','bold');
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})
%% WU V4
s = subplot(6,7,22);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.045;
s.Position(2) = s.Position(2)-0.04;
ylabel('RE d''')
text(-7,2,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,23);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)-0.04;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,24);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.075;
s.Position(2) = s.Position(2)-0.04;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,25);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.09;
s.Position(2) = s.Position(2)-0.04;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')