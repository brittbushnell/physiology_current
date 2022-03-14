function [population_rsps] = corrClass_XAFC_211108(circ_train, stim_train, circ_test, stim_test, nAFC, tmp_flg )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here

population_rsps = [];
total_trials = [];

for pos = 1:size(stim_test,5)
    for rf = 1:size(stim_test,4)
        %% set template
        if strcmp(tmp_flg, 'posInvar_all')
            %circle_template = squeeze(mean(mean(circ_train,4),3)); % avg across positions then across trials
            
            %% added 211108 - we need to subsample channels across positions before creating the template
            numTrials = size(stim_train,3)*size(stim_train,5);
            matchT = randsample(1:numTrials,size(stim_train,3));
            stim_reshape = stim_train(:,:,:,rf,:);
            circ_reshape = circ_train;
            cat_pos_stim = reshape(stim_reshape, size(stim_train,1), size(stim_train,2), numTrials);
            cat_pos_circ = reshape(circ_reshape, size(circ_train,1), size(circ_train,2), numTrials); 
            all_rf = squeeze(mean(mean(cat_pos_stim(:,:,matchT),2),3));
            circle_template = squeeze(mean(cat_pos_circ(:,:,matchT),3)); 
            %all_rf = squeeze(mean(mean(mean(stim_train(:,:,:,rf,:),5),2),3)); % avg across positions, then all mods, then all trials
            % added 211108 - end
             
            template = all_rf - circle_template;
        elseif strcmp(tmp_flg, 'all') % all mods - circle
            circle_template = squeeze(mean(circ_train(:,:,:,pos),3));
            all_rf = squeeze(mean(mean(stim_train(:,:,:,rf,pos),2),3));
            template = all_rf - circle_template;
        end
        
        %% classifier
        % draw X trials from the test sets
        pr = zeros(size(circ_test,3), size(stim_test,2)+1);
        %pr = zeros(size(circ_test,3), size(stim_test,2));
        for m = 0:size(stim_test,2) % go thru each modulation including circle
            clear nt
            
            nt = size(stim_test,3); % nTrials for stim_test
            
            for t = 1:nt % go thru each trial for this modulation
                clear target_trial corrVals ctVals max_cvals circle_trial
                
                % Draw 1 target trial
                if m == 0 % draw a circle
                    target_trial = circ_test(:,:,t,pos);
                else % draw an RFS
                    target_trial = stim_test(:,m,t,rf,pos);
                end
                
                corrVals = zeros(nAFC,1);
                corrVals(1) = corr(target_trial, template,'rows', 'pairwise'); % target vs template
                
                % Draw distractor trials
                ctVals = randsample(1:size(circ_test,3),nAFC-1); % draw three random values from 1:nT
                
                if nAFC == 2 % draw 1 circle trial for the corresponding trial
                    circle_trial = circ_test(:,:,ctVals,pos);
                    corrVals(nAFC) = corr(circle_trial, template, 'rows', 'pairwise'); % circle vs template (2AFC)
                    
                else % draw nAFC-1 circles based on the random trial values  you drew in circ_t
                    for c = 1:nAFC-1
                        circle_trial = circ_test(:,:,ctVals(c),pos); % draw a random circle test trial
                        corrVals(c+1) = corr(circle_trial, template, 'rows', 'pairwise'); % nAFC-1 circles vs templates
                    end
                end
                
                % Classify trial response based on the max correlation value
                max_cval = max(corrVals); % find max correlation value
                if max_cval == corrVals(1)
                    pr(t,m+1) = 1; % recuerda que aqui es m+1
                else
                    pr(t,m+1) = 0; % recuerda que aqui es m+1
                end
                
            end
        end
        
        population_rsps(:,:,rf,pos) = pr;
    end
end
end

