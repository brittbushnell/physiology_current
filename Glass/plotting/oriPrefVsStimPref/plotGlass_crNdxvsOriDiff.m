function [] = plotGlass_crNdxvsOriDiff(V1data, V4data)

[v1LEconRadNdx] = getGlassConRadSigPerm(V1data.LEsort(:,1:2),V1data.trLE.animal,'V1','LE');
[v1REconRadNdx] = getGlassConRadSigPerm(V1data.REsort(:,1:2),V1data.trRE.animal,'V1','RE');
[v4LEconRadNdx] = getGlassConRadSigPerm(V4data.LEsort(:,1:2),V4data.trLE.animal,'V4','LE');
[v4REconRadNdx] = getGlassConRadSigPerm(V4data.REsort(:,1:2),V4data.trRE.animal,'V4','RE');
%%
% stimX = unique(V1data.trLE.pos_x);
% stimY = unique(V1data.trLE.pos_y);
%%
% for each eye:
% x-axis: conRad index

figure%(1)
clf
hold on

pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 900])
s = suptitle (sprintf('%s orientation differences using translational patterns vs concentric radial indices',V1data.trLE.animal));
s.Position(2) = s.Position(2)+0.02;

for eye = 1:2
    if eye == 1
        V1trData = V1data.trLE;
        V4trData = V4data.trLE;
        V1crData = V1data.conRadLE;
        V4crData = V4data.conRadLE;
    else
        V1trData = V1data.trRE;
        V4trData = V4data.trRE;
        V1crData = V1data.conRadRE;
        V4crData = V4data.conRadRE;
    end
    
    if contains(V1trData.animal,'XT')
        V1rfParamsOrig = V1trData.chReceptiveFieldParamsBE;
        V4rfParamsOrig = V4trData.chReceptiveFieldParamsBE;
    else
        V1rfParamsOrig = V1trData.chReceptiveFieldParams;
        V4rfParamsOrig = V4trData.chReceptiveFieldParams;
    end
    % for XT, move receptive field locations to be in same coordinate space as Glass fixation
    if contains(V1trData.animal,'XT')
        for ch = 1:96
            V1rfParamsRelGlassFix{ch}(1) = V1rfParamsOrig{ch}(1) + unique(V1trData.fix_x);
            V1rfParamsRelGlassFix{ch}(2) = V1rfParamsOrig{ch}(2) + unique(V1trData.fix_y);
            
            V4rfParamsRelGlassFix{ch}(1) = V4rfParamsOrig{ch}(1) + unique(V4trData.fix_x);
            V4rfParamsRelGlassFix{ch}(2) = V4rfParamsOrig{ch}(2) + unique(V4trData.fix_y);
        end
    else
        for ch = 1:96
            V1rfParamsRelGlassFix{ch}(1) = V1rfParamsOrig{ch}(1);
            V1rfParamsRelGlassFix{ch}(2) = V1rfParamsOrig{ch}(2);
            
            V4rfParamsRelGlassFix{ch}(1) = V4rfParamsOrig{ch}(1);
            V4rfParamsRelGlassFix{ch}(2) = V4rfParamsOrig{ch}(2);
        end
    end
    %%
    oriDiffV1 = nan(1,96);
    oriDiffV4 = nan(1,96);
    v1ndx = 1; v4ndx = 1;
    for ch = 1:96
        if V1trData.goodCh(ch) == 1 && V1trData.inStim(ch) == 1 && V1crData.inStim(ch) == 1 && V1crData.goodCh(ch) == 1
            
            pOri = (V1trData.prefParamsPrefOri(ch));
            rfX  = V1rfParamsRelGlassFix{ch}(1);
            rfY  = V1rfParamsRelGlassFix{ch}(2);            
            
            hyp = sqrt(((rfX)^2)+((rfY)^2));
            sinThet = rfY/hyp;
            radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
            radAng = mod(radAng,180);
            cAng = (radAng - 90);  % 90 degrees off of the radial orientation
            
            oD(ch) = angdiff(cAng, pOri);
            oriDiffV1(1,ch) = mod(oD(ch),90); %oD(ch);

            if eye == 1
                
                subplot(2,2,1)
                hold on
                
                plot(v1LEconRadNdx(v1ndx),oriDiffV1(ch),'ob')
                plot([0 0], [0 90],':k')
                plot([0 90],[0 0],':k')
                            
                xlim([-1.2 1.2])
                ylim([0 92])
                
                set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',-90:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
                
                if v1ndx == 1
                    if contains(V1data.trLE.animal,'XT')
                        title('LE','FontSize',12,'FontAngle','italic','FontWeight','bold')
                    else
                        title('FE','FontSize',12,'FontAngle','italic','FontWeight','bold')
                    end
                    
                    
                    text(-1.8, 45, 'V1','FontSize',12,'FontAngle','italic','FontWeight','bold')
                end
                ylabel('Local orientation relative to concentric','FontSize',11,'FontAngle','italic')
                xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
                v1ndx = v1ndx+1;
            else
                subplot(2,2,2)
                hold on
                
                plot(v1REconRadNdx(v1ndx),oriDiffV1(ch),'or')
                plot([0 0], [0 90],':k')
                plot([0 90],[0 0],':k')
                
                xlim([-1.2 1.2])
                ylim([0 92])
                if v1ndx == 1
                    if contains(V1data.trLE.animal,'XT')
                        title('RE','FontSize',12,'FontAngle','italic','FontWeight','bold')
                    else
                        title('AE','FontSize',12,'FontAngle','italic','FontWeight','bold')
                    end
                end
                
                ylabel('Local orientation relative to concentric','FontSize',11,'FontAngle','italic')
                xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
                set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',-90:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
                v1ndx = v1ndx+1;
            end
            clear radAng cAng
        end
        
        if V4trData.goodCh(ch) == 1 && V4trData.inStim(ch) == 1 && V4crData.inStim(ch) == 1 && V4crData.goodCh(ch) == 1
                       
            pOri = (V4trData.prefParamsPrefOri(ch));
            rfX  = V4rfParamsRelGlassFix{ch}(1);
            rfY  = V4rfParamsRelGlassFix{ch}(2);            
            
            hyp = sqrt(((rfX)^2)+((rfY)^2));
            sinThet = rfY/hyp;
            radAng  = asind(sinThet);% the angle of the line from fixation to the center of the receptive field is the same as the dot pairs in a radial pattern
            radAng  = mod(radAng,180); 
            cAng = (radAng - 90);  % 90 degrees off of the radial orientation
            
            oD(ch) =angdiff(cAng, pOri);
            oriDiffV4(1,ch) = mod(oD(ch),90); %oD(ch);
            
            if eye == 1
                subplot(2,2,3)
                hold on
                
                plot(v4LEconRadNdx(v4ndx),oriDiffV4(ch),'ob')
                plot([0 0], [0 90],':k')
                plot([0 90],[0 0],':k')
                
                xlim([-1.2 1.2])
                ylim([0 92])
                if v4ndx == 1
                    text(-1.8, 45, 'V4','FontSize',12,'FontAngle','italic','FontWeight','bold')
                end
                set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',-90:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
                ylabel('Local orientation relative to concentric','FontSize',11,'FontAngle','italic')
                xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
                v4ndx = v4ndx+1;
            else
                subplot(2,2,4)
                hold on
                
                plot(v4REconRadNdx(v4ndx),oriDiffV4(ch),'or')
                plot([0 0], [0 90],':k')
                plot([0 90],[0 0],':k')
                
                xlim([-1.2 1.2])
                ylim([0 92])
                set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',-90:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
                ylabel('Local orientation relative to concentric','FontSize',11,'FontAngle','italic')
                xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
                v4ndx = v4ndx+1;
            end
             clear radAng cAng
        end
    end
    if eye == 1
        LEoriDiffV1 = oriDiffV1;
        LEoriDiffV4 = oriDiffV4;
    else
        REoriDiffV1 = oriDiffV1;
        REoriDiffV4 = oriDiffV4;
    end
end
%% save figure
figDir =  sprintf('~/Dropbox/Figures/%s/Glass/stats/conRadNdx/',V1data.trLE.animal);
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [V1data.trLE.animal,'_conRadNdxVStrOriDiff'];
print(gcf, figName,'-dpdf','-bestfit')
%%
figure%(4)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1100 600],'PaperOrientation','landscape')

suptitle(sprintf('%s distribution of local orientations relative to concentric',V1data.trLE.animal));


LElowNdx = v1LEconRadNdx < 0;
LEhiNdx  = v1LEconRadNdx > 0;

LElow = LEoriDiffV1((LElowNdx));
LEhi  = LEoriDiffV1((LEhiNdx));


h = subplot(2,4,1);
hold on
histogram(LElow,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',10)
xlim([-5 95])
ylim([0 0.5])
set(gca,'XTick', 0:10:90,'TickDir','out','layer','top')
ylabel('probability','FontSize',11,'FontAngle','italic')
title('Channels in radial half','FontSize',12,'FontWeight','bold','FontAngle','italic')
h.Position(4) = h.Position(4) - 0.12;
h.Position(3) = h.Position(3) + 0.03;
h.Position(1) = h.Position(1) - 0.04;

if contains(V1data.trLE.animal,'XT')
    text(110, 0.65,'LE','FontSize',12,'FontWeight','bold')
else
    text(110, 0.65,'FE','FontSize',12,'FontWeight','bold')
end

text(-170,0.25','V1','FontSize',12,'FontWeight','bold')
text(0,0.45,sprintf('n %d',length(LElow)))

h = subplot(2,4,2);
hold on
histogram(LEhi,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',10)
xlim([-5 95])
ylim([0 0.5])
set(gca,'XTick', 0:10:90,'TickDir','out','layer','top')
title('Channels in con half','FontSize',12,'FontWeight','bold','FontAngle','italic')
h.Position(4) = h.Position(4) - 0.12;
h.Position(3) = h.Position(3) + 0.03;
h.Position(1) = h.Position(1) - 0.027;
text(0,0.45,sprintf('n %d',length(LEhi)))

RElowNdx = v1REconRadNdx < 0;
REhiNdx  = v1REconRadNdx > 0;

RElow = REoriDiffV1(RElowNdx);
REhi  = REoriDiffV1(REhiNdx);


h = subplot(2,4,4);
hold on
histogram(REhi,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',10)
xlim([-5 95])
ylim([0 0.5])
set(gca,'XTick', 0:10:90,'TickDir','out','layer','top')
title('Channels in con half','FontSize',12,'FontWeight','bold','FontAngle','italic')
h.Position(4) = h.Position(4) - 0.12;
h.Position(3) = h.Position(3) + 0.03;
h.Position(1) = h.Position(1) + 0.03;
text(0,0.45,sprintf('n %d',length(REhi)))

h = subplot(2,4,3);
hold on
histogram(RElow,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',10)
xlim([-5 95])
ylim([0 0.5])
set(gca,'XTick', 0:10:90,'TickDir','out','layer','top')
title('Channels in radial half','FontSize',12,'FontWeight','bold','FontAngle','italic')
h.Position(4) = h.Position(4) - 0.12;
h.Position(3) = h.Position(3) + 0.03;
h.Position(1) = h.Position(1) + 0.02;

if contains(V1data.trLE.animal,'XT')
    text(110, 0.65,'RE','FontSize',12,'FontWeight','bold')
else
    text(110, 0.65,'AE','FontSize',12,'FontWeight','bold')
end
text(0,0.45,sprintf('n %d',length(RElow)))

clear RElowNdx; clear RElow;
clear REhiNdx;  clear REhi;

clear LElowNdx; clear LElow;
clear LEhiNdx;  clear LEhi;

LElowNdx = v4LEconRadNdx < 0;
LEhiNdx  = v4LEconRadNdx > 0;

LElow = LEoriDiffV4(LElowNdx);
LEhi  = LEoriDiffV4(LEhiNdx);


h = subplot(2,4,5);
hold on
histogram(LElow,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',10)
xlim([-5 95])
ylim([0 0.5])
set(gca,'XTick', 0:10:90,'TickDir','out','layer','top')
ylabel('probability','FontSize',11,'FontAngle','italic')
h.Position(4) = h.Position(4) - 0.12;
h.Position(3) = h.Position(3) + 0.03;
h.Position(2) = h.Position(2) + 0.05;
h.Position(1) = h.Position(1) - 0.04;

text(0,0.45,sprintf('n %d',length(LElow)))
text(-170,0.25','V4','FontSize',12,'FontWeight','bold')
t = xlabel('Local concentric orientation vs translational pref orientation','FontAngle','italic','FontSize',11);
t.Position(1) = t.Position(1)+80;
t.Position(2) = t.Position(2)-0.05;

h = subplot(2,4,6);
hold on
histogram(LEhi,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',10)
xlim([-5 95])
ylim([0 0.5])
set(gca,'XTick', 0:10:90,'TickDir','out','layer','top')
h.Position(4) = h.Position(4) - 0.12;
h.Position(3) = h.Position(3) + 0.03;
h.Position(2) = h.Position(2) + 0.05;
h.Position(1) = h.Position(1) - 0.027;
text(0,0.45,sprintf('n %d',length(LEhi)))

RElowNdx = v4REconRadNdx < 0;
REhiNdx  = v4REconRadNdx > 0;

RElow = REoriDiffV4(RElowNdx);
REhi  = REoriDiffV4(REhiNdx);

h = subplot(2,4,8);
hold on
histogram(REhi,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',10)
xlim([-5 95])
ylim([0 0.5])
set(gca,'XTick', 0:10:90,'TickDir','out','layer','top')
text(0,0.45,sprintf('n %d',length(REhi)))

h.Position(4) = h.Position(4) - 0.12;
h.Position(3) = h.Position(3) + 0.03;
h.Position(2) = h.Position(2) + 0.05;
h.Position(1) = h.Position(1) + 0.03;

h = subplot(2,4,7);
hold on
histogram(RElow,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',10)
xlim([-5 95])
ylim([0 0.5])
set(gca,'XTick', 0:10:90,'TickDir','out','layer','top')
text(0,0.45,sprintf('n %d',length(RElow)))

h.Position(4) = h.Position(4) - 0.12;
h.Position(3) = h.Position(3) + 0.03;
h.Position(2) = h.Position(2) + 0.05;
h.Position(1) = h.Position(1) + 0.02;
t = xlabel('Local concentric orientation vs translational pref orientation','FontAngle','italic','FontSize',11);
t.Position(1) = t.Position(1)+80;
t.Position(2) = t.Position(2)-0.05;
%%
figName = [V1data.trLE.animal,'_conRadNdxVStrOri_dist'];    
print(gcf, figName,'-dpdf','-bestfit')