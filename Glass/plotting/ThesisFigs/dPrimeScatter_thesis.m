figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1300 900]);
set(gcf,'PaperOrientation','landscape')
t = suptitle('d'' versus blank screen');
t.FontSize = 18;  
t.Position(1) = t.Position(1) - 0.24;
t.Position(2) = t.Position(2) + 0.0257;

% XT V1
s = subplot(6,7,1);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.08;
ylabel('RE d''')
text(-5,2,'V1','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,2);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.095;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,3);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.11;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,4);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.125;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
% XT V4
s = subplot(6,7,8);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.08;
ylabel('RE d''')
text(-5,2,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,9);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.095;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,10);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.11;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,11);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.125;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

% WU V4
s = subplot(6,7,22);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.08;
s.Position(2) = s.Position(2)-0.04;
ylabel('RE d''')
text(-5,2,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,23);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.095;
s.Position(2) = s.Position(2)-0.04;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,24);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.11;
s.Position(2) = s.Position(2)-0.04;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,25);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.125;
s.Position(2) = s.Position(2)-0.04;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')


% WV V4
s = subplot(6,7,36);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.08;
s.Position(2) = s.Position(2)-0.065;
ylabel('AE d''')
xlabel('FE d''')
text(-5,2,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,37);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlabel('FE d''')
s.Position(1) = s.Position(1)-0.095;
s.Position(2) = s.Position(2)-0.065;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,38);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlabel('FE d''')
s.Position(1) = s.Position(1)-0.11;
s.Position(2) = s.Position(2)-0.065;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,39);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlabel('FE d''')
s.Position(1) = s.Position(1)-0.125;
s.Position(2) = s.Position(2)-0.065;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

% WU V1
s = subplot(6,7,15);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.08;
s.Position(2) = s.Position(2)-0.015;
ylabel('AE d''')
text(-5,2,'V1','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,16);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.095;
s.Position(2) = s.Position(2)-0.015;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,17);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.11;
s.Position(2) = s.Position(2)-0.015;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,18);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.125;
s.Position(2) = s.Position(2)-0.015;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

% WV V1
s = subplot(6,7,29);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
xlim([-1.2 5])
ylim([-1.2 5])
s.Position(1) = s.Position(1)-0.08;
s.Position(2) = s.Position(2)-0.07;
ylabel('AE d''')
text(-5,2,'V1','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,30);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.095;
s.Position(2) = s.Position(2)-0.07;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,31);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.11;
s.Position(2) = s.Position(2)-0.07;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')

s = subplot(6,7,32);
hold on
xlim([-1.2 5])
ylim([-1.2 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
s.Position(1) = s.Position(1)-0.125;
s.Position(2) = s.Position(2)-0.07;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')