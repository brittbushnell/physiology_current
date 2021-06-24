% function [] = plotGlass_crNdxvsOriDiff_grat(V1data, V4data)
%%
[v1LEconRadNdx] = getGlassConRadSigPerm(V1data.LEsort(:,1:2),V1data.trLE.animal,'V1','LE');
[v1REconRadNdx] = getGlassConRadSigPerm(V1data.REsort(:,1:2),V1data.trRE.animal,'V1','RE');
[v4LEconRadNdx] = getGlassConRadSigPerm(V4data.LEsort(:,1:2),V4data.trLE.animal,'V4','LE');
[v4REconRadNdx] = getGlassConRadSigPerm(V4data.REsort(:,1:2),V4data.trRE.animal,'V4','RE');
%%
stimX = unique(V1data.trLE.pos_x);
stimY = unique(V1data.trLE.pos_y);
%% load gratings information
if contains(V1data.trLE.animal,'WU')
    if contains(V1data.trLE.array,'V1')
        gratLE = load('WU_LE_Gratings_nsp1_20170731_001_thresh35_ori_pref');
        gratRE = load('WU_RE_Gratings_nsp1_20170725_001_thresh35_ori_pref');
    else
        gratLE = load('WU_LE_Gratings_nsp2_20170731_001_thresh35_ori_pref');
        gratRE = load('WU_RE_Gratings_nsp2_20170725_001_thresh35_ori_pref');
    end
elseif contains(V1data.trLE.animal,'WV')
    if contains(V1data.trLE.array,'V1')
        %     gratLE = load('WV_LE_gratings_nsp1_20190510_002_thresh35_ori_pref');
        gratLE = load('WV_LE_gratings_nsp1_20190513_001_thresh35_ori_pref');
    else
        gratLE = load('WV_LE_gratings_nsp2_20190205_003_thresh35_ori_pref');
        gratRE = load('WV_RE_gratings_nsp2_20190205_002_thresh35_ori_pref');
    end
else
    graLE = load('XT_LE_Gratings_nsp2_20190131_002_thresh35_ori_pref');
    gratRE = load('XT_RE_Gratings_nsp2_20190321_001_thresh35_ori_pref');
end
%%
% for each eye:
% x-axis: conRad index
% y-axis: difference between preferred gratings ori and local concentric
% ori

figure%(1)
clf
hold on

pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 900])
s = suptitle (sprintf('%s orientation differences from gratings vs concentric radial indices',V1data.trLE.animal));
s.Position(2) = s.Position(2)+0.02;

for eye = 1%:2
    if eye == 1
        V1crData = V1data.conRadLE;
        V4crData = V4data.conRadLE;
        V1triMtx = V1data.LEsort;
        V4triMtx = V4data.LEsort;
        V1trData = gratLE;
        V4trData = gratLE;
        
        if contains(V1crData.animal,'XT')
            V1rfParamsOrig = V1data.chReceptiveFieldParamsBE;
            V4rfParamsOrig = V4data.chReceptiveFieldParamsBE;
        else
            V1rfParamsOrig = V1data.chReceptiveFieldParamsLE;
            V4rfParamsOrig = V4data.chReceptiveFieldParamsLE;
        end
    else
        V1crData = V1data.conRadRE;
        V4crData = V4data.conRadRE;
        V1triMtx = V1data.REsort;
        V4triMtx = V4data.REsort;
        V1trData = gratRE;
        V4trData = gratRE;
        
        if contains(V1crData.animal,'XT')
            V1rfParamsOrig = V1data.chReceptiveFieldParamsBE;
            V4rfParamsOrig = V4data.chReceptiveFieldParamsBE;
        else
            V1rfParamsOrig = V1data.chReceptiveFieldParamsRE;
            V4rfParamsOrig = V4data.chReceptiveFieldParamsRE;
        end
    end
    
    if contains(V1crData.animal,'XT')
        for ch = 1:96
            V1rfParamsRelGlassFix{ch}(1) = V1rfParamsOrig{ch}(1) + unique(V1crData.fix_x);
            V1rfParamsRelGlassFix{ch}(2) = V1rfParamsOrig{ch}(2) + unique(V1crData.fix_y);
            
            V4rfParamsRelGlassFix{ch}(1) = V4rfParamsOrig{ch}(1) + unique(V4crData.fix_x);
            V4rfParamsRelGlassFix{ch}(2) = V4rfParamsOrig{ch}(2) + unique(V4crData.fix_y);
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
    conAngV1 = nan(1,96);
    conAngV4 = nan(1,96);
    v1ndx = 1; v4ndx = 1;
    
    for ch = 1:96
        if V1crData.inStim(ch) == 1 && V1crData.goodCh(ch) == 1
            
            pOri = V1trData.ori_pref(ch);
            rfX  = V1rfParamsRelGlassFix{ch}(1);
            rfY  = V1rfParamsRelGlassFix{ch}(2);
            
            lLen = 0.5;
            x2 = rfX +(lLen*cos(pOri));
            y2 = rfY +(lLen*sin(pOri));
            
            x1 = rfX -(lLen*cos(pOri));
            y1 = rfY -(lLen*sin(pOri));
            
            vertex = [stimX;stimY];
            rfPts  = [rfX; rfY];
            horzEnd = [-stimX, stimY];
            
            x10 = rfX - stimX;
            y10 = rfY - stimY;
            x20 = -stimX - stimY;
            y20 = stimY -  rfY;
            radAng = rad2deg(atan2(abs(x10*y20-x20*y10),x10*y10+x20*y20));
            conAngV1(1,v1ndx) = radAng - 90;
        end
    if ~isnan(conAngV1(1,v1ndx))
    if eye == 1
        
        subplot(2,2,1)
        hold on
        
        plot(v1LEconRadNdx(v1ndx),conAngV1(1,v1ndx),'ob')
        plot([0 0], [-95 95],':k')
        plot([-95 95],[0 0],':k')
        
        
        xlim([-1.2 1.2])
        ylim([-90 90])
        
        set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',-90:30:90,'XTickLabel',{'radial','','','','no preference','','','','concentric'},'FontSize',10,'FontAngle','italic')
        
        if v1ndx == 1
            if contains(V1data.trLE.animal,'XT')
                title('LE','FontSize',12,'FontAngle','italic','FontWeight','bold')
            else
                title('FE','FontSize',12,'FontAngle','italic','FontWeight','bold')
            end
            
            
            text(-120, 0, 'V1','FontSize',12,'FontAngle','italic','FontWeight','bold')
        end
        ylabel('Local orientation relative to concentric','FontSize',11,'FontAngle','italic')
        xlabel('C-R/C+R','FontSize',11,'FontAngle','italic')
        v1ndx = v1ndx+1;
    else
        
    end
    end
    end
end