function [conConsist, radConsist] = gratPrefOriVSglassexpected(dataT)
%%
stimX = unique(dataT.trLE.pos_x);
stimY = unique(dataT.trLE.pos_y);
conConsist = [0 0];
radConsist = [0 0];
%%

[cDpLE, rDpLE] = getGlassConRadPrefDprime_allCh(dataT.conRadLE.radNoiseDprime, dataT.conRadLE.conNoiseDprime);
[cDpRE, rDpRE] = getGlassConRadPrefDprime_allCh(dataT.conRadRE.radNoiseDprime, dataT.conRadRE.conNoiseDprime);

conRadLE = [rDpLE, cDpLE];
conRadRE = [rDpRE, cDpRE];
[LEconRadNdx] = getGlassConRadSigPerm(conRadLE,dataT.trLE.animal,dataT.trLE.array,'LE');
[REconRadNdx] = getGlassConRadSigPerm(conRadRE,dataT.trRE.animal,dataT.trRE.array,'RE');
%%
figDir = sprintf('/Users/brittany/Dropbox/Thesis/Glass/figures/sprinkle/grat/%s',dataT.trLE.animal);
if~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figure(1)
clf
hold on

pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 900])

s = suptitle(sprintf('%s %s preferred stim and grating orientation',dataT.trLE.animal, dataT.trLE.array));
%     s.Position(2) = s.Position(2) + 0.025;
%     s.FontSize = 18;
%     s.FontWeight = 'bold';
%     axis off
%%
for eye = 1:2
    if eye == 1
        trData = dataT.gratLE;
        crData = dataT.conRadLE;
        crNdx  = LEconRadNdx;
        useCh = find(crData.goodCh & crData.inStim & trData.good_ch);
        gratOri = trData.ori_pref(useCh);
    else
        trData = dataT.gratRE;
        crData = dataT.conRadRE;
        crNdx  = REconRadNdx;
        useCh = find(crData.goodCh & crData.inStim & trData.good_ch);
        gratOri = trData.ori_pref(useCh);
    end
    
    if contains(dataT.trLE.animal,'XT')
        rfParamsOrig = dataT.trLE.chReceptiveFieldParamsBE;
    else
        rfParamsOrig = dataT.trLE.chReceptiveFieldParams;
    end
    % for XT, move receptive field locations to be in same coordinate space as Glass fixation
    if contains(dataT.trLE.animal,'XT')
        for ch = 1:96
            rfParamsRelGlassFix{ch}(1) = rfParamsOrig{ch}(1) + unique(dataT.trLE.fix_x);
            rfParamsRelGlassFix{ch}(2) = rfParamsOrig{ch}(2) + unique(dataT.trLE.fix_y);
        end
    else
        for ch = 1:96
            rfParamsRelGlassFix{ch}(1) = rfParamsOrig{ch}(1);
            rfParamsRelGlassFix{ch}(2) = rfParamsOrig{ch}(2);
        end
    end
    %%
    if contains(dataT.trLE.animal,'WU')
        xval = ([-8, 2]);
        yval = ([-4, 4]);
    elseif contains(dataT.trLE.animal,'XT')
        xval = ([-3, 5]);
        yval = ([-6, 2]);
    else
        xval = ([-4, 6]);
        yval = ([-5, 3]);
    end
    if eye == 1
        h1 = subplot(2,2,1);
        hold on
        viscircles([stimX,stimY],4,...
            'color',[0.2 0.2 0.2],'LineWidth',0.6);
        xlim(xval)
        ylim(yval)
        
        axis equal
        axis square
        axis tight
        axis off
        
        h3 = subplot(2,2,3);
        hold on
        viscircles([stimX,stimY],4,...
            'color',[0.2 0.2 0.2],'LineWidth',0.6);
        xlim(xval)
        ylim(yval)
        
        axis equal
        axis square
        axis tight
        axis off
    else
        h2 = subplot(2,2,2);
        hold on
        viscircles([stimX,stimY],4,...
            'color',[0.2 0.2 0.2],'LineWidth',0.6);
        xlim(xval)
        ylim(yval)
        
        axis equal
        axis square
        axis tight
        axis off
        
        h4 = subplot(2,2,4);
        hold on
        viscircles([stimX,stimY],4,...
            'color',[0.2 0.2 0.2],'LineWidth',0.6);
        xlim(xval)
        ylim(yval)
        
        axis equal
        axis square
        axis tight
        axis off
    end
    %%
    ndx = 1;
    for ch1 = 1:length(useCh)
        ch = useCh(ch1);
        %         if trData.goodCh(ch) == 1 && trData.inStim(ch) == 1
        pOri = gratOri(ndx);
        rfX = rfParamsRelGlassFix{ch}(1);
        rfY = rfParamsRelGlassFix{ch}(2);
        
        lLen = 0.5;%-(lwidth^2);
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
        
        if crNdx(ch) > 0 % con
            if eye == 1
                h = subplot(2,2,1);
                hold on
            else
                h = subplot(2,2,2);
                hold on
            end
            t = plot([x2, x1], [y2, y1],'-','color',[0.7 0 0.7 0.6],'lineWidth',1.5);
            if abs(conAng-pOri) <=15
                t = plot([x2, x1], [y2, y1],'-','color',[0.7 0 0.7],'lineWidth',1.5);
                conConsist(1,eye) = conConsist(1,eye)+1;
            else
                t = plot([x2, x1], [y2, y1],'-','color',[0.7 0 0.7 0.4],'lineWidth',1);
            end
        elseif crNdx(ch) < 0 % rad
            if eye == 1
                h = subplot(2,2,3);
                hold on
            else
                h = subplot(2,2,4);
                hold on
            end
            t = plot([x2, x1], [y2, y1],'-','color',[0 0.6 0.2 0.6],'lineWidth',1.5);
            if abs(radAng-pOri) <= 15
                radConsist(1,eye) = radConsist(1,eye)+1;
            else
                t = plot([x2, x1], [y2, y1],'-','color',[0 0.6 0.2 0.4],'lineWidth',1);
            end
        end
        ndx = ndx+1;
    end
    %     pause
    %     end
end

% h1.YLim = yval;
% h1.XLim = xval;
% h2.YLim = yval;
% h2.XLim = xval;
% h3.YLim = yval;
% h3.XLim = xval;
% h4.YLim = yval;
% h4.XLim = xval;

wd = h1.Position(3);
ht = h1.Position(4);
h2.Position(3) = wd;
h2.Position(4) = ht;
h3.Position(3) = wd;
h3.Position(4) = ht;
h4.Position(3) = wd;
h4.Position(4) = ht;


%%
figName = [dataT.trLE.animal,'_',dataT.trLE.array,'_sprinkle_gratOri','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')