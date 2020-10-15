function [] = plotGlass_CoherenceTuning(data)
[~,numDots,numDxs,numCoh,~,~,dots,dxs,coherences,~] = getGlassParameters(data.RE);
location = determineComputer;
%% 
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/stats/RE/coherenceTuning/',data.RE.animal,data.RE.programID,data.RE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/stats/RE/coherenceTuning/',data.RE.animal,data.RE.programID,data.RE.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)
%% RE plot coherences when stim v noise is significant
%NOTE: need to plot d' on a log scale, but also want to include negative values...
if contains(data.LE.animal,'WU')
    bottomRow = [81 83 85 88 90 92 93 96];
elseif contains(data.LE.animal,'WV')
    bottomRow = [2 81 85 88 90 92 93 96 10 83];
else
    bottomRow = [81 83 85 88 90 92 93 96];
end

cohs = coherences*100;
%% figure out y lims
% yMax
REconNoise = (data.RE.conNoiseDprime(:,:,:,data.RE.goodCh == 1));
REconNoiseMax = max(REconNoise(:));

REradNoise = (data.RE.radNoiseDprime(:,:,:,data.RE.goodCh == 1));
REradNoiseMax = max(REradNoise(:));

REconRad = (data.RE.conRadDprime(:,:,:,data.RE.goodCh == 1));
REconRadMax = max(REconRad(:));

LEconNoise = (data.LE.conNoiseDprime(:,:,:,data.LE.goodCh == 1));
LEconNoiseMax = max(LEconNoise(:));

LEradNoise = (data.LE.radNoiseDprime(:,:,:,data.LE.goodCh == 1));
LEradNoiseMax = max(LEradNoise(:));

LEconRad = (data.LE.conRadDprime(:,:,:,data.LE.goodCh == 1));
LEconRadMax = max(LEconRad(:));

yMax = round(max([REconNoiseMax, REradNoiseMax, REconRadMax,LEconNoiseMax, LEradNoiseMax, LEconRadMax]))+0.5;

% yMin
REconNoise = (data.RE.conNoiseDprime(:,:,:,data.RE.goodCh == 1));
REconNoiseMin = min(REconNoise(:));

REradNoise = (data.RE.radNoiseDprime(:,:,:,data.RE.goodCh == 1));
REradNoiseMin = min(REradNoise(:));

REconRad = (data.RE.conRadDprime(:,:,:,data.RE.goodCh == 1));
REconRadMin = min(REconRad(:));

LEconNoise = (data.LE.conNoiseDprime(:,:,:,data.LE.goodCh == 1));
LEconNoiseMin = min(LEconNoise(:));

LEradNoise = (data.LE.radNoiseDprime(:,:,:,data.LE.goodCh == 1));
LEradNoiseMin = min(LEradNoise(:));

LEconRad = (data.LE.conRadDprime(:,:,:,data.LE.goodCh == 1));
LEconRadMin = min(LEconRad(:));

yMin = round(min([REconNoiseMin, REradNoiseMin, REconRadMin,LEconNoiseMin, LEradNoiseMin, LEconRadMin]))-0.5;
%% plot coherences across the whole array RE
for dt = 1:numDots
    for dx = 1:numDxs
        figure
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1000 800])
        set(gcf,'PaperOrientation','Landscape');
        for ch = 1:96
            if data.RE.goodCh(ch) == 1
                
                subplot(data.RE.amap,10,10,ch);
                hold on
                conCohResps = squeeze(data.RE.conNoiseDprime(:,dt,dx,ch));
                plot(cohs,conCohResps,'-','LineWidth',1.5,'color',[0.5,0,0.5,0.7])
                
                radCohResps = squeeze(data.RE.radNoiseDprime(:,dt,dx,ch));
                plot(cohs,radCohResps,'-','LineWidth',1.5,'color',[0,0.6,0.2,0.7])
                
                conRadResps = (squeeze(data.RE.conRadDprime(:,dt,dx,ch)));
                plot(cohs,conRadResps,'-','LineWidth',1.5,'color',[0.5,0.5,0.5,0.7])
                
                title(ch)
                %                 xlabel('coherence')
                %                 ylabel('dPrime')
                xlim([0 125])
                ylim([yMin yMax])
                %axis square
                set(gca,'box','off')
                
                if intersect(bottomRow,ch)
                    set(gca,'XTick',0:25:100)%,'YScale','log')
                    xtickangle(45)
                    xlabel('coherence')
                else
                    set(gca,'XTick',[])
                end
            end
        end
        suptitle({sprintf('%s %s %s coherence responses dots %d dx %.2f',data.RE.animal, data.RE.eye, data.RE.array,dots(dt),dxs(dx));...
            ('p: conVnoise  gn: radVnoise  gy: conVsRad')})
        
        figName = [data.RE.animal,'_',data.RE.eye,'_',data.RE.array,'_',data.RE.programID,'_cohTuning_array_dots',num2str(dots(dt)),'_dx',num2str(dxs(dx)),'.pdf'];
        print(gcf, figName,'-dpdf','-fillpage')
    end
end
%%
% for ch = 1:96
%     if data.RE.goodCh(ch) == 1
%         figure(15)
%         pos = get(gcf,'Position');
%         set(gcf,'Position',[pos(1) pos(2) 600 400])
%         for dt = 1:numDots
%             for dx = 1:numDxs
%                 
%                 nsubplot(2,2,dt,dx);
%                 hold on
%                 conCohResps = squeeze(data.RE.conNoiseDprime(:,dt,dx,ch));
%                 plot(cohs,conCohResps,'-','LineWidth',1.5,'color',[0.5,0,0.5,0.7])
%                 
%                 radCohResps = squeeze(data.RE.radNoiseDprime(:,dt,dx,ch));
%                 plot(cohs,radCohResps,'-','LineWidth',1.5,'color',[0,0.6,0.2,0.7])
%                 
%                 conRadResps = (squeeze(data.RE.conRadDprime(:,dt,dx,ch)));
%                 plot(cohs,conRadResps,'-','LineWidth',1.5,'color',[0.5,0.5,0.5,0.7])
%                 
%                 title(sprintf('dots %d dx %.2f',dots(dt),dxs(dx)))
%                 xlabel('coherence')
%                 ylabel('dPrime')
%                 xlim([0 125])
%                 ylim([yMin yMax])
%                 axis square
%                 set(gca,'box','off')
%                 
%                 set(gca,'XTick',0:25:100)
%                 xtickangle(45)
%                 
%             end
%         end
%         suptitle({sprintf('%s %s %s coherence responses ch %d',data.RE.animal, data.RE.eye, data.RE.array,ch);...
%             ('p: conVnoise  gn: radVnoise  gy: conVsRad')})
%         
%         figName = [data.RE.animal,'_RE_',data.RE.array,'_',data.RE.programID,'_cohTuning_ch',num2str(ch),'.pdf'];
%         print(gcf, figName,'-dpdf','-fillpage')
%     end
% end
%% plot coherences across the whole array LE
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/stats/LE/coherenceTuning/',data.RE.animal,data.RE.programID,data.RE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/stats/LE/coherenceTuning/',data.RE.animal,data.RE.programID,data.RE.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)

%%
for dt = 1:numDots
    for dx = 1:numDxs
        figure
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1000 800])
        set(gcf,'PaperOrientation','Landscape');
        for ch = 1:96
            if data.LE.goodCh(ch) == 1
                
                subplot(data.LE.amap,10,10,ch);
                hold on
                conCohResps = squeeze(data.LE.conNoiseDprime(:,dt,dx,ch));
                plot(cohs,conCohResps,'.-','LineWidth',1.5,'color',[0.5,0,0.5,0.7])
                
                radCohResps = squeeze(data.LE.radNoiseDprime(:,dt,dx,ch));
                plot(cohs,radCohResps,'.-','LineWidth',1.5,'color',[0,0.6,0.2,0.7])
                
                conRadResps = (squeeze(data.LE.conRadDprime(:,dt,dx,ch)));
                plot(cohs,conRadResps,'.-','LineWidth',1.5,'color',[0.5,0.5,0.5,0.7])
                
                title(ch)
                %                 xlabel('coherence')
                %                 ylabel('dPrime')
                xlim([0 125])
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
        suptitle({sprintf('%s %s %s coherence responses dots %d dx %.2f',data.LE.animal, data.LE.eye, data.LE.array,dots(dt),dxs(dx));...
            ('p: conVnoise  gn: radVnoise  gy: conVsRad')})
        
        %figName = [data.LE.animal,'_',data.LE.eye,'_',data.LE.array,'_',data.LE.programID,'_cohTuning_array_dots',num2str(dots(dt)),'_dx',num2str(dxs(dx)),'.pdf'];
        %print(gcf, figName,'-dpdf','-fillpage')
    end
end
%%
% for ch = 1:96
%     if data.LE.goodCh(ch) == 1
%         figure(15)
%         pos = get(gcf,'Position');
%         set(gcf,'Position',[pos(1) pos(2) 600 400])
%         for dt = 1:numDots
%             for dx = 1:numDxs
%                 
%                 nsubplot(2,2,dt,dx);
%                 hold on
%                 conCohResps = squeeze(data.LE.conNoiseDprime(:,dt,dx,ch));
%                 plot(cohs,conCohResps,'-','LineWidth',1.5,'color',[0.5,0,0.5,0.7])
%                 
%                 radCohResps = squeeze(data.LE.radNoiseDprime(:,dt,dx,ch));
%                 plot(cohs,radCohResps,'-','LineWidth',1.5,'color',[0,0.6,0.2,0.7])
%                 
%                 conRadResps = (squeeze(data.LE.conRadDprime(:,dt,dx,ch)));
%                 plot(cohs,conRadResps,'-','LineWidth',1.5,'color',[0.5,0.5,0.5,0.7])
%                 
%                 title(sprintf('dots %d dx %.2f',dots(dt),dxs(dx)))
%                 xlabel('coherence')
%                 ylabel('dPrime')
%                 xlim([0 125])
%                 ylim([yMin yMax])
%                 axis square
%                 set(gca,'box','off')
%                 
%                 set(gca,'XTick',0:25:100)
%                 xtickangle(45)
%                 
%             end
%         end
%         suptitle({sprintf('%s %s %s coherence responses ch %d',data.LE.animal, data.LE.eye, data.LE.array,ch);...
%             ('p: conVnoise  gn: radVnoise  gy: conVsRad')})
%         
%         figName = [data.LE.animal,'_LE_',data.LE.array,'_',data.LE.programID,'_cohTuning_ch',num2str(ch),'.pdf'];
%         print(gcf, figName,'-dpdf','-fillpage')
%     end
% end