clear all
close all
clc
tic;
%%
% file = 'WU_V1_RadFreq_0707_find2';
% array = 'V1';
file = 'WU_V4_RadFreq_0707_find3';
array = 'V4';

location = 1;
%%
load(file);
%%
RFs   = unique(LEdata.rf);
amps  = unique(LEdata.amplitude);
phase = unique(LEdata.orientation);
SFs   = unique(LEdata.spatialFrequency);
xLocs = unique(LEdata.pos_x);
yLocs = unique(LEdata.pos_y);
rads  = unique(LEdata.radius);

numCh = size(LEdata.bins,3);
%% CD to correct folder for saving
if strfind(file,'V1')
    if location == 0
        cd ~/Dropbox/Figures/WU_Arrays/RF/V1/RFxAmp/0706
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/wu_Arrays/RF/V1/RFxAmp/0706
    elseif location == 2
        cd ~/Figures/V1/RadFreq/RFxAmp/0706
    end
else
    if location == 0
        cd ~/Dropbox/Figures/WU_Arrays/RF/V4/RFxAmp/0706
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/wu_Arrays/RF/V4/RFxAmp/0706
    elseif location == 2
        cd ~/Figures/V4/RadFreq/RFxAmp/0706
    end
end
%%
%[SfPrefRE,SfPrefLE, sizePrefRE, sizePrefLE, phasePrefRE, phasePrefLE]  = radFreqMwks_getPrefs(file,1);
%%
sz_sf_ndx = 1;
for sz_rad = [1 2]
    for circ_sf = [1 2]
        for ch = 1:numCh
            LEmuT = nan(4,6);
            REmuT = nan(4,6);
            
            LEmuTS = nan(4,6);
            REmuTS = nan(4,6);
            
            LEsteT = nan(4,6);
            REsteT = nan(4,6);
            for r = 1:length(RFs)
                ndx = 1;
                for a = 1:length(amps)
                    
                    REndx = find((REdata.stimResps{ch}(1,:) == RFs(r)) & ...
                        (REdata.stimResps{ch}(2,:) == amps(a)) & ...
                        (REdata.stimResps{ch}(5,:) == sz_rad) &...
                        (REdata.stimResps{ch}(4,:) == circ_sf));
                    
                    
                    LEndx = find((LEdata.stimResps{ch}(1,:) == RFs(r)) & ...
                        (LEdata.stimResps{ch}(2,:) == amps(a)) & ...
                        (LEdata.stimResps{ch}(5,:) == sz_rad) & ...
                        (LEdata.stimResps{ch}(4,:) == circ_sf));
                    
                    
                    if ~isempty(REndx)  % different RFs use different amplitudes, so this should skip any amplitudes that weren't run for that RF
                        %disp(sprintf('RF %d, amp %d',RFs(r),amps(a)))
                        clear REndxBS LEndxBS;
                        for i = 1:length(LEndx)
                            REndxBS(i) = (REdata.stimResps{ch}(19,REndx(i)));
                            LEndxBS(i) = (LEdata.stimResps{ch}(19,LEndx(i)));
                            
                            REndx2(i) = (REdata.stimResps{ch}(18,REndx(i)));
                            LEndx2(i) = (LEdata.stimResps{ch}(18,LEndx(i)));
                            
                            REste1(i) = REdata.stimResps{ch}(20,REndx(i));
                            LEste1(i) = LEdata.stimResps{ch}(20,LEndx(i));
                        end
                        LEmuTS(r,ndx) = mean(LEndxBS);
                        REmuTS(r,ndx) = mean(REndxBS);
                        
                        LEmuT(r,ndx) = mean(LEndx2);
                        REmuT(r,ndx) = mean(REndx2);
                        
                        REsteT(r,ndx) = 0.01;%mean(REste1);
                        LEsteT(r,ndx) = 0.01;%mean(LEste1);
                        
                        ndx = ndx+1;
                    end
                end
            end
            %     LEmuTS
            %     LEsteT
            %     LEmuT
            %     pause;
            
            LEmu{ch} = LEmuT;
            REmu{ch} = REmuT;
            
            REste{ch} = REsteT;
            LEste{ch} = LEsteT;
            
            LEmuBS{ch} = LEmuTS-LEdata.blankResps{ch}(end-2);
            REmuBS{ch} = REmuTS-REdata.blankResps{ch}(end-2);
        end
        all_RE(:,:,:,sz_sf_ndx) = cat(3,(REmuBS{logical(REdata.goodCh)}));
        all_LE(:,:,:,sz_sf_ndx) = cat(3,(LEmuBS{logical(LEdata.goodCh)}));
        sz_sf_ndx = sz_sf_ndx+1;
    end
end

%%
% %% Baseline subtracted responses as a function of amplitude
% %cd BaseSub
% xdata = [4,8,16,32,64,128];
% for ch = 1:numCh
%     if (REdata.goodCh(ch) + LEdata.goodCh(ch)) ~=0
%
%         figure;
%         %clf;
%
% %         reMax = max(REmuBS{ch}(:));
% %         leMax = max(LEmuBS{ch}(:));
% %         yMax = max(reMax,leMax);
% %         yMax = yMax + (yMax/15);
% %
% %         reMin = min(REmuBS{ch}(1:3,:));
% %         reMin = min(reMin);
% %         leMin = min(LEmuBS{ch}(1:3,:));
% %         leMin = min(leMin);
% %
% %         reSTEmin = min(REste{ch}(1:3,:));
% %         reSTEmin = min(reSTEmin);
% %         leSTEmin = min(LEste{ch}(1:3,:));
% %         leSTEmin = min(leSTEmin);
% %         steMin = min(reSTEmin, leSTEmin);
% %
% %         yMin = min(reMin,leMin);
% %         yMin = yMin - steMin;
% %         yMin = round(yMin);
% %         yMin = yMin + (yMin/40);
%
%         for  r = 1:4
%             subplot(2,2,r)
%             if r == 1
%                 title(sprintf('%s radial frequency tuning baseline subtracted ch %d', array, ch));
%                 axis off
%                 set(gca,'Color','none')
%             else
%                 hold on
%                 if REdata.goodCh(ch) == 1
%                     %                     plot(xdata,REmuBS{ch}(r-1,:),'r-o','LineWidth',2)
%                     %                     plot(2,REmuBS{ch}(end,1),'r-o','LineWidth',2)
%                     errorbar(xdata,REmuBS{ch}(r-1,:),REste{ch}(r-1,:),'r-o','LineWidth',2)
%                     errorbar(2,REmuBS{ch}(end,1),REste{ch}(end,1),'r-o','LineWidth',2)
%
%                     plot([2 128], [0 0], ':k')
%                 end
%                 if LEdata.goodCh(ch) == 1
%                     %                     plot(xdata,LEmuBS{ch}(r-1,:),'b-o','LineWidth',2)
%                     %                     plot(2,LEmuBS{ch}(end,1),'b-o','LineWidth',2)
%
%                     errorbar(xdata,LEmuBS{ch}(r-1,:),LEste{ch}(r-1,:),'b-o','LineWidth',2)
%                     errorbar(2,LEmuBS{ch}(end,1),LEste{ch}(end,1),'b-o','LineWidth',2)RE
%                     plot([2 128], [0 0], ':k')
%                 end
%                 set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128]...
%                     ,'XTickLabel',{'circle','low','','','','','high'},'XTickLabelRotation', 45)
%                 %ylim([yMin yMax])
%                 %[ampConv] = convertWF(sizePrefRE(1,ch),
%
%                 if r == 3
%                     ylabel('baseline subtracted response')
%                     xlabel('Amplitude modulation')
%                 end
%
%                 title(sprintf('RF %d', RFs(r-1)))
%             end
%         end
%     end
%     %pause;
% %     if REdata.goodCh(ch) == 1 || LEdata.goodCh(ch) == 1
% %         figName = ['WU_',array,'_',num2str(ch),'_RFxAmpBaseSub_small_norm'];
% %         saveas(gca,figName,'pdf')
% %     end
% end

%%
%average plots
xdata = [4,8,16,32,64,128];
mu_all_RE = squeeze(mean(all_RE,3));
mu_all_LE = squeeze(mean(all_LE,3));
se_all_LE = squeeze(std(all_LE,0,3)./sqrt(size(all_LE,3)));
se_all_RE = squeeze(std(all_RE,0,3)./sqrt(size(all_RE,3)));

max_LE = max(mu_all_LE(:));
max_RE = max(mu_all_RE(:));

figure
spot = 1;
for ndx = 1:4
    for  r = 1:3
        
        subplot(4,3,spot)
        %         title(sprintf('%s radial frequency tuning baseline subtracted average', array));
        %         axis off
        set(gca,'Color','none')
        hold on
        
        plot(xdata,mu_all_RE(r,:,ndx),'r-o','LineWidth',2);
        errorbar(xdata,mu_all_RE(r,:,ndx),se_all_RE(r,:,ndx),'r-o','LineWidth',2,'CapSize',0.1)
        plot(2,mu_all_RE(end,1,ndx),'r-o','LineWidth',2)
        errorbar(2,mu_all_RE(end,1,ndx),se_all_RE(end,1,ndx),'r-o','LineWidth',2,'CapSize',0.1)
        
        
        plot(xdata,mu_all_LE(r,:,ndx),'b-o','LineWidth',2);
        errorbar(xdata,mu_all_LE(r,:,ndx),se_all_LE(r,:,ndx),'b-o','LineWidth',2,'CapSize',0.1);
        plot(2,mu_all_LE(end,1,ndx),'b-o','LineWidth',2)
        errorbar(2,mu_all_LE(end,1,ndx),se_all_LE(end,1,ndx),'b-o','LineWidth',2,'CapSize',0.1);
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
                'String',{'Mean responses for all SF x Size combinations 07/06'},...
                'FontWeight','bold',...
                'FontSize',16,...
                'FontAngle','italic',...
                'EdgeColor','none');
        end
        spot = spot+1;
    end
end


%%
%all channels plotted

max_all_LE = max(all_LE(:));
max_all_RE = max(all_RE(:));
for ndx = 1:4
    figure
    for  r = 1:3
        subplot(1,3,r)
        %         title(sprintf('%s radial frequency tuning baseline subtracted average', array));
        %         axis off
        if r == 1 
            annotation('textbox',...
                [0.35 0.96 0.85 0.05],...
                'String',{'Mean responses 07/06'},...
                'FontWeight','bold',...
                'FontSize',16,...
                'FontAngle','italic',...
                'EdgeColor','none');
        end
        set(gca,'Color','none')
        hold on
        for gch = 1:size(all_RE,3)
            ch_resp = all_RE(r,:,gch,ndx);
            %ch_resp = ch_resp/max(ch_resp(:));
            plot(xdata,ch_resp,'r-','LineWidth',0.5)
            %plot(2,mu_all_RE(end,1,ndx),'r-o','LineWidth',2)
            %             errorbar(xdata,REmuBS{ch}(r-1,:),REste{ch}(r-1,:),'r-o','LineWidth',2)
            %             errorbar(2,REmuBS{ch}(end,1),REste{ch}(end,1),'r-o','LineWidth',2)
        end
        plot([2 128], [0 0], ':k')
        
        for gch = 1:size(all_LE,3)
            ch_resp = all_LE(r,:,gch,ndx);
            %ch_resp = ch_resp/max(ch_resp(:));
            plot(xdata,ch_resp,'b-','LineWidth',0.5)
            %plot(2,all_LE(end,1,ndx),'b-o','LineWidth',2)
        end
        
        %             errorbar(xdata,LEmuBS{ch}(r-1,:),LEste{ch}(r-1,:),'b-o','LineWidth',2);
        %             errorbar(2,LEmuBS{ch}(end,1),LEste{ch}(end,1),'b-o','LineWidth',2);
        plot([2 128], [0 0], ':k')
        
        %ylim([0 1]);
        ylim([0 130]);
        xlim([2 130])
        if r == 1
            xlabel('Modulation amplitude (arc sec)')
        %elseif r == 2
            ylabel('Average baseline subtracted response')
        end
        
        if ndx == 1
            title(sprintf('RF %d size = 1 sf = 1',RFs(r)));
            if r == 3 %rf16
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','22.5','45','90','180','360','720'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            else
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','11.25','22.5','45','90','180','360'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            end
        elseif ndx == 2
            title(sprintf('RF %d size = 1 sf = 2',RFs(r)));
            if r == 3 %rf16
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','22.5','45','90','180','360','720'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            else
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','11.25','22.5','45','90','180','360'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            end
        elseif ndx == 3
            title(sprintf('RF %d size = 2 sf = 1',RFs(r)));
            if r == 3 %rf16
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','45','90','180','360','720','1440'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            else
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','22.5','45','90','180','360','720'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            end
        elseif ndx == 4
            title(sprintf('RF %d size = 2 sf = 2',RFs(r)));
            if r == 3 %rf16
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','45','90','180','360','720','1440'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            else
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','22.5','45','90','180','360','720'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            end
        end
    end
end


%%
%allchannels plot typical example size = 2 deg, spatial frequency= 1 cpd;

max_all_LE = max(all_LE(:));
max_all_RE = max(all_RE(:));
for ndx = 3
    figure
    for  r = 1
        subplot(1,1,r)
        set(gca,'Color','none')
        hold on
        for gch = 1:size(all_RE,3)
            ch_resp = all_RE(r,:,gch,ndx);
            plot(xdata,ch_resp,'r-','LineWidth',0.5)
        end
        
        for gch = 1:size(all_LE,3)
            ch_resp = all_LE(r,:,gch,ndx);
            plot(xdata,ch_resp,'b-','LineWidth',0.5)
        end
        
        ylim([0 100]);
        if r == 3
            xlabel('Modulation amplitude (arc sec)')
        elseif r == 2
            ylabel('Average baseline subtracted response')
        end
        
        if ndx == 1
            title(sprintf('RF %d size = 1 deg sf = 1',RFs(r)));
            if r == 3 %rf16
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','22.5','45','90','180','360','720'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            else
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','11.25','22.5','45','90','180','360'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            end
        elseif ndx == 2
            title(sprintf('RF %d size = 1 deg sf = 2',RFs(r)));
            if r == 3 %rf16
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','22.5','45','90','180','360','720'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            else
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','11.25','22.5','45','90','180','360'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            end
        elseif ndx == 3
            title(sprintf('RF %d size = 2 deg sf = 1',RFs(r)));
            if r == 3 %rf16
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','45','90','180','360','720','1440'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            else
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','22.5','45','90','180','360','720'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            end
        elseif ndx == 4
            title(sprintf('RF %d size = 2 deg sf = 2',RFs(r)));
            if r == 3 %rf16
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','45','90','180','360','720','1440'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            else
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128],...
                    'XTickLabel',{'circle','22.5','45','90','180','360','720'},'XTickLabelRotation', 45,...
                    'FontName','Helvetica Neue','FontAngle','italic','FontSize',12)
            end
        end
        
    end
end


%%
%linear regression
all_LE_slopes = nan(3,size(all_LE,3),size(all_LE,4));
all_LE_rsq = nan(3,size(all_LE,3),size(all_LE,4));
all_RE_slopes = nan(3,size(all_RE,3),size(all_RE,4));
all_RE_rsq = nan(3,size(all_RE,3),size(all_RE,4));
x_var = log2(xdata)';
x_v_reg = [ones(size(x_var)),x_var];
for s_cond = 1:size(all_LE,4)
    for ch_n = 1:size(all_LE,3)
        for rf_n = 1:3
            y_var = all_LE(rf_n,:,ch_n,s_cond)';
            [r_p,~,~,stats] = regress(y_var,x_v_reg);
            all_LE_slopes(rf_n,ch_n,s_cond) = r_p(2);
            all_LE_rsq(rf_n,ch_n,s_cond) = stats(1);
        end
    end
end

for s_cond = 1:size(all_RE,4)
    for ch_n = 1:size(all_RE,3)
        for rf_n = 1:3
            y_var = all_RE(rf_n,:,ch_n,s_cond)';
            [r_p,~,~,stats] = regress(y_var,x_v_reg);
            all_RE_slopes(rf_n,ch_n,s_cond) = r_p(2);
            all_RE_rsq(rf_n,ch_n,s_cond) = stats(1);
        end
    end
end


%%
%linear regression hists

figure
for rf_n = 1:3
    for cond_n = 1:4
        
        subplot(6,4,8*(rf_n-1)+cond_n);
        hold on;
        bin_r = -2:0.3:2;
        [bin_c] = histc(log10(abs(all_LE_slopes(rf_n,:,cond_n))),bin_r);
        b = bar(bin_r,bin_c./sum(bin_c),'FaceColor',[0 0 1],'EdgeColor',[0 0 1]);
        b.BarWidth = 1;
        plot(median(log10(abs(all_LE_slopes(rf_n,:,cond_n)))),0.4,'bv','markerfacecolor','b');
        plot([0 0],[0 0.4],'b-');
        
        xlim([-2 1.2]);
        ylim([0 0.4]);
        
        set(gca,'tickdir','out',...
            'xtick',[-2 -1 0 1],...
            'xticklabel',10.^[-2 -1 0 1],...
            'tickdir','out','Color','none',...
            'FontName','Helvetica Neue',...
            'FontAngle','italic',...
            'FontSize',12)
        box off;
        
        if (rf_n == 1 && cond_n == 1)
            ylabel('RF=4');
            title('Size = 1 SF = 1');
        elseif (rf_n == 2 && cond_n == 1)
            ylabel('RF=8');
        elseif (rf_n == 3 && cond_n == 1)
            ylabel('RF=16');
        end
        if (rf_n == 1 && cond_n == 2)
            title('Size = 1 SF = 2');
        elseif (rf_n == 1 && cond_n == 3)
            title('Size = 2 SF = 1');
        elseif (rf_n == 1 && cond_n == 4)
            title('Size = 2 SF = 2');
        end
        
        subplot(6,4,8*(rf_n-1)+4+cond_n);
        hold on;
        [bin_c] = histc(log10(abs(all_RE_slopes(rf_n,:,cond_n))),bin_r);
        b = bar(bin_r,bin_c./sum(bin_c),'FaceColor',[1 0 0],'EdgeColor',[1 0 0]);
        b.BarWidth = 1;
        plot(median(log10(abs(all_RE_slopes(rf_n,:,cond_n)))),0.4,'rv','markerfacecolor','r');
        plot([0 0],[0 0.4],'r-');
        
        xlim([-2 1.2]);
        ylim([0 0.4]);
        
        set(gca,'tickdir','out',...
            'xtick',[-2 -1 0 1],...
            'xticklabel',10.^[-2 -1 0 1],...
            'tickdir','out','Color','none',...
            'FontName','Helvetica Neue',...
            'FontAngle','italic',...
            'FontSize',12)
        
        box off;
        if (rf_n == 3 && cond_n == 1)
            xlabel('Slope (spikes/octave)');
            ylabel('% channels');
        end
    end
    if rf_n == 1
        topTitle = 'Distribution of slopes across eyes for each RF set 07/06';
        annotation('textbox',...
            [0.2 0.96 0.65 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',14,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end








%%
all_LE_slopes_mu = mean(log10(abs(all_LE_slopes)),2);
all_RE_slopes_mu = mean(log10(abs(all_RE_slopes)),2);

figure

topTitle = 'Slopes across eyes for all parameters 07/06';
annotation('textbox',...
    [0.2 0.96 0.65 0.05],...
    'LineStyle','none',...
    'String',topTitle,...
    'Interpreter','none',...
    'FontSize',14,...
    'FontWeight','bold',...
    'FontAngle','italic',...
    'FontName','Helvetica Neue');

subplot(2,2,1);
hold on;
bin_r = -2:0.3:2;
[bin_c] = histc(log10(abs(all_LE_slopes(:))),bin_r);
b = bar(bin_r,bin_c./sum(bin_c),'FaceColor',[0 0 1],'EdgeColor',[0 0 1]);
b.BarWidth = 1;
plot(median(log10(abs(all_LE_slopes(:)))),0.3,'bv','markerfacecolor','b');
plot([0 0],[0 0.4],'b-');
xlim([-2 1.2]);
ylim([0 0.4]);
set(gca,'tickdir','out',...
    'xtick',[-2 -1 0 1],...
    'xticklabel',10.^[-2 -1 0 1],...
    'tickdir','out','Color','none',...
    'FontName','Helvetica Neue',...
    'FontAngle','italic',...
    'FontSize',12)
box off;


subplot(2,2,3);
hold on;
[bin_c] = histc(log10(abs(all_RE_slopes(:))),bin_r);
b = bar(bin_r,bin_c./sum(bin_c),'FaceColor',[1 0 0],'EdgeColor',[1 0 0]);
b.BarWidth = 1;
plot(median(log10(abs(all_RE_slopes(:)))),0.3,'rv','markerfacecolor','r');
plot([0 0],[0 0.4],'r-');
xlim([-2 1.2]);
ylim([0 0.4]);
xlabel('Slope (spikes/octave)');
ylabel('Propotion channels');
set(gca,'tickdir','out',...
    'xtick',[-2 -1 0 1],...
    'xticklabel',10.^[-2 -1 0 1],...
    'tickdir','out','Color','none',...
    'FontName','Helvetica Neue',...
    'FontAngle','italic',...
    'FontSize',12)
box off;



subplot(2,2,2);
hold on;
plot(log10([4 8 16]),squeeze(all_LE_slopes_mu),'b');
plot(log10([4 8 16]),squeeze(all_RE_slopes_mu),'r');
set(gca,'tickdir','out');
ylabel('Slope (spikes/octave)');
xlabel('RF');
set(gca,'tickdir','out');
ylim([-0.6,0.6]);
set(gca,'ytick',log10([0.3 1 3]));
set(gca,'yticklabel',[0.3 1 3]);
xlim([0.4,1.4]);
set(gca,'xtick',log10([4 8 16]));
set(gca,'xticklabel',([4 8 16]),'Color','none');
set(gca,'FontName','Helvetica Neue',...
    'FontAngle','italic',...
    'FontSize',12)


subplot(2,2,4);
hold on;
plot(log10([4 8 16]),mean(squeeze(all_LE_slopes_mu)'),'b');
plot(log10([4 8 16]),mean(squeeze(all_RE_slopes_mu)'),'r');
set(gca,'tickdir','out');
ylabel('Slope (spikes/octave)');
xlabel('RF');
set(gca,'tickdir','out');
ylim([-0.6,0.6]);
set(gca,'ytick',log10([0.3 1 3]));
set(gca,'yticklabel',[0.3 1 3]);
xlim([0.4,1.4]);
set(gca,'xtick',log10([4 8 16]));
set(gca,'xticklabel',([4 8 16]),'Color','none');
set(gca,'FontName','Helvetica Neue',...
    'FontAngle','italic',...
    'FontSize',12)




%%
figure(1);
clf;
all_LE_circle = squeeze(all_LE(4,1,:,:));
all_RE_circle = squeeze(all_RE(4,1,:,:));

LE_c = zeros(1,96);
LE_c(logical(LEdata.goodCh)) = mean(all_LE_circle,2);
RE_c = zeros(1,96);
RE_c(logical(REdata.goodCh)) = mean(all_RE_circle,2);

oc_dom_ind = ((LE_c-RE_c)./(LE_c+RE_c));
subplot(2,1,1);
hold on;
bin_r = -1:0.1:1;
bin_c = histc(oc_dom_ind,bin_r);
oc_b = bar(bin_r,bin_c./sum(bin_c),'FaceColor',[0 0 0]);
oc_b.BarWidth = 1;
xlim([-1.1,1.1]);
plot(nanmean(oc_dom_ind),0.3,'kv','markerfacecolor','k');

box off;
xlabel('FE-AE/FE+AE (Circle)');
ylabel('% channels');

set(gca,'tickdir','out','color','none',...
    'FontName','Helvetica Neue',...
    'FontAngle','italic',...
    'FontSize',12);
















