function plotGlass_CoherenceResps(dataT)
[~,numDots,numDxs,~,~,~,dots,dxs,coherences,~] = getGlassParameters(dataT);
coherences = coherences *100;
%%
con = squeeze(dataT.conNoiseDprime(:,end,end,:));
conSig = (squeeze(dataT.conNoiseDprimeSig(end,end,end,:)))';
conGood = con(:,(dataT.goodCh & conSig));

rad = squeeze(dataT.radNoiseDprime(:,end,end,:));
radSig = (squeeze(dataT.radNoiseDprimeSig(end,end,end,:)))';
radGood = rad(:,(dataT.goodCh & radSig));

figure(1)
clf

subplot(1,2,1)
hold on
plot(conGood,'o-k')

set(gca,'TickDir','out','XTick',1:4,'XTickLabel',coherences)
xlim([0.5 4.5])
ylim([-1 3])
ylabel('dPrime vs dipole')
xlabel('% coherence')
title('Concentric vs dipole')
text(0.8,2.9,sprintf('n: %d',sum(conSig)))

subplot(1,2,2)
hold on
plot(radGood,'o-k')
set(gca,'TickDir','out','XTick',1:4,'XTickLabel',coherences)
xlim([0.5 4.5])
ylim([-1 3])
xlabel('% coherence')
title('Radial vs dipole')
text(0.8,2.9,sprintf('n: %d',sum(radSig)))
suptitle(sprintf('%s %s %s dPrime vs noise as a function of coherence',dataT.animal, dataT.eye, dataT.array))
%%
if contains(dataT.animal,'WU')
    bottomRow = [81 83 85 88 90 92 93 96];
elseif contains(dataT.animal,'WV')
    bottomRow = [2 81 85 88 90 92 93 96 10 83];
else
    bottomRow = [81 83 85 88 90 92 93 96];
end


for dt = numDots
    for dx = numDxs
        figure
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1300 1000])
        set(gcf,'PaperOrientation','Landscape');
        for ch = 1:96
            if dataT.goodCh(ch) == 1
                
                subplot(dataT.amap,10,10,ch);
                hold on
                conCohResps = squeeze(dataT.conNoiseDprime(:,dt,dx,ch));
                if dataT.conNoiseDprimeSig(end,dt,dx,ch) ==1
                    plot(coherences,conCohResps,'.-','LineWidth',1.5,'color',[0.5,0,0.5,0.7])
                else
                  plot(coherences,conCohResps,'.:','LineWidth',1.5,'color',[0.5,0,0.5,0.7])  
                end
                
                radCohResps = squeeze(dataT.radNoiseDprime(:,dt,dx,ch));
                if dataT.radNoiseDprimeSig(end,dt,dx,ch) ==1
                    plot(coherences,radCohResps,'.-','LineWidth',1.5,'color',[0,0.6,0.2,0.7])
                else
                    plot(coherences,radCohResps,'.:','LineWidth',1.5,'color',[0,0.6,0.2,0.7])
                end
                
                title(ch)
                %                 xlabel('coherence')
                %                 ylabel('dPrime')
                xlim([15 110])
                %ylim([yMin yMax])
                ylim([-0.75 3])
                %axis square
                set(gca,'box','off')
                
                if intersect(bottomRow,ch)
                    set(gca,'XTick',0:25:100)%,'YScale','log')
                    xtickangle(45)
                else
                    set(gca,'XTick',[])
                end
            end
        end
        suptitle({sprintf('%s %s %s dPrime as a function of coherence dots %d dx %.2f',dataT.animal, dataT.eye, dataT.array,dots(dt),dxs(dx));...
            ('p: conVnoise  gn: radVnoise')})
        
        %figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_cohTuning_array_dots',num2str(dots(dt)),'_dx',num2str(dxs(dx)),'.pdf'];
        %print(gcf, figName,'-dpdf','-fillpage')
    end
end