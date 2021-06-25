function [REprefRFphase, LEprefRFphase] = radFreq_getFisherRFphase_BE(REdata, LEdata)
% This function should be called after running radFreq_getFisherLoc_BE to
% get the preferred location for each good channel. Looking at the
% preferred location, this function will find the preferred rotation (if there is one)
% for each RF.

% Brittany Bushnell 6/24/21

%%
location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/RFphase',LEdata.animal,LEdata.array);
    elseif contains(LEdata.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/RFphase',LEdata.animal,LEdata.array);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/RFphase',LEdata.animal,LEdata.array);
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/RFphase',LEdata.animal,LEdata.array);
    elseif contains(LEdata.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/RFphase',LEdata.animal,LEdata.array);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/RFphase',LEdata.animal,LEdata.array);
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
REprefRFphase = nan(3,2,96);

LEspikes = LEdata.RFspikeCount;
LEzTr = nan(3,2,96);
LEprefRFphase = nan(3,2,96);

REzPloc = nan(3, 2, 2, 2, 96);
LEzPloc = nan(3, 2, 2, 2, 96);

% subplot indices for each eye
LEsubs = [1,2,5,6,9,10];
REsubs = [3,4,7,8,11,12];

% define ranges for each option
rfs = [4,8,16];
phase4 = [0,45];
phase8 = [0 22.5];
phase16= [0 11.25];
amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 1:6;
%%
for ch = 1%:96
%     REzPloc(:,:,:,:,:,ch) = squeeze(REspikes{ch}(:,:,:,:,:,REprefLoc(ch)));
%     LEzPloc(:,:,:,:,:,ch) = squeeze(LEspikes{ch}(:,:,:,:,:,LEprefLoc(ch)));
%     
%     
    figure(1)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2), 600, 700])
    
    s = suptitle(sprintf('%s %s Fisher r to z ch %d',REdata.animal, REdata.array, ch));
    s.Position(2) = s.Position(2)+0.0272;
    % make dummy subplots to get correct dimensions of mygca. Otherwise it
    % throws an error if one eye isn't included when trying to redo the y
    % axis
    % if ch == 94
    %     keyboard
    % end
    for foo = 1:12
        subplot(3,4,foo)
        mygca(1,foo) = gca;
    end
    
    for ey = 1:2
        if ey == 1
            dataT = LEdata;
            scCh = LEspikes{ch};
            locNdx = (scCh(6,:) == locPair(LEprefLoc(ch),1)) & (scCh(7,:) == locPair(LEprefLoc(ch),2));
        else
            dataT = REdata;
            scCh = REspikes{ch};
            locNdx = (scCh(6,:) == locPair(REprefLoc(ch),1)) & (scCh(7,:) == locPair(REprefLoc(ch),2));
        end
        
        if dataT.goodCh(ch) == 1
            
            muSc = nan(3,2,6);
            corrP = nan(3,2);
            
            for rf = 1:3
                for ph = 1:2
                    
                    circNdx = (scCh(1,:) == 32);
                    rfNdx   = (scCh(1,:) == rfs(rf));
                    if rf == 1
                        phNdx = scCh(3,:) == phase4(ph);
                        ampRef = amps48;
                    elseif rf == 2
                        phNdx = scCh(3,:) == phase8(ph);
                        ampRef = amps48;
                    else
                        phNdx = scCh(3,:) == phase16(ph);
                        ampRef = amps16;
                    end
                    
                    for amp = 1:6
                        ampNdx = (scCh(2,:) == ampRef(amp));
                        
                        stimSpikes = squeeze(scCh(8:end,rfNdx & ampNdx & phNdx));
                        circSpikes = squeeze(scCh(8:end,locNdx & circNdx));
                        
                        muSc(rf,ph,amp) = (nanmean(stimSpikes,'all')) - (nanmean(circSpikes,'all'));
                    end %amplitude
                end %phase
            end %RF
        end % goodCh
    end %eye
end
