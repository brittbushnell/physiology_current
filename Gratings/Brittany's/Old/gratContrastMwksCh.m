% gratContrastMwksCh is a function that analyzes contrast sensitivity data
% from MWKS array data where the stimulus is a single sinusoidal grating that
% varies in contrast, spatial frequency, and orientation.
%
% Written Nov 8, 2017 Brittany Bushnell

clear all
close all
clc
tic
%%
location = 1; %1 = amfortas
files = 'WU_RE_GratingsCon_nsp1_20170811_001';
%mnUse = 4; % variable to designate whether to use the mean (4) or the baseline subtracted mean (5) for analysis
%%
if location == 1
    % Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
elseif location == 0
    % laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
elseif location == 2
    cd /home/bushnell/ArrayAnalysis/ArrayMaps
end
if ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');

elseif ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');

else
    error('Error: array ID missing or wrong')
end
%%
%for fi = 1:size(files,1)
filename = files(fi,:)
load(filename);
numChannels = size(LEdata.bins,3);
aMap = LEdata.amap;
%%
for eye = 1:2   % the fitted file mats have a data structure for each eye already
    if eye == 1
        dataT = LEdata;
    else
        dataT = REdata;
    end
    cons = unique(dataT.contrast);
    sfs = unique(dataT.spatial_frequency);
    sfsRelev = sfs(1,4:end);
    
    for ch = 1:numChannels
        blank = dataT.spatialFrequencyResp{ch}(3,1);
        for s = 1:size(sfsRelev,2)
            for c = 1:size(cons,2)
                maxOri = dataT.maxOri(1,ch);
                
                csfT(1,c) = sfsRelev(1,s);
                csfT(2,c) = cons(1,c);
                csfT(3,c) = sum((dataT.contrast == cons(1,c)) .* (dataT.spatial_frequency == sfsRelev(1,s)) .* (dataT.rotation == maxOri));
                tmpNdx   = find((dataT.contrast == cons(1,c)) .* (dataT.spatial_frequency == sfsRelev(1,s)) .* (dataT.rotation == maxOri));
                
                useRuns   = double(dataT.bins(tmpNdx,dataT.latency(1,ch):dataT.latency(2,ch),ch));
                csfT(4,c) = mean(useRuns(:))./0.010; %dividing the mean by binStimOn/.010 puts the results into spikes/sec
                csfT(5,c) = csfT(4,c) - blank;
                
                %error bars
                stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                csfT(6,c) = csfT(mnUse,c) - stErr;
                csfT(7,c) = csfT(mnUse,c) + stErr;
                csfT(8,c) = stErr;
                
            end
            conSens{s} = csfT;
            clear csfT;
        end
        dataT.conSensResps{ch} = conSens;
    end
    
    % use ss_weib function to get neurometric "threshold" for each spatial
    % frequency, then plot the csf for each eye, using these thresholds for
    % each SF.  To plot the csf, and calculate the AI, look at Tom's code
    % on GitHub.
    
    for ch  = 1:numChannels
        for s = 1:size(sfsRelev,2)
            xs = dataT.conSensResps{ch}{s}(2,:)';
            ys = dataT.conSensResps{ch}{s}(mnUse,:)';
            [csfParams(:,ch), csfThresh(1,ch), csfSE(1,ch)] = ss_weib(xs, ys, 0.5);
        end
    end
    dataT.csfParams = csfParams;
    dataT.csfThresh = csfThresh;
    data.csfSE = csfSE;
    
    if eye == 1
        LEdata = dataT;
    else
        REdata = dataT;
    end
end
%% plot thresholds

%figure
for ch = 1:numChannels
    figure
    % subplot(aMap,10,10,ch)
    LEx  = LEdata.conSensResps{ch}{s}(2,:);
    LEy  = LEdata.csfThresh(1,ch);
    LEx2 = LEx(1,1):60:LEx(1,end);
    LEy2 = REdata.csfParams(:,ch);
    
    hold on
    plot(LEx,LEy,'o')
    plot(LEx2,LEy2(4,1)+LEy2(3,1)*wblcdf(LEx2,LEy2(1,1),LEy2(2,1)),'-')
    
    title(ch)
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
        'XTick',[0.3 0.6 1.25 2.5 5 10],...
        'XTickLabel',{'0.3', '0.6', '1.25', '2.5', '5', '10'},...
        'FontSize',10,...
        'XTickLabelRotation', 45)
    xlim([0.2 11])
    
    %         if ch == 1
    %             if strfind(filename,'V4')
    %                 topTitle = 'SF thresholds for best orientation, V4 array';
    %                 subplot(10,10,1)
    %             elseif strfind(filename,'V1')
    %                 topTitle = 'SF tuning for best orientation V1 array';
    %                 subplot(10,10,21)
    %             end
    %             xlabel('sf(cpd)')
    %             ylabel('sp/s')
    %             xlim([0 30])
    %             ylim([0 35])
    %             set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    %             text(2,5,'lines = pref SF','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
    %
    %             if strfind(filename,'XT')
    %                 text(2,20,'RE','Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
    %                 text(18,20,'LE','Color','blue','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
    %             else
    %                 text(2,20,'AE','Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
    %                 text(18,20,'FE','Color','blue','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
    %             end
    %             annotation('textbox',...
    %                 [0.4 0.94 0.35 0.05],...
    %                 'LineStyle','none',...
    %                 'String',topTitle,...
    %                 'Interpreter','none',...
    %                 'FontSize',16,...
    %                 'FontAngle','italic',...
    %                 'FontName','Helvetica Neue');
    %         end
end
%%

% REx  = REdata.conSensResps{ch}{s}(1,:);
% REy  = REdata.conSensResps{ch}{s}(mnUse,:);
% REx2 = REx(1,1):60:REx(1,end);
% REy2 = REdata.csfParams(:,ch);
%
% plot(REx,REy,'ob')
% plot(REx2,REy2(4,1)+REy2(3,1)*wblcdf(REx,REy2(1,1),REy2(2,1)),'-b')


%%
toc/60