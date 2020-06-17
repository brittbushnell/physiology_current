% bin spike counts from nev file

function MworksNevParser(varargin)
% This function is at its most simple, a re-creation of Darren Seibert's
% Python parsing code. This Matlab version builds on it and increases some
% of the flexibility.
%
% The only required input is the blackrock filename, all others are
% optional.
%   fileName: Blackrock file name
%       Example:  WU_LE_Gratings_nsp1_20170705_003
%
% Optional inputs that may be entered in any order, but must come in pairs
% with the correct naming convention.
%   Input options and their defaults
%         fileName = varargin(1);
%         bin_size = 10;
%         num_bins = 100;
%         outputDir = '/home/bushnell/binned_dir/';
%         save_name = [fileName, '.mat'];
%
%  
%% Verify input arguments and set default values

switch nargin
    case 0
        error ('Must pass in the blackrock file name at a minimum')
    case 1
        fprintf('parsing %s',varargin(1));
        fileName = varargin(1);
        bin_size = 10;
        num_bins = 100;
        outputDir = '/home/bushnell/binned_dir/';
        save_name = [fileName, '.mat'];
    case 2 
        fprintf('parsing %s with %d ms bins',varargin(1), varargin(2));
        fileName = varargin(1);
        bin_size = varargin(2);
        num_bins = 100;
        outputDir = '/home/bushnell/binned_dir/';
        save_name = [fileName, '.mat'];
    case 3
        fprintf('parsing %s in %d %d ms bins',varargin(1), varargin(3), varargin(2));
        fileName = varargin(1);
        bin_size = varargin(2);
        num_bins = varargin(3);
        outputDir = '/home/bushnell/binned_dir/';
        save_name = [fileName, '.mat'];
    case 4
        fprintf('parsing %s in %d %d ms bins. Mat file will be saved at %s',varargin(1), varargin(3), varargin(2), varargin(4));
        fileName = varargin(1);
        bin_size = varargin(2);
        num_bins = varargin(3);
        outputDir = varargin(4);
        save_name = [fileName, '.mat'];
        inputDir = '/mnt/vnlstorage/bushnell_arrays/';
    case 5
        fprintf('parsing %s in %d %d ms bins. Mat file will be saved at %s',varargin(1), varargin(3), varargin(2), varargin(4));
        fileName = varargin(1);
        bin_size = varargin(2);
        num_bins = varargin(3);
        outputDir = varargin(4);
        save_name = [fileName, '.mat'];

%%
% example fileName: WU_LE_Gratings_nsp1_20170705_003
% Where do data live? - all of WU's data is on vnlstorage
% XT: 
%  vnlstorage if on or before 20190131
%  vnlstorage2 for the rest
%
% WV:
%  vnlstorage if on or before 20190130
%  vnlstorage2 if between 20190130 and 20190603
%  vnlstorage3 for the rest

tmp = strsplit(fileName,'_');
if length(tmp) == 6
    [animal,~,programID,array,date,~] = deal(tmp);
    if contains(animal,'WU')
        blackrockDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
        mworksDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/mworks/%s/',array,animal);
    elseif contains(animal,'XT')
        if date <= 20190131
            blackrockDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
            mworksDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/mworks/%s/',array,animal);
        else
            blackrockDir = sprintf('/mnt/vnlstorage2/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
            mworksDir = sprintf('/mnt/vnlstorage2/bushnell_arrays/%s/mworks/%s/',array,animal);
        end
    elseif contains(animal,'WV')
        if date <= 20190130
            blackrockDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
            mworksDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/mworks/%s/',array,animal);
        elseif date > 20190130 && date <= 20191603
            blackrockDir = sprintf('/mnt/vnlstorage2/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
            mworksDir = sprintf('/mnt/vnlstorage2/bushnell_arrays/%s/mworks/%s/',array,animal);
        else
            blackrockDir = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
            mworksDir = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/mworks/%s/',array,animal);
        end
    end
elseif length(tmp) == 7 %working from rethresholded and cleaned data
        [animal,~,~,array,date,~,threshold] = deal(tmp);
    if contains(animal,'WU')
        % /mnt/vnlstorage3/bushnell_arrays/nsp2/reThreshold
        dirBr = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/',array,animal);
        dirMw = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/',array,animal);
        blackrockDir = [prefix_dir, dirBr];
        mworksDir = [prefix_dir, dirMw];
    end
end
%%
tSuccess = 4*250 * 1e3;
pointsKeep = bin_size * 10;
intervalKeep = (pointsKeep*10) * 1e3;
tPerPoint = round(intervalKeep / pointsKeep);
numCh = 96;

% for nm in ['WU_gratmap_test_20170110_003']:
ns_nev_name = [blackrockDir, fileName];
%%
% only one mwk for multiple .nev files, remove the array-specific parts
% from the nev file name to get the .mwk name:

% Modifying so it will also ignore added portion for rethresholded files
replacement = {'_nsp1', '_nsp2','_thresh30','_thresh35','_thresh40','_thresh45'};
for n = 1: length(replacement)
    if n > 1
        shortName = strrep(shortName, replacement{n}, '');
    else
        shortName = strrep(fileName, replacement{n}, '');
    end
end   

mwk_name = [mworksDir, shortName, '.mwk2'];
%%
%%%%%%%%%%%%%%%%%%%%%%%%% get word out times and success events
force_process = 1;
% saveAll = 0;
saveMatFileMWorks = get_all_mworks_info_forBrittany(mwk_name, force_process, 'SaveFilePath', mworksDir);

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

t_spikes = cell(1, numCh);
for nn = 1:numCh
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

lastwarn('');
% mworks_correction = polyfit(double(mworks_wordout_times), nev_wordout_times_microseconds, 0);
[regressionResutls, ~, ~, ~, regressionStats] = regress(double(nev_wordout_times)',...
    [ones(size(nev_wordout_times)); double(mworks_wordout_times)]');

[msgstr, ~] = lastwarn;
if strcmp(msgstr, 'X is rank deficient to within machine precision.')
    % What is happening it a perfect line and regress is having a hard
    % time with it.
    regressionResutls(2) = (double(nev_wordout_times(1)) - double(nev_wordout_times(2)))./...
        (double(mworks_wordout_times(1)) - double(mworks_wordout_times(2)));
    regressionResutls(1) = double(nev_wordout_times(1)) - regressionResutls(2).*double(mworks_wordout_times(1));
end

%%%%%%%%%%%%%% loop through stimuli
if contains(programID,'grat','IgnoreCase',IGNORE)
    stim_var_names = {'starting_phase', 'direction', 'o_starting_phase',...
        'height', 'temporal_frequency',...
        'o_temporal_frequency', 'overlay','current_phase', 'width', 'grating',...
        'type', 'contrast', 'opacity', 'o_current_phase',  'start_time', 'yoffset',...
        'o_direction', 'rotation', 'xoffset','spatial_frequency', 'name',...
        'mask', 'o_rotation', 'o_spatial_frequency', 'action'};
else
    stim_var_names = {'pos_x','pos_y','filename','size_x','action','rotation'};
end

for kk = 1:length(stim_var_names)
    eval([stim_var_names{kk}, ' = [];']);
end

n_stim = 0;
t_stim = [];
new_stim = 0;

if contains(programID,'grat','IgnoreCase',IGNORE)
    for ind = 1:length(stim_display_update_events)
        if length(stim_display_update_events(ind).data) > 2
            cur_time = stim_display_update_events(ind).time_us;
            
            if sum((cur_time < success_times) .* (success_times < (cur_time + tSuccess))) ~= 0
                % determine if this is a new stimulus by looking if spatial_frequnecy and rotation are different from the most recently added value
                new_stim = 0;
                if length(spatial_frequency) >= 1
                    if spatial_frequency(end) ~= stim_display_update_events(ind).data{2}.spatial_frequency ||...
                            rotation(end) ~= stim_display_update_events(ind).data{2}.rotation
                        new_stim = 1;
                    end
                else
                    new_stim = 1;
                end
                
                % add the stimulus:
                if new_stim == 1
                    t_stim = [t_stim, cur_time.*regressionResutls(2) + regressionResutls(1)];
                    for kk = 1:length(stim_var_names)
                        eval([stim_var_names{kk}, ' = [', stim_var_names{kk},  ', stim_display_update_events(ind).data{2}.', stim_var_names{kk}, '];']);
                    end
                    n_stim = n_stim + 1;
                end
            end
        end
    end
else
    for ind = 1:length(stim_display_update_events)
        if length(stim_display_update_events(ind).data) > 2
            cur_time = stim_display_update_events(ind).time_us;
            
            if sum((cur_time < success_times) .* (success_times < (cur_time + tSuccess))) ~= 0
                % determine if this is a new stimulus by looking if spatial_frequnecy and rotation are different from the most recently added value
                new_stim = 1;
            end
            
            % add the stimulus:
            if new_stim == 1
                t_stim = [t_stim, cur_time.*regressionResutls(2) + regressionResutls(1)];
                for kk = 1:length(stim_var_names)
                    eval([stim_var_names{kk}, ' = [', stim_var_names{kk},  ', stim_display_update_events(ind).data{2}.', stim_var_names{kk}, '];']);
                end
                n_stim = n_stim + 1;
            end
        end
    end
end

sprintf('stim shown: %i', n_stim)

%%%%%%%%%%%%%%%%% binning electrophysiology data
bins = zeros(n_stim, pointsKeep, numCh);

for channel = 1:numCh
    channel
    bins(:,:, channel) = nev_bin_spikes(t_spikes{channel}, t_stim, pointsKeep, tPerPoint);
    
end

save([outputDir, save_name], 'stimOn', 'starting_phase', 'direction', 'o_starting_phase',...
    'height', 'temporal_frequency', 't_stim', 'o_temporal_frequency', 'overlay','current_phase', 'width', 'grating',...
    'type', 'contrast', 'opacity', 'o_current_phase',  'start_time', 'yoffset',...
    'o_direction', 'rotation', 'xoffset','spatial_frequency', 'name',...
    'mask', 'o_rotation', 'o_spatial_frequency', 'action', 'stimOff', 'bins');

end









