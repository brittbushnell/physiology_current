% function [REprefRFrot, LEprefRFrot] = radFreq_getFisherRFrot_BE(REdata, LEdata,plotEbar)
% This function should be called after running radFreq_getFisherLoc_BE to
% get the preferred location for each good channel. Looking at the
% preferred location, this function will find the preferred rotation (if there is one)
% for each RF.

% Brittany Bushnell 6/24/21
plotEbar = 0;
%%
location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/RFrot',LEdata.animal,LEdata.array);
    elseif contains(LEdata.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/RFrot',LEdata.animal,LEdata.array);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/RFrot',LEdata.animal,LEdata.array);
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/RFrot',LEdata.animal,LEdata.array);
    elseif contains(LEdata.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/RFrot',LEdata.animal,LEdata.array);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/RFrot',LEdata.animal,LEdata.array);
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
REzTr = nan(3,2,96);
REprefRot = nan(3,2,96);

LEspikes = LEdata.RFspikeCount;
LEzTr = nan(3,2,96);
LEprefRot = nan(3,2,96);

% REzPloc = nan(3, 2, 2, 2, 96);
% LEzPloc = nan(3, 2, 2, 2, 96);

% subplot indices for each eye
LEsubs = [1,2,5,6,9,10];
REsubs = [3,4,7,8,11,12];

% define ranges for each option
radfreqs = [4,8,16];
rot4 = [0 45];
rot8 = [0 22.5];
rot16= [0 11.25];
amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 0:6;
%%
close all
for ch = 1:10%:96
    figure %(1)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2), 600, 700])
    
    s = suptitle(sprintf('%s %s Fisher r to z ch %d',REdata.animal, REdata.array, ch));
    s.Position(2) = s.Position(2)+0.0272;
    
    % make dummy subplots to get correct dimensions of mygca. Otherwise it
    % throws an error if one eye isn't included when trying to redo the y
    % axis
    
    for foo = 1:12
        subplot(3,4,foo)
        mygca(1,foo) = gca;
        xlim([-0.5 7.5])
    end
    
    for ey = 1:2
        ndx = 1;
        if ey == 1
            dataT = LEdata;
            scCh = LEspikes{ch};
            subNdx = LEsubs;
        else
            dataT = REdata;
            scCh = REspikes{ch};
            subNdx = REsubs;
        end
        
        if dataT.goodCh(ch) == 1
            
            muSc = nan(3,2,6);
            corrP = nan(3,2,2); %RF, rotation, corr, significance
            
            if ey == 1
                locNdx = (scCh(6,:) == locPair(LEprefLoc(ch),1)) & (scCh(7,:) == locPair(LEprefLoc(ch),2));
            else
                locNdx = (scCh(6,:) == locPair(REprefLoc(ch),1)) & (scCh(7,:) == locPair(REprefLoc(ch),2));
            end
            
            for rf = 1:3
                for rot = 1:2
                    
                    sub = subNdx(ndx); % determines which subplot
                    circNdx = (scCh(1,:) == 32);
                    rfNdx   = (scCh(1,:) == radfreqs(rf));
                    
                    if rf == 1
                        rotNdx = scCh(3,:) == rot4(rot);
                        ampRef = amps48;
                    elseif rf == 2
                        rotNdx = scCh(3,:) == rot8(rot);
                        ampRef = amps48;
                    else
                        rotNdx = scCh(3,:) == rot16(rot);
                        ampRef = amps16;
                    end
                    
                    circSpikes = squeeze(scCh(8:end,locNdx & circNdx));
                    circSpikes = reshape(circSpikes,[1,numel(circSpikes)]);
                    cirErr = (std(circSpikes))/(sqrt(size(circSpikes,1)));
                    muCirc = (nanmean(circSpikes,'all'));
                    
                    for amp = 1:6
                        ampNdx = (scCh(2,:) == ampRef(amp));
                        
                        stimSpikes = squeeze(scCh(8:end,rfNdx & ampNdx & rotNdx & locNdx));
                        stimSpikes = reshape(stimSpikes,[1,numel(stimSpikes)]);
                        
                        muStim = (nanmean(stimSpikes,'all'));
                        muSc(rf,rot,amp) = muStim - muCirc;
                        stErr(rf,rot,amp) = (std(stimSpikes - circSpikes))/(sqrt(size(stimSpikes,1)));
                        clear muStim
                    end %amplitude
                    
                    % get the correlation and p-value
                    muSct = squeeze(muSc(rf,rot,:));
                    muScRFrot = [0; muSct];
                    [corMtx,corPmtx] = corrcoef(xs,muScRFrot);
                    sCorr = corMtx(2);
                    corrP(rf,rot,1) = corPmtx(2);
                    
                    % make a logical for whether or not the correlation is
                    % significant. This is just to make it easier to determine if
                    % there are more than one  significant locations and if I need
                    % to use the max response to pick preferred location
                    if corrP(rf,rot,1) <= 0.05
                        corrP(rf,rot,2) = 1;
                    else
                        corrP(rf,rot,2) = 0;
                    end
                    
                    % get the Fisher r to z transform
                    if ey == 1
                        zCh = atanh(sCorr);
                        LEzTr(rf,rot,ch) = zCh;
                    else
                        zCh = atanh(sCorr);
                        REzTr(rf,rot,ch) = zCh;
                    end
                    
                    % plot mean spike counts as a function of amplitude.
                    
                    h = subplot(3,4,sub);
                    hold on
                    errT = squeeze(stErr(rf,rot,:));
                    eBar = [cirErr;errT]; 
%                     clear
                    if contains(dataT.eye,'LE') || contains(dataT.eye,'FE')
                        plot(muScRFrot,'o-b')
                        if plotEbar == 1
                        errorbar(1:7,muScRFrot,eBar,'b')
                        end
                    else
                        plot(muScRFrot,'o-r')
                        if plotEbar == 1
                        errorbar(1:7,muScRFrot,eBar,'r')
                        end
                    end
                    
                    xlim([-0.5 7.5])
                    title(sprintf('r %.2f z %.2f', sCorr, zCh), 'FontSize',12,'FontWeight','normal');
                    
                    set(gca,'XTick',1:7,'XTickLabel',0:6,'tickdir','out','FontSize',10,'FontAngle','italic')
                    
                    mygca(1,sub) = gca;
                    b = get(gca,'YLim');
                    yMaxs(sub) = b(2);
                    yMins(sub) = b(1);
                    
                    if sub == 1
                        lbl = text(-4,(b(1)+b(2))/2,'RF 4','FontWeight','bold','FontSize',12);
                        lbl.Rotation = 90;
                        ylabel('Mean spike count')
                    elseif sub == 5
                        lbl = text(-4,(b(1)+b(2))/2,'RF 8','FontWeight','bold','FontSize',12);
                        lbl.Rotation = 90;
                        ylabel('Mean spike count')
                    elseif sub == 9
                        lbl = text(-4,(b(1)+b(2))/2,'RF 16','FontWeight','bold','FontSize',12);
                        lbl.Rotation = 90;
                        ylabel('Mean spike count')
                        xlabel('Amplitude')
                    end
                    
                    ndx = ndx+1;
                end %rot
                
                scTmp = squeeze(muSc(rf,:,:));
                if sum(corrP(rf,:,2)) == 1
                    prpt = find(corrP(rf,:,2) == 1);
                elseif sum(corrP(rf,:,2)) > 1
                    [~,mxNdx] = max(scTmp,[],'all','linear');
                    [prpt,~] = ind2sub(size(scTmp),mxNdx);
                elseif sum(corrP(rf,:,2)) == 0
                    [~,mxNdx] = max(muSc,[],'all','linear');
                    [prpt,~] = ind2sub(size(muSc),mxNdx);
                end
                
                if ey == 1
                    LEprefRot(rf,ch) = prpt;
                else
                    REprefRot(rf,ch) = prpt; 
                end
                
                if prpt == 1
                    subplot(3,4,subNdx(ndx-2))
                    hold on
                    text(6,0,'*','FontSize',22,'FontWeight','bold')
                elseif prpt == 2
                    subplot(3,4,sub)
                    hold on
                    text(6,0,'*','FontSize',22,'FontWeight','bold')
                end
            end %RF
            
        end % goodCh
    end %eye
    minY = min(yMins);
    maxY = max(yMaxs);
    yLimits = ([minY maxY]);
    set(mygca,'YLim',yLimits);
end
