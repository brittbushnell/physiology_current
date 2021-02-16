function plotGlassCR_dtdxByCh(conZs,radZs,nozZs,blankZ,goodCh,inStim,amap,subj)
%%
if contains(subj,'WU')
    if contains(amap.filename, '90') % v1
        cornerCh = 90;
        legendCh = 60;
        legendPos =[0.46 0.06 0.28917 0.023053];
    else
        cornerCh = 81;
        legendCh = 60;
        legendPos =[0.46 0.06 0.28917 0.023053];
    end
elseif contains(subj,'WV')
        if contains(amap.filename, '48') % v1
        cornerCh = 73;
        legendCh = 91;
        legendPos =[0.46 0.06 0.28917 0.023053];
    else
        cornerCh = 2;
        legendCh = 60;
        legendPos =[0.46 0.05 0.28917 0.023053];
        end
else
    if contains(amap.filename, '90') % v1
        cornerCh = 81;
        legendCh = 60;
        legendPos =[0.46 0.06 0.28917 0.023053];
    else
        cornerCh = 83;
        legendCh = 60;
        legendPos =[0.46 0.06 0.28917 0.023053];
    end
end
%%
uC = brewermap(4,'set1');
useColors =  [uC(1,:);uC(4,:);uC(2,:);uC(3,:)];

for ch = 1:96
    
    s = subplot(amap,10,10,ch);
    hold on
    
    c = squeeze(conZs(:,:,ch));
    c = reshape(c,[1,numel(c)]);
    
    d = squeeze(nozZs(:,:,ch));
    d = reshape(d,[1,numel(d)]);
    
    r = squeeze(radZs(:,:,ch));
    r = reshape(r,[1,numel(r)]);
    
    yy = [d c r blankZ(ch)];
    yy = reshape(yy,[1,numel(yy)]);
    y1 = max(yy);
    y2 = min(yy);
    y2 = abs(y2);
    yMax = (max(y1,y2))+ 0.25;
    
    yMax = round(yMax,1);
    ylim([-yMax,yMax])
    xlim([0.5 4.75])
    
    ndx = 1;
    for dt = 1:2
        for dx = 1:2
            con = squeeze(conZs(dt,dx,ch));
            rad = squeeze(radZs(dt,dx,ch));
            dip = squeeze(nozZs(dt,dx,ch));
            
            t = [dip con rad];
            if goodCh(ch) == 1 && inStim(ch) == 1
                line(2:4,t,'color',[useColors(ndx,:) 0.6],'LineWidth',0.25)
                scatter(2:4,t,5,'filled','MarkerFaceColor',useColors(ndx,:),'MarkerEdgeColor',useColors(ndx,:),...
                    'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
            else
                %                 plot(t,':','LineWidth',0.6,'color',useColors(ndx,:))
                scatter(2:4,t,8,'MarkerEdgeColor',useColors(ndx,:),'MarkerEdgeAlpha',0.5)
            end
            ndx = ndx+1;
        end
    end
    if goodCh(ch) == 1 && inStim(ch) == 1
        scatter(1,blankZ(ch),5,'filled','MarkerFaceColor','k','MarkerEdgeColor','k',...
            'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
    else
        scatter(1,blankZ(ch),6,'MarkerEdgeColor','k','MarkerEdgeAlpha',0.5)
    end
    t = title(ch,'FontSize',9);
    t.Position(2) = t.Position(2) - 0.05;
    set(gca,'tickdir','out','XTick',2:4,'XTickLabel',[],'FontSize',8.75,'FontAngle','italic','YTick',[-yMax,0,yMax],'TickLength',[0.035 0.09])
   
    s.Position(3) = 0.05;
    s.Position(4) = 0.046;
    
    if ch == legendCh
        l = legend('200, 0.16','','200, 0.24','','400, 0.16','','400, 0.24','','blank');
        l.Box = 'off';
        l.NumColumns = 5;
        l.LineWidth = 3;
        l.FontSize = 11.5;
        l.Position = legendPos;
    end
    
    if ch == cornerCh
        set(gca,'tickdir','out','XTick',1:4,'XTickLabel',{'blank','dipole','con','radial'},'TickLength',[0.035 0.09],'FontSize',8.5,'FontAngle','italic','YTick',[-yMax,0,yMax])
        xtickangle(90)
        ylabel('mean z score','FontSize',11);
        xlabel('stimulus','FontSize',11)
    end
    
end
