The discrimination here is between noise and contour (noise-1cont, noise-3cont, etc -- though you could modify it to discriminate between 1cont-3cont, 1cont-5cont, etc). So the variable of interest is element length (1, 3, 5, 7), and I compute it for each orientation (0, 45, 90, 135). 



I imagine for glass patterns, you would sub in dx for orientation, and density for number of contour elements? As always, lmk if there is anything confusing.





%% Linear classifier (EACH ORIENTATION).

% Reference: Shooner et al, 2015. 

oriAxis     = [0 45 90 135];
tStart      = 10;                    % Sum responses from 100 ms - 200 ms
tEnd        = 20;
t1          = size(R_fel.respAll{1},1);
t2          = size(R_fel.respNoise{1},1);
t3          = size(R_amb.respAll{1},1);
t4          = size(R_amb.respNoise{1},1);
nRep        = min([t1 t2 t3 t4]);       % annoyingly, there is not a consistent number of reps for each stimulus condition.
Xc_fel      = nan(nOri, nEl, nRep, nChan);
Xn_fel      = nan(nRep, nChan);
Xc_amb      = nan(nOri, nEl, nRep, nChan);
Xn_amb      = nan(nRep, nChan);
 
for iC = 1:nChan
    Xn_fel(:,iC)    = nansum(R_fel.respNoise{iC}(1:nRep,tStart:tEnd),2);   % Distribution of responses to blanks.
    Xn_amb(:,iC)    = nansum(R_amb.respNoise{iC}(1:nRep,tStart:tEnd),2);
    for iOri = 1:nOri
        for iEl = 1:nEl                                                    % Distribution of responses to stimulus conditions
            Xc_fel(iOri,iEl,:,iC)    = nansum(R_fel.respAll{iOri,iEl,iC}(1:nRep,tStart:tEnd),2);
            Xc_amb(iOri,iEl,:,iC)    = nansum(R_amb.respAll{iOri,iEl,iC}(1:nRep,tStart:tEnd),2);
        end
    end
end

dpSing_fel      = nan(nOri, nEl, nChan);          % Initialize arrays for ordering the channels by dprime.
dpSingSort_fel  = nan(nOri, nEl, nChan);
dpSingSortOrd_fel = nan(nOri, nEl, nChan);
dp_fel          = nan(nOri, nEl, nChan);
dpSing_amb      = nan(nOri, nEl, nChan);
dpSingSort_amb  = nan(nOri, nEl, nChan);
dpSingSortOrd_amb = nan(nOri, nEl, nChan);
dp_amb          = nan(nOri, nEl, nChan);

 
%%
% get dprimes
for iOri = 1:nOri
    for iEl = 1:nEl
        for iC = 1:nChan
            dpSing_fel(iOri,iEl,iC)  = discrim(Xn_fel(:,iC), squeeze(Xc_fel(iOri,iEl,:,iC)));
            dpSing_amb(iOri,iEl,iC)  = discrim(Xn_amb(:,iC), squeeze(Xc_amb(iOri,iEl,:,iC)));
            %figure; histogram(Xn_fel(:,iC)); hold on; histogram(Xc_fel(iEl,:,iC))
        end

        

        % Rank the channels by best dprime
        [~,dpSingSortOrd_fel(iOri,iEl,:)]    = sort(abs(dpSing_fel(iOri,iEl,:)),'descend','MissingPlacement','last');  % sort with NaNs at end
        dpSingSort_fel(iOri,iEl,:)           = dpSing_fel(iOri,iEl, dpSingSortOrd_fel(iOri,iEl,:));
        [~,dpSingSortOrd_amb(iOri,iEl,:)]    = sort(abs(dpSing_amb(iOri,iEl,:)),'descend','MissingPlacement','last');
        dpSingSort_amb(iOri,iEl,:)           = dpSing_amb(iOri,iEl, dpSingSortOrd_amb(iOri,iEl,:));

        for k = 1:nChan     % now, do discrimination with rank-ordered channels.
            X0                  = Xn_fel(:,dpSingSortOrd_fel(iOri,iEl,1:k));
            X1                  = squeeze(Xc_fel(iOri,iEl,:,dpSingSortOrd_fel(iOri,iEl,1:k)));
            dp_fel(iOri,iEl,k)  = discrim(X0,X1);
            
            X0                  = Xn_amb(:,dpSingSortOrd_amb(iOri,iEl,1:k));
            X1                  = squeeze(Xc_amb(iOri,iEl,:,dpSingSortOrd_amb(iOri,iEl,1:k)));
            dp_amb(iOri,iEl,k)  = discrim(X0,X1);
        end
    end
end

%% Plot LDA as function of number of channels

figure; hold on

pos         = get(gcf,'Position');

set(gcf,'Position',[pos(1) pos(2) 900 100])

for iOri = 1:nOri

    yax         = [0 10];

    nsubplot(nOri, 5, iOri, 1);

        scatter([1:nChan], dp_fel(iOri, 1,:), 'b')

        scatter([1:nChan], dp_amb(iOri, 1,:), 'r')

        xlim([1 nChan]); ylim(yax)

        ylabel(sprintf('%g deg', oriAxis(iOri)))

        if iOri==1; title('1 contour'); end

    nsubplot(nOri, 4, iOri, 2);

        scatter([1:nChan], dp_fel(iOri, 2,:), 'b')

        scatter([1:nChan], dp_amb(iOri, 2,:), 'r')

        xlim([1 nChan]); ylim(yax)

        if iOri==1; title('3 contour'); end

    nsubplot(nOri, 4, iOri, 3);

        scatter([1:nChan], dp_fel(iOri, 3,:), 'b')

        scatter([1:nChan], dp_amb(iOri, 3,:), 'r')

        xlim([1 nChan]); ylim(yax)

        if iOri==1; title('5 contour'); end

    nsubplot(nOri, 4, iOri, 4);

        scatter([1:nChan], dp_fel(iOri, 4,:), 'b')

        scatter([1:nChan], dp_amb(iOri, 4,:), 'r')

        xlim([1 nChan]); ylim(yax)

        if iOri==1; title('7 contour'); end

end

suptitle(sprintf('LDA: contour versus noise', oriAxis(iOri)))

%export_fig([figureDir 'LDA/' animalID '_contourInt_linDiscrim_byOri.pdf'])

 

% Plot the summary for each orientation

figure; hold on

pos         = get(gcf,'Position');

set(gcf,'Position',[pos(1) pos(2) 1100 300])

for iOri = 1:nOri

    nsubplot(1, 5, 1, iOri);

        scatter([1:4], dp_fel(iOri,:,96), 30, 'b')

        scatter([1:4], dp_amb(iOri,:,96), 30, 'r')

        plot([1:4], dp_fel(iOri,:,96), 'b')

        plot([1:4], dp_amb(iOri,:,96), 'r')

        xlim([0.5 4.5]); ylim([0 8]); axis square

        set(gca, 'XTick', [1:4], 'XTickLabel', [1 3 5 7]);

        xlabel('Number of contours')

        title(sprintf('%g deg', oriAxis(iOri)))

        if iOri == 1

            ylabel('dprime')

            legend({'FE', 'AE'})

        end

end

nsubplot(1, 5, 1, 5);

    scatter([1:4], nanmean(dp_fel(:,:,96),1), 30, 'b')

    scatter([1:4], nanmean(dp_amb(:,:,96),1), 30, 'r')

    plot([1:4], nanmean(dp_fel(:,:,96),1), 'b')

    plot([1:4], nanmean(dp_amb(:,:,96),1), 'r')

    xlim([0.5 4.5]); ylim([0 8]); axis square

    set(gca, 'XTick', [1:4], 'XTickLabel', [1 3 5 7]);

    xlabel('Number of contours')

    title('Average over oris')

suptitle('Maximum decoding for each orientation - versus noise')

%export_fig([figureDir 'LDA/' animalID '_contourInt_linDiscrim_summary_byOri.pdf'])