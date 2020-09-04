% RunRFArrayAnalysis
%
% This program goes through all of the recordings using RF stimuli within a
% specific folder and runs the analysis.

clear all
%close all
clc
tic
%%
location  = 0;
dispFig = 1;
files = ['WU_LE_RadFreq_nsp2_June2017';'WU_RE_RadFreq_nsp2_June2017'];
% %% Check file, get array map
% if location == 1
%     %Amfortas
%     cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
% else
%     %laptop
%     cd ~/Dropbox/ArrayData/WU_ArrayMaps
% end
%%

for i = 1:size(files,1)
    fprintf('running file #%d %s',i,files(i,:))
    data = radFreqMwksch_April(files(i,:),location);
    if strfind(files(i,:),'LE')
        LEdata = data;
    else
        REdata = data;
    end
end
%% amp x RF 
% subplots for each RF, responses to the different amplitudes collapsed
% across all other parameters.

if dispFig == 1
    rfs = [4,8,16];
    for ch = 1:96
        for po = 1:length(LEdata.rfAmpResponse{ch})
            LEt(1,po) = max(LEdata.rfAmpResponse{ch}{po}(:,4));
            REt(1,po) = max(REdata.rfAmpResponse{ch}{po}(:,4));
            
            LEb = LEdata.radFreqResponse{ch}(end,3);
            LES = min(LEdata.rfAmpResponse{ch}{po}(:,4));
            Ltmp = min(LEb, LES);
            LEty(1,po) = Ltmp;
            
            REb = REdata.radFreqResponse{ch}(end,3);
            RES = min(REdata.rfAmpResponse{ch}{po}(:,4));
            Rtmp = min(REb, RES);
            REty(1,po) = Rtmp;
        end
        lm = max(LEt);
        rm = max(REt);
        yMax = max(lm,rm);
        buffer = yMax * 0.10;
        yMax = yMax+buffer;
        
        lm = min(LEty);
        rm = min(REty);
        yMin = min(lm,rm);
        buffer = yMin * 0.10;
        yMin = yMin-buffer;
        
        figure
        if strfind(files(1,:),'nsp2')
            topTitle = (sprintf('V4 RF amplitude responses channel %d',ch));
        else
            topTitle = (sprintf('V1 RF amplitude responses channel %d',ch));
        end
        annotation('textbox',...
            [0.1 0.96 0.7 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',16,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
        for rs = 1:3
            
            %xCirc   = data.rfAmpResponse{ch}{1}(8,2);
            LEyCirc   = LEdata.radFreqResponse{ch}((end-1),3);
            LEcircErr = LEdata.radFreqResponse{ch}((end-1),4);
            
            REyCirc   = REdata.radFreqResponse{ch}((end-1),3);
            REcircErr = REdata.radFreqResponse{ch}((end-1),4);
            
            REblankResp = REdata.radFreqResponse{ch}(end,3);
            REblankErr  = REdata.radFreqResponse{ch}(end,4);
            LEblankResp = LEdata.radFreqResponse{ch}(end,3);
            LEblankErr  = REdata.radFreqResponse{ch}(end,4);
            
            subplot(2,2,1)
            hold on
            set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
            if strfind(files(1,:),'XT')
                text(1,5,'RE','Color','red','FontSize',20,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
                text(7,5,'LE','Color','blue','FontSize',20,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
            else
                text(1,5,'AE','Color','red','FontSize',20,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
                text(7,5,'FE','Color','blue','FontSize',20,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
            end
            xlim([0 10])
            ylim([0,10])
            
            subplot(2,2,rs+1)
            hold on
            
%            if ~isempty(intersect(LEdata.goodChannels,ch))
                LExdata = LEdata.rfAmpResponse{ch}{rs}(:,2);
                LEydata = LEdata.rfAmpResponse{ch}{rs}(:,4);
                LEstErr = LEdata.rfAmpResponse{ch}{rs}(:,5);
                
                errorbar(LExdata,LEydata,LEstErr,'.-b','LineWidth',2,'MarkerSize',11)
                errorbar(1.5,LEyCirc,LEcircErr,'b*','LineWidth',2,'MarkerSize',8)
                
                plot([1 310], [LEblankResp LEblankResp],'b','LineWidth',2,'MarkerSize',11)
                errorbar(300,LEblankResp,LEblankErr,'b.','LineWidth',2,'MarkerSize',11)
 %           end
            
  %          if ~isempty(intersect(REdata.goodChannels,ch))
                RExdata = REdata.rfAmpResponse{ch}{rs}(:,2);
                REydata = REdata.rfAmpResponse{ch}{rs}(:,4);
                REstErr = REdata.rfAmpResponse{ch}{rs}(:,5);
                
                errorbar(RExdata,REydata,REstErr,'.-r','LineWidth',2,'MarkerSize',11)
                errorbar(1.5,REyCirc,REcircErr,'r*','LineWidth',2,'MarkerSize',8)
                
                plot([1 310], [REblankResp REblankResp],'r','LineWidth',2,'MarkerSize',11)
                errorbar(300,REblankResp,REblankErr,'r.','LineWidth',2,'MarkerSize',11)
   %         end
            
            axis square xy
            set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTickLabelRotation', 45)
            xlabel('amplitude')
            ylabel('Spikes/sec')
            xlim([1 310])
            ylim([yMin yMax])
            title(sprintf('RF %d',rfs(rs)))
        end
        if strfind(files(1,:),'nsp1')
            figName = ['WU','_','V1','_',num2str(ch,'ch%d')];
            cd /Users/bbushnell/Dropbox/Figures/wu_arrays/RF/V1
        else
            figName = ['WU','_','V4','_',num2str(ch,'ch%d')];
            cd /Users/bbushnell/Dropbox/Figures/wu_arrays/RF/V4
        end
        
        saveas(gcf,figName,'pdf')
    end
end
%%

toc/60
