% subplot(3,2,1)
figure(1)
clf
hold on
axis square
ylabel('max |d''|')

if contains(REdata.animal,'XT')
    title('RE')
else
    title('FE')
end

xlim([-1 1])
ylim([0, yMax])
text( -2.3, (0+yMax)/2, 'RF4','FontSize',12,'FontWeight','bold')

for ch = 1:96
    if REdata.goodCh(ch)
        [y, maxAmp] = max(abs(REdata.stimCircDprime(1,:,ch)));
        x = REdata.stimCorrs(1,ch);
        dps(ch) = y;
        cors(ch) = x;
        dPrimeSig = squeeze(REdata.stimCircDprimeSig(1,maxAmp,ch));
        corrSig   = squeeze(REdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

dPmedian = nanmedian(dps);
corMedian = nanmedian(cors);

plot([-1 1], [dPmedian dPmedian],':k')
plot([corMedian corMedian], [0 yMax],':k')

text(-0.8, dPmedian+0.15, sprintf('median d'' %.2f',dPmedian))
text(corMedian-0.05,yMax-1.5, sprintf('median correlation %.2f',corMedian),'rotation',90)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)