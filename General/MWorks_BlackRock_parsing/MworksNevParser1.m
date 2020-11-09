% bin spike counts from nev file

function MworksNevParser1(varargin)
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
%         fileName = varargin{1};
%         bin_size = 10;
%         num_bins = 100;
%         outputDir = '/home/bushnell/binned_dir/';
%         %save_name = [fileName, '.mat'];
%
%
%% Verify input arguments and set default values

switch nargin
    case 0
        error ('Must pass in the blackrock file name at a minimum')
    case 1
        fprintf('parsing %s\n',varargin{1});
        fileName = varargin{1};
        bin_size = 10;
        num_bins = 100;
        outputDir = '/home/bushnell/binned_dir/';
        %save_name = [fileName, '.mat'];
    case 2
        fprintf('parsing %s with %d ms bins\n',varargin{1}, varargin{2});
        fileName = varargin{1};
        bin_size = varargin{2};
        num_bins = 100;
        outputDir = '/home/bushnell/binned_dir/';
        %save_name = [fileName, '.mat'];
    case 3
        fprintf('parsing %s in %d %d ms bins\n',varargin{1}, varargin{3}, varargin{2});
        fileName = varargin{1};
        bin_size = varargin{2};
        num_bins = varargin{3};
        outputDir = '/home/bushnell/binned_dir/';
        %save_name = [fileName, '.mat'];
    case 4
        fprintf('parsing %s in %d %d ms bins.\n Mat file will be saved at %s\n',varargin{1}, varargin{3}, varargin{2}, varargin{4});
        fileName = varargin{1};
        bin_size = varargin{2};
        num_bins = varargin{3};
        outputDir = varargin{4};
        %save_name = [fileName, '.mat'];
end
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
fileName = string(fileName);
tmp = strsplit(fileName,'_');
fileName = char(fileName);
animal = tmp{1};
eye = tmp{2};
programID = tmp{3};
array = tmp{4};
date = tmp{5};
runNum = tmp{6};
threshold = tmp{7};

if ~isempty(threshold)%working from rethresholded and cleaned data
%     [animal,eye,programID,array,date,~,threshold] = deal(tmp{:});
    date = str2double(date);
    % /vnlstorage3/bushnell_arrays/nsp2/reThreshold
    if contains(programID,'grat','IgnoreCase',true)
        blackrockDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/gratings/%s/%s/',array,animal,eye);
    elseif contains(fileName,'clean')
        blackrockDir = '/users/bushnell/Desktop/my_zemina/vnlstorage3/';
    else
        blackrockDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/png/%s/%s/',array,animal,eye);
    end
else
%     [animal,~,programID,array,date,~] = deal(tmp{:});
    date = str2double(date);
    if contains(animal,'WU')
        blackrockDir = sprintf('/users/bushnell/Desktop/my_vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
    elseif contains(animal,'XT')
        if date <= 20190131
            blackrockDir = sprintf('/users/bushnell/Desktop/my_vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
        else
            blackrockDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage2/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
        end
    elseif contains(animal,'WV')
        if date <= 20190130
            blackrockDir = sprintf('/users/bushnell/Desktop/my_vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
        elseif date > 20190130 && date <= 20191603
            blackrockDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage2/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
        else
            blackrockDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
        end
    end
end
% this will always be in the same place, regardless of if it's been cleaned
% and thresholded again
if contains(animal,'WU')
    mworksDir = sprintf('/users/bushnell/Desktop/my_vnlstorage/bushnell_arrays/nsp1/mworks/%s/',animal);
elseif contains(animal,'XT')
    if date <= 20190131
        mworksDir = sprintf('/users/bushnell/Desktop/my_vnlstorage/bushnell_arrays/nsp1/mworks/%s/',animal);
    else
        mworksDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage2/bushnell_arrays/nsp1/mworks/%s/',animal);
    end
elseif contains(animal,'WV')
    if date <= 20190130
        mworksDir = sprintf('/users/bushnell/Desktop/my_vnlstorage/bushnell_arrays/nsp1/mworks/%s/',animal);
    elseif date > 20190130 && date <= 20191603
        mworksDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage2/bushnell_arrays/nsp1/mworks/%s/',animal);
    else
        mworksDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/nsp1/mworks/%s/',animal);
    end
end
%mworksDir = sprintf('/v/awake/%s/mwk/',animal);
%%
tSuccess = 4*250 * 1e3;
pointsKeep = num_bins;
intervalKeep = (pointsKeep*10) * 1e3;
tPerPoint = round(intervalKeep / pointsKeep);
numCh = 96;
saveMatFileMWorks = {};
fp = {};
% for nm in ['WU_gratmap_test_20170110_003']:
ns_nev_name = [blackrockDir,fileName];
%%
% only one mwk for multiple .nev files, remove the array-specific parts
% from the nev file name to get the .mwk name:

% Modifying so it will also ignore added portion for rethresholded files
 replacement = {'_nsp1', '_nsp2','_thresh30','_thresh35','_thresh40','_thresh45','_cleaned3.5','_ogcorrupt','.nev'};% '_cleaned4.5',,'_cleaned3.5'
for n = 1: length(replacement)
    if n > 1
        shortName = strrep(shortName, replacement{n}, '');
    else
        shortName = strrep(fileName, replacement{n}, '');
    end
end

mwk_name = [mworksDir,shortName,'.mwk'];
%%
%%%%%%%%%%%%%%%%%%%%%%%%% get word out times and success events
force_process = 1;
% saveAll = 0;

saveMatFileMWorks = get_all_mworks_info_forBrittany(mwk_name, force_process, 'SaveFilePath', mworksDir);
%%
aux = load(saveMatFileMWorks);

sent = aux.wordout_varEvents;
stim_display_update_events = aux.stimDisplayUpdateEvents;
success_events = aux.number_of_stm_shownEvents;

stimOn = cell2mat({aux.stimon_timeEvents.data});
stimOff = cell2mat({aux.stimoff_timeEvents.data});
fix_x = aux.stimDisplayUpdateEvents(5).data{1,2}.pos_x;
fix_y = aux.stimDisplayUpdateEvents(5).data{1,2}.pos_y;
%% 

success_times = cell2mat({success_events.time_us});
t_sent = cell2mat({sent.time_us});

clear aux;
%% nev file word out times
% read header
if contains(ns_nev_name,'.nev') % some files had .nev.nev ends, so this will get rid of all of those.
    ns_nev_name = strrep(ns_nev_name,'.nev','');
end
fp = openNEV([ns_nev_name,'.nev'],'nosave');
% nev_wordout_times_step1 = fp.Data.SerialDigitalIO.TimeStamp;
% nev_wordout_times_microseconds = double(nev_wordout_times_step1)/(double(fp.MetaTags.SampleRes)/1e6);

% conversion_factor = 1e6/time_res_timestamps; % conversion to microseconds
%%
offset = fp.MetaTags.HeaderOffset;

t_spikes = cell(1, numCh);
for nn = 1:numCh
    if isempty(fp.Data.Spikes.Electrode == nn)
        t_spikes{nn} = 0;
    else
        t_spikes{nn} = (double(fp.Data.Spikes.TimeStamp(fp.Data.Spikes.Electrode == nn))./double(fp.MetaTags.SampleRes)).*(10^6);
    end
end

%% Segment to do time alignment:
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
nev_wordout_times = nev_wordout_times./(10^6);

lastwarn('');
% mworks_correction = polyfit(double(mworks_wordout_times), nev_wordout_times_microseconds, 0);
regressionResutls = regress(double(nev_wordout_times)',...
    [ones(size(nev_wordout_times)); double(mworks_wordout_times)./(10^6)]');
regressionResutls(1) = regressionResutls(1).*(10^6);
%% loop through stimuli
if contains(programID,'grat','IgnoreCase',true) || contains(programID,'edge','IgnoreCase',true)
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

if contains(programID,'grat','IgnoreCase',true) || contains(programID,'edge','IgnoreCase',true)
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
    
else % stimulus is a png image
    for ind = 1:length(stim_display_update_events)
        if length(stim_display_update_events(ind).data) > 2
            cur_time = stim_display_update_events(ind).time_us;
            
            if sum((cur_time < success_times) .* (success_times < (cur_time + tSuccess))) ~= 0
                t_stim = [t_stim, cur_time.*regressionResutls(2) + regressionResutls(1)];
                for kk = 1:length(stim_var_names)
                    if contains(stim_var_names{kk},'filename')
                        tmpName1 = string(stim_display_update_events(ind).data{2}.filename);
                        tmpName2 = strsplit(tmpName1,'/');
                        tmpFname = tmpName2(end); % this gets rid of all of the unneeded path name, and just keeps the stimulus name
                        filename = cat(1,filename,tmpFname);
                        clear tmpFname
                        clear tmpName1
                        clear tmpName2
                    else
                        eval([stim_var_names{kk}, ' = [', stim_var_names{kk},  ', stim_display_update_events(ind).data{2}.', stim_var_names{kk}, '];'])%;
                    end
                end
                n_stim = n_stim + 1;
            end
        end
    end
end
sprintf('stim shown: %i', n_stim)

if contains(programID,'grat','IgnoreCase',true) || contains(programID,'edge','IgnoreCase',true)
    if size(xoffset,2) ~= size(spatial_frequency,2)
        fprintf('ERROR: size of xoffset does not match other variables')
        keyboard
    end
end
%% binning electrophysiology data
bins = zeros(n_stim, pointsKeep, numCh);
tic
for channel = 1:numCh
    bins(:,:, channel) = nev_bin_spikes_verRatePerChannel(t_spikes{channel}, t_stim, pointsKeep, tPerPoint,fp.MetaTags);    
    %fprintf('%.2f minutes to bin %d channels\n', toc/60,channel)
end
%%
strpName = strrep(fileName,'.nev','');
save_name = [strpName,'.mat'];
saveName = fullfile(outputDir,save_name);
if contains(programID,'grat','IgnoreCase',true) || contains(programID,'edge','IgnoreCase',true)
    save(saveName, 'stimOn', 'starting_phase', 'direction', 'o_starting_phase',...
        'height', 'temporal_frequency', 't_stim', 'o_temporal_frequency', 'overlay','current_phase', 'width', 'grating',...
        'type', 'contrast', 'opacity', 'o_current_phase',  'start_time', 'yoffset',...
        'o_direction', 'rotation', 'xoffset','spatial_frequency', 'name',...
        'mask', 'o_rotation', 'o_spatial_frequency', 'action', 'stimOff', 'bins',...
        't_stim','fix_x','fix_y');
    fprintf('saved as %s\n',saveName)
else
    save(saveName, 'stimOn', 'action', 'stimOff', 'bins','pos_x','pos_y','filename','size_x','action','rotation','fix_x','fix_y','t_stim');
    fprintf('saved as %s\n',saveName)
end
%%











