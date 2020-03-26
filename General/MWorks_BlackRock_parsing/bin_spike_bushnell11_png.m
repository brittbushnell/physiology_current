function bin_spike_bushnell11_png(fileNAME,prefix_dir,OUTPUT_DIR,plotNEVTimestamp)
% bin spike counts from nev file
% NOTE: this is only for the gratings experiment
% Inputs:
% fileNAME = name of the blackrock .nev file (without extension). Ex:
%   fileNAME format: WU_LE_Gratings_nsp1_20170705_003
%   fileNAME = 'WU_LE_Gratings_nsp2_20170531_004';
% prefix_dir = directory where recordings are kept.
% OUTPUT_DIR = directory to save output structures.

T_SUCCESS = 4*250 * 1e3;
INTERVAL_KEEP = 1000 * 1e3;
POINTS_KEEP = 100;
T_PER_POINT = round(INTERVAL_KEEP / POINTS_KEEP);
n_channels = 256;
N_CHANNELS_KEEP = 96;
%
% if location == 2
% prefix_dir = '/mnt/vnlstorage/bushnell_arrays/';
% else
%     prefix_dir = '/Volumes/';
% end

if strfind(fileNAME,'nsp1')
    if strfind(fileNAME, 'recut')
        BLACKROCK_DIR = [prefix_dir, 'nsp1/nsp1_blackrock/WU_recut/'];
    else
        BLACKROCK_DIR = [prefix_dir, 'nsp1/nsp1_blackrock/'];
    end
else
    if strfind(fileNAME, 'recut')
        BLACKROCK_DIR = [prefix_dir, 'nsp2/nsp2_blackrock/WU_recut/'];
    else
       BLACKROCK_DIR = [prefix_dir, 'nsp2/nsp2_blackrock/'];
    end
end
   
if strfind(fileNAME, 'recut')
    MWORKS_DIR = [prefix_dir, 'nsp1/mworks/recut/'];
else
    MWORKS_DIR = [prefix_dir, 'nsp1/mworks/'];
end

% for nm in ['WU_gratmap_test_20170110_003']:
ns_nev_name = [BLACKROCK_DIR, fileNAME];
save_name = [fileNAME, '.mat'];

% only one mwk for multiple .nev files, remove the array-specific parts
% from the nev file name to get the .mwk name:
replacement = {'NSP2_P_', '_NSP1_M', '_NSP1_A','_NSP1_P', '_NSP1_S130404',...
    '_NSP2_P', '_NSP2_M', 'NSP2_A', '_nsp1', '_nsp2'};
for n = 1: length(replacement)
    if n > 1
        shortName = strrep(shortName, replacement{n}, '');
    else
        shortName = strrep(fileNAME, replacement{n}, '');
    end
end

mwk_name = [MWORKS_DIR, shortName, '.mwk'];

%%%%%%%%%%%%%%%%%%%%%%%%% get word out times and success events
force_process = 0;
% saveAll = 0;
saveMatFileMWorks = get_all_mworks_info_forBrittany(mwk_name, force_process, 'SaveFilePath', MWORKS_DIR);

aux = load(saveMatFileMWorks);

sent = aux.wordout_varEvents;
stim_display_update_events = aux.stimDisplayUpdateEvents;
success_events = aux.number_of_stm_shownEvents;

stimOn = cell2mat({aux.stimon_timeEvents.data});
stimOff = cell2mat({aux.stimoff_timeEvents.data});

success_times = cell2mat({success_events.time_us});
t_sent = cell2mat({sent.time_us});

clear aux;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% nev file word out times
% read header

fp = openNEV([ns_nev_name, '.nev']);
% nev_wordout_times_step1 = fp.Data.SerialDigitalIO.TimeStamp;
% nev_wordout_times_microseconds = double(nev_wordout_times_step1)/(double(fp.MetaTags.SampleRes)/1e6);

% conversion_factor = 1e6/time_res_timestamps; % conversion to microseconds

offset = fp.MetaTags.HeaderOffset;

t_spikes = cell(1, N_CHANNELS_KEEP);
for nn = 1:N_CHANNELS_KEEP
    if isempty(fp.Data.Spikes.Electrode == nn)
        t_spikes{nn} = 0;
    else
        t_spikes{nn} = (double(fp.Data.Spikes.TimeStamp(fp.Data.Spikes.Electrode == nn))./double(fp.MetaTags.SampleRes)).*(10^6);
    end
end

%%%% Segment to do time alignment:
%first find the times when mworks sends out a word, mworks data is stored in microseconds, IMAGINE THAT
mworks_wordout_times = double(cell2mat({sent(cell2mat({sent.data})~=0).time_us}));

nev_wordout_times_step1 = fp.Data.SerialDigitalIO.TimeStampSec;
nev_wordout_times = double(nev_wordout_times_step1).*(10^6);

%find the smallest interval between words in an mworks file
minimum_interword_interval = min(diff(mworks_wordout_times));

%locate times in nev file when interword interval is less than half the
%minimum interword interval detected above and remove (by convention
%choose the later of the two close values as the starting point
bad_nev_times = find(diff(nev_wordout_times)<minimum_interword_interval/2) + 1; %find nev inter_word_intervals that are too short
nev_wordout_times(bad_nev_times) = []; %remove these times

% If blackrock clock resets (as it does sometimes, then nev_wordout_times
% should hypothetically reset to 0 in the middle of the experiment. 
if plotNEVTimestamp
    figure;
    plot(nev_wordout_times); title(fileNAME);
end

lastwarn('');
% mworks_correction = polyfit(double(mworks_wordout_times), nev_wordout_times_microseconds, 0);
tempMult = 10^6;
[regressionResults, ~, ~, ~, regressionStats] = regress(double(nev_wordout_times)'/tempMult,...
    [ones(size(nev_wordout_times)); double(mworks_wordout_times)/tempMult]');
regressionResults(1)    = regressionResults(1) * tempMult;

[msgstr, ~] = lastwarn;
if strcmp(msgstr, 'X is rank deficient to within machine precision.')
    % What is happening it a perfect line and regress is having a hard
    % time with it.
    %
    % 10/9/18
    % what is actually happening is that the time stamp numbers are TOO BIG
    % for regress to handle. see above, 'tempMult' is  used to make the
    % numbers smaller and easier to manage. This just has to be factored
    % into the offset as well (regressionResults(2)) 
    %     -JP
    regressionResults(2) = (double(nev_wordout_times(1)) - double(nev_wordout_times(2)))./...
        (double(mworks_wordout_times(1)) - double(mworks_wordout_times(2)));
    regressionResults(1) = double(nev_wordout_times(1)) - regressionResults(2).*double(mworks_wordout_times(1));
end

%%%%%%%%%%%%%% get file names

stimFilename = {};

n_stim = 0;
t_stim = [];
new_stim = 0;

for ind = 1:length(stim_display_update_events)
    if length(stim_display_update_events(ind).data) > 2
        cur_time = stim_display_update_events(ind).time_us;
    
        if sum((cur_time < success_times) .* (success_times < (cur_time + T_SUCCESS))) ~= 0
            % determine if this is a new stimulus by looking if name of stim file are different from the most recently added value
            new_stim = 0;
            if length(stimFilename) >= 1
                if strcmp(stimFilename{end},stim_display_update_events(ind).data{2}.name) == 0 
                    new_stim = 1;
                end
            else
                new_stim = 1;
            end
            
            % add the stimulus:
            if new_stim == 1
                t_stim = [t_stim, cur_time.*regressionResults(2) + regressionResults(1)];
                stimFilename = [stimFilename; stim_display_update_events(ind).data{2}.name];
                n_stim = n_stim + 1;
            end
        end
    end
end

%%%%%%%%%%%%%%%%%% time stamps for particular channel... (FOR DEBUGGING)
% figure; hold on
% for iC = 1:10
%     nsubplot(1 , 10, 1, iC);
%     iC = iC+60;
%     t_stim_sec = double(t_stim) ./ 1000000;                             % convert to seconds
%     %t_stim_sec = t_stim_sec - (offset/1000);
%     spiketimes = t_spikes{iC};
%     spiketimes_sec = spiketimes ./ 1000000;
%     timestamps = cell(length(t_stim),1);
%     for iT = 1:length(t_stim)
%         tempStart   = t_stim_sec(iT);
%         tempEnd     = tempStart+1;
%         timestamps{iT} = spiketimes_sec(tempStart < spiketimes_sec & spiketimes_sec < tempEnd) - tempStart;
%     end
%     axis off
%     plotSpikeRaster(timestamps);
%     set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
%         title(iC)
% end
    
%%%%%%%%%%%%%%%%% binning electrophysiology data
bins = zeros(n_stim, POINTS_KEEP, N_CHANNELS_KEEP);

fprintf('Binning spike data for channels... \n')
for channel = 1:N_CHANNELS_KEEP
    %channel
    bins(:,:, channel) = nev_bin_spikes(t_spikes{channel}, t_stim, POINTS_KEEP, T_PER_POINT);
    fprintf('%g ', channel);
    if ~mod(channel,20)
        fprintf('\n')
    end
end

save([OUTPUT_DIR, save_name], 'stimOn', 'stimOff', 't_stim', 'bins', 'stimFilename');

end

