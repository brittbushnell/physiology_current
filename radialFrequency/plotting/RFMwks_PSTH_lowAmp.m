clear all
close all
clc
%%
file = 'WU_RadFreqLoc2_V4_20170706_RFxAmp_chxch_sortedBins';

load(file);
%% Get stimulus information
rfs  = unique(REcleanData.rfResps(1,:,:));
amps = unique(REcleanData.rfResps(2,:,:));
phase = unique(REcleanData.rfResps(3,:,:));
sfs = unique(REcleanData.rfResps(4,:,:));
radius = unique(REcleanData.rfResps(5,:,:));
xloc = unique(REcleanData.rfResps(6,:,:));
yloc = unique(REcleanData.rfResps(7,:,:));

numRFs = length(rfs);
numAmps = length(amps);
numPhases = length(phase);
numSfs = length(sfs);
numRad = length(radius);
numXloc = length(xloc);
numYloc = length(yloc);

numCh = size(REdata.bins,3);
%% Reshape sorted bins to make it easy to pull out each stimulus type
for ch = 5%1:numCh
    %% break into circle, RF, and blank matrices
    % rotating the matrices so they're the same orientation as the normal
    % matrices, changing the rest of the code from cols to rows is causing
    % problems.
    REblankResps = REcleanData.blankBins{ch}(:,8:end);
    REstimResps  = REcleanData.RFbins{ch}';
    
    LEblankResps = LEcleanData.blankBins{ch}(:,8:end);
    LEstimResps  = LEcleanData.RFbins{ch}';
    
    REcircResps = REstimResps(:,(REstimResps(1,:) == 32));
    LEcircResps = LEstimResps(:,(LEstimResps(1,:) == 32));
    
    RErfResps = REstimResps(:,(REstimResps(1,:) ~= 32));
    LErfResps = LEstimResps(:,(LEstimResps(1,:) ~= 32));
    %% Reshape to split by RF
    rfNdx = length(unique(RErfResps(1,:)));
    RErfResps = reshape(RErfResps,size(RErfResps,1),(size(RErfResps,2)/rfNdx),rfNdx); % now RF responses are a 3d matrix:
    
    rfNdx = length(unique(LErfResps(1,:)));
    LErfResps = reshape(LErfResps,size(LErfResps,1),(size(LErfResps,2)/rfNdx),rfNdx); % now RF responses are a 3d matrix:
    %% split by phase
    RErf4 = RErfResps(:,:,1);
    RErf8 = RErfResps(:,:,2);
    RErf16= RErfResps(:,:,3);
    
    LErf4 = LErfResps(:,:,1);
    LErf8 = LErfResps(:,:,2);
    LErf16= LErfResps(:,:,3);
    
    % sort each matrix by phase and concatenate to create 3d matrix of sorted
    % data.
    [~,indices] = sort(RErf4(3,:));
    RErf4 = RErf4(:,indices);
    
    [~,indices] = sort(RErf8(3,:));
    RErf8 = RErf8(:,indices);
    
    [~,indices] = sort(RErf16(3,:));
    RErf16 = RErf16(:,indices);
    
    [~,indices] = sort(LErf4(3,:));
    LErf4 = LErf4(:,indices);
    
    [~,indices] = sort(LErf8(3,:));
    LErf8 = LErf8(:,indices);
    
    [~,indices] = sort(LErf16(3,:));
    LErf16 = LErf16(:,indices);
    
    % go back to a 3Dimensional matrix, but now sorted by phase.
    RErfSorted = cat(3,RErf4,RErf8,RErf16);
    LErfSorted = cat(3,LErf4,LErf8,LErf16);
    
    % reshape so the 4th dimension is phase
    numRowsRE = size(RErfSorted,1);
    numColsRE = size(RErfSorted,2)/2;
    
    numRowsLE = size(LErfSorted,1);
    numColsLE = size(LErfSorted,2)/2;
    
    RErfPhases = reshape(RErfSorted,numRowsRE,numColsRE,2,3);
    LErfPhases = reshape(LErfSorted,numRowsLE,numColsLE,2,3);
    %% split by loction
    if length(xloc) > 1
        loc1 = min(xloc);
        useStim = find((LErfPhases(6,:,1,1) == loc1));
        LErfLoc1 = LErfPhases(:,useStim,:,:);
        RErfLoc1 = RErfPhases(:,useStim,:,:);
        
        useStim = find((LEcircResps(6,:,1) == loc1));
        LECircleLoc1 = LEcircResps(:,useStim,:);
        RECircleLoc1 = REcircResps(:,useStim,:);
        
        centerLoc = mean(xloc);
        useStim = find((LErfPhases(6,:,1,1) == centerLoc));
        LErfCenterLoc = LErfPhases(:,useStim,:,:);
        RErfCenterLoc = RErfPhases(:,useStim,:,:);
        
        useStim = find((LEcircResps(6,:,1) == centerLoc));
        LECircleCenterLoc = LEcircResps(:,useStim,:);
        RECircleCenterLoc = REcircResps(:,useStim,:);
        
        loc2 = max(xloc);
        useStim = find((LErfPhases(6,:,1,1) == loc2));
        LErfLoc2 = LErfPhases(:,useStim,:,:);
        RErfLoc2 = RErfPhases(:,useStim,:,:);
        
        useStim = find((LEcircResps(6,:,1) == loc2));
        LECircleLoc2 = LEcircResps(:,useStim,:);
        RECircleLoc2 = REcircResps(:,useStim,:);
    end
    %% Plot that shiz
    % plan is for each channel to have one figure per sf, size, and
    % location combination. Amplitudes will increase from left to right.
    % Each RF will have two rows, one for each phase.
    
    %     I dont' think this is going to work well. The best bet is probably to just make
    %     it so there's one loop per matrix dimension. Each dimension is a new figure,
    %     and subplots are each column within that dimension.
    
    cd '/Local/Users/bushnell/Dropbox/Figures/WU_Arrays/RF/V4/PSTH/phase'
    col2 = 1;
    % Plot RF data
    for xy = 1:numXloc
        if xy == 1
            % use location 1
            useREmtx  = RErfLoc1;
            useLEmtx  = LErfLoc1;
            
            useRECircleMtx  = RECircleLoc1;
            useLECircleMtx  = LECircleLoc1;
        elseif xy == 2
            % use center location
            useREmtx  = RErfCenterLoc;
            useLEmtx  = LErfCenterLoc;
            
            useRECircleMtx  = RECircleCenterLoc;
            useLECircleMtx  = LECircleCenterLoc;
        else
            % use location 2
            useREmtx  = RErfLoc2;
            useLEmtx  = LErfLoc2;
            
            useRECircleMtx  = RECircleLoc2;
            useLECircleMtx  = LECircleLoc2;
        end
        ymaxRE = max(useREmtx(8:end,:,:,:));
        ymaxRE = max(ymaxRE(:));
        ymaxLE = max(useLEmtx(8:end,:,:,:));
        ymaxLE = max(ymaxLE(:));
        ymax = max(ymaxRE, ymaxLE);
        
        for rf = 1:numRFs
            for ph = 1:2
                figure
                
                for col = 1:size(RErfLoc1,2)
                    subplot(6,4,col)
                    hold on
                    rectangle('position',[0 0 20 ymax],'FaceColor',[0.9,0.9,0.9],'EdgeColor',[0.9,0.9,0.9])
                    rectangle('position',[30 0 10 ymax],'FaceColor',[0.9,0.9,0.9],'EdgeColor',[0.9,0.9,0.9])
                    
                    plot(useREmtx(8:end,col,ph,rf),'r-')
                    plot(useLEmtx(8:end,col,ph,rf),'b-')
                        
                    plot(useRECircleMtx(8:end,col2),'m-')
                    plot(useLECircleMtx(8:end,col2),'c-')
                    
                    col2 = col2+1;
                    if col2 == 5
                        col2 = 1;
                    end

                    
                    plot(REblankResps,'k-')
                    ylim([0 ymax])
                    title(['amp',num2str(useREmtx(2,col)),' sf', num2str(useREmtx(4,col)),' rad',num2str(useREmtx(5,col))],'fontsize',9)
                    plot([20 20], [0 ymax],'k:')
                    plot([30 30], [0 ymax],'k:')
%                     title({['RF:', num2str(useREmtx(1,1,1,rf)), ' amp:',num2str(useREmtx(2,col)), ' ph:', num2str(useREmtx(3,1,ph,1))];...
%                         ['sf:', num2str(useREmtx(4,col)),' rad:',num2str(useREmtx(5,col)),' xloc:',num2str(useREmtx(6,col))]},'fontsize',9.5)
                    set(gca,'color','none','tickdir','out','box','off')

                    
                    if col == 1
                        topTitle = sprintf('Channel %d  RF %d  phase %.2f  location %d',ch,useREmtx(1,1,ph,rf),useREmtx(3,1,ph,1),xy);
                        annotation('textbox',...
                            [0.1 0.95 0.85 0.05],...
                            'LineStyle','none',...
                            'String',topTitle,...
                            'Interpreter','none',...
                            'FontSize',14,...
                            'FontAngle','italic',...
                            'FontName','Helvetica Neue');
                    end
                    %pause
                end
                figName = ['WU_stimPSTH_ch',num2str(ch),'_loc',num2str(xy),'_RF',num2str(rfs(rf)),'_phase',num2str(phase(ph)),'.pdf'];
                saveas(gcf,figName,'pdf')
            end
        end
    end
    
    %% plot the circle data
%     topTitle = sprintf('Channel %d circle',ch);
%     for xy = 1:numXloc
%         figure
%         if xy == 1
%             % use location 1
%             useREmtx  = RECircleLoc1;
%             useLEmtx  = LECircleLoc1;
%         elseif xy == 2
%             % use center location
%             useREmtx  = RECircleCenterLoc;
%             useLEmtx  = LECircleCenterLoc;
%         else
%             % use location 2
%             useREmtx  = RECircleLoc2;
%             useLEmtx  = LECircleLoc2;
%         end
%         ymaxRE = max(useREmtx(8:end,:));
%         ymaxRE = max(ymaxRE(:));
%         ymaxLE = max(useLEmtx(8:end,:));
%         ymaxLE = max(ymaxLE(:));
%         ymax = max(ymaxRE, ymaxLE);
%         for col = 1:size(RECircleLoc1,2)
%             
%             subplot(2,2,col)
%             hold on
%             plot(useREmtx(8:end,col),'r-')
%             plot(useLEmtx(8:end,col),'b-')
%             plot(REblankResps,'k-')
%             ylim([0 ymax])
%             title(['sf:', num2str(useREmtx(4,col)),' rad:',num2str(useREmtx(5,col)),' xloc:',num2str(useREmtx(6,col))],'fontsize',9.5)
%             set(gca,'color','none','tickdir','out','box','off')
%             
%             if col == 1
%                 annotation('textbox',...
%                     [0.1 0.95 0.85 0.05],...
%                     'LineStyle','none',...
%                     'String',topTitle,...
%                     'Interpreter','none',...
%                     'FontSize',14,...
%                     'FontAngle','italic',...
%                     'FontName','Helvetica Neue');
%             end
%         end
%         figName = ['WU_stimPSTH_circle_ch',num2str(ch),'_loc',num2str(xy),'.pdf'];
%         saveas(gcf,figName,'pdf')
%     end
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
