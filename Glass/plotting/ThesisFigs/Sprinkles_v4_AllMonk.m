function [] = Sprinkles_v4_AllMonk(XTV4,WUV4, WVV4)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
% Receptive fields are relative to fixation at (0,0). In order to get
% quadrants, need to move the stimulus center to (0,0) which means
% adjusting receptive field centers and stimulus center in the correct
% direction.

%%
for spt = 1:6
    if spt == 1
        trData = XTV4.trLE;     crData = XTV4.conRadLE;     triplotMtx = XTV4.LEsort;
    elseif spt == 2
        trData = XTV4.trRE;     crData = XTV4.conRadRE;     triplotMtx = XTV4.REsort;
    elseif spt == 3
        trData = WUV4.trLE;     crData = WUV4.conRadLE;     triplotMtx = WUV4.LEsort;
    elseif spt == 4
        trData = WUV4.trRE;     crData = WUV4.conRadRE;     triplotMtx = WUV4.REsort;
    elseif spt == 5
        trData = WVV4.trLE;     crData = WVV4.conRadLE;     triplotMtx = WVV4.LEsort;
    else
        trData = WVV4.trRE;     crData = WVV4.conRadRE;     triplotMtx = WVV4.rEsort;
    end
        
        
    rct = triplotMtx(:,1:3);
    [~,prefPattern] = max(rct,[],2);
    %%
    glassX = unique(trData.pos_x);
    glassY = unique(trData.pos_y);
    
    if contains(trData.animal,'XT')
        rfParamsOrig = trData.chReceptiveFieldParamsBE;
    else
        rfParamsOrig = trData.chReceptiveFieldParams;
    end
    %% for XT, move receptive field locations to be in same coordinate space as Glass fixation
    if contains(trData.animal,'XT')
        for ch = 1:96
            rfParamsRelGlassFix{ch}(1) = rfParamsOrig{ch}(1) + unique(trData.fix_x);
            rfParamsRelGlassFix{ch}(2) = rfParamsOrig{ch}(2) + unique(trData.fix_y);
        end
    else
        for ch = 1:96
            rfParamsRelGlassFix{ch}(1) = rfParamsOrig{ch}(1);
            rfParamsRelGlassFix{ch}(2) = rfParamsOrig{ch}(2);
        end
    end
    %% center stimulus at (0,0)
    % Need stimulus to be centered at origin to define the quadrants according
    % to their signs
    
    if glassX ~= 0
        for ch = 1:96
            rfParamsStim0{ch}(1) = rfParamsRelGlassFix{ch}(1) - unique(trData.pos_x);
        end
        glassXstim0 = unique(trData.pos_x) - unique(trData.pos_x);
    else
        for ch = 1:96
            rfParamsStim0{ch}(1) = rfParamsRelGlassFix{ch}(1);
        end
        glassXstim0 = unique(trData.pos_x);
    end
    
    if glassY ~= 0
        for ch = 1:96
            rfParamsStim0{ch}(2) = rfParamsRelGlassFix{ch}(2) - unique(trData.pos_y);
        end
        glassYstim0 = unique(trData.pos_x) - unique(trData.pos_x);
    else
        for ch = 1:96
            rfParamsStim0{ch}(2) = rfParamsRelGlassFix{ch}(2);
        end
        glassYstim0 = unique(trData.pos_x);
    end
    if glassXstim0 ~=0 && glassYstim0 ~= 0
        fprintf('stimulus did not move to (0,0) \n')
        keyboard
    end
    %% glitteratti plot
    
    figure
    clf
    hold on
    
    
    viscircles([glassX,glassY],4,...
        'color',[0.2 0.2 0.2],'LineWidth',0.6);
    grid on;
    
    ndx = 1;
    for ch = 1:96
        if trData.goodCh(ch) == 1 && trData.inStim(ch) == 1 && crData.inStim(ch) == 1 && crData.goodCh(ch) == 1
            pOri = trData.prefParamsPrefOri(ch);
            rfX = rfParamsRelGlassFix{ch}(1);
            rfY = rfParamsRelGlassFix{ch}(2);
            o = squeeze(trData.OSI(1,:,:,ch));
            lwidth = o(trData.prefParamsIndex(ch));
            %         t(ch) =lwidth;
            if lwidth > 0.5
                lLen = 1+(lwidth^2);
            else
                lLen = 1-(lwidth^2);
            end
            x2 = rfX +(lLen*cos(pOri));
            y2 = rfY +(lLen*sin(pOri));
            
            if prefPattern(ndx) == 1
                plot([rfX, x2], [rfY, y2],'-','color',[0.7 0 0.7],'lineWidth',lLen)
            elseif prefPattern(ndx) == 2
                plot([rfX, x2], [rfY, y2],'-','color',[0 0.6 0.2],'lineWidth',lLen)
            elseif prefPattern(ndx) == 3
                plot([rfX, x2], [rfY, y2],'-','color',[1 0.5 0.1],'lineWidth',lLen)
            end
            ndx = ndx+1;
        end
        xlim([-15,15])
        ylim([-15,15])
        set(gca,'YAxisLocation','origin','XAxisLocation','origin','tickdir','both',...
            'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    end
    if spt == 1
        text(-14, 14, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
        text(-14, 13, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
        text(-14, 12, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)
    end
    axis square
end
%
% if contains(trData.animal,'XT')
%     suptitle({'Preferred orientations and pattern type for each channel and their receptive field locations';...
%         sprintf('%s BE %s',trData.animal, trData.array)})
%     figName = [trData.animal,'_BE_',trData.array,'_RFloc_prefOri_prefPattern','.pdf'];
% else
%     suptitle({'Preferred orientations and pattern type for each channel and their receptive field locations';...
%         sprintf('%s %s %s',trData.animal, trData.eye, trData.array)})
%     figName = [trData.animal,'_',trData.eye,'_',trData.array,'_RFloc_prefOri_prefPattern_gCh','.pdf'];
% end

%%
print(gcf, figName,'-dpdf','-bestfit')