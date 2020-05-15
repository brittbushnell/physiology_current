function [] = plotGlassTR_OSI_eyeComps(data)

[numOris,numDots,numDxs,numCoh,numSamp,oris,dots,dxs,coherences,samples] = getGlassTRParameters(data.RE);
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/EyeComps/scatter/',data.RE.animal, data.RE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/EyeComps/scatter/',data.RE.animal, data.RE.array);
end

cd(figDir)
% go to date specific folder, if it doesn't exist, make it
folder = data.RE.date2;
mkdir(folder)
cd(sprintf('%s',folder))
%% RE
figure(12)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1200])
set(gcf,'PaperOrientation','Landscape');

tmpRE = squeeze(data.RE.OriSelectIndex2thetaNoise(end,:,:,data.RE.goodCh == 1));
SImaxRE = max(tmpRE(:));
%SImaxRE = SImaxRE+0.05;

tmpLE = squeeze(data.LE.OriSelectIndex2thetaNoise(end,:,:,data.LE.goodCh == 1));
SImaxLE = max(tmpLE(:));
%SImaxLE = SImaxLE+0.05;

SImax = max([SImaxRE, SImaxLE]);


ndx = 1;
for dt = 1:numDots
    for dx = 1:numDxs
        
        SIR = squeeze(data.RE.OriSelectIndex2thetaNoise(end,dt,dx,:));
        SIR(isnan(SIR)) = 0;
        bfr = ones(size(SIR,1),1); % vector of ones for linear regression
        SIRmtx = [bfr,SIR];
        
        SIL = squeeze(data.LE.OriSelectIndex2thetaNoise(end,dt,dx,:));
        SIL(isnan(SIL)) = 0;
        SILmtx = [bfr,SIL];
        
        [~,~,resids,~,regStats] = regress(SIR,SILmtx);
        cor = corr2(SIR,SIL);
        
        if numDots == 2
            subplot(2,2,ndx);
        else
            subplot(3,3,ndx);
        end
        
        hold on
        
        scatter(SIR,SIL,45,'k','filled','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        plot([0 SImax], [0 SImax],'k:')
        
        text(SImax-0.07,SImax-0.03,sprintf('R: %.2f',cor),'FontSize',12);
        text(SImax-0.07,SImax-0.05,sprintf('R^2: %.2f  p: %.2f', regStats(1),regStats(3)),'FontSize',12);
        
        xlim([0 SImax])
        ylim([0 SImax])
        set(gca,'tickdir', 'out','Layer','top','XTick',0:0.1:round(SImax,1),'YTick',0:0.1:round(SImax,1))
        
        
        if numDots == 2
            if ndx == 1
                if contains(data.RE.animal,'XT')
                    ylabel('OSI LE','FontSize',12,'FontAngle','italic')
                else
                    ylabel('OSI FE','FontSize',12,'FontAngle','italic')
                end
            elseif ndx == 3
                if contains(data.RE.animal,'XT')
                    ylabel('OSI LE','FontSize',12,'FontAngle','italic')
                    xlabel('OSI RE','FontSize',12,'FontAngle','italic')
                else
                    ylabel('OSI FE','FontSize',12,'FontAngle','italic')
                    xlabel('OSI AE','FontSize',12,'FontAngle','italic')
                end
            elseif ndx == 4
                if contains(data.RE.animal,'XT')
                    xlabel('OSI RE','FontSize',12,'FontAngle','italic')
                else
                    xlabel('OSI AE','FontSize',12,'FontAngle','italic')
                end
            end
        end
        
        ndx = ndx+1;
        
    end
end
suptitle({sprintf('%s %s distribution of orientation selectivity indices by parameter 100%% coherence',data.RE.animal, data.RE.array);...
    sprintf('%s run %s',data.RE.date,data.RE.runNum)});


text(-0.68,0.78,'200 dots','FontSize',14,'FontWeight','bold');
text(-0.68,0.21,'400 dots','FontSize',14,'FontWeight','bold');

text(-0.4,1,'dx 0.02','FontSize',14,'FontWeight','bold');
text(0.2,1,'dx 0.03','FontSize',14,'FontWeight','bold');


figName = [data.RE.animal,'_',data.RE.array,'_BE_OSIscatter_byParam','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
