close all
clc
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
%oris = rad2deg(oris);
%%

stimCorr = nan(numOris,numDots,numDxs);
noisCorr = nan(numDots,numDxs);

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 300])
set(gcf,'PaperOrientation','Landscape');
% suptitle({sprintf('%s %s %s orientation selectivity vs dPrime', dataT.animal, dataT.eye, dataT.array);...
%     'o: stimulus s: bipole '})
ndx = 1;
for dt = 1%:numDots
    for dx = 1%:numDxs
        
        dP = squeeze(dataT.linBlankDprime(:,end,dt,dx,:));
        no = squeeze(dataT.noiseBlankDprime(dt,dx,:));
        SI = squeeze(dataT.OriSelectIndex2thetaNoise(end,dt,dx,:));
        
        dpMax = max(dP(:));
        noMax = max(no(:));
        siMax = max(SI(:))+0.1;
        
        dpMax = max([dpMax, noMax])+0.25;
        
        dpMin = min(dP(:));
        noMin = min(no(:));
        
        dpMin = min([dpMin, noMin])-0.25;
        
        for or = 1:5 %numOris
            SI = squeeze(dataT.OriSelectIndex2thetaNoise(end,dt,dx,:));
            SI(isnan(SI)) = [];
            
            if or <= 4
                dP = squeeze(dataT.linBlankDprime(:,end,dt,dx,:));
                dPor(isnan(dPor)) = [];
                stimCorr(or,dt,dx) = corr2(dPor,SI');
                dPor = dP(or,:);
            else
                no = squeeze(dataT.noiseBlankDprime(dt,dx,:));
                no(isnan(no)) = [];
                noisCorr(dt,dx) = corr2(no,SI);
            end
            sp = subplot(1,5,ndx); %position = [left bottom width height]
            %sp.Position(1) = sp.Position(1)-0.02;
           sp.Position(2) = sp.Position(2)+0.015;
            %sp.Position(3) = sp.Position(3)+0.02;
            sp.Position(4) = sp.Position(4)-0.2;
            
            hold on
            ylim([0 siMax])
            xlim([dpMin dpMax])
            
            for ch = 1:96
                dPrime = dataT.linBlankDprime(:,end,dt,dx,ch);
                noise = dataT.noiseBlankDprime(dt,dx,ch);
                OSI = dataT.OriSelectIndex2thetaNoise(end,dt,dx,ch);
                
                if or == 5
                    scatter(noise,OSI,'s','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3,'MarkerFaceColor','k','MarkerEdgeColor','k');
                    if ch == 1
                        %text(dpMax-0.8,siMax-0.03,sprintf('r_G: %.2f',stimCorr(or,ch)),'FontSize',10)
                        text(dpMax-1.3,siMax-0.03,sprintf('r_b: %.2f',noisCorr(dt,dx)),'FontSize',10)
                        title('bipole')
                    end
                else
                    scatter(dPrime(ndx),OSI,'filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3,'MarkerFaceColor','k','MarkerEdgeColor','k');
                    if ch == 1
                        text(dpMax-1.3,siMax-0.03,sprintf('r_G: %.2f',stimCorr(or,dt,dx)),'FontSize',10)
                        title(oris(or))
                    end
                end
                %scatter(noise,OSI,'s','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3,'MarkerFaceColor','k','MarkerEdgeColor','k');
                %
                %                 if ch == 1
                %                     text(dpMax-0.8,siMax-0.03,sprintf('r_G: %.2f',stimCorr(or,ch)),'FontSize',10)
                %                     % text(dpMax-0.8,siMax-0.06,sprintf('r_b: %.2f',noisCorr(or,ch)),'FontSize',10)
                %                 end
                
                
                % axis square
                xlabel('dPrime vs Blank')
                if or == 1
                    ylabel('OSI')
                end
                set(gca,'box','off','tickdir','out')
            end
            ndx = ndx+1;
        end
        suptitle({sprintf('%s %s %s orientation selectivity vs dPrime', dataT.animal, dataT.eye, dataT.array);...
            'o: stimulus s: bipole '})
    end
end
%%
% figure(2)
% ndx = 1;
% for or = 1:numOris
%
%         subplot(2,2,ndx)
%         hold on
%         histogram(stimCorr(dt,dx
%
%
%        ndx = ndx+1;
%
% end