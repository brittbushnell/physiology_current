% radFreq3_RFxAmp
%
% This is the third step in the radial frequency analysis pipeline. It
% takes in the .mat file that has data structures for both eyes, and has
% the rfResps and blankResps matrices and breaks them down further to
% analyze responses to each radial frequency as a function of amplitude. 
%
% June 3, 2018 Brittany Bushnell


clear all
close all
clc
tic
%% This is what will be passed in for running as a function
% file = 'WU_RadialFrequency_V4_3day_byStim';
% newName = 'WU_RadialFrequency_V4_3day_RFxAmp';

file = 'WU_LE_RadFreqLoc2_V4_20170707_002_recut_byStim';
newName = 'WU_LE_RadFreqLoc2_V4_20170707_002_recut_RFxAmp';

location = 1;
startBin = 5;
endBin = 35;
%% Get stimulus information
load(file);

RFs   = unique(LEdata.rf);
amps  = unique(LEdata.amplitude);
phase = unique(LEdata.orientation);
SFs   = unique(LEdata.spatialFrequency);
xLocs = unique(LEdata.pos_x);
yLocs = unique(LEdata.pos_y);
rads  = unique(LEdata.radius);

numCh = size(LEdata.bins,3);
%%
sz_sf_ndx = 1;
for sz_rad = [1 2]
    for circ_sf = [1 2]
        for ch = 1:numCh
            LEmedT = nan(4,6);
%             REmedT = nan(4,6);
            
            LEmuTS = nan(4,6);
%             REmuTS = nan(4,6);
            
            LEsteT = nan(4,6);
%             REsteT = nan(4,6);
            for r = 1:length(RFs)
                ndx = 1;
                for a = 1:length(amps)
                    %find the trials with the given rf x amp x size x sf
                    %combo
%                     REndx = find((REdata.stimResps{ch}(1,:) == RFs(r)) & ...
%                         (REdata.stimResps{ch}(2,:) == amps(a)) & ...
%                         (REdata.stimResps{ch}(5,:) == sz_rad) &...
%                         (REdata.stimResps{ch}(4,:) == circ_sf));
                    
                    
                    LEndx = find((LEdata.stimResps{ch}(1,:) == RFs(r)) & ...
                        (LEdata.stimResps{ch}(2,:) == amps(a)) & ...
                        (LEdata.stimResps{ch}(5,:) == sz_rad) & ...
                        (LEdata.stimResps{ch}(4,:) == circ_sf));
                    
                    
                    if ~isempty(LEndx)  % different RFs use different amplitudes, so this should skip any amplitudes that weren't run for that RF
                        %disp(sprintf('RF %d, amp %d',RFs(r),amps(a)))
%                        clear REndxBS LEndxBS;
                        clear LEndxBS;
                        for i = 1:length(LEndx)
%                             REndxMean(i) = (REdata.stimResps{ch}(end-3,REndx(i)));
                            LEndxMean(i) = (LEdata.stimResps{ch}(end-3,LEndx(i)));
                            
%                             REndxMed(i) = (REdata.stimResps{ch}(end-2,REndx(i)));
                            LEndxMed(i) = (LEdata.stimResps{ch}(end-2,LEndx(i)));
                            
%                             REste1(i) = REdata.stimResps{ch}(end-1,REndx(i));
                            LEste1(i) = LEdata.stimResps{ch}(end-1,LEndx(i));
                        end
                        LEmuTS(r,ndx) = mean(LEndxMean);
%                         REmuTS(r,ndx) = mean(REndxMean);
                        
                        LEmedT(r,ndx) = mean(LEndxMed);
%                         REmedT(r,ndx) = mean(REndxMed);
                        
%                         REsteT(r,ndx) = 0.01; %mean(REste1); % why 0.01?
                        LEsteT(r,ndx) = 0.01; %mean(LEste1);
                        
                        ndx = ndx+1;
                    end
                end
            end
            
            LEmedian{ch} = LEmedT;
%             REmedian{ch} = REmedT;
            
%             REste{ch} = REsteT;
            LEste{ch} = LEsteT;
            
            LEmuBS{ch} = LEmuTS-LEdata.blankResps{ch}(end-2);
%             REmuBS{ch} = REmuTS-REdata.blankResps{ch}(end-2);
        end
%         all_RE(:,:,:,sz_sf_ndx) = cat(3,(REmuBS{logical(REdata.goodChannels)}));
        all_LE(:,:,:,sz_sf_ndx) = cat(3,(LEmuBS{logical(LEdata.goodChannels)}));
        sz_sf_ndx = sz_sf_ndx+1;
    end
end

% REdata.all_RE = all_RE;
LEdata.all_LE = all_LE;

% REdata.medianResps = REmedian;
LEdata.medianResps = LEmedian; 
%% linear regression
xdata = [4,8,16,32,64,128];

all_LE_slopes = nan(3,size(all_LE,3),size(all_LE,4));
all_LE_rsq = nan(3,size(all_LE,3),size(all_LE,4));
% all_RE_slopes = nan(3,size(all_RE,3),size(all_RE,4));
% all_RE_rsq = nan(3,size(all_RE,3),size(all_RE,4));
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

% for s_cond = 1:size(all_RE,4)
%     for ch_n = 1:size(all_RE,3)
%         for rf_n = 1:3
%             y_var = all_RE(rf_n,:,ch_n,s_cond)';
%             [r_p,~,~,stats] = regress(y_var,x_v_reg);
%             all_RE_slopes(rf_n,ch_n,s_cond) = r_p(2);
%             all_RE_rsq(rf_n,ch_n,s_cond) = stats(1);
%         end
%     end
% end
% REdata.regressionSlopes = all_RE_slopes;
% REdata.slopeRsquare = all_RE_rsq;

LEdata.regressionSlopes = all_LE_slopes;
LEdata.slopeRsquare = all_LE_rsq;
%% Save data
if strfind(file,'nsp1')
    if location == 2
        cd /home/bushnell/matFiles/V1/RadialFrequency/RFxAmp
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/RFxAmp
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/RFxAmp
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/V4/RadialFrequency/RFxAmp
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/RFxAmp
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/RFxAmp
    end
end


%save(newName,'REdata','LEdata');
save(newName, 'LEdata');
fprintf('File saved as: %s',newName)
%% plot Mean responses for all SF x Size combinations
xdata = [4,8,16,32,64,128];
% mu_all_RE = squeeze(mean(all_RE,3));
mu_all_LE = squeeze(mean(all_LE,3));
se_all_LE = squeeze(std(all_LE,0,3)./sqrt(size(all_LE,3)));
% se_all_RE = squeeze(std(all_RE,0,3)./sqrt(size(all_RE,3)));

max_LE = max(mu_all_LE(:));
% max_RE = max(mu_all_RE(:));

figure
spot = 1;
for ndx = 1:4
    for  r = 1:3
        
        subplot(4,3,spot)
        %         title(sprintf('%s radial frequency tuning baseline subtracted average', array));
        %         axis off
        set(gca,'Color','none')
        hold on
        
%         plot(xdata,mu_all_RE(r,:,ndx),'r-o','LineWidth',2);
%         errorbar(xdata,mu_all_RE(r,:,ndx),se_all_RE(r,:,ndx),'r-o','LineWidth',2,'CapSize',0.1)
%         plot(2,mu_all_RE(end,1,ndx),'r-o','LineWidth',2)
%         errorbar(2,mu_all_RE(end,1,ndx),se_all_RE(end,1,ndx),'r-o','LineWidth',2,'CapSize',0.1)
%         
        
        plot(xdata,mu_all_LE(r,:,ndx),'b-o','LineWidth',2);
        errorbar(xdata,mu_all_LE(r,:,ndx),se_all_LE(r,:,ndx),'b-o','LineWidth',2,'CapSize',0.1);
        plot(2,mu_all_LE(end,1,ndx),'b-o','LineWidth',2)
        errorbar(2,mu_all_LE(end,1,ndx),se_all_LE(end,1,ndx),'b-o','LineWidth',2,'CapSize',0.1);
%        ylim([0 max(max_LE, max_RE)])
        ylim([0 max_LE])
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
                'String',{'Mean responses for all SF x Size combinations 06/28'},...
                'FontWeight','bold',...
                'FontSize',16,...
                'FontAngle','italic',...
                'EdgeColor','none');
        end
        spot = spot+1;
    end
end
%% slopes for all channels plotted, one fig per sf rad combo

max_all_LE = max(all_LE(:));
% max_all_RE = max(all_RE(:));
for ndx = 1:4
    figure
    for  r = 1:3
        subplot(1,3,r)
        %         title(sprintf('%s radial frequency tuning baseline subtracted average', array));
        %         axis off
        if r == 1 
            annotation('textbox',...
                [0.35 0.96 0.85 0.05],...
                'String',{'Mean responses 06/28'},...
                'FontWeight','bold',...
                'FontSize',16,...
                'FontAngle','italic',...
                'EdgeColor','none');
        end
        set(gca,'Color','none')
        hold on
%         for gch = 1:size(all_RE,3)
%             ch_resp = all_RE(r,:,gch,ndx);
%             %ch_resp = ch_resp/max(ch_resp(:));
%             plot(xdata,ch_resp,'r-','LineWidth',0.5)
%             %plot(2,mu_all_RE(end,1,ndx),'r-o','LineWidth',2)
%             %             errorbar(xdata,REmuBS{ch}(r-1,:),REste{ch}(r-1,:),'r-o','LineWidth',2)
%             %             errorbar(2,REmuBS{ch}(end,1),REste{ch}(end,1),'r-o','LineWidth',2)
%         end
%         plot([2 128], [0 0], ':k')
        
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
        ylim([0 180]);
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


%% allchannels plot typical example size = 2 deg, spatial frequency= 1 cpd;

max_all_LE = max(all_LE(:));
% max_all_RE = max(all_RE(:));
for ndx = 3
    figure
    for  r = 1
        subplot(1,1,r)
        set(gca,'Color','none')
        hold on
%         for gch = 1:size(all_RE,3)
%             ch_resp = all_RE(r,:,gch,ndx);
%             plot(xdata,ch_resp,'r-','LineWidth',0.5)
%         end
        
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
%% linear regression hists

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
        
%         subplot(6,4,8*(rf_n-1)+4+cond_n);
%         hold on;
%         [bin_c] = histc(log10(abs(all_RE_slopes(rf_n,:,cond_n))),bin_r);
%         b = bar(bin_r,bin_c./sum(bin_c),'FaceColor',[1 0 0],'EdgeColor',[1 0 0]);
%         b.BarWidth = 1;
%         plot(median(log10(abs(all_RE_slopes(rf_n,:,cond_n)))),0.4,'rv','markerfacecolor','r');
%         plot([0 0],[0 0.4],'r-');
%         
%         xlim([-2 1.2]);
%         ylim([0 0.4]);
%         
%         set(gca,'tickdir','out',...
%             'xtick',[-2 -1 0 1],...
%             'xticklabel',10.^[-2 -1 0 1],...
%             'tickdir','out','Color','none',...
%             'FontName','Helvetica Neue',...
%             'FontAngle','italic',...
%             'FontSize',12)
%         
%         box off;
%         if (rf_n == 3 && cond_n == 1)
%             xlabel('Slope (spikes/octave)');
%             ylabel('% channels');
%         end
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
%% collapsed regressions
all_LE_slopes_mu = mean(log10(abs(all_LE_slopes)),2);
%all_RE_slopes_mu = mean(log10(abs(all_RE_slopes)),2);

figure

topTitle = 'Slopes across eyes for all parameters 06/28';
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


% subplot(2,2,3);
% hold on;
% [bin_c] = histc(log10(abs(all_RE_slopes(:))),bin_r);
% b = bar(bin_r,bin_c./sum(bin_c),'FaceColor',[1 0 0],'EdgeColor',[1 0 0]);
% b.BarWidth = 1;
% plot(median(log10(abs(all_RE_slopes(:)))),0.3,'rv','markerfacecolor','r');
% plot([0 0],[0 0.4],'r-');
% xlim([-2 1.2]);
% ylim([0 0.4]);
% xlabel('Slope (spikes/octave)');
% ylabel('Propotion channels');
% set(gca,'tickdir','out',...
%     'xtick',[-2 -1 0 1],...
%     'xticklabel',10.^[-2 -1 0 1],...
%     'tickdir','out','Color','none',...
%     'FontName','Helvetica Neue',...
%     'FontAngle','italic',...
%     'FontSize',12)
% box off;



subplot(2,2,2);
hold on;
plot(log10([4 8 16]),squeeze(all_LE_slopes_mu),'b');
%plot(log10([4 8 16]),squeeze(all_RE_slopes_mu),'r');
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
%plot(log10([4 8 16]),mean(squeeze(all_RE_slopes_mu)'),'r');
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
%% ocular dominance
% figure
% all_LE_circle = squeeze(all_LE(4,1,:,:));
% all_RE_circle = squeeze(all_RE(4,1,:,:));
% 
% LE_c = zeros(1,96);
% LE_c(logical(LEdata.goodChannels)) = mean(all_LE_circle,2);
% RE_c = zeros(1,96);
% RE_c(logical(REdata.goodChannels)) = mean(all_RE_circle,2);
% 
% oc_dom_ind = ((LE_c-RE_c)./(LE_c+RE_c));
% subplot(2,1,1);
% hold on;
% bin_r = -1:0.1:1;
% bin_c = histc(oc_dom_ind,bin_r);
% oc_b = bar(bin_r,bin_c./sum(bin_c),'FaceColor',[0 0 0]);
% oc_b.BarWidth = 1;
% xlim([-1.1,1.1]);
% plot(nanmean(oc_dom_ind),0.3,'kv','markerfacecolor','k');
% 
% box off;
% xlabel('FE-AE/FE+AE (Circle)');
% ylabel('% channels');
% title('RF ocular dominance 07/06');
% 
% set(gca,'tickdir','out','color','none',...
%     'FontName','Helvetica Neue',...
%     'FontAngle','italic',...
%     'FontSize',12);

