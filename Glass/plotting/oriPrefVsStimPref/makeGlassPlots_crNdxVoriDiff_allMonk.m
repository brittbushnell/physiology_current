function [] = makeGlassPlots_crNdxVoriDiff_allMonk(XTV4RE, XTV4LE, WUV1RE, WUV1LE, WUV4RE, WUV4LE, WVV1RE, WVV1LE, WVV4RE, WVV4LE)


%%
figure(2)
clf
hold on

pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 700, 900],'PaperSize',[7.5 10])
s = suptitle('Orientation differences from gratings vs concentric radial indices');
s.Position(2) = s.Position(2)+0.012;

% WV

for chNdx = 1:length(WVV4RE.useCh)
    ch = WVV4RE.useCh(chNdx);
    
    pOri = WVV4RE.trData.ori_pref(ch);
    rfX  = WVV4RE.rfParams{ch}(1);
    rfY  = WVV4RE.rfParams{ch}(2);
    
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
    plot(WVV4RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
    xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
end
h.Position(2) = h.Position(2) -0.035;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WVV4LE.useCh)
    ch = WVV4LE.useCh(chNdx);
    
    pOri = WVV4LE.trData.ori_pref(ch);
    rfX  = WVV4LE.rfParams{ch}(1);
    rfY  = WVV4LE.rfParams{ch}(2);
    
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
    plot(WVV4LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
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

for chNdx = 1:length(WVV1RE.useCh)
    ch = WVV1RE.useCh(chNdx);
    
    pOri = WVV1RE.trData.ori_pref(ch);
    rfX  = WVV1RE.rfParams{ch}(1);
    rfY  = WVV1RE.rfParams{ch}(2);
    
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
    plot(WVV1RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',[],'FontSize',10,'FontAngle','italic')
end
h.Position(2) = h.Position(2) - 0.055;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WVV1LE.useCh)
    ch = WVV1LE.useCh(chNdx);
    
    pOri = WVV1LE.trData.ori_pref(ch);
    rfX  = WVV1LE.rfParams{ch}(1);
    rfY  = WVV1LE.rfParams{ch}(2);
    
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
    plot(WVV1LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
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

for chNdx = 1:length(WUV4RE.useCh)
    ch = WUV4RE.useCh(chNdx);
    
    pOri = WUV4RE.trData.ori_pref(ch);
    rfX  = WUV4RE.rfParams{ch}(1);
    rfY  = WUV4RE.rfParams{ch}(2);
    
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
    plot(WUV4RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
end
h.Position(2) = h.Position(2) -0.03;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WUV4LE.useCh)
    ch = WUV4LE.useCh(chNdx);
    
    pOri = WUV4LE.trData.ori_pref(ch);
    rfX  = WUV4LE.rfParams{ch}(1);
    rfY  = WUV4LE.rfParams{ch}(2);
    
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
    plot(WUV4LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
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

for chNdx = 1:length(WUV1RE.useCh)
    ch = WUV1RE.useCh(chNdx);
    
    pOri = WUV1RE.trData.ori_pref(ch);
    rfX  = WUV1RE.rfParams{ch}(1);
    rfY  = WUV1RE.rfParams{ch}(2);
    
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
    plot(WUV1RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',[],'FontSize',10,'FontAngle','italic')
    title('AE','FontSize',12)
end
h.Position(2) = h.Position(2) -0.055;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(WUV1LE.useCh)
    ch = WUV1LE.useCh(chNdx);
    
    pOri = WUV1LE.trData.ori_pref(ch);
    rfX  = WUV1LE.rfParams{ch}(1);
    rfY  = WUV1LE.rfParams{ch}(2);
    
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
    plot(WUV1LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
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

for chNdx = 1:length(XTV4RE.useCh)
    ch = XTV4RE.useCh(chNdx);
    
    pOri = XTV4RE.trData.ori_pref(ch);
    rfX  = XTV4RE.rfParams{ch}(1);
    rfY  = XTV4RE.rfParams{ch}(2);
    
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
    plot(XTV4RE.conRadNdx(chNdx),oriDiff(1,ch),'or','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
    
    plot([0 0], [-95 95],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
    title('RE','FontSize',12)
end
h.Position(2) = h.Position(2) -0.015;
% h.Position(3) = h.Position(3) +0.01;
% h.Position(4) = h.Position(4) +0.01;

for chNdx = 1:length(XTV4LE.useCh)
    ch = XTV4LE.useCh(chNdx);
    
    pOri = XTV4LE.trData.ori_pref(ch);
    rfX  = XTV4LE.rfParams{ch}(1);
    rfY  = XTV4LE.rfParams{ch}(2);
    
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
    plot(XTV4LE.conRadNdx(chNdx),oriDiff(1,ch),'oc','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerSize',7)
    
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