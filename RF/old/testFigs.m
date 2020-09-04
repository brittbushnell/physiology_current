close all
clc

%% test figures for each response
REgoodCh = find(REcleanData.goodCh);
LEgoodCh = find(LEcleanData.goodCh);

for ch = 1:length(REgoodCh)
    gch = REgoodCh(ch);
    REcircs = REcleanData.stimResps{REgoodCh(ch)}(8:14,433:end);
    REblank = REcleanData.blankResps{REgoodCh(ch)};

    ymaxR = max(REcircs(:));    
    yminR = min(REcircs(:));
    
    figure
    hold on
    for crc = 1:size(REcircs,2)
        sz = REcleanData.stimResps{REgoodCh(ch)}(5,432+crc);
        sf = REcleanData.stimResps{REgoodCh(ch)}(4,432+crc);
        xl = REcleanData.stimResps{REgoodCh(ch)}(6,432+crc);
        if xl == -4.5
            pos = 1;
        elseif xl == -3
            pos = 2;
        else
            pos = 3;
        end
        subplot(4,3,crc)
        plot(REcircs(:,crc),'ro')
        set(gca,'tickdir','out','box','off','Color','none')
        title(sprintf('size%d sf%d pos %d',sz,sf,pos))
        ylim([yminR ymaxR])
        
        if crc == 1
            annotation('textbox',...
                [0.15 0.95 0.77 0.05],...
                'String',{sprintf('responses to circles RE ch %d',gch)},...
                'FontWeight','bold',...
                'FontSize',16,...
                'FontAngle','italic',...
                'EdgeColor','none');
        end
    end
    cd('/Local/Users/bushnell/Dropbox/Figures/WU_Arrays/RF/V4/0707/circles/RE')
    figName = ['ch_',num2str(gch),'_circleResponses_RE'];
    saveas(gcf,figName,'pdf')
end
for ch = 1:length(LEgoodCh)
        gch = LEgoodCh(ch);
    LEcircs = LEcleanData.stimResps{LEgoodCh(ch)}(8:14,433:end);
    LEblank = LEcleanData.blankResps{LEgoodCh(ch)};    
    ymaxL = max(LEcircs(:));
    yminL = min(LEcircs(:));
    
    figure
    for crc = 1:size(REcircs,2)
        sz = LEcleanData.stimResps{LEgoodCh(ch)}(5,432+crc);
        sf = LEcleanData.stimResps{LEgoodCh(ch)}(4,432+crc);
        xl = LEcleanData.stimResps{LEgoodCh(ch)}(6,432+crc);
        if xl == -4.5
            pos = 1;
        elseif xl == -3
            pos = 2;
        else
            pos = 3;
        end
        subplot(4,3,crc)
        plot(LEcircs(:,crc),'bo')
        set(gca,'tickdir','out','box','off','Color','none')
        title(sprintf('size%d sf%d pos%d',sz,sf,pos))
        ylim([yminL ymaxL])
        if crc == 1
            annotation('textbox',...
                [0.15 0.95 0.77 0.05],...
                'String',{sprintf('responses to circles LE ch %d',gch)},...
                'FontWeight','bold',...
                'FontSize',16,...
                'FontAngle','italic',...
                'EdgeColor','none');
        end
    end
    cd('/Local/Users/bushnell/Dropbox/Figures/WU_Arrays/RF/V4/0707/circles/LE')
    figName = ['ch_',num2str(gch),'_circleResponses_LE'];
    saveas(gcf,figName,'pdf')
end
%% channel by channel figures from RF3
xdata = [4,8,16,32,64,128];


reNdx = 3;
leNdx = 4;

for ch=5%1:numCh
    if leNdx < length(LEgoodCh)
        max_LE = max(max(max(all_LE(:,:,leNdx,:))));
    end
    if reNdx < length(REgoodCh)
        max_RE = max(max(max(all_RE(:,:,reNdx,:))));
    end
    
    a = sum(ismember(LEgoodCh,ch));
    a2 = sum(ismember(REgoodCh,ch));
    both = a+a2;
    
    if both == 0
        continue
    elseif both == 2
        %         sum(ismember(REgoodCh,ch))
        %         sum(ismember(LEgoodCh,ch))
        figure
        spot = 1;
        for ndx = 1:4
            for  r = 1:3
                
                subplot(4,3,spot)
                %         title(sprintf('%s radial frequency tuning baseline subtracted average', array));
                %         axis off
                hold on
                
                plot(xdata,all_RE(r,:,reNdx,ndx),'r-o','LineWidth',2);
                plot(2,all_RE(end,1,reNdx,ndx),'r-o','LineWidth',2)
                
                plot(xdata,all_LE(r,:,leNdx,ndx),'b-o','LineWidth',2);
                plot(2,all_LE(end,1,leNdx,ndx),'b-o','LineWidth',2)
                ylim([0 max(max_LE, max_RE)])
                xlim([1 130])
                
                if spot == 10
                    xlabel('Modulation amplitude (arc sec)')
                elseif spot == 7
                    ylabel('Average baseline subtracted response')
                end
                
                if ndx == 1
                    title(sprintf('RFS %d size = 1 deg sf = 1',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'22.5',[],'90',[],'360'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                elseif ndx == 2
                    title(sprintf('RFS %d size = 1 deg sf = 2',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'22.5',[],'90',[],'360'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                elseif ndx == 3
                    title(sprintf('RFS %d size = 2 deg sf = 1',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'90',[],'360',[],'1440'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                elseif ndx == 4
                    title(sprintf('RFS %d size = 2 deg sf = 2',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'90',[],'360',[],'1440'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                end
                
                if spot == 1
                    annotation('textbox',...
                        [0.15 0.95 0.77 0.05],...
                        'String',{sprintf('%s mean responses for all stimuli %s ch %d',array, date,ch)},...
                        'FontWeight','bold',...
                        'FontSize',16,...
                        'FontAngle','italic',...
                        'EdgeColor','none');
                end
                spot = spot+1;
            end
        end
        reNdx = reNdx+1;
        leNdx = leNdx+1;
    elseif a2 == 1
        figure
        spot = 1;
        for ndx = 1:4
            for  r = 1:3
                
                subplot(4,3,spot)
                %         title(sprintf('%s radial frequency tuning baseline subtracted average', array));
                %         axis off
                set(gca,'Color','none')
                hold on
                
                plot(xdata,all_RE(r,:,reNdx,ndx),'r-o','LineWidth',2);
                plot(2,all_RE(end,1,reNdx,ndx),'r-o','LineWidth',2)
                
                ylim([0 max(max_RE)])
                xlim([1 130])
                
                if spot == 10
                    xlabel('Modulation amplitude (arc sec)')
                elseif spot == 7
                    ylabel('Average baseline subtracted response')
                end
                
                if ndx == 1
                    title(sprintf('RFS %d size = 1 deg sf = 1',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'22.5',[],'90',[],'360'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                elseif ndx == 2
                    title(sprintf('RFS %d size = 1 deg sf = 2',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'22.5',[],'90',[],'360'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                elseif ndx == 3
                    title(sprintf('RFS %d size = 2 deg sf = 1',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'90',[],'360',[],'1440'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                elseif ndx == 4
                    title(sprintf('RFS %d size = 2 deg sf = 2',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'90',[],'360',[],'1440'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                end
                
                if spot == 1
                    annotation('textbox',...
                        [0.15 0.95 0.77 0.05],...
                        'String',{sprintf('%s mean responses for all stimuli %s ch %d',array,date,ch)},...
                        'FontWeight','bold',...
                        'FontSize',16,...
                        'FontAngle','italic',...
                        'EdgeColor','none');
                end
                spot = spot+1;
            end
        end
        ch;
        reNdx = reNdx+1;
    elseif a == 1
        figure
        spot = 1;
        for ndx = 1:4
            for  r = 1:3
                
                subplot(4,3,spot)
                %         title(sprintf('%s radial frequency tuning baseline subtracted average', array));
                %         axis off
                set(gca,'Color','none')
                hold on
                
                plot(xdata,all_LE(r,:,leNdx,ndx),'b-o','LineWidth',2);
                plot(2,all_LE(end,1,leNdx,ndx),'b-o','LineWidth',2)
                ylim([0 max(max_LE)])
                xlim([1 130])
                
                if spot == 10
                    xlabel('Modulation amplitude (arc sec)')
                elseif spot == 7
                    ylabel('Average baseline subtracted response')
                end
                
                if ndx == 1
                    title(sprintf('RFS %d size = 1 deg sf = 1',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'22.5',[],'90',[],'360'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                elseif ndx == 2
                    title(sprintf('RFS %d size = 1 deg sf = 2',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'22.5',[],'90',[],'360'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                elseif ndx == 3
                    title(sprintf('RFS %d size = 2 deg sf = 1',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'90',[],'360',[],'1440'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                elseif ndx == 4
                    title(sprintf('RFS %d size = 2 deg sf = 2',RFs(r)));
                    if r == 3 %rf16
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'90',[],'360',[],'1440'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    else
                        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                            'XTickLabel',{'circle',[],'45',[],'180',[],'720'},'XTickLabelRotation', 45,...
                            'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
                    end
                end
                
                if spot == 1
                    annotation('textbox',...
                        [0.15 0.95 0.77 0.05],...
                        'String',{sprintf('%s mean responses for all stimuli %s ch %d',array ,date,ch)},...
                        'FontWeight','bold',...
                        'FontSize',16,...
                        'FontAngle','italic',...
                        'EdgeColor','none');
                end
                spot = spot+1;
            end
        end
        ch;
        leNdx = leNdx+1;
    end
end