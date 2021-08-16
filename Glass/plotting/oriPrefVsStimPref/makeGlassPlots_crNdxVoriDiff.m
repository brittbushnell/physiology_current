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
    
    oD = angdiff(cAng, pOri);
    oriDiff = mod(oD,90); %oD(ch);
    
    isEven = rem(subNdx/2,1);
    
%     subplot(5,2,subNdx)
    
    hold on
    axis square
    if isEven == 0
        scatter(conRadNdx(chNdx),oriDiff,30,'o','MarkerFaceColor','r','MarkerEdgeColor','w','LineWidth',0.5)
    else
        scatter(conRadNdx(chNdx),oriDiff,30,'o','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','LineWidth',0.5)
    end
    plot([0 0], [-95 95],':k')
    plot([-95 95],[0 0],':k')
    
    xlim([-1 1])
    ylim([0 90])
    
    set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',0:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
    if subNdx == 5
        ylabel('Local orientation relative to concentric','FontSize',11,'FontAngle','italic')
    end
    if subNdx >= 9
        xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
    end
    
    ndx = ndx+1;
    clear oD oriDiff
end
%%
if subNdx == 1
    t = title('LE');
    t.Position(2) = t.Position(2) +0.01;
    text(-1.5, 45, 'V4','FontSize',12,'FontWeight','bold','FontAngle','italic')
elseif subNdx == 2
    t = title('RE');
    t.Position(2) = t.Position(2) +0.015;
elseif subNdx == 3
    t = title('FE');
    t.Position(2) = t.Position(2) +0.01;
    text(-1.5, 45, 'V1','FontSize',12,'FontWeight','bold','FontAngle','italic')
elseif subNdx == 4
    t = title('AE');
    t.Position(2) = t.Position(2) +0.01;
elseif subNdx == 5
    text(-1.5, 45, 'V4','FontSize',12,'FontWeight','bold','FontAngle','italic')    
end

if subNdx == 7
    keyboard
end


