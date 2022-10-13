function plotRFarrayTuning(LEdata,REdata)
xLE = [0 1 0];
yLE = [0 1 1];
xRE = [0 1 1];
yRE = [0 0 1];

arrayInfo = [REdata.array,REdata.animal];
amap = getBlackrockArrayMap(arrayInfo);

numRE = REdata.numRFsSigHighAmp;
numLE = LEdata.numRFsSigHighAmp;

faceColors = [
    1 0.5 0.1;
    0 0.6 0.2;
    0.7 0 0.7];
%%
fg = figure(2);
clf
pos = fg.Position;
fg.Position = [pos(1) pos(2) 1200 1200];
% fg.InnerPosition = [60 1 1500 1500];

st = suptitle(sprintf('%s %s radial frequency tuning',REdata.animal, REdata.array));
st.Position(2) = st.Position(2) + 0.035;
% st.Position(1) = st.Position(1) - 0.05;
for ch = 1:96
    
    sp = subplot(amap,10,10,ch);
    sp.Position(3) = 0.065;
    sp.Position(4) = 0.065;
    hold on
    box off
    
    LE = numLE(ch);
    RE = numRE(ch);
    
    if LEdata.goodCh(ch)==1
        if LE == 0
%             patch(xLE,yLE,'w','EdgeColor','k','FaceColor','none')
        else
            patch(xLE,yLE,faceColors(LE,:),'FaceAlpha',0.5)
        end
    else
%         patch(xLE,yLE,'w','EdgeColor','k','FaceColor','none')
    end
    
    if REdata.goodCh(ch)==1
        if RE == 0
%             patch(xRE,yRE,'w','EdgeColor','k','FaceColor','none')
        else
            patch(xRE,yRE,faceColors(RE,:),'FaceAlpha',0.5)
        end
    else
%         patch(xRE,yRE,'w','EdgeColor','k','FaceColor','none')
    end
    
    %     title(ch)
    axis square
    axis off
    axis tight
    
end

%% save data

figDir = '~/Dropbox/posters/SfN/2022/figures/Radial/tuning/tuningMaps';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [REdata.animal,'_',REdata.array,'_tuningMapNoUntuned','.pdf'];
set(gcf,'PaperOrientation','landscape','InvertHardcopy','off','PaperSize',[6 6],'Color','w')
print(figure(2), figName,'-dpdf','-bestfit')

