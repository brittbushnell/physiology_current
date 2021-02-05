function plotGlassTR_dtdxByCh(dataZs,goodCh,inStim,amap,cornerCh)
%%
uC = brewermap(4,'set1');
useColors =  [uC(1,:);uC(4,:);uC(2,:);uC(3,:)]; 

for ch = 1:96
    
    subplot(amap,10,10,ch)
    hold on
    
    yy = squeeze(dataZs(:,:,:,ch));
    yy = reshape(yy,[1,numel(yy)]);
    y1 = max(yy);
    y2 = min(yy);
    y2 = abs(y2);
    yMax = round(max(y1,y2))+10;
    
    ylim([-yMax,yMax])
    xlim([0.5 5.5])
    
    ndx = 1;
    for dt = 1:2
        for dx = 1:2
            t =  squeeze(dataZs(:,dt,dx,ch));
            if goodCh(ch) == 1 && inStim(ch) == 1
                line(1:5,t,'color',[useColors(ndx,:) 0.6],'LineWidth',0.25)
                scatter(1:5,t,8,'filled','MarkerFaceColor',useColors(ndx,:),'MarkerEdgeColor',useColors(ndx,:),...
                    'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
                title(ch)
            else
                %                 plot(t,':','LineWidth',0.6,'color',useColors(ndx,:))
                scatter(1:5,t,8,'MarkerEdgeColor',useColors(ndx,:),'MarkerEdgeAlpha',0.5)
                title(ch)
            end
            ndx = ndx+1;
        end
        
        set(gca,'tickdir','out','XTick',1:5,'XTickLabel',[],'FontSize',8.5,'FontAngle','italic','YTick',[-yMax,0,yMax])
    end
    
    if ch == 94 %63
        l = legend('200, 0.02','','200, 0.03','','400, 0.02','','400, 0.03','');
        l.Position(1) = l.Position(1) - 0.18;
        l.Position(2) = l.Position(2) - 0.16;
        l.Box = 'off';
        l.NumColumns = 2;
        l.LineWidth = 3;
        l.FontSize = 11.5;
    end
    
    
    if ch == cornerCh
        ylabel('summed z score')
        xlabel('orientation')
        set(gca,'tickdir','out','XTick',1:5,'XTickLabel',{'dip','0','45','90','135'},'FontSize',9.5,'FontAngle','italic','YTick',[-yMax,0,yMax])
        xtickangle(30)
    end
end
