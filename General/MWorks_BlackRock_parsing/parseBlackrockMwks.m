% bin spike counts from nev file

function parseBlackrockMwks(varargin)
%{
This function is at its most simple, a re-creation of Darren Seibert's
Python parsing code. This Matlab version builds on it and increases some
of the flexibility.
The main output data strucutre is data.bins, which has all of the data
binned by stimulus presentation. The first bin is always when the
stimulus comes on, and extends for as long as requested (see below). By
default, this will return 1 second worth of 10 ms binned spike counts.


The only required input is the blackrock filename, all others are
optional.
  fileName: Blackrock file name
      Example: parseBlackrockMwks('WU_LE_Gratings_nsp1_20170705_003');

Optional inputs that may be entered in any order, but must come in pairs
with the correct naming convention.

 'B:aaa/bbb' : Path to where the Blackrock data file can be
 found. By default, this will point to the nsp1 or nsp2 directories on
 Zemina depending on the filename.
      DEFAULT: /vnlstorage/bushnell_arrays/nsp1/nsp1_blackrock/ or /vnlstorage/bushnell_arrays/nsp2/nsp2_blackrock/
        Example: parseBlackrockMwks('WU_LE_Gratings_nsp1_20170705_003','B:Volumes/BrizzleBackup');
          This would indicate the data can be found on an external
          hard drive named BrizzleBackup.

 'M:aaa/bbb' : Path to where the Mworks data file can be
 found. By default, this will point to the Mworks directory on Zemina.
      DEFAULT: /vnlstorage/bushnell_arrays/nsp1/mworks/ 
        Example: parseBlackrockMwks('WU_LE_Gratings_nsp1_20170705_003','M:Volumes/BrizzleBackup');
          This would indicate the data can be found on an external
          hard drive named BrizzleBackup.

 'binSize',# : number of ms to count spikes over
      DEFAULT: 10ms
        Example: parseBlackrockMwks('WU_LE_Gratings_nsp1_20170705_003','binSize',5);
          This would parse that data file with 100 5ms bins, yielding
          500ms of data from stimulus onset.

  'numBins',# : Number of bins to create for each stimulus
      DEFAULT: 100 bins.
      Multiply with binSize to know how much time the
      full data set will be.  For example, 100 10ms bins will yield 1s of
      data from stimulus on.
         Example: parseBlackrockMwks('WU_LE_Gratings_nsp1_20170705_003','numBins',50);
              This would parse the data into 50 10 ms bins, also yielding
              500ms of data from stimulus onset.

  'outputDir','xxxx' : preferred location for saving mat files
      DEFAULT: bushnell/binned_dir when running on zemina.
         Example: parseBlackrockMwks('WU_LE_Gratings_nsp1_20170705_003','outputDir','bushnell/binned_dir/recut')

  'saveName', 'yyyy' : preferred name to use to save the mat file
      DEFAULT: the same as the input filename
         Example: parseBlackrockMwks('WU_LE_Gratings_nsp1_20170705_003','saveName','WU_FE_Gratings_V1_July5')

  'overwrite', 0 or 1 : If this file has been run previously, do you want
  to force the program to re-parse?
                0 = do not process again if you do not want to
                1 = process again
      DEFAULT: 1, process again
      Example: parseBlackrockMwks('WU_LE_Gratings_nsp1_20170705_003','overwrite',0)

  
  Version 1.0 written by Mariana Cardoso
      Translating Darren's code from Python to Matlab

  Version 2.0 Written by Brittany Bushnell
      Adding Varargin and changing some variable names to ones that are
      more inuitive.
  June 28, 2018
  %}
%% Verify input arguments and set default values

if isempty(varargin)
    error('Must pass in the Blackrock filename at a minimum')
else
    % Set default values
    binSize = 10;
    numBins = 100;
    outputDir = '/home/bushnell/binned_dir/';
    location = 2;
    overwrite = 1;
    
    
    for ins = 1:length(varargin)
        argIn = varargin(ins);
        argIn = cell2mat(argIn)
        
        if isnumeric(argIn)
            continue
        end
        
        if strfind(argIn,'nsp')
            fileName = string(varargin(ins));
            saveName = [fileName, '.mat'];
            continue
            
        elseif strcmpi(argIn,'binSize')
            next = cell2mat(varargin(ins+1));
            if isnumeric(next)
                binSize = next;
            else
                error ('Input following binSize is not numeric')
            end
            continue
            
        elseif strcmpi(argIn,'numBins')
            next = cell2mat(varargin(ins+1));
            if isnumeric(next)
                numBins = next;
            else
                error ('Input following numBins is not numeric')
            end
            continue
            
        elseif strcmpi(argIn,'location')
            next = cell2mat(varargin(ins+1));
            if isnumeric(next)
                location = next;
            else
                error ('Input following location is not numeric')
            end
            continue
            
        elseif strcmpi(argIn,'overwrite')
            next = cell2mat(varargin(ins+1));
            if isnumeric(next)
                location = next;
            else
                error ('Input following overwrite is not numeric')
            end
            continue
            
        elseif strfind(argIn,'B:')
            blackrockPath = string(varargin(ins));
            chunks = strsplit(blackrockPath,':');
            blackrockPath = chunks(end);
            continue 
        elseif strfind(argIn,'b:')
            blackrockPath = string(varargin(ins));
            chunks = strsplit(blackrockPath,':');
            blackrockPath = chunks(end);
            continue 
            
        elseif strfind(argIn,'M:')
            mworksPath = string(varargin(ins));
            chunks = strsplit(mworksPath,':');
            mworksPath = chunks(end);
            continue 
        elseif strfind(argIn,'m:')
            mworksPath = string(varargin(ins));
            chunks = strsplit(mworksPath,':');
            mworksPath = chunks(end);
            continue 
            
        elseif strcmpi(argIn,'savePath')
            savePath =  string(varargin(ins+1));
            continue 
            
        elseif strcmpi(argIn,'outputDir')
            outputDir = string(varargin(ins+1));
            continue
            
        else
            error('cannot identify input')
        end
    end
end
%% setup default paths based on filenames
if sum(strcmpi(varargin,'blackrockPath')) == 0
    if strfind(fileName,'nsp1')
        if strfind(fileName, 'recut')
            blackrockDir =  '/mnt/vnlstorage/bushnell_arrays/vnlstorage/bushnell_arrays/nsp1/nsp1_blackrock/WU_recut/';
        else
            blackrockDir = '/mnt/vnlstorage/bushnell_arrays/nsp1/nsp1_blackrock/';
        end
    else
        if strfind(fileName, 'recut')
            blackrockDir =  '/mnt/vnlstorage/bushnell_arrays/nsp2/nsp2_blackrock/WU_recut/';
        else
            blackrockDir =  '/mnt/vnlstorage/bushnell_arrays/nsp2/nsp2_blackrock/';
        end
    end
end

if sum(strcmpi(varargin,'mworksPath')) == 0
    if strfind(fileName, 'recut')
        mworksDir = 'nsp1/mworks/recut/';
    else
        mworksDir = 'nsp1/mworks/';
    end
end
%%
tSuccess = 4*250 * 1e3;
% pointsKeep = binSize * 10;
intervalKeep = (binSize * numBins) * 1e3;
tPerPoint = round(intervalKeep / binSize); %round(intervalKeep / pointsKeep);
numCh = 96;

% for nm in ['WU_gratmap_test_20170110_003']:
ns_nev_name = [blackrockDir, fileName];

% only one mwk for multiple .nev files, remove the array-specific parts
% from the nev file name to get the .mwk name:
replacement = {'NSP2_P_', '_NSP1_M', '_NSP1_A','_NSP1_P', '_NSP1_S130404',...
    '_NSP2_P', '_NSP2_M', 'NSP2_A', '_nsp1', '_nsp2'};

for n = 1: length(replacement)
    if n > 1
        shortName = strrep(shortName, replacement{n}, '');
    else
        shortName = strrep(fileName, replacement{n}, '');
    end
end

mwk_name = [mworksDir, shortName, '.mwk'];

%%%%%%%%%%%%%%%%%%%%%%%%% get word out times and success events

force_process = overwrite;
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

stim_var_names = {'starting_phase', 'direction', 'o_starting_phase',...
    'height', 'temporal_frequency',...
    'o_temporal_frequency', 'overlay','current_phase', 'width', 'grating',...
    'type', 'contrast', 'opacity', 'o_current_phase',  'start_time', 'yoffset',...
    'o_direction', 'rotation', 'xoffset','spatial_frequency', 'name',...
    'mask', 'o_rotation', 'o_spatial_frequency', 'action'};

for kk = 1:length(stim_var_names)
    eval([stim_var_names{kk}, ' = [];']);
end

n_stim = 0;
t_stim = [];
new_stim = 0;

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

sprintf('stim shown: %i', n_stim)

%%%%%%%%%%%%%%%%% binning electrophysiology data
bins = zeros(n_stim, pointsKeep, numCh);

for channel = 1:numCh
    channel
    bins(:,:, channel) = nev_bin_spikes(t_spikes{channel}, t_stim, pointsKeep, tPerPoint);
    
end

save([outputDir, saveName], 'stimOn', 'starting_phase', 'direction', 'o_starting_phase',...
    'height', 'temporal_frequency', 't_stim', 'o_temporal_frequency', 'overlay','current_phase', 'width', 'grating',...
    'type', 'contrast', 'opacity', 'o_current_phase',  'start_time', 'yoffset',...
    'o_direction', 'rotation', 'xoffset','spatial_frequency', 'name',...
    'mask', 'o_rotation', 'o_spatial_frequency', 'action', 'stimOff', 'bins');

end









