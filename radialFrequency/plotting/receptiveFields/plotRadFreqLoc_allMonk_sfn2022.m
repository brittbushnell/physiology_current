function plotRadFreqLoc_allMonk_sfn2022(LEdataXT,LEdataWU,REdataWU, LEdataWV, REdataWV)
%%
LEdataXT = callReceptiveFieldParameters(LEdataXT);
XTrfParamsLE = LEdataXT.chReceptiveFieldParamsBE;

LEdataWU = callReceptiveFieldParameters(LEdataWU);
REdataWU = callReceptiveFieldParameters(REdataWU);

WUrfParamsLE = LEdataWU.chReceptiveFieldParams;
WUrfParamsRE = REdataWU.chReceptiveFieldParams;

LEdataWV = callReceptiveFieldParameters(LEdataWV);
REdataWV = callReceptiveFieldParameters(REdataWV);

WVrfParamsLE = LEdataWV.chReceptiveFieldParams;
WVrfParamsRE = REdataWV.chReceptiveFieldParams;

XTlocPair = LEdataXT.locPair;
WVlocPair = LEdataWV.locPair;
WUlocPair = LEdataWU.locPair;
%% setup positions for all subplots
p1xt = 0.09;
p1wu = 0.35;
p1wv = 0.62;

p2v1 = 0.55;
p2v4 = 0.09;

p3 = 0.275;
p4 = 0.375;
%% XT
if contains(LEdataXT.array,'V1','IgnoreCase', true)
    subplot(2,3,1)
    title('XT')
    set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
        'Position',[p1xt, p2v1, p3, p4])
    text(-20,0,'V1/V2','FontSize',18)
else
    subplot(2,3,4)
    
    set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
        'Position',[p1xt, p2v4, p3, p4]);
    text(-18,0,'V4','FontSize',18)
end

hold on
xlim([-10 10])
ylim([-10 10])
axis square
grid on

% plot circles for stimulus locations
viscircles([XTlocPair(1,1),XTlocPair(1,2)],2,...
    'color','k','LineWidth',1);
viscircles([XTlocPair(2,1),XTlocPair(2,2)],2,...
    'color','k','LineWidth',1);
viscircles([XTlocPair(3,1),XTlocPair(3,2)],2,...
    'color','k','LineWidth',1);

for ch = 1:96
    if LEdataXT.goodCh(ch)
        scatter(XTrfParamsLE{ch}(1),XTrfParamsLE{ch}(2),30,'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end
%% WU
if contains(LEdataWU.array,'V1','IgnoreCase', true)
    subplot(2,3,2)
    title('WU')
    set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
        'Position',[p1wu, p2v1, p3, p4])
    
else
    subplot(2,3,5)
    set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
        'Position',[p1wu, p2v4, p3, p4]);
end

hold on
xlim([-10 10])
ylim([-10 10])
axis square
grid on

for ch = 1:96
    if LEdataWU.goodCh(ch)
        scatter(WUrfParamsLE{ch}(1),WUrfParamsLE{ch}(2),30,'MarkerFaceColor',[0 0.67 0.93],'MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
    if REdataWU.goodCh(ch)
        scatter(WUrfParamsRE{ch}(1),WUrfParamsRE{ch}(2),30,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end

% plot circles for stimulus locations
viscircles([WUlocPair(1,1),WUlocPair(1,2)],2,...
    'color','k','LineWidth',1);
viscircles([WUlocPair(2,1),WUlocPair(2,2)],2,...
    'color','k','LineWidth',1);
viscircles([WUlocPair(3,1),WUlocPair(3,2)],2,...
    'color','k','LineWidth',1);
%% WV
if contains(LEdataWV.array,'V1','IgnoreCase', true)
    subplot(2,3,3)
    title('WV')
    set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
        'Position',[p1wv, p2v1, p3, p4])
else
    subplot(2,3,6)
    
    set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
        'Position',[p1wv, p2v4, p3, p4]);
end

hold on
xlim([-10 10])
ylim([-10 10])
axis square
grid on

for ch = 1:96
    if LEdataWV.goodCh(ch)
        scatter(WVrfParamsLE{ch}(1),WVrfParamsLE{ch}(2),30,'MarkerFaceColor',[0 0.67 0.93],'MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
    if REdataWV.goodCh(ch)
        scatter(WVrfParamsRE{ch}(1),WVrfParamsRE{ch}(2),30,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end

% plot circles for stimulus locations
viscircles([WVlocPair(1,1),WVlocPair(1,2)],2,...
    'color','k','LineWidth',1);
viscircles([WVlocPair(2,1),WVlocPair(2,2)],2,...
    'color','k','LineWidth',1);
viscircles([WVlocPair(3,1),WVlocPair(3,2)],2,...
    'color','k','LineWidth',1);
%%
location = determineComputer;
if location == 1
    figDir = '~/Dropbox/posters/SfN/2022/figures/Radial/receptiveFields';
elseif location == 0
    figDir = '~/Dropbox/posters/SfN/2022/figures/Radial/receptiveFields';
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['AllAnimalRFlocsSfn2022','.pdf'];
set(gcf,'PaperOrientation','landscape','InvertHardcopy','off','PaperSize',[9 7],'Color','w')
print(figure(2), figName,'-dpdf','-bestfit')
% keyboard
%% plot each separately

for i = 1:3
    figure(3)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2), 500, 500],'PaperSize',[4.5,4.5],'InvertHardcopy','off','Color','w','PaperOrientation','landscape')
  
    hold on
    
    xlim([-10 10])
    ylim([-10 10])
    
    set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
        'XTick',[-10 -5 5 10],'XTickLabel',{'-10' '-5' '5' '10'},...
        'YTick',[-10 -5 5 10],'YTickLabel',{'-10' '-5' '5' '10'},...
        'FontSize',18,'FontAngle','italic')
    grid on
    
    if i == 1
        LEdataT = LEdataXT;
        
        s = suptitle(sprintf('XT %s',LEdataXT.array));
        s.FontSize = 10;
        s.Position(2) = s.Position(2) + 0.035; 
%         s.FontWeight = 'bold';
    
        viscircles([XTlocPair(1,1),XTlocPair(1,2)],2,...
            'color',[0.2 0.2 0.2],'LineWidth',0.5);
        viscircles([XTlocPair(2,1),XTlocPair(2,2)],2,...
            'color',[0.2 0.2 0.2],'LineWidth',0.5);
        viscircles([XTlocPair(3,1),XTlocPair(3,2)],2,...
            'color',[0.2 0.2 0.2],'LineWidth',0.5);
        
        for ch = 1:96
            scatter(XTrfParamsLE{ch}(1),XTrfParamsLE{ch}(2),30,'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
        end
    else

        if i == 2
            LEdataT = LEdataWU;
            LErfParams = WUrfParamsLE;

            RErfParams = WUrfParamsRE;
            
            locPair = LEdataWU.locPair;
        else
            LEdataT = LEdataWV;
            LErfParams = WVrfParamsLE;

            RErfParams = WVrfParamsRE;
            
            locPair = LEdataWV.locPair;
        end
        
        s = suptitle(sprintf('%s %s',LEdataT.animal,LEdataT.array));
        s.FontSize = 10;
        s.Position(2) = s.Position(2) + 0.035; 
%         s.FontWeight = 'bold';
        
        viscircles([locPair(1,1),locPair(1,2)],2,...
            'color',[0.2 0.2 0.2],'LineWidth',0.5);
        viscircles([locPair(2,1),locPair(2,2)],2,...
            'color',[0.2 0.2 0.2],'LineWidth',0.5);
        viscircles([locPair(3,1),locPair(3,2)],2,...
            'color',[0.2 0.2 0.2],'LineWidth',0.5);
        
        for ch = 1:96
            scatter(LErfParams{ch}(1),LErfParams{ch}(2),30,'MarkerFaceColor',[0.4 0.8 1],'MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
            scatter(RErfParams{ch}(1),RErfParams{ch}(2),30,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
        end
        
    end
    figName = [LEdataT.animal,'_',LEdataT.array,'_RFlocsSfn2022','.pdf'];
    print(figure(3), figName,'-dpdf','-fillpage')
end
