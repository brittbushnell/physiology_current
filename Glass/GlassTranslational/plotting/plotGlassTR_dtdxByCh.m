function plotGlassTR_dtdxByCh(dataZs,goodCh,inStim,amap)
%%
useColors = brewermap(4,'set1');

for ch = 1:96
    
    subplot(amap,10,10,ch)
    hold on
    
    yy = squeeze(dataZs(:,:,:,ch));
    yy = reshape(yy,[1,numel(yy)]);
    y1 = max(yy);
    y2 = min(yy);
    y2 = abs(y2);
    yMax = round(max(y1,y2),1)+0.1;
    
    ylim([-yMax,yMax])
    xlim([0.5 4.5])
    
    ndx = 1;
    for dt = 1:2
        for dx = 1:2    
            t =  squeeze(dataZs(:,dt,dx,ch));
            if goodCh(ch) == 1 && inStim(ch) == 1
                plot(t,'-o','LineWidth',0.6,'color',useColors(ndx,:),'MarkerSize',2.4,'MarkerFaceColor',useColors(ndx,:))
%                 plot(t,'.','MarkerSize',10,'color',useColors(ndx,:))
                title(ch)
            else
                plot(t,':','LineWidth',0.6,'color',useColors(ndx,:))
                title(ch)
            end
            ndx = ndx+1;
        end
        
        set(gca,'tickdir','out','XTick',1:4,'XTickLabel',[],'FontSize',9,'FontAngle','italic','YTick',[-yMax,0,yMax])
    end
    
    % if ch == 96 && goodCh(ch) == 1 && inStim(ch) == 1
    if ch == 63
        l = legend('200, 0.02','200, 0.03','400, 0.02','400, 0.03');
        l.Position(1) = l.Position(1) - 0.18;
         l.Position(2) = l.Position(2) - 0.15;
        l.Box = 'off';
        l.NumColumns = 2;
        l.LineWidth = 3;
        l.FontSize = 11.5;
    end
    
    if ch == 83
        ylabel('mean z score')
        xlabel('orientation')
    end    
end
