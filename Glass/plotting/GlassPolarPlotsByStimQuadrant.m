function [] = GlassPolarPlotsByStimQuadrant(quadOris,quadRanks,titleString)
%% define variables
%test of the git variety

q1Ranks = quadRanks.q1;
q2Ranks = quadRanks.q2;
q3Ranks = quadRanks.q3;
q4Ranks = quadRanks.q4;

q1Oris = quadOris.q1;
q2Oris = quadOris.q2;
q3Oris = quadOris.q3;
q4Oris = quadOris.q4;

if contains(titleString{2},'RE')
    eye = 'RE';
else
    eye = 'LE';
end
%%
figure%(6)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
axis off

t = suptitle({titleString{1}; titleString{2}});
t.Position(2) = -0.028;
t.FontSize = 18;
text(0.35, -0.1, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14) 
text(0.5, -0.1, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14) 
text(0.6, -0.1, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14) 
%% quadrant 2
s1 = subplot(2,2,1,polaraxes);
hold on
if ~isempty(q2Oris)
    plotQuadHist(q2Oris,q2Ranks,2,eye) 
end
s1.Position(2) = s1.Position(2) - 0.02;
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
%% quadrant 1
s1 = subplot(2,2,2,polaraxes);
hold on
if ~isempty(q1Oris)
    plotQuadHist(q1Oris,q1Ranks,1,eye) 
end
s1.Position(2) = s1.Position(2) - 0.02;
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
%%
s1 = subplot(2,2,3,polaraxes);
hold on
if ~isempty(q3Oris)
    plotQuadHist(q3Oris,q3Ranks,3,eye) 
end
s1.Position(2) = s1.Position(2) - 0.02;
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
%% 
s1 = subplot(2,2,4,polaraxes);
hold on
if ~isempty(q4Oris)
    plotQuadHist(q4Oris,q4Ranks,4,eye) 
end
s1.Position(2) = s1.Position(2) - 0.02;
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

