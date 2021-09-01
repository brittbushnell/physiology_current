%% percentage of channels tuned for RF
% [untuned highAmp Circles]
ControlTuningLEv1 = [0.18 0.65 0.24];
ControlTuningREv1 = [0.71 0.17 0.12];
ControlTuningLEv4 = [0.20 0.63 0.25];
ControlTuningREv4 = [0.44 0.47 0.15];

A1TuningLEv1 = [0.22 0.65 0.17];
A1TuningREv1 = [0.55 0.40 0.07];
A1TuningLEv4 = [0.14 0.61 0.09];
A1TuningREv4 = [0.47 0.39 0.16];

A2TuningLEv1 = [0.17 0.61 0.31];
A2TuningREv1 = [0.72 0.21 0.09];
A2TuningLEv4 = [0.13 0.69 0.20];
A2TuningREv4 = [0.64 0.28 0.11];
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 800],'PaperSize',[7.5 10])
s = suptitle('Control''s proportion of channels tuned for radial frequency stimuli');
s.Position(2) = s.Position(2) + 0.025;

subplot(2,2,1)
hold on
axis off
axis square
title('LE')
p = pie(ControlTuningLEv1);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];
set(gca,'FontSize',10)
text(-1.25, 0.25, 'V1','FontWeight','bold','FontSize',12)

subplot(2,2,2)
hold on
axis off
axis square
title('RE')
p = pie(ControlTuningREv1);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];

subplot(2,2,3)
hold on
axis off
axis square
p = pie(ControlTuningLEv4);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];
text(-1.25, 0.25, 'V4','FontWeight','bold','FontSize',12)

subplot(2,2,4)
hold on
axis off
axis square
p = pie(ControlTuningREv4);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];

legend('untuned','high amp','circle')
%%
figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 800],'PaperSize',[7.5 10])
s = suptitle('A1''s proportion of channels tuned for radial frequency stimuli');
s.Position(2) = s.Position(2) + 0.025;

subplot(2,2,1)
hold on
axis off
axis square
title('FE')
p = pie(A1TuningLEv1);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];
set(gca,'FontSize',10)
text(-1.25, 0.25, 'V1','FontWeight','bold','FontSize',12)

subplot(2,2,2)
hold on
axis off
axis square
title('AE')
p = pie(A1TuningREv1);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];

subplot(2,2,3)
hold on
axis off
axis square
p = pie(A1TuningLEv4);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];
text(-1.25, 0.25, 'V4','FontWeight','bold','FontSize',12)

subplot(2,2,4)
hold on
axis off
axis square
p = pie(A1TuningREv4);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];

legend('untuned','high amp','circle')
%%
figure(3)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 800],'PaperSize',[7.5 10])
s = suptitle('A2''s proportion of channels tuned for radial frequency stimuli');
s.Position(2) = s.Position(2) + 0.025;

subplot(2,2,1)
hold on
axis off
axis square
title('FE')
p = pie(A2TuningLEv1);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];
set(gca,'FontSize',10)
text(-1.25, 0.25, 'V1','FontWeight','bold','FontSize',12)

subplot(2,2,2)
hold on
axis off
axis square
title('AE')
p = pie(A2TuningREv1);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];

subplot(2,2,3)
hold on
axis off
axis square
p = pie(A2TuningLEv4);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];
text(-1.25, 0.25, 'V4','FontWeight','bold','FontSize',12)

subplot(2,2,4)
hold on
axis off
axis square
p = pie(A2TuningREv4);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];

legend('untuned','high amp','circle')