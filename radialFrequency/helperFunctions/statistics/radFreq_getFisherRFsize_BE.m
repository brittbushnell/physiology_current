function [REsigPerms, LEsigPerms, RECorrDiff, LEcorrDiff, REprefSize, LEprefSize, REcorrPerm, LEcorrPerm] = radFreq_getFisherRFsize_BE(REdata, LEdata,numBoot)
% This function should be called after running radFreq_getFisherLoc_BE to
% get the preferred location for each good channel. Looking at the
% preferred location, this function will find the preferred carrier Size (if there is one)
% for each RF.

% Brittany Bushnell 7/8/21
% numBoot = 1000;
%%
location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
        end
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/size/',LEdata.animal,LEdata.array);
        end
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
locPair = LEdata.locPair;
LEprefLoc = LEdata.prefLoc;
REprefLoc = REdata.prefLoc;

%(RF,ori,amp,sf,radius,location, ch)
REspikes = REdata.RFspikeCount;
REprefSize = nan(1,96);

LEspikes = LEdata.RFspikeCount;
LEprefSize = nan(1,96);

stimCorr = nan(2,96); %(eye, ch)
corrDiff = nan(2,96);

% define ranges for each option

amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 0:6;
sfTitles = [1 2 1 2];

spikeStart = 8;
%%
% close all
for ch = 1:96
    if REdata.goodCh(ch) || LEdata.goodCh(ch)
        %%
        ndx = 1;
        
        figure(4)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1), pos(2), 700, 300],'PaperOrientation','landscape')
        
        s = suptitle(sprintf('%s %s %s spike counts per amplitude mean radius x RF ch %d',REdata.animal, REdata.array, REdata.programID, ch));
        %     s.Position(2) = s.Position(2)+0.0272;
        
        % make dummy subplots to get correct dimensions of mygca. Otherwise it
        % throws an error if one eye isn't included when trying to redo the y
        % axis
        
        for foo = 1:4
            subplot(1,4,foo)
            mygca(1,foo) = gca;
            xlim([-0.5 7.5])
            axis square
            title(sprintf('mean radius %d%c',sfTitles(foo),char(176)),'FontSize',12,'FontWeight','normal','FontAngle','italic');
        end
        
        for ey = 1:2
            if ey == 1
                dataT = LEdata;
                scCh = LEspikes{ch};
            else
                dataT = REdata;
                scCh = REspikes{ch};
            end
            
            if dataT.goodCh(ch) == 1
                
                if ey == 1
                    locNdx = (scCh(6,:) == locPair(LEprefLoc(ch),1)) & (scCh(7,:) == locPair(LEprefLoc(ch),2));
                else
                    locNdx = (scCh(6,:) == locPair(REprefLoc(ch),1)) & (scCh(7,:) == locPair(REprefLoc(ch),2));
                end
                
                for sz = 1:2
                    muSc = nan(1,6);
                    %                 corrP = nan(3,2);
                    
                    noCircNdx = (scCh(1,:) < 32);
                    circNdx = (scCh(1,:) == 32);
                    
                    circSpikes = squeeze(scCh(spikeStart:end,locNdx & circNdx));
                    
                    circSpikes = reshape(circSpikes,[1,numel(circSpikes)]);
                    muCirc = (nanmean(circSpikes,'all'));
                    
                    for amp = 1:6
                        
                        amp48Ndx = (scCh(2,:) == amps48(amp) & (scCh(1,:) < 16));
                        amp16Ndx = (scCh(2,:) == amps16(amp)& (scCh(1,:) == 16));
                        sizeNdx = scCh(5,:) == sz;
                        
                        
                        stim48Spikes = squeeze(scCh(spikeStart:end,locNdx & amp48Ndx & noCircNdx & sizeNdx));
                        stim16Spikes = squeeze(scCh(spikeStart:end,locNdx & amp16Ndx & noCircNdx & sizeNdx));
                        
                        stimSpikes = [stim48Spikes, stim16Spikes];
                        
                        muStim = (nanmean(stimSpikes,'all'));
                        muSc(1,amp) = muStim - muCirc;
                        clear muStim
                    end %amplitude
                    
                    % get the correlation
                    muScSize = [0 muSc];
                    corMtx = corrcoef(xs,muScSize);
                    stimCorr(sz,ch) = corMtx(2);
                    %% plot mean spike counts as a function of amplitude.
                    
                    subplot(1,4,ndx);
                    hold on
                    
                    if contains(dataT.eye,'LE') || contains(dataT.eye,'FE')
                        plot(muScSize,'o-b')
                    else
                        plot(muScSize,'o-r')
                    end
                    
                    xlim([-0.5 7.5])
                    set(gca,'XTick',1:7,'XTickLabel',0:6,'tickdir','out','FontSize',10,'FontAngle','italic')
                    
                    mygca(1,ndx) = gca;
                    b = get(gca,'YLim');
                    yMaxs(ndx) = b(2);
                    yMins(ndx) = b(1);
                    
                    if ndx == 1
                        ylabel('Mean spike count')
                    end
                    xlabel('Amplitude')
                    
                    ndx = ndx+1;
                end %size
                clear muSc
                
                size1 = squeeze(stimCorr(1,ch));  size2 = squeeze(stimCorr(2,ch));
                corrDiff(ey,ch) = size1 - size2; % if it's negative, responses to the larger stimuli are higher
            end % goodCh
        end %eye
        
        minY = min(yMins);
        maxY = max(yMaxs);
        yLimits = ([minY maxY]);
        set(mygca,'YLim',yLimits);
        
        figName = [LEdata.animal,'_BE_',LEdata.array,'_',LEdata.programID,'_rotationPrefs_ch',num2str(ch),'.pdf'];
        print(gcf, figName,'-dpdf','-bestfit')
    end
end
%%
LEcorrDiff = corrDiff(1,:);
RECorrDiff = corrDiff(2,:);
[REsigPerms, LEsigPerms, REcorrPerm, LEcorrPerm] = radFreq_getFisherRFsize_perm(REdata, LEdata,numBoot, corrDiff);