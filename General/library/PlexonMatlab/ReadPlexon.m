function output = ReadPlexon(varargin)
%%
%Updated 2014-02-17 - rdk
%%

output     = [];
doSpikes   = 1;
doWideband = 1;
doEvents   = 1;
if nargin <1
    StartingFileName = '';
else
    StartingFileName = varargin{1};
    if nargin >1
        doSpikes   = 0;
        doWideband = 0;
        doEvents   = 0;
    end
end

for ii=2:nargin
    switch lower(varargin{ii})
        case 'spikes'
            doSpikes = 1;
        case 'wideband'
            doWideband = 1;
        case 'events'
            doEvents = 1;
    end
end

% ========================================================================================
% GENERAL PROCESSING
% ========================================================================================

[OpenedFileName, Version, Freq, Comment, Trodalness, NPW, ...
    PreThresh, SpikePeakV, SpikeADResBits, WidebandPeakV, ...
    WidebandADResBits, Duration, DateTime] = plx_information(StartingFileName);
if isempty(Comment)
    Comment = '[NONE]';
end

[tscounts, ~, evcounts, widebandcounts] = plx_info(OpenedFileName,1);
spikes   = struct(...
    'nUnits_max',size(tscounts,1),...
    'nChannels',size(tscounts,2)-1,...
    'DSPChannel',[],...
    'Names',[],...
    'Filters',[],...
    'Gains',[],...
    'Thresholds',[],...
    'Times',[],...
    'Counts',[]);
wideband = struct(...
    'nChannels',size(widebandcounts,2),...
    'Freqs',[],...
    'Gains',[],...
    'Names',[],...
    'Data',[]);
events   = struct(...
    'nEventChannels',size(evcounts,2),...
    'nEvents',[],...
    'Times',[],...
    'Strobed',[],...
    'Names',[]);

nthreads = matlabpool('size');
if nthreads==0
    matlabpool('open');
    nthreads = matlabpool('size');
    fprintf('Opening New Matlab Pool: %d threads opened.\n',nthreads);

else
    fprintf('Found Opened Matlab Pool: %d threads opened.\n',nthreads);    
end
pause(.01);

% ========================================================================================
% PARAMETER PROCESSING
% ========================================================================================

fprintf('              Opened File Name : %s\n', OpenedFileName);
fprintf('                       Version : %d\n', Version);
fprintf('                     Frequency : %d\n', Freq);
fprintf('                       Comment : %s\n', Comment);
fprintf('                     Date/Time : %s\n', DateTime);
fprintf('                      Duration : %d min, %.3f s\n', mod(Duration - mod(Duration,60),3600)/60, mod(Duration,60));
fprintf('              Num Pts Per Wave : %d\n', NPW);
fprintf('         Num Pts Pre-Threshold : %d\n', PreThresh);

if ( Version > 102 )
    if ( Trodalness < 2 )
        fprintf('                     Data type : Single Electrode\n');
    elseif ( Trodalness == 2 )
        fprintf('                     Data type : Stereotrode\n');
    elseif ( Trodalness == 4 )
        fprintf('                     Data type : Tetrode\n');
    else
        fprintf('                     Data type : UNKNOWN!\n');
    end
    
    fprintf('   Spike     Peak Voltage (mV) : %.1f\n', SpikePeakV);
    fprintf('   Spike A/D Resolution (bits) : %d\n', SpikeADResBits);
    fprintf('Wideband A/D Peak Voltage (mV) : %.1f\n', WidebandPeakV);
    fprintf('Wideband A/D Resolution (bits) : %d\n', WidebandADResBits);
end
fprintf('#####################################################\n');
fprintf('  Spikes : %d ch, %d spikes total\n', size(tscounts,2)-1,sum(tscounts(:)));
fprintf('Wideband : %d ch, %d with records\n', size(widebandcounts,2), sum(widebandcounts>0));
fprintf('  Events : %d ch, %d with data\n', size(evcounts,2), sum(evcounts>0));
fprintf('#####################################################\n');

parameters = struct('OpenedFileName',OpenedFileName,...
    'Version',Version,...
    'Freq',Freq,...
    'Comment',Comment,...
    'Trodalness',Trodalness,...
    'NPW',NPW,...
    'PreThresh',PreThresh,...
    'SpikePeakV',SpikePeakV,...
    'SpikeADResBits',SpikeADResBits,...
    'WidebandPeakV',WidebandPeakV,...
    'WidebandADResBits',WidebandADResBits,...
    'Duration',Duration,...
    'DateTime',DateTime);
% ========================================================================================
% SPIKE PROCESSING
% ========================================================================================
if doSpikes
    fprintf('Processing Spike Data...\n');
    % gives actual number of units (including unsorted) and actual number of channels plus 1
    [nunits1, nchannels1] = size( tscounts );
    
    % this is not necessary in normal .plx files from the map, as the dspchans
    % array is always the trivial mapping dspchans[i] = i in that map.
    [~, dspchans]    = plx_chanmap(OpenedFileName);
    [~, spk_names]   = plx_chan_names(OpenedFileName);
    [~, spk_filters] = plx_chan_filters(OpenedFileName);
    [~, spk_gains]   = plx_chan_gains(OpenedFileName);
    [~, spk_threshs] = plx_chan_thresholds(OpenedFileName);
    
    % we will read in the timestamps of all units,channels into a two-dim cell
    % array named allts, with each cell containing the timestamps for a unit,channel.
    % Note that allts second dim is indexed by the 1-based channel number.
    % preallocate for speed
    allts = cell(nunits1, nchannels1-1);
    for ii=1:nchannels1-1
        for jj=1:nunits1
            allts{jj,ii} = nan(1);
        end
    end
    for iunit = 0:nunits1-1   % starting with unit 0 (unsorted)
        if iunit==0
            fprintf('Unsorted : ');
        else
            fprintf(' Unit %02d : ',iunit);
        end
        temp = cell(1,nchannels1-1);
        curtscounts = tscounts(iunit+1,:);
        tic;
        for ii = 1:nthreads:(nchannels1-1);
            parfor ich = ii:min(ii+nthreads-1,nchannels1-1)
                if ( curtscounts(ich+1) > 0 )
                    % get the timestamps for this channel and unit
                    %[~, allts{iunit+1,ich}] = plx_ts(OpenedFileName, dspchans(ich), iunit );
                    [~, temp{ich}] = plx_ts(OpenedFileName, dspchans(ich), iunit );
                end
            end
            fprintf('%s',repmat('.',1,nthreads));
        end
        for ii = 1:nchannels1-1
            allts{iunit+1,ii} = temp{ii};
        end
        fprintf(' | %04.1f sec\n',toc);
    end
    
    spikes = struct('nUnits_max',nunits1,'nChannels',nchannels1-1,...
        'DSPChannel',dspchans,'Names',spk_names,...
        'Filters',spk_filters,'Gains',spk_gains,...
        'Thresholds',spk_threshs,'Times',{allts},'Counts',tscounts(:,2:end)); % rdk fix
    fprintf('Done.\n');
    clear allts;
end
% ========================================================================================
% ANALOG PROCESSING
% ========================================================================================
if doWideband
    fprintf('Processing Wideband Data...');
    tic;
    
    % this is not necessary in normal .plx files from the map, as the dspchans
    % array is always the trivial mapping dspchans[i] = i in that map.
    [~, adchans] = plx_ad_chanmap(OpenedFileName);
    % Note that analog ch numbering starts at 0, not 1 in the data, but the
    % 'allad' cell array is indexed by ich+1
    
    numads = 0;
    nwidebandchannels = size( widebandcounts, 2);
    if ( nwidebandchannels > 0 )
        % preallocate for speed
        allad = cell(1,nwidebandchannels);
        parfor ich = 0:nwidebandchannels-1
            if ( widebandcounts(ich+1) > 0 )
                %[adfreq, nad, tsad, fnad, allad{ich+1}] = plx_ad(OpenedFileName, adchans(ich+1));
                [~, ~, ~, ~, allad{ich+1}] = plx_ad(OpenedFileName, adchans(ich+1));
                numads = numads + 1;
            end
        end
    end
    if ( numads > 0 )
        [~,adfreqs] = plx_adchan_freqs(OpenedFileName);
        [~,adgains] = plx_adchan_gains(OpenedFileName);
        [~,adnames] = plx_adchan_names(OpenedFileName);
        
        % just for fun, plot the channels with a/d data - NO! - rdk
        %iplot = 1;
        %numPlots = min(4, numads);
        %for ich = 1:nwidebandchannels
        %    nsamples = size(allad{ich},1);
        %    if ( nsamples > 0 )
        %        subplot(numPlots,1,iplot); plot(allad{ich});
        %        iplot = iplot + 1;
        %    end
        %    if iplot > numPlots
        %        break;
        %    end
        %end
        wideband = struct('nChannels',nwidebandchannels,'Freqs',adfreqs,'Gains',adgains,'Names',adnames,'Data',allad);
        clear allad;
    end
    fprintf('Done. [%.1f sec]\n',toc);
end
% ========================================================================================
% EVENT PROCESSING
% ========================================================================================
if doEvents
    fprintf('Processing Event Data...');
    tic;
    nevchannels = size(evcounts, 2);
    if ( nevchannels > 0 )
        % need the event chanmap to make any sense of these
        [~,evchans] = plx_event_chanmap(OpenedFileName);
        nevs  = zeros(1,nevchannels);
        tsevs = cell(1,nevchannels);
        parfor iev = 1:nevchannels
            if ( evcounts(iev) > 0 )
                [nevs(iev), tsevs{iev}] = plx_event_ts(OpenedFileName, evchans(iev));
            end
        end
        svStrobed = [];
        for iev = find(evchans==257)
            if ( evcounts(iev) > 0 )
                [~, ~, svStrobed] = plx_event_ts(OpenedFileName, evchans(iev));
            end
        end
    end
    [~,evnames] = plx_event_names(OpenedFileName);
    evnames = mat2cell(evnames,ones(size(evnames,1),1),size(evnames,2));
    evnames = cellfun(@(x) x(x>0),evnames,'UniformOutput',false);

    events = struct('nEventChannels',nevchannels,'nEvents',nevs,'Times',{tsevs},'Strobed',svStrobed,'Names',{evnames});
    clear tsevs;
    fprintf('Done. [%.1f sec]\n',toc);
end

output = struct('Parameters',parameters,'Spikes',spikes,'Wideband',wideband,'Events',events);