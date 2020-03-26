% bin spike counts from nev file

% function parse_nevMorks_MarianaRig(varargin)
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
%
%  'binSize',#: number of ms to count spikes over
%             DEFAULT: 10ms
%     Example: (fileName),
%
%
%
%% Verify input arguments and set default values
% switch nargin
%     case 0
%         error ('Must pass in the blackrock file name at a minimum')
%     case 1
%         fprintf('parsing %s \n',varargin{1});
%         fileName = varargin{1};
%         bin_size = 10;
%         num_bins = 100;
%         outputDir = '/home/bushnell/binned_dir/';
%         save_name = [fileName, '.mat'];
%     case 2
%         fprintf('parsing %s with %d ms bins \n',varargin{1}, varargin{2});
%         fileName = varargin{1};
%         bin_size = varargin{2};
%         num_bins = 100;
%         outputDir = '/home/bushnell/binned_dir/';
%         save_name = [fileName, '.mat'];
%     case 3
%         fprintf('parsing %s in %d %d ms bins \n',varargin{1}, varargin{3}, varargin{2});
%         fileName = varargin{1};
%         bin_size = varargin{2};
%         num_bins = varargin{3};
%         outputDir = '/home/bushnell/binned_dir/';
%         save_name = [fileName, '.mat'];
%     case 4
%         fprintf('parsing %s in %d %d ms bins. Mat file will be saved at %s \n',varargin{1}, varargin{3}, varargin{2}, varargin{4});
%         fileName = varargin{1};
%         bin_size = varargin{2};
%         num_bins = varargin{3};
%         outputDir = varargin{4};
%         save_name = [fileName, '.mat'];
%     case 5
%         fprintf('parsing %s in %d %d ms bins. Mat file will be saved at %s \n',varargin{1}, varargin{3}, varargin{2}, varargin{4});
%         fileName = varargin{1};
%         bin_size = varargin{2};
%         num_bins = varargin{3};
%         outputDir = varargin{4};
%         save_name = [fileName, '.mat'];
%% testing
clc
clear all
close all
%%
files = {
%     'XX_LE_Glass_20200210_001';
%     'XX_LE_Glass_20200210_002';
    'XX_LE_Glass_20200210_003';
    'XX_LE_GlassTR_20200212_003';
    'XX_LE_GlassTR_20200213_001';
    'XX_LE_GlassTR_20200213_002';
    'XX_LE_GlassTR_20200214_001';
    'XX_LE_GlassTR_20200214_002';
    'XX_LE_GlassTR_20200214_003';
    'XX_LE_GlassTR_20200217_001';
    'XX_LE_GlassTR_20200217_002';
    'XX_LE_GlassTR_20200217_003';
    'XX_LE_GlassTR_20200218_001';
    'XX_RE_Glass_20200211_001';
    'XX_RE_Glass_20200211_002';
    'XX_RE_Glass_20200211_003';
    'XX_RE_Glass_20200212_001';
    'XX_RE_Glass_20200212_002';
    'XX_RE_GlassTR_20200212_002';
    'XX_RE_GlassTR_20200218_002';
    'XX_RE_GlassTR_20200219_001';
    'XX_RE_GlassTR_20200219_002';
    'XX_RE_GlassTR_20200219_003';
    'XX_RE_GlassTR_20200219_004';
    'XX_RE_GlassTR_20200220_001';
    'XX_RE_GlassTR_20200220_002';
    'XX_RE_GlassTR_20200221_002';
    };
%%
for fi = 1:size(files,1)
    fileName = files{fi};
    
    fprintf('\n*** running %s file ***\n', fileName)
    fprintf('file %d/%d\n\n',fi,size(files,1))
    
    bin_size = 10;
    num_bins = 100;
    outputDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/';
    save_name_v1 = [fileName,'_nsp1_', '.mat'];
    save_name_v4 = [fileName,'_nsp2_', '.mat'];
    %%
    prefix_dir = '/Volumes/MatFiles/arrayData/XX';
    
    blackrockDir = [prefix_dir, '/blackrock/'];
    mworksDir = [prefix_dir, '/mWorks/'];
    %% set paths
    tSuccess = 4*250 * 1e3;
    pointsKeep = bin_size * 10;
    intervalKeep = (pointsKeep*10) * 1e3;
    tPerPoint = round(intervalKeep / pointsKeep);
    
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
    
    mwk_name = [mworksDir, shortName, '.mwk2'];
    %%
    % [regressionResutls, regressionStats] = regressTimeMWorksNEV(mworksFile, nevFile);
    % [mworks_words_out, mworks_words_time_out, nev_words_out, nev_words_time_out] =...
    %     wordAlignVodnik(mworks_words, mworks_words_time, nev_words, nev_words_time);
    %% get word out times and success events
    force_process = 1;
    % saveAll = 0;
    % saveMatFileMWorks = get_all_mworks_info_forBrittany(mwk_name, force_process, 'SaveFilePath', mworksDir);
    
    saveMatFileMWorks = ['/Volumes/MatFiles/arrayData/XX/matfiles/', fileName, '_mworks_output.mat'];
    
    
    %%
    aux = load(saveMatFileMWorks);
    
    sent = aux.wordout_varEvents;
    stim_display_update_events = aux.stimDisplayUpdateEvents;
    success_events = aux.number_of_stm_shownEvents;
    
    stimOn = cell2mat({aux.stimon_timeEvents.data});
    stimOff = cell2mat({aux.stimoff_timeEvents.data});
    
    success_times = cell2mat({success_events.time_us});
    t_sent = cell2mat({sent.time_us});
    
    clear aux;
    %% nev file word out times
    % read header
    
    fp = openNEV([ns_nev_name, '.nev']);
    % nev_wordout_times_step1 = fp.Data.SerialDigitalIO.TimeStamp;
    % nev_wordout_times_microseconds = double(nev_wordout_times_step1)/(double(fp.MetaTags.SampleRes)/1e6);
    
    % conversion_factor = 1e6/time_res_timestamps; % conversion to microseconds
    numCh = size(fp.ElectrodesInfo,2);
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
    [regressionResutls, regressionStats] = regressTimeMWorksNEV(saveMatFileMWorks, fp);
    %% %first find the times when mworks sends out a word, mworks data is stored in microseconds, IMAGINE THAT
    % mworks_wordout_times = double(cell2mat({sent(cell2mat({sent.data})~=0).time_us}));
    %
    % nev_wordout_times_step1 = fp.Data.SerialDigitalIO.TimeStampSec;
    % nev_wordout_times = double(nev_wordout_times_step1).*(10^6);
    %
    % %find the smallest interval between words in an mworks file
    % minimum_interword_interval = min(diff(mworks_wordout_times));
    %
    % %locate times in nev file when interword interval is less than half the
    % %minimum interword interval detected above and remove (by convention
    % %choose the later of the two close values as the starting point
    % bad_nev_times = find(diff(nev_wordout_times)<minimum_interword_interval/2) + 1; %find nev inter_word_intervals that are too short
    % nev_wordout_times(bad_nev_times) = []; %remove these times
    %
    % lastwarn('');
    % % mworks_correction = polyfit(double(mworks_wordout_times), nev_wordout_times_microseconds, 0);
    % [regressionResutls, ~, ~, ~, regressionStats] = regress(double(nev_wordout_times)',...
    %     [ones(size(nev_wordout_times)); double(mworks_wordout_times)]');
    %
    % [msgstr, ~] = lastwarn;
    % if strcmp(msgstr, 'X is rank deficient to within machine precision.')
    %     % What is happening it a perfect line and regress is having a hard
    %     % time with it.
    %     regressionResutls(2) = (double(nev_wordout_times(1)) - double(nev_wordout_times(2)))./...
    %         (double(mworks_wordout_times(1)) - double(mworks_wordout_times(2)));
    %     regressionResutls(1) = double(nev_wordout_times(1)) - regressionResutls(2).*double(mworks_wordout_times(1));
    % end
    %% loop through stimuli
    
    stim_var_names = {'pos_x','pos_y','filename','size_x','action','rotation'};
    
    n_stim = 0;
    t_stim = [];
    new_stim = 0;
    
    auxMonitorAndFixUpdate = find(cellfun(@(x) size(x, 2) == 3,...
        {stim_display_update_events.data}));
    
    stim_display_update_events_Subset = stim_display_update_events(auxMonitorAndFixUpdate);
    
    
    for ind = 1:length(stim_display_update_events_Subset)
        if length(stim_display_update_events_Subset(ind).data) > 2
            cur_time = stim_display_update_events_Subset(ind).time_us;
            
            if sum((cur_time < success_times) .* (success_times < (cur_time + tSuccess))) ~= 0
                % determine if this is a new stimulus by looking if spatial_frequnecy and rotation are different from the most recently added value
                %       new_stim = 0;
                %       if length(spatial_frequency) >= 1
                %         if spatial_frequency(end) ~= stim_display_update_events_Subset(ind).data{2}.spatial_frequency ||...
                %             rotation(end) ~= stim_display_update_events_Subset(ind).data{2}.rotation
                %           new_stim = 1;
                %         end
                %       else
                %         new_stim = 1;
                %       end
                
                % add the stimulus:
                %       if new_stim == 1
                t_stim = [t_stim, cur_time.*regressionResutls(2) + regressionResutls(1)]; % This time will be in ?NEV? time alignment
                for kk = 1:length(stim_var_names)
                    % eval([stim_var_names{kk}, ' = [?, stim_var_names{kk} ?; stim_display_update_events_Subset(ind).data{2}.?, stim_var_names{kk}, ?];?]);
                    eval([stim_var_names{kk}, '{n_stim+1} = stim_display_update_events_Subset(ind).data{2}.', stim_var_names{kk}, ';']);
                end
                n_stim = n_stim + 1;
                %       end
            end
        end
    end
    
    %% for kk = 1:length(stim_var_names)
    %     eval([stim_var_names{kk}, ' = [];']);
    % end
    %
    % n_stim = 0;
    % t_stim = [];
    % new_stim = 0;
    %
    % for ind = 1:length(stim_display_update_events)
    %     if length(stim_display_update_events(ind).data) > 2
    %         cur_time = stim_display_update_events(ind).time_us;
    %
    %         if sum((cur_time < success_times) .* (success_times < (cur_time + tSuccess))) ~= 0
    %             % determine if this is a new stimulus by looking if spatial_frequnecy and rotation are different from the most recently added value
    %             new_stim = 0;
    %             if length(spatial_frequency) >= 1
    %                 if spatial_frequency(end) ~= stim_display_update_events(ind).data{2}.spatial_frequency ||...
    %                         rotation(end) ~= stim_display_update_events(ind).data{2}.rotation
    %                     new_stim = 1;
    %                 end
    %             else
    %                 new_stim = 1;
    %             end
    %
    %             % add the stimulus:
    %             if new_stim == 1
    %                 t_stim = [t_stim, cur_time.*regressionResutls(2) + regressionResutls(1)];
    %                 for kk = 1:length(stim_var_names)
    %                     eval([stim_var_names{kk}, ' = [', stim_var_names{kk},  ', stim_display_update_events(ind).data{2}.', stim_var_names{kk}, '];']);
    %                 end
    %                 n_stim = n_stim + 1;
    %             end
    %         end
    %     end
    % end
    %% bin electrophysiology data
    fprintf('stim shown: %i \n', n_stim)
    binsV1 = zeros(n_stim, pointsKeep, 96);
    binsV4 = zeros(n_stim, pointsKeep, 96);
    v4Ch  = 1;
    for channel = 1:numCh
        tag = fp.ElectrodesInfo(channel).ElectrodeLabel(2);
        if contains(tag,'1')
            fprintf('V1 channel %d \n',channel)
            binsV1(:,:, channel) = nev_bin_spikes(t_spikes{channel}, t_stim, pointsKeep, tPerPoint);
        else
            fprintf('V4 channel %d \n',channel)
            binsV4(:,:, v4Ch) = nev_bin_spikes(t_spikes{channel}, t_stim, pointsKeep, tPerPoint);
            v4Ch  = v4Ch +1;
        end
    end
    
    save([outputDir, save_name_v1], 'stimOn', 't_stim', 'stimOff', 'binsV1','pos_x','pos_y',...
        'filename','size_x','action','rotation');
    
    save([outputDir, save_name_v4], 'stimOn', 't_stim', 'stimOff', 'binsV4','pos_x','pos_y',...
        'filename','size_x','action','rotation');
    fprintf('%.2f minutes to analyze %s file', toc/60,fileName)
end









