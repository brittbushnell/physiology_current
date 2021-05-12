function [] = Sprinkles_AllMonk(XT,WU, WV)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
% Receptive fields are relative to fixation at (0,0). In order to get
% quadrants, need to move the stimulus center to (0,0) which means
% adjusting receptive field centers and stimulus center in the correct
% direction.

%%
location = determineComputer;

if location == 1
    figDir =  ('~/bushnell-local/Dropbox/Thesis/Glass/figures/CrossAnimals/Glass');
elseif location == 0
    figDir = ('/Users/brittany/Dropbox/Thesis/Glass/figures/CrossAnimals/Glass');
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
figure(1)
clf
hold on

pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 900, 1200])

s = suptitle(sprintf('Preferred orientation and pattern type in %s for each channel and their receptive field locations',XT.trLE.array));
s.Position(2) = s.Position(2) + 0.025;
s.FontSize = 18;
s.FontWeight = 'bold';
axis off
%%
for spt = 1:6
    if spt == 1
        trData = XT.trLE;     crData = XT.conRadLE;     triplotMtx = XT.LEsort;
    elseif spt == 2
        trData = XT.trRE;     crData = XT.conRadRE;     triplotMtx = XT.REsort;
    elseif spt == 3
        trData = WU.trLE;     crData = WU.conRadLE;     triplotMtx = WU.LEsort;
    elseif spt == 4
        trData = WU.trRE;     crData = WU.conRadRE;     triplotMtx = WU.REsort;
    elseif spt == 5
        trData = WV.trLE;     crData = WV.conRadLE;     triplotMtx = WV.LEsort;
    else
        trData = WV.trRE;     crData = WV.conRadRE;     triplotMtx = WV.REsort;
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
    h = subplot(3,2,spt);
    hold on

    xlim([-15,15])
    ylim([-15,15])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin','tickdir','both',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
        
    viscircles([glassX,glassY],4,...
        'color',[0.2 0.2 0.2],'LineWidth',0.6);
    grid on;
    
    h.Position(2) = h.Position(2)-0.075;
    h.Position(3) = 0.34;
    h.Position(4) = 0.34;
    
    axis square
%     axis equal
    
h.Position
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
                lLen = 1;%+(lwidth^2);
            else
                lLen = 1;%-(lwidth^2);
            end
            x2 = rfX +(lLen*cos(pOri));
            y2 = rfY +(lLen*sin(pOri));
            
            if prefPattern(ndx) == 2
                plot([rfX, x2], [rfY, y2],'-','color',[0.7 0 0.7],'lineWidth',lLen)
            elseif prefPattern(ndx) == 1
                plot([rfX, x2], [rfY, y2],'-','color',[0 0.6 0.2],'lineWidth',lLen)
            elseif prefPattern(ndx) == 3
                plot([rfX, x2], [rfY, y2],'-','color',[0.2 0.4 1],'lineWidth',lLen)
            end
            ndx = ndx+1;
        end
        
    end
    if spt == 1
        text(-14, 14, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',11)
        text(-14, 12, 'Translational','Color',[0.2 0.4 1],'FontWeight','Bold','FontSize',11)
        text(-14, 10, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',11)
        text(-25, 0,  'Control','FontWeight','Bold','FontSize',12)
        title('LE/FE')
    elseif spt == 2
        title('RE/AE')
    elseif spt == 3
        text(-22, 0,  'A1','FontWeight','Bold','FontSize',12)
    elseif spt == 5
        text(-22, 0,  'A2','FontWeight','Bold','FontSize',12)
    end
end
%%
figName = [XT.trLE.array,'_sprinklePlots_allMonk','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')