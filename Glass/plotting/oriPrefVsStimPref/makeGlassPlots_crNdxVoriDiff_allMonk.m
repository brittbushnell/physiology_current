function [] = makeGlassPlots_crNdxVoriDiff_allMonk(XTv4RE, XTv4LE, WUv1RE, WUv1LE, WUv4RE, WUv4LE, WVv1RE, WVv1LE, WVv4RE, WVv4LE )


%%
figure(2)
clf
hold on

pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 700, 900],'PaperSize',[7.5 10])
s = suptitle('Orientation differences from gratings vs concentric radial indices');
s.Position(2) = s.Position(2)+0.012;

% WV

for chNdx = 1:length(WVv4RE.useCh)
    ch = WVv4RE.useCh(chNdx);
    
    pOri = WVv4RE.trData.ori_pref(ch);
    rfX  = WVv4RE.rfParams{ch}(1);
    rfY  = WVv4RE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,10);
    hold on
    axis square
    plot(WVv4RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
    xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
end
h.Position(2) = h.Position(2) -0.035;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WVv4LE.useCh)
    ch = WVv4LE.useCh(chNdx);
    
    pOri = WVv4LE.trData.ori_pref(ch);
    rfX  = WVv4LE.rfParams{ch}(1);
    rfY  = WVv4LE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,9);
    hold on
    axis square
    plot(WVv4LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,...
        'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
    xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
    y = ylabel('Local orientation relative to concentric','FontSize',11,'FontAngle','italic');
    y.Position(2) = y.Position(2) + 10;
end
text(-2, 45,'V4','FontSize',12,'FontWeight','bold','FontAngle','italic')
h.Position(2) = h.Position(2) -0.035;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WVv1RE.useCh)
    ch = WVv1RE.useCh(chNdx);
    
    pOri = WVv1RE.trData.ori_pref(ch);
    rfX  = WVv1RE.rfParams{ch}(1);
    rfY  = WVv1RE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,8);
    hold on
    axis square
    plot(WVv1RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',[],'FontSize',10,'FontAngle','italic')
end
h.Position(2) = h.Position(2) - 0.055;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WVv1LE.useCh)
    ch = WVv1LE.useCh(chNdx);
    
    pOri = WVv1LE.trData.ori_pref(ch);
    rfX  = WVv1LE.rfParams{ch}(1);
    rfY  = WVv1LE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,7);
    hold on
    axis square
    plot(WVv1LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,...
        'XTickLabel',[],'FontSize',10,'FontAngle','italic')
end
text(-2.25, 100,'A2','FontSize',13,'FontWeight','bold','FontAngle','italic')
text(-2, 45,'V1','FontSize',12,'FontWeight','bold','FontAngle','italic')
h.Position(2) = h.Position(2) - 0.055;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WUv4RE.useCh)
    ch = WUv4RE.useCh(chNdx);
    
    pOri = WUv4RE.trData.ori_pref(ch);
    rfX  = WUv4RE.rfParams{ch}(1);
    rfY  = WUv4RE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,6);
    hold on
    axis square
    plot(WUv4RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
end
h.Position(2) = h.Position(2) -0.03;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WUv4LE.useCh)
    ch = WUv4LE.useCh(chNdx);
    
    pOri = WUv4LE.trData.ori_pref(ch);
    rfX  = WUv4LE.rfParams{ch}(1);
    rfY  = WUv4LE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,5);
    hold on
    axis square
    plot(WUv4LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,...
        'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
end
text(-2, 45,'V4','FontSize',12,'FontWeight','bold','FontAngle','italic')
h.Position(2) = h.Position(2) -0.03;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WUv1RE.useCh)
    ch = WUv1RE.useCh(chNdx);
    
    pOri = WUv1RE.trData.ori_pref(ch);
    rfX  = WUv1RE.rfParams{ch}(1);
    rfY  = WUv1RE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,4);
    hold on
    axis square
    plot(WUv1RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',[],'FontSize',10,'FontAngle','italic')
    title('AE','FontSize',12)
end
h.Position(2) = h.Position(2) -0.055;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WUv1LE.useCh)
    ch = WUv1LE.useCh(chNdx);
    
    pOri = WUv1LE.trData.ori_pref(ch);
    rfX  = WUv1LE.rfParams{ch}(1);
    rfY  = WUv1LE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,3);
    hold on
    axis square
    plot(WUv1LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,...
        'XTickLabel',[],'FontSize',10,'FontAngle','italic')
    title('FE','FontSize',12)
end
text(-2, 45,'V1','FontSize',12,'FontWeight','bold','FontAngle','italic')
text(-2.25, 100,'A1','FontSize',13,'FontWeight','bold','FontAngle','italic')
h.Position(2) = h.Position(2) -0.055;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(XTv4RE.useCh)
    ch = XTv4RE.useCh(chNdx);
    
    pOri = XTv4RE.trData.ori_pref(ch);
    rfX  = XTv4RE.rfParams{ch}(1);
    rfY  = XTv4RE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,2);
    hold on
    axis square
    plot(XTv4RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
    title('RE','FontSize',12)
end
h.Position(2) = h.Position(2) -0.015;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(XTv4LE.useCh)
    ch = XTv4LE.useCh(chNdx);
    
    pOri = XTv4LE.trData.ori_pref(ch);
    rfX  = XTv4LE.rfParams{ch}(1);
    rfY  = XTv4LE.rfParams{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    h = subplot(5,2,1);
    hold on
    axis square
    plot(XTv4LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,...
        'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
    title('LE','FontSize',12)
end
h.Position(2) = h.Position(2) -0.015;
text(-2, 45,'V4','FontSize',12,'FontWeight','bold','FontAngle','italic')
text(-2.25, 100,'Control','FontSize',13,'FontWeight','bold','FontAngle','italic')
% save figure
figDir = '/Users/brittany/Dropbox/Thesis/Glass/figures/conRadvOri';
if~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['allMonk','_conRadNdxVStrOriDiff_Grat'];
print(gcf, figName,'-dpdf','-bestfit')