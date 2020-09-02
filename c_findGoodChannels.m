
%% Load data
clearvars 
close all
clc

animal_id = 'KY';
dataType = 0;
[file, program] = loadfile_fn(dataType,animal_id, 'combinedData_b_clean');
output_name = 'c_goodChannels';
combined_data = file.combined_data;
clear file

%% Compute d' and reliability metric (in section below)

%% Step 1: Compute spikecounts, firing rates, PSTHs across sessions and d'


struct_name = fieldnames(combined_data);

for ar = 1:2 % go thru each array
z_store = [];
stim_sc_store = [];
blnk_sc_store = [];
psth_store = [];


array = struct_name{ar};
sub_struct = fieldnames(combined_data.(struct_name{ar}));
amap = find_amap(animal_id, array);

% go thru each sample
for smp = 1:numel(sub_struct)
    sample = sub_struct{smp};
    
    
    % go thru each session/recording
    for session = 1:size(combined_data.(array).(sample),2)
        
        % get spike data
        sesh_data = combined_data.(array).(sample)(session).spikes; 
        
        % compute spike counts for stimuli and blanks separately
        stim_sc_cell = cellfun(@(x) squeeze(nansum(x(:, 1:60, :),2)), sesh_data(2:35), 'UniformOutput',false); % spikecount for each stim trial
        blnk_sc_cell = cellfun(@(x) squeeze(nansum(x(:, 1:60, :),2)), sesh_data(36:38), 'UniformOutput',false); % spikecount for each blank trial
          % eliminate 'diskfade' data
            if (dataType == 0) && (combined_data.(array).(sub_struct{smp})(session).sample_number == 1 || 2)
                stim_sc_cell{1} = nan(size(stim_sc_cell{1}));
            end
            %spikecounts_acrossTrials = cellfun(@(x) squeeze(nanmean(x)), stim_sc_cell, 'UniformOutput', false);
            
            
        % for PSTHs below
        stimulus_rsps = cellfun(@(x) squeeze(nanmean(x,1))/0.01, sesh_data(2:35,:), 'UniformOutput',false); % get the spike data for each stimulus condition
        stimulus_resps_mat = cat(3,stimulus_rsps{:}); % take the 35 100x96 cells and turn it into a 100x96x35 matrix
        across_condition = nanmean(stimulus_resps_mat,3); % average all responses across conditions
        blank_rsps = cellfun(@(x) squeeze(nanmean(x,1))/0.01, sesh_data(36:38,:), 'UniformOutput',false); % get the spike data for each set of blanks
        blank_resps_mat = nanmean(cat(3,blank_rsps{:}),3);
        
        % for tuning 
        time_avgd_rsps(:,:,session,smp) = zscore(squeeze(nanmean(stimulus_resps_mat(10:60,:,:),1)),0,2); % tuning curve
        z_tar(:,:,session) = zscore(time_avgd_rsps(:,:,session,smp),0,2); % z-score the time avgd rsps (z-scored tuning curve)
        
        % restructure & store spikecounts 
        stim_sc = cat(1,stim_sc_cell{:});
        blnk_sc = cat(1,blnk_sc_cell{:});
        
        % store things
        stim_sc_store = [stim_sc_store; stim_sc];
        blnk_sc_store = [blnk_sc_store; blnk_sc];
        psth_store(:,:,session,smp) = across_condition;
        blnk_psth_store(:,:,session,smp) = blank_resps_mat;
        
        % compute PSTHs across all sessions for each sample
        psth_across_sessions = squeeze(mean(psth_store, 3));
        
        % compute d' for each session and store per sample
        perSesh_dp(:,session,smp) = compute_dp(blnk_sc,stim_sc); 
                
    end
     z_store = cat(3,z_store,z_tar); % store the data for this sample along with the other samples
    
    dp(:,smp) = compute_dp(blnk_sc_store, stim_sc_store); % compute d' across all sessions for each sample

end



%% Compute reliability metric
for nboot = 1:100
    for chan = 1:96
        zt = squeeze(z_store(chan,:,:)); % take z-scored time avgd rsps (z-scored tuning curves)
        for cond = 1:34
            rand_vals(cond,:,chan) = datasample(zt(cond,:),2,2, 'Replace', false); % subsample 2 tuning curves from the data across samples
        end
        
        corr_val(chan,nboot) = corr(rand_vals(:,1,chan), rand_vals(:,2,chan), 'rows', 'pairwise'); % correlate the tuning curves
        to_plot(:,nboot,chan) = rand_vals(:,1,chan);
    end
    
end

tc_plot = to_plot;

%% Plot the distribution of permuted r values for each channel, compute median 
h1 = figure;
for chan2 = 1:96
    subplot(amap,10,10, chan2);
    med_rval(chan2) = median(corr_val(chan2,:)); % get median r value from the distribution after permuting nboot times
    
    %if med_rval(ar,chan2) > 0.35
    %  store_val(chan2,ar) = chan2; % find channels with r_val > 0.35
    %end
    
    h = histogram(corr_val(chan2,:), 'Normalization', 'probability');
    hold on
    xline(med_rval(chan2), 'r--', 'LineWidth', 2);
    h.BinWidth = 0.1;
    h.FaceColor = 'b';
    h.EdgeColor = 'b';
    title(sprintf('%d, %0.2f', chan2, med_rval(chan2)), 'FontSize', 10);
    %sgtitle(sprintf('%s %s %s: Distribution of correlation between tuning curves permuted across samples (1st day of each sample)', ...
    %   animal_id, array, sub_struct{smp}));
    sgtitle(sprintf('%s %s: Distribution of correlation between tuning curves permuted across samples (all 7mo data)', ...
        animal_id, array), 'FontSize', 14);
    xlim([0 1])
    ylim([0 0.5])
    box off
    axis square
end

figure_settings(h1)
%nGoodChans(ar) = sum(~ store_val(:,ar) == 0);


%% Scatter the d prime averaged across individual sessions against the median split-half correlation (reliability metric)

d_crit = 0.75;
r_crit = 0.25;

h2 = figure;

A = perSesh_dp;
B = reshape(A(1:96, 1:5, 1:3),96,15);
mean_dp = nanmean(B,2);
var_dp = nanvar(B,[],2);

scatter(mean_dp,med_rval)

hold on
xlabel('mean d prime')
ylabel('reliability metric')
xlim([ 0 2])
ylim([0 1])
plot([0 2],[0 1])
xline(d_crit, 'b--')
yline(r_crit, 'b--')
axis square
title(sprintf('%s %s: d prime vs. reliability metric', animal_id, struct_name{ar}), 'FontSize', 14)

figure_settings(h2)

%% Sub-select channels that meet the criteria 
all_chans = 1:96;


good_ndx(ar,:) = med_rval(:) >= r_crit & mean_dp(:) >= d_crit;

A = [med_rval' mean_dp good_ndx(ar,:)'];

num_goodChans = sum(good_ndx(ar,:));

goodChans{ar} = all_chans(good_ndx(ar,:));
disp(fprintf('In %s, a total of  %d channels pass the test.\n', array, num_goodChans))



%% Plot psth across sessions 
blnk_across_sessions = squeeze(mean(blnk_psth_store, 3));
cmap = distinguishable_colors(3);

h3 = figure;
for nChan = 1:amap.nChannels
    
    subplot(amap, 10, 10, nChan)
    for smp2 = 1:3
        if good_ndx(nChan) == 1
            
            plot(psth_across_sessions(1:60,nChan,smp2), 'Color', cmap(smp2,:,:));
            hold on
            plot(blnk_across_sessions(1:60,nChan,smp2), 'Color', [0 0 0 0.5], 'lineWidth', 1); % plot the corresponding blank rsp
            
            title(sprintf('%d', nChan), 'FontSize', 12);
        else
            axis off
        end
    end
    sgtitle(sprintf('%s %s: Stimulus-locked response to filtered noise images across sessions for each sample,', ...
        animal_id, array), 'FontSize', 14);
    ylim([0 inf])
    box off
    axis square
    
end

figure_settings(h3)
%end









%% Find channels that have:
% 1. hi d', hi reliability
% 2. hi d', lo reliability
% 3. lo d', hi reliability
% 4. lo d', lo reliability

p1 = [0 0 2 2];
p2 = [0 1 0 1];
h5 = figure;

for pt = 1:4
    
    A = [mean_dp med_rval'];
    distances = sqrt(sum((A-[p1(pt) p2(pt)]).^2,2)); % aqui cambias el punto 2,1 por las otras esquinas
    [~,ind(pt)] = min(distances);
    
    % psths
    
    subplot(1,4,pt)
    for smp5 = 1:3
        plot(psth_across_sessions(1:60, ind(pt),smp5), 'Color', cmap(smp5,:,:));
        hold on
        plot(blnk_across_sessions(1:60,ind(pt), smp5), 'Color', [0 0 0 0.5], 'lineWidth', 1);
    end
    switch pt
        case 1
            str = 'Low r, low dprime';
        case 2
            str = 'High r, low dprime';
        case 3
            str = 'Low r, high dprime';
        case 4
            str = 'High r, high drime';
    end
    title(sprintf('%s (%d,%d)\n channel #%d', str, p1(pt), p2(pt), ind(pt)), 'FontSize', 12);
    box off
    xlim([0 60])
    ylim([0 100])
    xlabel('Time Bins', 'FontSize', 12)
    ylabel('Mean response', 'FontSize', 12)
    axis square
end



sgtitle(sprintf('%s %s: Channels with high/low reliability + dprime', animal_id, struct_name{ar}), 'FontSize', 14)
figure_settings(h5)


h6 = figure;
tar_avgd = squeeze(nanmean(time_avgd_rsps,3));
for pt2 = 1:4
    subplot(1,4,pt2)
    for smp6 = 1:3
        plot(tar_avgd(ind(pt2),:,smp6), 'Color', cmap(smp6,:,:));
        hold on
    end
    switch pt2
        case 1
            str = 'Low r, low dprime';
        case 2
            str = 'High r, low dprime';
        case 3
            str = 'Low r, high dprime';
        case 4
            str = 'High r, high drime';
    end
    title(sprintf('%s (%d,%d)\n channel #%d', str, p1(pt2), p2(pt2), ind(pt2)), 'FontSize', 12);
    box off
    xlim([1 35])
    ylim([-1.5 2.5])
    xlabel('Stimulus Condition', 'FontSize', 12)
    ylabel('Average Response', 'FontSize', 12)
    axis square
end
sgtitle(sprintf('%s %s: Tuning for channels with high/low reliabilty & dprime', animal_id, struct_name{ar}));
figure_settings(h6)
end
%% Save
[savename] = savename_fn(animal_id, program, output_name);
save(savename, 'good_ndx', 'goodChans');

%%
%% TESTING THE CODE:

%% Sub-sampled tuning curves for select channels
h4 = figure;

% vals = randi(100,1,10);
% chans = [29];
% for nch1 = 1%:3
%     for nb = 1:10
%         subplot(1,numel(chans),nch1)
%         plot(tc_plot(:,vals(nb), chans(nch1)))
%         
%         hold on
%         
%         title(sprintf('channel %d, median r = %.2f', chans(nch1), med_rval(1,chans(nch1))))
%         xlabel('condition')
%         ylabel('response')
%         sgtitle(sprintf('%s Examples of sub-sampled tuning curves for a "good" vs. "bad" %s channels', animal_id, array))
%         box off
%         xlim([1 35])
%         %ylim([-1.5 3])
%     end
%     figure_settings(h4)
% end
