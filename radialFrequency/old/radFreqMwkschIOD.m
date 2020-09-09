%function [data] = radFreqMwksch(filename, numBins)
%
% Analysis code for MWorks RadFreq program using .mat files that have been
% merged using .py code from Darren.
%
% Created Feb 22, 2017
% Brittany Bushnell


%% Comment out when running as a function
clear all
close all
clc
tic

beRFVerbose = 0;
beAmpVerbose = 1;
numBins = 10; % how many bins to search across
binDelay = 1; % ghetto latency measure, how many bins to wait to start counting responses
numBoots = 100; % number of bootstraps to do 

FEfilename = 'WU_LE_RadFreqSparse_nsp2_20170609_002'; 
AEFilename = 'WU_RE_RadFreqSparse_nsp2_20170607_005';
%%
%Amfortas
%cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;

%laptop
cd ~/Dropbox/ArrayData/WU_ArrayMaps

if ~isempty(strfind(FEfilename,'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    cd ../matFiles/V4/RadialFrequency
    
elseif ~isempty(strfind(FEfilename,'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    cd ../matFiles/V1/RadialFrequency
    
else
    error('Error: array ID missing or wrong')
end


%% load data and extract info
data = load(FEfilename);

% Find unique x and y locations used
xloc = unique(data.pos_x);
yloc = unique(data.pos_y);

% all of the other unique parameters are stored in the file name and needs
% to be parsed out.
for i = 1:length(data.filename)
    [name, rf, rad, mod, ori, sf] = parseRFName(data.filename(i,:));
    rfParams(1,i) = rf;
    rfParams(2,i) = mod;
    rfParams(3,i) = ori;
    rfParams(4,i) = sf;
    rfParams(5,i) = rad;
    
    % save all of the data in a cell in the same way it's done for other
    % experiments (eg: gratings).  Each cell represents what stimulus is
    % shown on a given presentation.
    data.rf(i,1)  = rf;
    data.amplitude(i,1) = mod;
    data.orientation(i,1) = ori;
    data.spatialFrequency(i,1) = sf;
    data.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
    name                 = char(name);
    data.name(i,:)       = name;
end

name = unique(data.filename,'rows');
rfs  = unique(data.rf(:,1));
amps = unique(data.amplitude(:,1));
oris = unique(data.orientation(:,1));
sfs  = unique(data.spatialFrequency(:,1));
rads = unique(data.radius(:,1));

% blnk = nan(1,length(name));
% for l = 1:length(name)
%     blnk(1,l) = strncmp(name(l,:),'blank',3);
% end
% blanks = sum(blnk);

%numStim = length(xloc) * length(rad) * (length(name)-blanks);
numChannels = size(data.bins,3);

%% Get responses across parameters

% Define some search parameters
binSize = 10; %ms per bin
secConv = binSize/1000; %make spike counts in spikes/sec rather than spikes/ms
endBin = numBins+binDelay;
rfAmpT = nan(9,6);

for ch = 1:numChannels
    disp(sprintf('Analyzing channel %d',ch))
    % First, separate by location
    for x = 1:size(xloc,1)
        for y = 1:size(yloc,1)
            % collapse across locations
            
            % collapse across all RFs
            for i = 1:size(rfs,1)
                rfs(i,2) = sum(data.rf == rfs(i,1));
                tmpNdx   = find(data.rf == rfs(i,1));
                useRuns  = data.bins(tmpNdx,binDelay:endBin,ch);
                rfs(i,3) = mean(mean(useRuns))./0.010;
                % bootstrap confidence intervals
                bootBounds = bootci(numBoots,@mean,useRuns(:));
                rfs(i,4) = bootBounds(1,1);
                rfs(i,5) = bootBounds(2,1);
                
                % collapse across all amplitudes
                for m = 1:size(amps,1)
                    rfAmpT(m,1) = rfs(i,1);
                    rfAmpT(m,2) = amps(m,1);
                    rfAmpT(m,3) = sum((data.amplitude == amps(m,1)) .* (data.rf == rfs(i,1)));
                    tmpNdx      = find((data.amplitude == amps(m,1)) .* (data.rf == rfs(i,1)));
                    useRuns     = data.bins(tmpNdx,binDelay:endBin,ch)./0.010;
                    rfAmpT(m,4) = mean(mean(useRuns));
                    
                    if isnan(rfAmpT(m,4)) == 0
                        bootBounds  = bootci(numBoots,@mean,useRuns(:));
                        rfAmpT(m,5) = bootBounds(1,1);
                        rfAmpT(m,6) = bootBounds(2,1);
                    end
                end
                % Each RF gets a cell of the responses at different
                % amplitudes. Keep in mind, not every RF uses all
                % amplitudes, and any that weren't used for the given RF
                % will be NAN
                rfAmp{i} = rfAmpT;
                clear rfAmpT
            end
            % collapse across all amplitudes
            for am = 1:size(amps,1)
                amps(am,2) = sum(data.amplitude == amps(am,1));
                tmpNdx     = find(data.amplitude == amps(am,1));
                useRuns    = data.bins(tmpNdx,binDelay:endBin,ch);
                amps(am,3) = mean(mean(useRuns))./0.010;
                if ~isnan(amps(am,3))
                    bootBounds = bootci(numBoots,@mean,useRuns(:));
                    amps(am,4) = bootBounds(1,1);
                    amps(am,5) = bootBounds(2,1);
                end
            end
            % collapse across all sizes
            for s = 1:size(rads,1)
                rads(s,2) = sum(data.radius == rads(s,1));
                tmpNdx    = find(data.radius == rads(s,1));
                useRuns    = data.bins(tmpNdx,binDelay:endBin,ch);
                rads(s,3) = mean(mean(useRuns))./0.010;
                bootBounds = bootci(numBoots,@mean,useRuns);
                rads(s,4) = bootBounds(1,1);
                rads(s,5) = bootBounds(2,1);
            end
            % collapse across all sfs
            for sp = 1:size(sfs,1)
                sfs(sp,2) = sum(data.spatialFrequency == sfs(sp,1));
                tmpNdx    = find(data.spatialFrequency == sfs(sp,1));
                useRuns    = data.bins(tmpNdx,binDelay:endBin,ch);
                sfs(sp,3) = mean(mean(useRuns))./0.010;
                bootBounds = bootci(numBoots,@mean,useRuns(:));
                sfs(sp,4) = bootBounds(1,1);
                sfs(sp,5) = bootBounds(2,1);
            end
        end
    end
    data.radFreqResponse{ch} = rfs;
    data.radiusResponse{ch} = rads;
    data.ampResponse{ch} = amps;
    data.sfResponse{ch} = sfs;
    data.rfAmpResponse{ch} = rfAmp;
end

%% Plot the Responses by RF
figure
for ch = 1:numChannels
    subplot(aMap,10,10,ch)
    hold on
    % plot the data for the stimuli
    plot(data.radFreqResponse{ch}((1:end-2),1),data.radFreqResponse{ch}((1:end-2),3),'b.')
    plot(data.radFreqResponse{ch}((end-1),1),data.radFreqResponse{ch}((end-1),3),'k.')
    % plot a horizontal line that is the response to a blank screen
    blankResp = data.radFreqResponse{ch}(end,3);
    plot([2 35], [blankResp blankResp],'r--')
    
    title(sprintf('%d',ch))
    axis square xy
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[0 4 8 16 32]...
        ,'XTickLabel',{'','4','8','16','c'})
    xlim([2 32])
    maxResp = max(data.radFreqResponse{ch}(:,3)+1);
    ylim([0 maxResp])
    xtickangle(45)
    
    
    subplot(10,10,1)
    xlabel('RF')
    ylabel('sp/s')
    axis square xy
    ylim([0 max(data.radFreqResponse{ch}(:,3)+5)])
    if ~isempty(strfind(FEfilename,'nsp2'))
        set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    end
    
    topTitle = sprintf('Radial Frequency Tuning: %s',FEfilename);
    annotation('textbox',...
        [0.2 0.94 0.8 0.05],...
        'LineStyle','none',...
        'String',topTitle,...
        'Interpreter','none',...
        'FontSize',13,...
        'FontAngle','italic');
end

%% RF Response, fig for each channel

if beRFVerbose == 1
    for ch = 1:numChannels
        figure
        hold on
        % plot the data for the stimuli
        xdata = data.radFreqResponse{ch}((1:end-2),1);
        ydata = data.radFreqResponse{ch}((1:end-2),3);
        dnErr = data.radFreqResponse{ch}((1:end-2),4);
        upErr = data.radFreqResponse{ch}((1:end-2),5);
        
        xCirc     = data.radFreqResponse{ch}((end-1),1);
        yCirc     = data.radFreqResponse{ch}((end-1),3);
        dnErrCirc = data.radFreqResponse{ch}((end-1),4);
        upErrCirc = data.radFreqResponse{ch}((end-1),5);
        
        errorbar(xdata,ydata,dnErr,upErr,'b.')
        errorbar(xCirc,yCirc,dnErrCirc,upErrCirc,'k.')
        % plot a horizontal line that is the response to a blank screen
        blankResp = data.radFreqResponse{ch}(end,3);
        plot([2 35], [blankResp blankResp],'m--')
        errorbar(2,blankResp,data.radFreqResponse{ch}((end),4),data.radFreqResponse{ch}((end),5),'r.')
        
        title(sprintf('RF responses channel %d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[0 4 8 16 32]...
            ,'XTickLabel',{'','4','8','16','c'})
        xlim([2 32])
        maxResp = max(data.radFreqResponse{ch}(:,3)+1);
        ylim([0 maxResp])
        xtickangle(45)
        xlabel('Radial Frequency')
        ylabel('Spikes/sec')
        legend('RF','Circle','Blank','Location','NorthWestOutside')
        
    end
end
%% Plot data for each RF and amplitude
figure
for ch = 1:numChannels
    for rs = 1:size(rfs,1)
        subplot(aMap,10,10,ch)
        hold on
        % plot the responses of each channel to the various amplitudes of
        % each RF
        xdata = data.rfAmpResponse{ch}{rs}(:,2);
        ydata = data.rfAmpResponse{ch}{rs}(:,4);
        dnErr = data.rfAmpResponse{ch}{rs}(:,5);
        upErr = data.rfAmpResponse{ch}{rs}(:,6);
        
        xCirc     = data.rfAmpResponse{ch}{rs}(:,2);
        yCirc     = data.rfAmpResponse{ch}{rs}(:,4);
        dnErrCirc = data.rfAmpResponse{ch}{rs}(:,5);
        upErrCirc = data.rfAmpResponse{ch}{rs}(:,6);
        
        if rs < 4
            plot(xdata,ydata,dnErr,upErr,'.')
        elseif rs == 4
            plot(1.5,(data.rfAmpResponse{ch}{rs}(8,4)),'k.')
        elseif rs == 5
            blankResp = (data.rfAmpResponse{ch}{rs}(9,4));
            plot([1 300], [blankResp blankResp],'m--')
        end
        
        title(sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log') %,'XTick',[3 6 12 25 50 100 200 400],'XTickLabel',...
        %{'3','','12','','50','','200','c'});
        % maxResp = max(data.rfAmpResponse{ch}(:,4)+1);
        % ylim([0 maxResp])
        xtickangle(45)
        
        
        subplot(10,10,1)
        xlabel('amp(web)')
        ylabel('sp/s')
        axis square xy
        ylim([0 max(data.radFreqResponse{ch}(:,3)+5)])
        if ~isempty(strfind(FEfilename,'nsp2'))
            set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
            %legend ('4','8','16','c','blank')
        end
        
        topTitle = sprintf('RF Modulation Tuning by RF: %s',FEfilename);
        annotation('textbox',...
            [0.2 0.94 0.8 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',13,...
            'FontAngle','italic');
    end
end

%% Amplitude responses, fig for each channel

if beAmpVerbose == 1   
    for ch = 1:numChannels
        figure
        for rs = 1:size(rfs,1)
            hold on
            % plot the responses of each channel to the various amplitudes of
            % each RF
            xdata = data.rfAmpResponse{ch}{rs}(:,2);
            ydata = data.rfAmpResponse{ch}{rs}(:,4);
            dnErr = data.rfAmpResponse{ch}{rs}(:,5);
            upErr = data.rfAmpResponse{ch}{rs}(:,6);
            
            xCirc     = data.rfAmpResponse{ch}{rs}(8,2);
            yCirc     = data.rfAmpResponse{ch}{rs}(8,4);
            dnErrCirc = data.rfAmpResponse{ch}{rs}(8,5);
            upErrCirc = data.rfAmpResponse{ch}{rs}(8,6);
            
            if rs < 4
                errorbar(xdata,ydata,dnErr,upErr,'-')
                errorbar(xdata,ydata,dnErr,upErr,'.')
            elseif rs == 4
                errorbar(1.5,yCirc,dnErrCirc,upErrCirc,'k.')
            elseif rs == 5
                blankResp = (data.rfAmpResponse{ch}{rs}(9,4));
                plot([1 300], [blankResp blankResp],'m--')
                errorbar(300,data.rfAmpResponse{ch}{rs}(9,4),data.rfAmpResponse{ch}{rs}(9,5),data.rfAmpResponse{ch}{rs}(9,6),'m.')
            end
            
            title(sprintf('RF responses channel %d',ch))
            axis square xy
            set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log') %,'XTick',[3 6 12 25 50 100 200 400],'XTickLabel',...
            %{'3','','12','','50','','200','c'});
            % maxResp = max(data.rfAmpResponse{ch}(:,4)+1);
            % ylim([0 maxResp])
            xtickangle(45)
            xlabel('amplitude')
            ylabel('Spikes/sec')
            legend('RF 4','RF 8','RF 16','Circle','Blank','Location','NorthWestOutside')
            
        end
    end
end
%%  Plot responses by radius
if size(rads,1)>1
    figure
    for ch = 1:numChannels
        subplot(aMap,10,10,ch)
        hold on
        % plot the data for the stimuli
        plot(data.radiusResponse{ch}((1:end-1),1),data.radiusResponse{ch}((1:end-1),3),'b.-')
        % plot a horizontal line that is the response to a blank screen
        blankResp = data.radiusResponse{ch}(end,3);
        plot([0 3], [blankResp blankResp],'m')
        
        title(sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out')
        xlim([0 3])
        maxResp = max(data.radiusResponse{ch}(:,3)+1);
        ylim([0 maxResp])
        xtickangle(45)
        
        
        subplot(10,10,1)
        xlabel('mean rad')
        ylabel('sp/s')
        axis square xy
        ylim([0 max(data.radiusResponse{ch}(:,3)+5)])
        if ~isempty(strfind(FEfilename,'nsp2'))
            set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
        end
        
        topTitle = sprintf('Radial Frequency Size Tuning: %s',FEfilename);
        annotation('textbox',...
            [0.2 0.94 0.8 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',13,...
            'FontAngle','italic');
    end
end

%% Plot responses by spatial frequency
figure
for ch = 1:numChannels
    subplot(aMap,10,10,ch)
    hold on
    
    xdata = data.sfResponse{ch}((1:end-1),1);
    ydata = data.sfResponse{ch}((1:end-1),3);
    dnErr = data.sfResponse{ch}((1:end-1),4);
    upErr = data.sfResponse{ch}((1:end-1),5);
    % plot the data for the stimuli
    errorbar(xdata,ydata,dnErr,upErr,'b.-')
    % plot a horizontal line that is the response to a blank screen
    blankResp = data.sfResponse{ch}(end,3);
    plot([0 3], [blankResp blankResp],'m')
    errorbar(3,blankResp,data.sfResponse{ch}(end,4),data.sfResponse{ch}(end,5),'m.')

    title(sprintf('%d',ch))
    axis square xy
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XTickLabel',{'','1','2','b'});
    xlim([0 3])
    maxResp = max(data.sfResponse{ch}(:,3)+1);
    ylim([0 maxResp])
    xtickangle(45)


    subplot(10,10,1)
    xlabel('SF')
    ylabel('sp/s')
    axis square xy
    ylim([0 max(data.sfResponse{ch}(:,3)+5)])
    if ~isempty(strfind(FEfilename,'nsp2'))
        set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    end

    topTitle = sprintf('RF spatial frequency Tuning: %s',FEfilename);
    annotation('textbox',...
        [0.2 0.94 0.8 0.05],...
        'LineStyle','none',...
        'String',topTitle,...
        'Interpreter','none',...
        'FontSize',13,...
        'FontAngle','italic');
end

%% Plot data by modulation amplitude
figure
for ch = 1:numChannels
    subplot(aMap,10,10,ch)
    hold on
    % plot the data for the stimuli
    plot(data.ampResponse{ch}((1:end-2),1),data.ampResponse{ch}((1:end-2),3),'b.-')
    plot(data.ampResponse{ch}((end-2),1),data.ampResponse{ch}((end-2),3),'b.')
    % plot a horizontal line that is the response to a blank screen
    blankResp = data.ampResponse{ch}(end,3);
    plot([4 35], [blankResp blankResp],'r')

    title(sprintf('%d',ch))
    axis square xy
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[3 6 12 25 50 100 200 400],'XTickLabel',...
        {'3','','12','','50','','200','c'});
    maxResp = max(data.ampResponse{ch}(:,3)+1);
    ylim([0 maxResp])
    xtickangle(45)


    subplot(10,10,1)
    xlabel('amp(web)')
    ylabel('sp/s')
    axis square xy
    ylim([0 max(data.radFreqResponse{ch}(:,3)+5)])
    if ~isempty(strfind(FEfilename,'nsp2'))
        set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    end

    topTitle = sprintf('RF Modulation Amplitude Tuning: %s',FEfilename);
    annotation('textbox',...
        [0.2 0.94 0.8 0.05],...
        'LineStyle','none',...
        'String',topTitle,...
        'Interpreter','none',...
        'FontSize',13,...
        'FontAngle','italic');
end

%%
toc