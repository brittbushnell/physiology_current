%function [ODImtx] = getODI(data)
% GETODI [ODImtx] = ocularDominance(data)
% is a function that computes the ocular dominance of monocularlly recorded
% data.
%
%  ODI = (LE-RE) / (LE+RE) using each eye's maximum response.
%  1: only responds to the LE
%  -1: only responds to the RE
%
% OUTPUT is a row vector where each column is the ODI for that channel, and
% the last two values are the mean ODI and the t-test Pvalue respectively.
%
% Written Nov 13, 2017 Brittany Bushnell
%%
close all
clear all
clc
%%
location = 1; % 1 = amfortas
%files = ['fitData_WU_Gratings_V4_withRF'; 'fitData_WU_Gratings_V1_withRF'];

%files = ['fitData_WU_GratingsCon_V4_Aug2017';'fitData_WU_GratingsCon_V1_Aug2017'];
files = ['fitData_WU_Gratings_V4_recuts';'fitData_WU_Gratings_V1_recuts'];
%%
for fi = 1:size(files,1)
    filename = files(fi,:);
    if location == 1
    else
        if strfind(filename,'V4')
            cd ~/Dropbox/ArrayData/matFiles/V4/Gratings/FittedMats/
        else
            cd ~/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/
        end
    end
    %%
    load(filename)
    numChannels = size(LEdata.bins,3);
    aMap = LEdata.amap;
    for eye = 1:2
        if eye == 1
            dataT = LEdata;
        else
            dataT = REdata;
        end
        
        sfs = unique(dataT.spatial_frequency);
        sfsR = sfs(1,4:end);
        oris = unique(dataT.rotation);
        %%
        for ch = 1:numChannels
            [maxSfOr(:,ch),maxSfOrB(:,ch)] = getPrefGrating(dataT,ch);
        end
        if eye == 1
            LEdata.maxSfOr = maxSfOr;
        else
            REdata.maxSfOr = maxSfOr;
        end
        if strfind(filename,'V4')
            if eye == 1
                V4dataLE = LEdata;
            else
                V4dataRE = REdata;
            end
        else
            if eye == 1
                V1dataLE = LEdata;
            else
                V1dataRE = REdata;
            end
        end
    end
    
    if strfind(filename,'V4')
        V4dataLE.ODI = computeODI_Grat(LEdata,REdata);
        V4dataRE.ODI = computeODI_Grat(LEdata,REdata);
        clear ODI
    else
        V1dataLE.ODI = computeODI_Grat(LEdata,REdata);
        V1dataRE.ODI = computeODI_Grat(LEdata,REdata);
        clear ODI
    end
end
clear foo
format short
[~,pODI] = ttest(V4dataLE.ODI(1,1:numChannels),V1dataLE.ODI(1,1:numChannels));
[~,pMI] = ttest(V4dataLE.ODI(2,1:numChannels),V1dataLE.ODI(2,1:numChannels));
%% plot ODI

figure
hold on
histogram(V4dataLE.ODI(1,1:end-2),10,'BinWidth',0.1,'FaceColor',[0,0,1],'FaceAlpha',0.3)
histogram(V1dataLE.ODI(1,1:end-2),10,'BinWidth',0.1,'FaceColor',[1,0,0],'FaceAlpha',0.3)

plot(V1dataLE.ODI(1,end-1),50,'v','MarkerFaceColor',[1,0,0],...
    'MarkerEdgeColor',[1,0,0],'MarkerSize',8)
text(V1dataLE.ODI(1,end-1),52,num2str(V1dataLE.ODI(1,end-1),'V1/V2 med %.3f'),...
    'FontSize',10,'HorizontalAlignment','center')
% text(V1dataLE.ODI(1,end-1),52,num2str(V4dataLE.ODI(2,end),'V1 p = %.3f'),...
%     'FontSize',10,'HorizontalAlignment','center')


plot(V4dataLE.ODI(1,end-1),50,'v','MarkerFaceColor',[0,0,1],...
    'MarkerEdgeColor',[0,0,1],'MarkerSize',8)
text(V4dataLE.ODI(1,end-1),55,num2str(V4dataLE.ODI(1,end-1),'V4 med %.3f'),...
    'FontSize',10,'HorizontalAlignment','center')
% text(V4dataLE.ODI(1,end-1),55,num2str(V4dataLE.ODI(2,end),'V4 p = %.3f'),...
%     'FontSize',10,'HorizontalAlignment','center')

% text(0.75,70,num2str(pODI,'V1/V2 vs V4 p = %.3f'),...
%     'FontSize',10,'HorizontalAlignment','center')

set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'},...
    'XTickLabelRotation', 45);

plot([0 0], [0 90], 'k:')
xlim([-1 1])
legend('V4','V1/V2')

xlabel('ODI','FontWeight','bold')
ylabel('# of channels','FontWeight','bold')

title('Ocular dominance index (ODI)')
%% Plot monocularity index
figure
hold on
histogram(V4dataLE.ODI(2,1:end-2),10,'BinWidth',0.1,'FaceColor',[0,0,1],'FaceAlpha',0.3)
histogram(V1dataLE.ODI(2,1:end-2),10,'BinWidth',0.1,'FaceColor',[1,0,0],'FaceAlpha',0.3)

plot(V1dataLE.ODI(2,end-1),50,'v','MarkerFaceColor',[1,0,0],...
    'MarkerEdgeColor',[1,0,0],'MarkerSize',8)
text(V1dataLE.ODI(2,end-1),51.5,num2str(V1dataLE.ODI(2,end-1),'V1/V2 med %.3f'),...
    'FontSize',10,'HorizontalAlignment','center')
% text(V1dataLE.ODI(2,end-1),51.5,num2str(V1dataLE.ODI(2,end),'V1 p=%.3f'),...
%     'FontSize',10,'HorizontalAlignment','center')

plot(V4dataLE.ODI(2,end-1),50,'v','MarkerFaceColor',[0,0,1],...
    'MarkerEdgeColor',[0,0,1],'MarkerSize',8)
text(V4dataLE.ODI(2,end-1),53,num2str(V4dataLE.ODI(2,end-1),'V4 med %.3f'),...
    'FontSize',10,'HorizontalAlignment','center')
% text(V4dataLE.ODI(2,end-1),53,num2str(V4dataLE.ODI(2,end),'V4 p=%.3f'),...
%     'FontSize',10,'HorizontalAlignment','center')

% text(0.8,46,num2str(pMI,'V1/V2 vs V4 p = %.3f'),...
%     'FontSize',10,'HorizontalAlignment','center')

set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTick',[0 0.5 1],'XTickLabel',{'Binoc','','Monoc'},...
    'XTickLabelRotation', 45);

xlim([0 1])
ylim([0 55])
legend('V4','V1/V2')

xlabel('MI','FontWeight','bold')
ylabel('# of channels','FontWeight','bold')

title('Moncularity index (MI)')





