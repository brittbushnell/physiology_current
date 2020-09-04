%function [] = plotRFArrayData(data)
% PLOTRFARRAYDATA is a function that plots the responses to RF stimuli when
% collected with a Blackrock array
%
% INPUT
% DATA is the data structure that comes out after the data has already been
% parsed and collapsed across parameters. 
%
% OUTPUT
% no values are returned, just plots
%
% Written May 30, 2017 by Brittany Bushnell
clear all
close all
tic
%%
% file = 'WU_V1_RadFreq_combined';
% array = 'V1';
% file ='WU_V4_RadFreq_combined';
% array = 'V4';

 files = ['WU_LE_RadFreqLoc2_nsp1_20170707_means1'; 'WU_RE_RadFreqLoc2_nsp1_20170707_means1'];
 %files = ['WU_LE_RadFreqLoc2_nsp2_20170707_means1'; 'WU_RE_RadFreqLoc2_nsp2_20170707_means1'];

for fi = 1:size(files,1)
    filename = files(fi,:);
    load(filename);
    if strfind(filename,'LE')
        LEdata = data;
    else
        REdata = data;
    end
end
%%
location = 2;

if location == 2
    addpath(genpath('/home/bushnell/ArrayAnalysis/'))
    addpath(genpath('/home/bushnell/Figures/'))
    addpath(genpath('/home/bushnell/binned_data/'))
    addpath(genpath('/home/bushnell/matFiles/'))
end
%%
load(file);
numChannels = size(LEdata.bins,3);
%% Plot RF data
xdata = LEdata.radFreqResponse((1:end-2),1);

AEydata = REdata.radFreqResponse((1:end-2),3);
AEErr   = REdata.radFreqResponse((1:end-2),4);
AExCirc     = REdata.radFreqResponse((end-1),1);
AEyCirc     = REdata.radFreqResponse((end-1),3);
AEcircErr   = REdata.radFreqResponse((end-1),4);

FEydata = LEdata.radFreqResponse((1:end-2),3);
FEErr   = LEdata.radFreqResponse((1:end-2),4);
FExCirc     = LEdata.radFreqResponse((end-1),1);
FEyCirc     = LEdata.radFreqResponse((end-1),3);
FEcircErr   = LEdata.radFreqResponse((end-1),4);

figure
hold on
errorbar(xdata,AEydata,AEErr,'ro','LineWidth',2,'MarkerSize',6)
errorbar(2,AEyCirc,AEcircErr,'ro','LineWidth',2,'MarkerSize',6)
AEblankResp = REdata.radFreqResponse(end,3);
plot([1 35], [AEblankResp AEblankResp],'r','MarkerSize',5)

errorbar(xdata,FEydata,FEErr,'bo','LineWidth',2,'MarkerSize',6)
errorbar(2,FEyCirc,FEcircErr,'bo','LineWidth',2,'MarkerSize',6)

FEblankResp = LEdata.radFreqResponse(end,3);
plot([1 35], [FEblankResp FEblankResp],'b','MarkerSize',5)

eBar = [1 2 4 8 16 32 64 128];

for stuff = 1:length(eBar)
    errorbar(eBar(stuff),FEblankResp,data.radFreqResponse((end),4),'b.')
    errorbar(eBar(stuff),AEblankResp,data.radFreqResponse((end),4),'r.')
end

title('Responses as a function of radial frequency')
axis square xy
set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32]...
    ,'XTickLabel',{'circle','4','8','16',''},'XTickLabelRotation', 45)
xlim([1 32])
% maxResp = max(data.radFreqResponse{ch}(:,3)+10); % use top of the upper error bar as the limit
% ylim([0 maxResp])
xlabel('Radial Frequency')
ylabel('Spikes/sec')
legend('AE RF','AE Circle','AE Blank','FE RF','FE Circle','FE Blank','Location','NorthWestOutside')
%% Plot amplitude data
figure
for rs = 1:size(rfs,1)
    AExdata = REdata.rfAmpResponse{rs}(:,2);
    AEydata = REdata.rfAmpResponse{rs}(:,4);
    AEstErr = REdata.rfAmpResponse{rs}(:,5);
    hold on
    subplot(1,2,1)
    if rs < 4
        errorbar(AExdata,AEydata,AEstErr,'o:','LineWidth',2,'MarkerSize',6)
    elseif rs == 4
        errorbar(1.5,AEyCirc,AEcircErr,'o','LineWidth',2,'MarkerSize',6)
    elseif rs == 5
        AEblankResp = (REdata.rfAmpResponse{rs}(9,4));
        plot([1 300], [AEblankResp AEblankResp],'k','LineWidth',2,'MarkerSize',11)
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),REdata.rfAmpResponse{rs}(9,4),REdata.rfAmpResponse{rs}(9,5),'k.','MarkerSize',11)
        end
    end
end
title('AE responses to RF stimuli as a function of amplitude')
axis square xy
set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTickLabelRotation', 45)
xlabel('Modulation amplitude')
ylabel('Spikes/sec')
xlim([1 310])
ylim([85 120])
%legend('RF 4','RF 8','RF 16','Circle','Blank','Location','NorthWestOutside')


for sr = 1:size(rfs,1)
    FExdata = LEdata.rfAmpResponse{sr}(:,2);
    FEydata = LEdata.rfAmpResponse{sr}(:,4);
    FEstErr = LEdata.rfAmpResponse{sr}(:,5);
    hold on
    subplot(1,2,2)
    if sr < 4
        errorbar(FExdata,FEydata,FEstErr,'o-','LineWidth',2,'MarkerSize',6)
    elseif sr == 4
        errorbar(1.5,FEyCirc,FEcircErr,'o','LineWidth',2,'MarkerSize',6)
    elseif sr == 5
        FEblankResp = (LEdata.rfAmpResponse{sr}(9,4));
        plot([1 300], [FEblankResp FEblankResp],'k','LineWidth',2,'MarkerSize',11)
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),LEdata.rfAmpResponse{rs}(9,4),LEdata.rfAmpResponse{rs}(9,5),'k.','MarkerSize',11)
        end
    end
end
title('FE responses to RF stimuli as a function of amplitude')
axis square xy
set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTickLabelRotation', 45)
xlabel('Modulation amplitude')
ylabel('Spikes/sec')
xlim([1 310])
ylim([85 120])
legend('RF 4','RF 8','RF 16','Circle','Blank','Location','SouthWestOutside')
%%
figure
for jigs = 1:3
    xdata = [4,8,16,32,64,128];
    
    FEydata = LEdata.rfAmpResponse{jigs}(:,4);
    FEstErr = LEdata.rfAmpResponse{jigs}(:,5);
    FEblankResp = LEdata.rfAmpResponse{jigs}(9,4);
    
    AEydata = REdata.rfAmpResponse{jigs}(:,4);
    AEstErr = REdata.rfAmpResponse{jigs}(:,5);
    AEblankResp = REdata.rfAmpResponse{jigs}(9,4);
    
    nd = 1;
    for ja = 1:length(FEydata)
        if ~isnan(FEydata(ja,1))
            FEy(nd,1) = FEydata(ja,1);
            FEerr(nd,1) = FEstErr(ja,1);
            
            AEy(nd,1) = AEydata(ja,1);
            AEerr(nd,1) = AEstErr(ja,1);
            nd = nd+1;
        end
    end
    
    if jigs == 1
        subplot(1,3,1)
        hold on
        errorbar(xdata,AEy,AEerr,'ro-')
        errorbar(xdata,FEy,FEerr,'bo-')
        
        errorbar(2,FEyCirc,FEcircErr,'bo')
        errorbar(2,AEyCirc,AEcircErr,'ro')
        
        
        plot([2 256], [LEdata.rfAmpResponse{sr}(9,4) LEdata.rfAmpResponse{sr}(9,4)],'b')
        plot([2 256], [REdata.rfAmpResponse{sr}(9,4) REdata.rfAmpResponse{sr}(9,4)],'r')
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),LEdata.rfAmpResponse{rs}(9,4),LEdata.rfAmpResponse{rs}(9,5),'b.')
            errorbar(eBar(stuff),REdata.rfAmpResponse{rs}(9,4),REdata.rfAmpResponse{rs}(9,5),'r.')
        end
        
        title('RF4')
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32 64 128 256]...
            ,'XTickLabel',{'circle','low','','','','','high','blank'},'XTickLabelRotation', 45)
        xlim([1 260])
        ylim([85 120])
        ylabel('response sp/sec')
        
    elseif jigs == 2
        subplot(1,3,2)
        hold on
        errorbar(xdata,AEy,AEerr,'o-r')
        errorbar(xdata,FEy,FEerr,'o-b')
        
        errorbar(2,FEyCirc,FEcircErr,'bo')
        errorbar(2,AEyCirc,AEcircErr,'ro')
        
        plot([2 256], [LEdata.rfAmpResponse{sr}(9,4) LEdata.rfAmpResponse{sr}(9,4)],'b')
        plot([2 256], [REdata.rfAmpResponse{sr}(9,4) REdata.rfAmpResponse{sr}(9,4)],'r')
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),LEdata.rfAmpResponse{rs}(9,4),LEdata.rfAmpResponse{rs}(9,5),'b.')
            errorbar(eBar(stuff),REdata.rfAmpResponse{rs}(9,4),REdata.rfAmpResponse{rs}(9,5),'r.')
        end
        
        title('RF8')
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32 64 128 256]...
            ,'XTickLabel',{'circle','low','','','','','high','blank'},'XTickLabelRotation', 45)
        xlim([1 260])
        ylim([85 120])
        xlabel('Modulation amplitude')
        
    elseif jigs == 3
        subplot(1,3,3)
        hold on
        errorbar(xdata,AEy,AEerr,'o-r')
        errorbar(xdata,FEy,FEerr,'o-b')
        
        errorbar(1.5,FEyCirc,FEcircErr,'bo')
        errorbar(1.5,AEyCirc,AEcircErr,'ro')
        
        plot([2 256], [LEdata.rfAmpResponse{sr}(9,4) LEdata.rfAmpResponse{sr}(9,4)],'b')
        plot([2 256], [REdata.rfAmpResponse{sr}(9,4) REdata.rfAmpResponse{sr}(9,4)],'r')
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),LEdata.rfAmpResponse{rs}(9,4),LEdata.rfAmpResponse{rs}(9,5),'b.')
            errorbar(eBar(stuff),REdata.rfAmpResponse{rs}(9,4),REdata.rfAmpResponse{rs}(9,5),'r.')
        end
        title('RF16')
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32 64 128 256]...
            ,'XTickLabel',{'circle','low','','','','','high','blank'},'XTickLabelRotation', 45)
        xlim([1 260])
        ylim([85 120])
        legend ('AE','FE')
    end
end
%%
figure
hold on

xdata = [4,8,16,32,64,128];

for jigs = 1:3
    FEydata = LEdata.rfAmpResponse{jigs}(:,4);
    FEstErr = LEdata.rfAmpResponse{jigs}(:,5);
    FEblankResp = LEdata.rfAmpResponse{jigs}(9,4);
    
    AEydata = REdata.rfAmpResponse{jigs}(:,4);
    AEstErr = REdata.rfAmpResponse{jigs}(:,5);
    AEblankResp = REdata.rfAmpResponse{jigs}(9,4);
    
    nd = 1;
    for ja = 1:length(FEydata)
        if ~isnan(FEydata(ja,1))
            FEy(nd,1) = FEydata(ja,1);
            FEerr(nd,1) = FEstErr(ja,1);
            
            AEy(nd,1) = AEydata(ja,1);
            AEerr(nd,1) = AEstErr(ja,1);
            nd = nd+1;
        end
    end
    errorbar(xdata,AEy,AEerr,'o:')
    errorbar(xdata,FEy,FEerr,'o-')
end

errorbar(2,AEyCirc,AEcircErr,'ro')
errorbar(2,FEyCirc,FEcircErr,'bo')

plot([2 256], [REdata.rfAmpResponse{sr}(9,4) REdata.rfAmpResponse{sr}(9,4)],'r')
plot([2 256], [LEdata.rfAmpResponse{sr}(9,4) LEdata.rfAmpResponse{sr}(9,4)],'k')

eBar = [2 4 8 16 32 64 128 256];
for stuff = 1:length(eBar)
    errorbar(eBar(stuff),REdata.rfAmpResponse{rs}(9,4),REdata.rfAmpResponse{rs}(9,5),'r.')
    errorbar(eBar(stuff),LEdata.rfAmpResponse{rs}(9,4),LEdata.rfAmpResponse{rs}(9,5),'k.')
end

title('Responses to RF stimuli as a function of amplitude')
axis square xy
set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32 64 128 256]...
    ,'XTickLabel',{'circle','low','','','','','high','blank'},'XTickLabelRotation', 45)
xlim([1 260])
ylim([85 135])
legend ('AE RF4','FE RF4',...
    'AE RF8','FE RF8',...
    'AE RF16','FE RF 16',...
    'AE circe','FE circle',...
    'AE blank','FE blank')
ylabel('response spikes/sec')
xlabel('Modulation amplitude')






%%
toc/60