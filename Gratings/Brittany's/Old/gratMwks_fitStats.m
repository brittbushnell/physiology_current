% gratMwks_fitStats
%
%

clear all
close all
%clc
tic
%%
file = 'WU_Gratings_V4_withRF_goodCh_fit_T3';
newName = 'WU_Gratings_V4_withRF_prefStim';

% file = 'WU_Gratings_V1_withRF_goodCh_fit';
% newName = 'WU_Gratings_V1_withRF_prefStim';

%file = 'fit_WU_Gratings_V4_recut_surf_6days_1ch';

location = 2;
%%
load(file)

if strfind(file,'V1')
    array = 'V1';
else
    array = 'V4';
end
numChannels = size(LEdata.bins,3);

sfs = unique(LEdata.spatial_frequency);
sfs = (sfs(1,4:end));
logSFs = log10(sfs);

oris = unique(LEdata.rotation);
oris = oris(1,1:end-1);
%% Orientation
LEPrefOris = LEparams(:,2);
REPrefOris = REparams(:,2);
prefOris = [LEPrefOris'; REPrefOris'];

prefOris = mod(prefOris,360);

% Difference in preferences across eyes
for ch = 1:numChannels
    oriDiff(1,ch) = prefOris(ch,1) - prefOris(ch,1);
    oriDiff(1,ch) = mod(oriDiff(1,ch),180);
    
    % bandwidth
    LE_OriBan(1,ch) = vonmisesbandwidth_B(LEparams(ch,:));
    RE_OriBan(1,ch) = vonmisesbandwidth_B(REparams(ch,:));
    
    % paramOut(2) = mod(paramOut(2),360);  % this will make the number between 0 and 360
    % if paramOut(2) >180
    %     paramOut(2) = paramOut(2) - 180;
    % end
    
end
%% SF preferences
LEPrefSFs  = (LEparams(:,3));
REPrefSFs  = (REparams(:,3));
prefSFs = [LEPrefSFs'; REPrefSFs'];
for ch = 1:numChannels
    sfDiff(1,ch)  = LogDifference(REPrefSFs(ch),LEPrefSFs(ch));
end
%% plot preferred orientations
figure
subplot(1,2,1)
hold on
plot(oriDiff,'.b','MarkerSize',20)
xlabel('channel')
ylabel('AE-FE')
title(sprintf('Difference in ori preferences %s',array))

subplot(1,2,2)
hold on
semilogy(sfDiff,'.b','MarkerSize',20)
xlabel('channel')
ylabel('Log ration (AE/FE)')
title('Difference in SF preferences')

figure
subplot(1,2,1)
hold on
plot(LEPrefOris,REPrefOris,'ob')
xlabel('FE pref Ori')
ylabel('AE pref Ori')
axis square
xlim([0 180])
ylim([0 180])
set(gca,'TickDir','out','color','none')

title(sprintf('%s Ori comparisons',array))

subplot(1,2,2)
hold on
plot(LEPrefSFs,REPrefSFs,'ob')
xlabel('FE pref SF')
ylabel('AE pref SF')
axis square
xlim([0.01 100])
ylim([0.01 100])
set(gca,'TickDir','out','color','none','XScale','log','YScale','log')
title(sprintf('%s SF comparisons',array))
%%num2str(LErank)
%% plot errors
figure
subplot(1,2,1)
hold on
for ch = 1:numChannels
    if ~isempty(intersect(ch,LEdata.goodChannels))
        if ch == 5
            plot(ch,LEerror(5),'.b','MarkerSize',20)
        elseif ch == 12
            plot(ch,LEerror(12),'.','MarkerSize',20,'MarkerFaceColor',[0 0.7 0],'MarkerEdgeColor',[0 0.7 0])
        elseif ch == 67
            plot(ch,LEerror(67),'.k','MarkerSize',20)
        else
            plot(LEerror,'ob')
        end
    end
    if ~isempty(intersect(ch,REdata.goodChannels))
        if ch == 93
            plot(ch,REerror(93),'.m','MarkerSize',20)
        elseif ch == 92
            plot(ch,REerror(92),'.','MarkerSize',20,'MarkerFaceColor',[1 0.5 0],'MarkerEdgeColor',[1 0.5 0])
        elseif ch == 88
            plot(ch,REerror(88),'.','MarkerSize',20,'MarkerFaceColor',[0.7 0.7 0.7],'MarkerEdgeColor',[0.7 0.7 0.7])
        else
            plot(REerror,'or')
        end
    end
end
set(gca,'TickDir','out')
xlabel('channel')
ylabel('error')

subplot(1,2,2)
hold on
for ch = 1:numChannels
    if ~isempty(intersect(ch,LEdata.goodChannels))
        if ch == 5
            plot(ch,LEerror(5),'.b','MarkerSize',20)
        elseif ch == 12
            plot(ch,LEerror(12),'.','MarkerSize',20,'MarkerFaceColor',[0 0.7 0],'MarkerEdgeColor',[0 0.7 0])
        elseif ch == 67
            plot(ch,LEerror(67),'.k','MarkerSize',20)
        else
            plot(LEerror,'ob')
        end
    end
    if ~isempty(intersect(ch,REdata.goodChannels))
        if ch == 93
            plot(ch,REerror(93),'.m','MarkerSize',20)
        elseif ch == 92
            plot(ch,REerror(92),'.','MarkerSize',20,'MarkerFaceColor',[1 0.5 0],'MarkerEdgeColor',[1 0.5 0])
        elseif ch == 88
            plot(ch,REerror(88),'.','MarkerSize',20,'MarkerFaceColor',[0.7 0.7 0.7],'MarkerEdgeColor',[0.7 0.7 0.7])
        else
            plot(REerror,'or')
        end
    end
end
set(gca,'TickDir','out')
xlabel('channel')
ylabel('error')
ylim([0 100])