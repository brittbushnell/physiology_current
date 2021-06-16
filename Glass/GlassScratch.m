[v1LEconRadNdx] = getGlassConRadSigPerm(V1data.LEsort(:,1:2),V1data.trLE.animal,'V1','LE');
[v1REconRadNdx] = getGlassConRadSigPerm(V1data.REsort(:,1:2),V1data.trRE.animal,'V1','RE');
[v4LEconRadNdx] = getGlassConRadSigPerm(V4data.LEsort(:,1:2),V4data.trLE.animal,'V4','LE');
[v4REconRadNdx] = getGlassConRadSigPerm(V4data.REsort(:,1:2),V4data.trRE.animal,'V4','RE');
%%
stimX = unique(V1data.trLE.pos_x);
stimY = unique(V1data.trLE.pos_y);
%%
% for each eye:
% x-axis: conRad index
% y-axis: angular difference between preferred and expected oris
% open symbols for V1/V2 filled for V4
figure(1)
clf
hold on

pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 900])
% suptitle ('
for eye = 1:2
    if eye == 1
        V1trData = V1data.trLE;
        V4trData = V4data.trLE;
        V1crData = V1data.conRadLE;
        V4crData = V4data.conRadLE;
        V1triMtx = V1data.LEsort;
        V4triMtx = V4data.LEsort;
    else
        V1trData = V1data.trRE;
        V4trData = V4data.trRE;
        V1crData = V1data.conRadRE;
        V4crData = V4data.conRadRE;
        V1triMtx = V1data.REsort;
        V4triMtx = V4data.REsort;
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
    
    rct = V1triMtx(:,1:3);
    [~,V1prefPattern] = max(rct,[],2);
    clear rct
    
    rct = V4triMtx(:,1:3);
    [~,V4prefPattern] = max(rct,[],2);
    %%
    v1ndx = 1; v4ndx = 1;
    for ch = 1:96
        if V1trData.goodCh(ch) == 1 && V1trData.inStim(ch) == 1 && V1crData.inStim(ch) == 1 && V1crData.goodCh(ch) == 1
            
            pOri = V1trData.prefParamsPrefOri(ch);
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
            conAng = radAng - 90;
            
            if eye == 1
                subplot(2,2,1)
                hold on
                
                plot(v1LEconRadNdx(v1ndx),conAng,'ob')
                ylabel('local orientation relative to concentric')
                xlabel('c-r/c+r')
                xlim([-1.2 1.2])
                ylim([-95 95])
                
                set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',-90:30:90)
                v1ndx = v1ndx+1;
            else
                subplot(2,2,2)
                hold on
                
                plot(v1REconRadNdx(v1ndx),conAng,'or')
                ylabel('local orientation relative to concentric')
                xlabel('c-r/c+r')
                xlim([-1.2 1.2])
                set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',-90:30:90)
                v1ndx = v1ndx+1;  
            end
            
        end
        if V4trData.goodCh(ch) == 1 && V4trData.inStim(ch) == 1 && V4crData.inStim(ch) == 1 && V4crData.goodCh(ch) == 1
            
            pOri = V4trData.prefParamsPrefOri(ch);
            rfX  = V4rfParamsRelGlassFix{ch}(1);
            rfY  = V4rfParamsRelGlassFix{ch}(2);
            
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
            conAng = radAng - 90;
            
            if eye == 1
                subplot(2,2,3)
                hold on
                
                plot(v4LEconRadNdx(v4ndx),conAng,'ob')
                ylabel('local orientation relative to concentric')
                xlabel('c-r/c+r')
                xlim([-1.2 1.2])
                ylim([-95 95])
                
                set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',-90:30:90)
                v4ndx = v4ndx+1;
            else
                subplot(2,2,4)
                hold on
                
                plot(v4REconRadNdx(v4ndx),conAng,'or')
                ylabel('local orientation relative to concentric')
                xlabel('c-r/c+r')
                xlim([-1.2 1.2])
                set(gca,'box','off','tickdir','out','XTick',-1:0.25:1,'Ytick',-90:30:90)
                v4ndx = v4ndx+1;  
            end
            
        end
    end
end