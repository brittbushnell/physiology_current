
subplot(3,2,2)
hold on
axis square
ylabel('max |d''|')

if contains(REdata.animal,'XT')
    title('RE')
else
    title('FE')
end

xlim([-1 1])

for ch = 1:96
    if REdata.goodCh(ch)
        [y, maxAmp] = max(abs(REdata.stimCircDprime(1,:,ch)));
        x = REdata.stimCorrs(1,ch);
        
        dPrimeSig = squeeze(REdata.stimCircDprimeSig(1,maxAmp,ch));
        corrSig   = squeeze(REdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

subplot(3,2,4)
hold on
axis square
ylabel('max |d''|')

if contains(REdata.animal,'XT')
    title('RE')
else
    title('FE')
end

xlim([-1 1])

for ch = 1:96
    if REdata.goodCh(ch)
        [y, maxAmp] = max(abs(REdata.stimCircDprime(2,:,ch)));
        x = REdata.stimCorrs(1,ch);
        
        dPrimeSig = squeeze(REdata.stimCircDprimeSig(2,maxAmp,ch));
        corrSig   = squeeze(REdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[1 0.5 0.1], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

subplot(3,2,6)
hold on
axis square
ylabel('max |d''|')

if contains(REdata.animal,'XT')
    title('RE')
else
    title('FE')
end

xlim([-1 1])

for ch = 1:96
    if REdata.goodCh(ch)
        [y, maxAmp] = max(abs(REdata.stimCircDprime(3,:,ch)));
        x = REdata.stimCorrs(1,ch);
        
        dPrimeSig = squeeze(REdata.stimCircDprimeSig(3,maxAmp,ch));
        corrSig   = squeeze(REdata.stimCorrSig(1,ch));
        
        if dPrimeSig || corrSig
            scatter(x,y,'MarkerFaceColor',[0 0.6 0.2], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        else
            scatter(x,y,'MarkerFaceColor','none', 'MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
        end
    end
end

set(gca,'tickdir','out','FontAngle','italic','FontSize',10)