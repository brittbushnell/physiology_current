function [] = makeGlassPlots_crNdxVoriDiff(trData, conRadNdx, useCh, rfParamsRelGlassFix, subNdx)
ndx = 1;

for chNdx = 1:length(useCh)
    ch = useCh(chNdx);
    
    pOri = trData.ori_pref(ch);
    rfX  = rfParamsRelGlassFix{ch}(1);
    rfY  = rfParamsRelGlassFix{ch}(2);
    
    hyp = sqrt(((rfX)^2)+((rfY)^2));
    sinThet = rfY/hyp;
    radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
    radAng = mod(radAng,180);
    cAng = (radAng - 90);  % 90 degrees off of the radial orientation
    
    oD(ch) = angdiff(cAng, pOri);
    oriDiff(1,ch) = mod(oD(ch),90); %oD(ch);
    
    
    subplot(2,2,subNdx)
    hold on
    if subNdx == 2 || subNdx == 4
        plot(conRadNdx(ndx),oriDiff(1,ch),'or')
    else
        plot(conRadNdx(ndx),oriDiff(1,ch),'ob')
    end
    plot([0 0], [-95 95],':k')
    plot([-95 95],[0 0],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
    ylabel('Local orientation relative to concentric','FontSize',11,'FontAngle','italic')
    xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
    
    ndx = ndx+1;
end

if subNdx == 1
    t = title('LE');
    t.Position(2) = t.Position(2) +0.01;
    text(-1.5, 45, 'V1','FontSize',12,'FontWeight','bold','FontAngle','italic')
elseif subNdx == 2
    t = title('RE');
    t.Position(2) = t.Position(2) +0.015;
elseif subNdx == 3
    text(-1.5, 45, 'V4','FontSize',12,'FontWeight','bold','FontAngle','italic')
end