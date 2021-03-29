function GlassCohCorrStats(V1data, V4data)

% Steps for each channel that's good and in stim:
% 1) find preferred dt,dx at 100%
% 1) corirelation of d' and coherence
% 2) determine what channels have significant r values
% 3) repeat for all three stimuli, and for each oriientation
% 4) plot d' as a function of coherence, each channel on a separate figure
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassCombo/coh/',V1data.conRadRE.animal);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassCombo/coh/',V1data.conRadRE.animal);
end
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% get preferred dt,dx
conDLEV4 = abs(squeeze(V4data.conRadLE.conNoiseDprime(end,:,:,:)));
cDpLEV4 = squeeze([squeeze(conDLEV4(1,1,:)),squeeze(conDLEV4(1,2,:)),squeeze(conDLEV4(2,1,:)),squeeze(conDLEV4(2,2,:))]);
[~,conDtDxPrefLEV4] = max(cDpLEV4,[],2);

radDLEV4 = abs(squeeze(V4data.conRadLE.radNoiseDprime(end,:,:,:)));
rDpLEV4 = squeeze([squeeze(radDLEV4(1,1,:)),squeeze(radDLEV4(1,2,:)),squeeze(radDLEV4(2,1,:)),squeeze(radDLEV4(2,2,:))]);
[~,radDtDxPrefLEV4] = max(rDpLEV4,[],2);

for o = 1:4
    trDLEV4 = abs(squeeze(V4data.trLE.linNoiseDprime(o,end,:,:,:)));
    trDpLEV4 = squeeze([squeeze(trDLEV4(1,1,:)),squeeze(trDLEV4(1,2,:)),squeeze(trDLEV4(2,1,:)),squeeze(trDLEV4(2,2,:))]);
    [~,trDtDxPrefLEV4(:,o)] = max(trDpLEV4,[],2);
end
%% RE V4

conDREV4 = abs(squeeze(V4data.conRadRE.conNoiseDprime(end,:,:,:)));
cDpREV4 = squeeze([squeeze(conDREV4(1,1,:)),squeeze(conDREV4(1,2,:)),squeeze(conDREV4(2,1,:)),squeeze(conDREV4(2,2,:))]);
[~,conDtDxPrefREV4] = max(cDpREV4,[],2);

radDREV4 = abs(squeeze(V4data.conRadRE.radNoiseDprime(end,:,:,:)));
rDpREV4 = squeeze([squeeze(radDREV4(1,1,:)),squeeze(radDREV4(1,2,:)),squeeze(radDREV4(2,1,:)),squeeze(radDREV4(2,2,:))]);
[~,radDtDxPrefREV4] = max(rDpREV4,[],2);

for o = 1:4
    trDREV4 = abs(squeeze(V4data.trRE.linNoiseDprime(o,end,:,:,:)));
    trDpREV4 = squeeze([squeeze(trDREV4(1,1,:)),squeeze(trDREV4(1,2,:)),squeeze(trDREV4(2,1,:)),squeeze(trDREV4(2,2,:))]);
    [~,trDtDxPrefREV4(:,o)] = max(trDpREV4,[],2);
end
%% LE V1

conDLEV1 = abs(squeeze(V1data.conRadLE.conNoiseDprime(end,:,:,:)));
cDpLEV1 = squeeze([squeeze(conDLEV1(1,1,:)),squeeze(conDLEV1(1,2,:)),squeeze(conDLEV1(2,1,:)),squeeze(conDLEV1(2,2,:))]);
[~,conDtDxPrefLEV1] = max(cDpLEV1,[],2);

radDLEV1 = abs(squeeze(V1data.conRadLE.radNoiseDprime(end,:,:,:)));
rDpLEV1 = squeeze([squeeze(radDLEV1(1,1,:)),squeeze(radDLEV1(1,2,:)),squeeze(radDLEV1(2,1,:)),squeeze(radDLEV1(2,2,:))]);
[~,radDtDxPrefLEV1] = max(rDpLEV1,[],2);

for o = 1:4
    trDLEV1 = abs(squeeze(V1data.trLE.linNoiseDprime(o,end,:,:,:)));
    trDpLEV1 = squeeze([squeeze(trDLEV1(1,1,:)),squeeze(trDLEV1(1,2,:)),squeeze(trDLEV1(2,1,:)),squeeze(trDLEV1(2,2,:))]);
    [~,trDtDxPrefLEV1(:,o)] = max(trDpLEV1,[],2);
end
%% RE V1

conDREV1 = abs(squeeze(V1data.conRadRE.conNoiseDprime(end,:,:,:)));
cDpREV1 = squeeze([squeeze(conDREV1(1,1,:)),squeeze(conDREV1(1,2,:)),squeeze(conDREV1(2,1,:)),squeeze(conDREV1(2,2,:))]);
[~,conDtDxPrefREV1] = max(cDpREV1,[],2);

radDREV1 = abs(squeeze(V1data.conRadRE.radNoiseDprime(end,:,:,:)));
rDpREV1 = squeeze([squeeze(radDREV1(1,1,:)),squeeze(radDREV1(1,2,:)),squeeze(radDREV1(2,1,:)),squeeze(radDREV1(2,2,:))]);
[~,radDtDxPrefREV1] = max(rDpREV1,[],2);

for o = 1:4
    trDREV1 = abs(squeeze(V1data.trRE.linNoiseDprime(o,end,:,:,:)));
    trDpREV1 = squeeze([squeeze(trDREV1(1,1,:)),squeeze(trDREV1(1,2,:)),squeeze(trDREV1(2,1,:)),squeeze(trDREV1(2,2,:))]);
    [~,trDtDxPrefREV1(:,o)] = max(trDpREV1,[],2);
end
%% get the d'x coh for that dt,dx for each pattern
% this way we can leave the first value as 0 to anchori the corirelations.
cohs = [0,25,50,75,100];
cmapOri = brewermap(9,'Blues');
cmapOri = flipud(cmapOri);
conDp = zeros(5,1);
radDp = zeros(5,1);
trDp = zeros(5,1);

REv1conSig = 0;
REv1radSig = 0;
REv1sig0 = 0;
REv1sig45 = 0;
REv1sig90 = 0;
REv1sig135 = 0;

LEv1conSig = 0;
LEv1radSig = 0;
LEv1sig0 = 0;
LEv1sig45 = 0;
LEv1sig90 = 0;
LEv1sig135 = 0;

REv4conSig = 0;
REv4radSig = 0;
REv4sig0 = 0;
REv4sig45 = 0;
REv4sig90 = 0;
REv4sig135 = 0;

LEv4conSig = 0;
LEv4radSig = 0;
LEv4sig0 = 0;
LEv4sig45 = 0;
LEv4sig90 = 0;
LEv4sig135 = 0;
%%
inclConRadLEV1 = (V1data.conRadLE.goodCh == 1) & (V1data.conRadLE.inStim == 1);
incltrLEV1 = (V1data.trLE.goodCh == 1) & (V1data.trLE.inStim == 1);

inclConRadREV1 = (V1data.conRadRE.goodCh == 1) & (V1data.conRadRE.inStim == 1);
incltrREV1 = (V1data.trRE.goodCh == 1) & (V1data.trRE.inStim == 1);

inclConRadLEV4 = (V4data.conRadLE.goodCh == 1) & (V4data.conRadLE.inStim == 1);
incltrLEV4 = (V4data.trLE.goodCh == 1) & (V4data.trLE.inStim == 1);

inclConRadREV4 = (V4data.conRadRE.goodCh == 1) & (V4data.conRadRE.inStim == 1);
incltrREV4 = (V4data.trRE.goodCh == 1) & (V4data.trRE.inStim == 1);
%%
for ch = 1:96
    chSig = 0;
    figure(1)
    clf
    hold on
    s = suptitle(sprintf('%s coherence responses ch %d',V4data.conRadLE.animal,ch));
    s.Position(2) = s.Position(2)+0.025;
    s.FontSize = 18;
    
    subplot(2,2,1)
    if contains(V4data.trLE.animal,'WV')
        ylim([-1.5, 1.5])
    else
        ylim([-2.5, 2.5])
    end
    hold on
    
    if inclConRadLEV1(ch)
        if conDtDxPrefLEV1(ch) == 1
            conDp(2:end) = squeeze(V1data.conRadLE.conNoiseDprime(:,1,1,ch));
        elseif conDtDxPrefLEV1(ch) == 2
            conDp(2:end) = squeeze(V1data.conRadLE.conNoiseDprime(:,1,2,ch));
        elseif conDtDxPrefLEV1(ch) == 3
            conDp(2:end) = squeeze(V1data.conRadLE.conNoiseDprime(:,2,1,ch));
        else
            conDp(2:end) = squeeze(V1data.conRadLE.conNoiseDprime(:,2,2,ch));
        end
        [~,cT] = corrcoef(conDp,cohs','Alpha',0.01);
        cPv = cT(2);
        if round(cPv,2) <=0.05
            plot(cohs, conDp, 'o-','color',[0.7 0 0.7],'LineWidth',1.2)
            LEv1conSig = LEv1conSig +1;
            chSig = chSig+1;
        else
            plot(cohs, conDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
        end
        
        if radDtDxPrefLEV1(ch) == 1
            radDp(2:end) = squeeze(V1data.conRadLE.radNoiseDprime(:,1,1,ch));
        elseif radDtDxPrefLEV1(ch) == 2
            radDp(2:end) = squeeze(V1data.conRadLE.radNoiseDprime(:,1,2,ch));
        elseif radDtDxPrefLEV1(ch) == 3
            radDp(2:end) = squeeze(V1data.conRadLE.radNoiseDprime(:,2,1,ch));
        else
            radDp(2:end) = squeeze(V1data.conRadLE.radNoiseDprime(:,2,2,ch));
        end
        [~,rT] = corrcoef(radDp,cohs','Alpha',0.01);
        rPv = rT(2);
        if round(rPv,2) <=0.05
            plot(cohs, radDp, 'o-','color',[0 0.6 0.2],'LineWidth',1.2)
            LEv1radSig = LEv1radSig+1;
            chSig = chSig+1;
        else
            plot(cohs, radDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
        end
    end
    if incltrLEV1(ch)
        for ori = 1:4
            if trDtDxPrefLEV1(ch,ori) == 1
                trDp(2:end) = squeeze(V1data.trLE.linNoiseDprime(ori,:,1,1,ch));
            elseif trDtDxPrefLEV1(ch,ori) == 2
                trDp(2:end) = squeeze(V1data.trLE.linNoiseDprime(ori,:,1,2,ch));
            elseif trDtDxPrefLEV1(ch,ori) == 3
                trDp(2:end) = squeeze(V1data.trLE.linNoiseDprime(ori,:,2,1,ch));
            else
                trDp(2:end) = squeeze(V1data.trLE.linNoiseDprime(ori,:,2,2,ch));
            end
            [~,trT] = corrcoef(trDp,cohs','Alpha',0.01);
            trPv = trT(2);
            if round(trPv,2) <= 0.05
                plot(cohs, trDp, 'o-','color',cmapOri(ori,:),'LineWidth',1.2)
                if ori == 1
                    LEv1sig0 = LEv1sig0+1;
                elseif ori == 2
                    LEv1sig45 = LEv1sig45+1;
                elseif ori == 3
                    LEv1sig90 = LEv1sig90+1;
                else
                    LEv1sig135 = LEv1sig135+1;
                end
                chSig = chSig+1;
            else
                plot(cohs, trDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
            end
        end
    end
    
    title('FE')
    set(gca,'tickdir','out','box','off','XTick',0:25:100)
    axis square
    clear trPv; clear rPv; clear cPv; clear trT; clear cT; clear rT; trDp = zeros(5,1);
  
    subplot(2,2,2)
    if contains(V4data.trLE.animal,'WV')
        ylim([-1.5, 1.5])
    else
        ylim([-2.5, 2.5])
    end
    hold on
    
    if inclConRadREV1(ch)
        if conDtDxPrefREV1(ch) == 1
            conDp(2:end) = squeeze(V1data.conRadRE.conNoiseDprime(:,1,1,ch));
        elseif conDtDxPrefREV1(ch) == 2
            conDp(2:end) = squeeze(V1data.conRadRE.conNoiseDprime(:,1,2,ch));
        elseif conDtDxPrefREV1(ch) == 3
            conDp(2:end) = squeeze(V1data.conRadRE.conNoiseDprime(:,2,1,ch));
        else
            conDp(2:end) = squeeze(V1data.conRadRE.conNoiseDprime(:,2,2,ch));
        end
        [~,cT] = corrcoef(conDp,cohs','Alpha',0.01);
        cPv = cT(2);
        if round(cPv,2) <=0.05
            plot(cohs, conDp, 'o-','color',[0.7 0 0.7],'LineWidth',1.2)
            REv1conSig = REv1conSig+1;
            chSig = chSig+1;
        else
            plot(cohs, conDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
        end
        
        if radDtDxPrefREV1(ch) == 1
            radDp(2:end) = squeeze(V1data.conRadRE.radNoiseDprime(:,1,1,ch));
        elseif radDtDxPrefREV1(ch) == 2
            radDp(2:end) = squeeze(V1data.conRadRE.radNoiseDprime(:,1,2,ch));
        elseif radDtDxPrefREV1(ch) == 3
            radDp(2:end) = squeeze(V1data.conRadRE.radNoiseDprime(:,2,1,ch));
        else
            radDp(2:end) = squeeze(V1data.conRadRE.radNoiseDprime(:,2,2,ch));
        end
        [~,rT] = corrcoef(radDp,cohs','Alpha',0.01);
        rPv = rT(2);
        if round(rPv,2) <=0.05
            plot(cohs, radDp, 'o-','color',[0 0.6 0.2],'LineWidth',1.2)
            REv1radSig = REv1radSig+1;
            chSig = chSig+1;
        else
            plot(cohs, radDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
        end
    end
    if incltrREV1(ch)
        for ori = 1:4
            if trDtDxPrefREV1(ch,ori) == 1
                trDp(2:end) = squeeze(V1data.trRE.linNoiseDprime(ori,:,1,1,ch));
            elseif trDtDxPrefREV1(ch,ori) == 2
                trDp(2:end) = squeeze(V1data.trRE.linNoiseDprime(ori,:,1,2,ch));
            elseif trDtDxPrefREV1(ch,ori) == 3
                trDp(2:end) = squeeze(V1data.trRE.linNoiseDprime(ori,:,2,1,ch));
            else
                trDp(2:end) = squeeze(V1data.trRE.linNoiseDprime(ori,:,2,2,ch));
            end
            [~,trT] = corrcoef(trDp,cohs','Alpha',0.01);
            trPv = trT(2);
            if round(trPv,2) <= 0.05
                plot(cohs, trDp, 'o-','color',cmapOri(ori,:),'LineWidth',1.2)
                if ori == 1
                    REv1sig0 = REv1sig0+1;
                elseif ori == 2
                    REv1sig45 = REv1sig45+1;
                elseif ori == 3
                    REv1sig90 = REv1sig90+1;
                else
                    REv1sig135 = REv1sig135+1;
                end
                chSig = chSig+1;
            else
                plot(cohs, trDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
            end
        end
    end
    
    title('AE')
    set(gca,'tickdir','out','box','off','XTick',0:25:100)
    axis square
    clear trPv; clear rPv; clear cPv; clear trT; clear cT; clear rT; trDp = zeros(5,1);
    
    subplot(2,2,3)
    hold on
    
    if contains(V4data.trLE.animal,'WV')
        ylim([-1.5, 1.5])
    else
        ylim([-2.5, 2.5])
    end
    
    if inclConRadLEV4(ch)
        if conDtDxPrefLEV4(ch) == 1
            conDp(2:end) = squeeze(V4data.conRadLE.conNoiseDprime(:,1,1,ch));
        elseif conDtDxPrefLEV4(ch) == 2
            conDp(2:end) = squeeze(V4data.conRadLE.conNoiseDprime(:,1,2,ch));
        elseif conDtDxPrefLEV4(ch) == 3
            conDp(2:end) = squeeze(V4data.conRadLE.conNoiseDprime(:,2,1,ch));
        else
            conDp(2:end) = squeeze(V4data.conRadLE.conNoiseDprime(:,2,2,ch));
        end
        [~,cT] = corrcoef(conDp,cohs','Alpha',0.01);
        cPv = cT(2);
        if round(cPv,2) <=0.05
            plot(cohs, conDp, 'o-','color',[0.7 0 0.7],'LineWidth',1.2)
            LEv4conSig = LEv4conSig+1;
            chSig = chSig+1;
        else
            plot(cohs, conDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
        end
        
        if radDtDxPrefLEV4(ch) == 1
            radDp(2:end) = squeeze(V4data.conRadLE.radNoiseDprime(:,1,1,ch));
        elseif radDtDxPrefLEV4(ch) == 2
            radDp(2:end) = squeeze(V4data.conRadLE.radNoiseDprime(:,1,2,ch));
        elseif radDtDxPrefLEV4(ch) == 3
            radDp(2:end) = squeeze(V4data.conRadLE.radNoiseDprime(:,2,1,ch));
        else
            radDp(2:end) = squeeze(V4data.conRadLE.radNoiseDprime(:,2,2,ch));
        end
        [~,rT] = corrcoef(radDp,cohs','Alpha',0.01);
        rPv = rT(2);
        if round(rPv,2) <=0.05
            plot(cohs, radDp, 'o-','color',[0 0.6 0.2],'LineWidth',1.2);
            LEv4radSig = LEv4radSig +1;
            chSig = chSig+1;
        else
            plot(cohs, radDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35);
        end
    end
    if incltrLEV4(ch)
        for ori = 1:4
            if trDtDxPrefLEV4(ch,ori) == 1
                trDp(2:end) = squeeze(V4data.trLE.linNoiseDprime(ori,:,1,1,ch));
            elseif trDtDxPrefLEV4(ch,ori) == 2
                trDp(2:end) = squeeze(V4data.trLE.linNoiseDprime(ori,:,1,2,ch));
            elseif trDtDxPrefLEV4(ch,ori) == 3
                trDp(2:end) = squeeze(V4data.trLE.linNoiseDprime(ori,:,2,1,ch));
            else
                trDp(2:end) = squeeze(V4data.trLE.linNoiseDprime(ori,:,2,2,ch));
            end
            [~,trP] = corrcoef(trDp,cohs','Alpha',0.01);
            trPv = trP(2);
            if round(trPv,2) <= 0.05
                plot(cohs, trDp, 'o-','color',cmapOri(ori,:),'LineWidth',1.2)
                if ori == 1
                    LEv4sig0 = LEv4sig0+1;
                elseif ori == 2
                    LEv4sig45 = LEv4sig45+1;
                elseif ori == 3
                    LEv4sig90 = LEv4sig90+1;
                else
                    LEv4sig135 = LEv4sig135+1;
                end
                chSig = chSig+1;
            else
                plot(cohs, trDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
            end
        end
    end
    
    title('FE')
    set(gca,'tickdir','out','box','off','XTick',0:25:100)
    axis square
    clear trPv; clear rPv; clear cPv; clear trT; clear cT; clear rT; trDp = zeros(5,1);
    
    subplot(2,2,4)
    if contains(V4data.trLE.animal,'WV')
        ylim([-1.5, 1.5])
    else
        ylim([-2.5, 2.5])
    end
    hold on
    
    if inclConRadREV4(ch)
        if conDtDxPrefREV4(ch) == 1
            conDp(2:end) = squeeze(V4data.conRadRE.conNoiseDprime(:,1,1,ch));
        elseif conDtDxPrefREV4(ch) == 2
            conDp(2:end) = squeeze(V4data.conRadRE.conNoiseDprime(:,1,2,ch));
        elseif conDtDxPrefREV4(ch) == 3
            conDp(2:end) = squeeze(V4data.conRadRE.conNoiseDprime(:,2,1,ch));
        else
            conDp(2:end) = squeeze(V4data.conRadRE.conNoiseDprime(:,2,2,ch));
        end
        [~,cT] = corrcoef(conDp,cohs','Alpha',0.01);
        cPv = cT(2);
        if round(cPv,2) <=0.05
            plot(cohs, conDp, 'o-','color',[0.7 0 0.7],'LineWidth',1.2)
            REv4conSig = REv4conSig +1;
            chSig = chSig+1;
        else
            plot(cohs, conDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
        end
        
        if radDtDxPrefREV4(ch) == 1
            radDp(2:end) = squeeze(V4data.conRadRE.radNoiseDprime(:,1,1,ch));
        elseif radDtDxPrefREV4(ch) == 2
            radDp(2:end) = squeeze(V4data.conRadRE.radNoiseDprime(:,1,2,ch));
        elseif radDtDxPrefREV4(ch) == 3
            radDp(2:end) = squeeze(V4data.conRadRE.radNoiseDprime(:,2,1,ch));
        else
            radDp(2:end) = squeeze(V4data.conRadRE.radNoiseDprime(:,2,2,ch));
        end
        [~,rT] = corrcoef(radDp,cohs','Alpha',0.01);
        rPv = rT(2);
        if round(rPv,2) <=0.05
            plot(cohs, radDp, 'o-','color',[0 0.6 0.2],'LineWidth',1.2)
            REv4radSig = REv4radSig+1;
            chSig = chSig+1;
        else
            plot(cohs, radDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
        end
    end
    if incltrREV4(ch)
        for ori = 1:4
            if trDtDxPrefREV4(ch,ori) == 1
                trDp(2:end) = squeeze(V4data.trRE.linNoiseDprime(ori,:,1,1,ch));
            elseif trDtDxPrefREV4(ch,ori) == 2
                trDp(2:end) = squeeze(V4data.trRE.linNoiseDprime(ori,:,1,2,ch));
            elseif trDtDxPrefREV4(ch,ori) == 3
                trDp(2:end) = squeeze(V4data.trRE.linNoiseDprime(ori,:,2,1,ch));
            else
                trDp(2:end) = squeeze(V4data.trRE.linNoiseDprime(ori,:,2,2,ch));
            end
            [~,trP] = corrcoef(trDp,cohs','Alpha',0.01);
            trPv = trP(2);
            if round(trPv,2) <= 0.05
                plot(cohs, trDp, 'o-','color',cmapOri(ori,:),'LineWidth',1.2)
                if ori == 1
                    REv4sig0 = REv4sig0+1;
                elseif ori == 2
                    REv4sig45 = REv4sig45+1;
                elseif ori == 3
                    REv4sig90 = REv4sig90+1;
                else
                    REv4sig135 = REv4sig135+1;
                end
                chSig = chSig+1;
            else
                plot(cohs, trDp, 'o-','color',[0.65 0.65 0.65],'LineWidth',0.35)
            end
        end
    end
    title('AE')
    set(gca,'tickdir','out','box','off','XTick',0:25:100)
    axis square
    clear trPv; clear rPv; clear cPv; clear trT; clear cT; clear rT; trDp = zeros(5,1); 
    %%
    if contains(V4data.trLE.animal,'WV')
        ymax = 1.5;
        trTxt = 1.4;
        crTxt = 1.2;
        txty = -2.2;
    else
        ymax = 2.5;
        trTxt = 2.4;
        crTxt = 2.1;
        txty = -3.65;
    end
    
    subplot(2,2,1)
    if incltrLEV1(ch) == 0
        text(1,trTxt,'translational didn''t pass inclusion')
    end
    if inclConRadLEV1(ch) == 0
        text(1,crTxt,'con/rad didn''t pass inclusion')
    end
    xlim([0 100])
    ylabel('d''')
    text(-35, 0,'V1','FontSize',18)
    
    subplot(2,2,2)
    if incltrREV1(ch) == 0
        text(1,trTxt,'translational didn''t pass inclusion')
    end
    if inclConRadREV1(ch) == 0
        text(1,crTxt,'con/rad didn''t pass inclusion')
    end
    xlim([0 100])
    
    subplot(2,2,3)
    if incltrLEV4(ch) == 0
        text(1,trTxt,'translational didn''t pass inclusion')
    end
    if inclConRadLEV4(ch) == 0
        text(1,crTxt,'con/rad didn''t pass inclusion')
    end
    xlim([0 100])
    ylabel('d''')
    xlabel('% coherence')
    text(-35, 0,'V4','FontSize',18)
    
    text(30, txty,'Concentric','color',[0.7 0 0.7],'FontSize',12,'FontWeight','bold')
    text(70, txty,'Radial','color',[0 0.6 0.2],'FontSize',12,'FontWeight','bold')
    text(100,txty,sprintf('0%c',char(176)),'color',cmapOri(1,:),'FontSize',12,'FontWeight','bold')
    text(125,txty,sprintf('45%c',char(176)),'color',cmapOri(2,:),'FontSize',12,'FontWeight','bold')
    text(150,txty,sprintf('90%c',char(176)),'color',cmapOri(3,:),'FontSize',12,'FontWeight','bold')
    text(175,txty,sprintf('135%c',char(176)),'color',cmapOri(4,:),'FontSize',12,'FontWeight','bold')
    
    subplot(2,2,4)
    if incltrREV4(ch) == 0
        text(1,trTxt,'translational didn''t pass inclusion')
    end
    if inclConRadREV4(ch) == 0
        text(1,crTxt,'con/rad didn''t pass inclusion')
    end
    xlabel('% coherence')
    xlim([0 100])
    
    %     pause
    figName = [V4data.conRadRE.animal,'sigCohPlotsAllCurves_ch',num2str(ch),'.pdf'];
    if chSig >1
        cd sigChs
        print(gcf, figName,'-dpdf','-bestfit')
        cd ../
    else
        print(gcf, figName,'-dpdf','-bestfit')
    end
end
%%
cd sigChs

figure(2)
clf
hold on
suptitle(sprintf('%s number of significant coherences per area by stimulus',V4data.trLE.animal))
ylim([-1 1])
xlim([-1 1])

set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin','XTickLabel',[],'YTickLabel',[])

% LE V1
text(-0.8, 0.95,'LE V1','FontSize',14,'FontWeight','bold')
text(-0.8,0.8,sprintf('Con = %d ',LEv1conSig),'color',[0.7 0 0.7],'FontSize',12,'FontWeight','bold')
text(-0.8,0.68,sprintf('Rad = %d ',LEv1radSig),'color',[0 0.6 0.2],'FontSize',12,'FontWeight','bold')
text(-0.8,0.56,sprintf('0%c  =  %d ',char(176),LEv1sig0),'color',cmapOri(1,:),'FontSize',12,'FontWeight','bold')
text(-0.8,0.44,sprintf('45%c = %d ',char(176),LEv1sig45),'color',cmapOri(2,:),'FontSize',12,'FontWeight','bold')
text(-0.8,0.32,sprintf('90%c = %d ',char(176),LEv1sig90),'color',cmapOri(3,:),'FontSize',12,'FontWeight','bold')
text(-0.8,0.2,sprintf('135%c = %d ',char(176),LEv1sig135),'color',cmapOri(4,:),'FontSize',12,'FontWeight','bold')

% LE V4
text(-0.8, -0.1,'LE V4','FontSize',14,'FontWeight','bold')
text(-0.8,-0.2,sprintf('Con = %d ',LEv4conSig),'color',[0.7 0 0.7],'FontSize',12,'FontWeight','bold')
text(-0.8,-0.32,sprintf('Rad = %d ',LEv4radSig),'color',[0 0.6 0.2],'FontSize',12,'FontWeight','bold')
text(-0.8,-0.44,sprintf('0%c  =  %d ',char(176),LEv4sig0),'color',cmapOri(1,:),'FontSize',12,'FontWeight','bold')
text(-0.8,-0.56,sprintf('45%c = %d ',char(176),LEv4sig45),'color',cmapOri(2,:),'FontSize',12,'FontWeight','bold')
text(-0.8,-0.68,sprintf('90%c = %d ',char(176),LEv4sig90),'color',cmapOri(3,:),'FontSize',12,'FontWeight','bold')
text(-0.8,-0.8,sprintf('135%c = %d ',char(176),LEv4sig135),'color',cmapOri(4,:),'FontSize',12,'FontWeight','bold')

% RE V1
text(0.3, 0.95,'RE V1','FontSize',14,'FontWeight','bold')
text(0.3,0.8,sprintf('Con = %d ',REv1conSig),'color',[0.7 0 0.7],'FontSize',12,'FontWeight','bold')
text(0.3,0.68,sprintf('Rad = %d ',REv1radSig),'color',[0 0.6 0.2],'FontSize',12,'FontWeight','bold')
text(0.3,0.56,sprintf('0%c  =  %d ',char(176),REv1sig0),'color',cmapOri(1,:),'FontSize',12,'FontWeight','bold')
text(0.3,0.44,sprintf('45%c = %d ',char(176),REv1sig45),'color',cmapOri(2,:),'FontSize',12,'FontWeight','bold')
text(0.3,0.32,sprintf('90%c = %d ',char(176),REv1sig90),'color',cmapOri(3,:),'FontSize',12,'FontWeight','bold')
text(0.3,0.2,sprintf('135%c = %d ',char(176),REv1sig135),'color',cmapOri(4,:),'FontSize',12,'FontWeight','bold')

% RE V4
text(0.3, -0.1,'RE V4','FontSize',14,'FontWeight','bold')
text(0.3,-0.2,sprintf('Con = %d ',REv4conSig),'color',[0.7 0 0.7],'FontSize',12,'FontWeight','bold')
text(0.3,-0.32,sprintf('Rad = %d ',REv4radSig),'color',[0 0.6 0.2],'FontSize',12,'FontWeight','bold')
text(0.3,-0.44,sprintf('0%c  =  %d ',char(176),REv4sig0),'color',cmapOri(1,:),'FontSize',12,'FontWeight','bold')
text(0.3,-0.56,sprintf('45%c = %d ',char(176),REv4sig45),'color',cmapOri(2,:),'FontSize',12,'FontWeight','bold')
text(0.3,-0.68,sprintf('90%c = %d ',char(176),REv4sig90),'color',cmapOri(3,:),'FontSize',12,'FontWeight','bold')
text(0.3,-0.8,sprintf('135%c = %d ',char(176),REv4sig135),'color',cmapOri(4,:),'FontSize',12,'FontWeight','bold')

plot([-1 1],[0 0],'k:')
plot([0 0],[-1 1],'k:')
axis off
figName = [V4data.conRadRE.animal,'_SigCohCount','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')