function GlassCohCorrStats(V1data, V4data)

% Steps for each channel that's good and in stim:
% 1) find preferred dt,dx at 100%
% 1) correlation of d' and coherence
% 2) determine what channels have significant r values
% 3) repeat for all three stimuli, and for each orientation
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

inclConRadLEV4 = (V4data.conRadLE.goodCh == 1) & (V4data.conRadLE.inStim == 1);
incltrLEV4 = (V4data.trLE.goodCh == 1) & (V4data.trLE.inStim == 1);

conDLEV4 = abs(squeeze(V4data.conRadLE.conNoiseDprime(end,:,:,:)));
cDpLEV4 = squeeze([squeeze(conDLEV4(1,1,:)),squeeze(conDLEV4(1,2,:)),squeeze(conDLEV4(2,1,:)),squeeze(conDLEV4(2,2,:))]);
[~,conDtDxPrefLEV4] = max(cDpLEV4,[],2);
% conDtDxPref = cDp(inclConRadLE);

radDLEV4 = abs(squeeze(V4data.conRadLE.radNoiseDprime(end,:,:,:)));
rDpLEV4 = squeeze([squeeze(radDLEV4(1,1,:)),squeeze(radDLEV4(1,2,:)),squeeze(radDLEV4(2,1,:)),squeeze(radDLEV4(2,2,:))]);
[~,radDtDxPrefLEV4] = max(rDpLEV4,[],2);
% radDtDxPref = rDp(inclConRadLE);

for o = 1:4
    trDLEV4 = abs(squeeze(V4data.trLE.linNoiseDprime(o,end,:,:,:)));
    trDpLEV4 = squeeze([squeeze(trDLEV4(1,1,:)),squeeze(trDLEV4(1,2,:)),squeeze(trDLEV4(2,1,:)),squeeze(trDLEV4(2,2,:))]);
    [~,trDtDxPrefLEV4(:,o)] = max(trDpLEV4,[],2);
end

inclConRadREV4 = (V4data.conRadRE.goodCh == 1) & (V4data.conRadRE.inStim == 1);
incltrREV4 = (V4data.trRE.goodCh == 1) & (V4data.trRE.inStim == 1);

conDREV4 = abs(squeeze(V4data.conRadRE.conNoiseDprime(end,:,:,:)));
cDpREV4 = squeeze([squeeze(conDREV4(1,1,:)),squeeze(conDREV4(1,2,:)),squeeze(conDREV4(2,1,:)),squeeze(conDREV4(2,2,:))]);
[~,conDtDxPrefREV4] = max(cDpREV4,[],2);
% conDtDxPref = cDp(inclConRadRE);

radDRE = abs(squeeze(V4data.conRadRE.radNoiseDprime(end,:,:,:)));
rDpRE = squeeze([squeeze(radDRE(1,1,:)),squeeze(radDRE(1,2,:)),squeeze(radDRE(2,1,:)),squeeze(radDRE(2,2,:))]);
[~,radDtDxPrefREV4] = max(rDpRE,[],2);
% radDtDxPref = rDp(inclConRadRE);

for o = 1:4
    trDREV4 = abs(squeeze(V4data.trRE.linNoiseDprime(o,end,:,:,:)));
    trDpREV4 = squeeze([squeeze(trDREV4(1,1,:)),squeeze(trDREV4(1,2,:)),squeeze(trDREV4(2,1,:)),squeeze(trDREV4(2,2,:))]);
    [~,trDtDxPrefREV4(:,o)] = max(trDpREV4,[],2);
end


inclConRadLEV1 = (V1data.conRadLE.goodCh == 1) & (V1data.conRadLE.inStim == 1);
incltrLEV1 = (V1data.trLE.goodCh == 1) & (V1data.trLE.inStim == 1);

conDLEV1 = abs(squeeze(V1data.conRadLE.conNoiseDprime(end,:,:,:)));
cDpLEV1 = squeeze([squeeze(conDLEV1(1,1,:)),squeeze(conDLEV1(1,2,:)),squeeze(conDLEV1(2,1,:)),squeeze(conDLEV1(2,2,:))]);
[~,conDtDxPrefLEV1] = max(cDpLEV1,[],2);
% conDtDxPref = cDp(inclConRadLE);

radDLEV1 = abs(squeeze(V1data.conRadLE.radNoiseDprime(end,:,:,:)));
rDpLEV1 = squeeze([squeeze(radDLEV1(1,1,:)),squeeze(radDLEV1(1,2,:)),squeeze(radDLEV1(2,1,:)),squeeze(radDLEV1(2,2,:))]);
[~,radDtDxPrefLEV1] = max(rDpLEV1,[],2);
% radDtDxPref = rDp(inclConRadLE);

for o = 1:4
    trDLEV1 = abs(squeeze(V1data.trLE.linNoiseDprime(o,end,:,:,:)));
    trDpLEV1 = squeeze([squeeze(trDLEV1(1,1,:)),squeeze(trDLEV1(1,2,:)),squeeze(trDLEV1(2,1,:)),squeeze(trDLEV1(2,2,:))]);
    [~,trDtDxPrefLEV1(:,o)] = max(trDpLEV1,[],2);
end

inclConRadREV1 = (V1data.conRadRE.goodCh == 1) & (V1data.conRadRE.inStim == 1);
incltrREV1 = (V1data.trRE.goodCh == 1) & (V1data.trRE.inStim == 1);

conDREV1 = abs(squeeze(V1data.conRadRE.conNoiseDprime(end,:,:,:)));
cDpREV1 = squeeze([squeeze(conDREV1(1,1,:)),squeeze(conDREV1(1,2,:)),squeeze(conDREV1(2,1,:)),squeeze(conDREV1(2,2,:))]);
[~,conDtDxPrefREV1] = max(cDpREV1,[],2);
% conDtDxPref = cDp(inclConRadRE);

radDRE = abs(squeeze(V1data.conRadRE.radNoiseDprime(end,:,:,:)));
rDpRE = squeeze([squeeze(radDRE(1,1,:)),squeeze(radDRE(1,2,:)),squeeze(radDRE(2,1,:)),squeeze(radDRE(2,2,:))]);
[~,radDtDxPrefREV1] = max(rDpRE,[],2);
% radDtDxPref = rDp(inclConRadRE);

for o = 1:4
    trDREV1 = abs(squeeze(V1data.trRE.linNoiseDprime(o,end,:,:,:)));
    trDpREV1 = squeeze([squeeze(trDREV1(1,1,:)),squeeze(trDREV1(1,2,:)),squeeze(trDREV1(2,1,:)),squeeze(trDREV1(2,2,:))]);
    [~,trDtDxPrefREV1(:,o)] = max(trDpREV1,[],2);
end
%% get the d'x coh for that dt,dx for each pattern
% this way we can leave the first value as 0 to anchor the correlations.
cohs = [0,25,50,75,100];
ors = [0 45 90 135];
cmap = gray(6);
conDp = zeros(5,1);
radDp = zeros(5,1);
trDpLEV4 = zeros(5,1);
trDpREV4 = zeros(5,1);
trDpLEV1 = zeros(5,1);
trDpREV1 = zeros(5,1);


%%
for ch = 1:96
    cPv = 1;
    rPv = 1;
    trPv = ones(4,1);

    figure(1)
    clf
    hold on

    subplot(2,2,3)
    hold on
    s = suptitle(sprintf('%s coherence responses ch %d',V4data.conRadLE.animal,ch));
    s.Position(2) = s.Position(2)+0.025;
    s.FontSize = 18;    

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
        [conCorr,cPv] = corr(conDp,cohs');
        if cPv <=0.05
            plot(cohs, conDp, 'o-','color',[0.7 0 0.7])
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
        [radCorr,rPv] = corr(radDp,cohs');
        if rPv <=0.05
            plot(cohs, radDp, 'o-','color',[0 0.6 0.2]);
        end
    end
    if incltrLEV4(ch)
        for or = 1:4
            if trDtDxPrefLEV4(ch,or) == 1
                trDpLEV4(2:end) = squeeze(V4data.trLE.linNoiseDprime(or,:,1,1,ch));
            elseif trDtDxPrefLEV4(ch,or) == 2
                trDpLEV4(2:end) = squeeze(V4data.trLE.linNoiseDprime(or,:,1,2,ch));
            elseif trDtDxPrefLEV4(ch,or) == 3
                trDpLEV4(2:end) = squeeze(V4data.trLE.linNoiseDprime(or,:,2,1,ch));
            else
                trDpLEV4(2:end) = squeeze(V4data.trLE.linNoiseDprime(or,:,2,2,ch));
            end
            [trCorr,trPv(or)] = corr(trDpLEV4,cohs');
            if trPv(or) <= 0.05
                plot(cohs, trDpLEV4, 'o-','color',cmap(or,:))
            end
        end
    end
    if any(trPv <= 0.05) || cPv <= 0.05 || rPv <= 0.05
        y3 = ylim;
    else
        y3 = [0 0.1];
    end
    title('FE')
    set(gca,'tickdir','out','box','off','XTick',0:25:100)
    axis square
    
    subplot(2,2,4)
    cPv = 1;
    rPv = 1;
    trPv = ones(4,1);
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
        [conCorr,cPv] = corr(conDp,cohs');
        if cPv <=0.05
            plot(cohs, conDp, 'o-','color',[0.7 0 0.7])
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
        [radCorr,rPv] = corr(radDp,cohs');
        if rPv <=0.05
            plot(cohs, radDp, 'o-','color',[0 0.6 0.2])
        end
    end
    if incltrREV4(ch)
        for or = 1:4
            if trDtDxPrefREV4(ch,or) == 1
                trDpREV4(2:end) = squeeze(V4data.trRE.linNoiseDprime(or,:,1,1,ch));
            elseif trDtDxPrefREV4(ch,or) == 2
                trDpREV4(2:end) = squeeze(V4data.trRE.linNoiseDprime(or,:,1,2,ch));
            elseif trDtDxPrefREV4(ch,or) == 3
                trDpREV4(2:end) = squeeze(V4data.trRE.linNoiseDprime(or,:,2,1,ch));
            else
                trDpREV4(2:end) = squeeze(V4data.trRE.linNoiseDprime(or,:,2,2,ch));
            end
            [trCorr,trPv(or)] = corr(trDpREV4,cohs');
            if trPv(or) <= 0.05
                plot(cohs, trDpREV4, 'o-','color',cmap(or,:))
            end
            
        end
    end
    if any(trPv <= 0.05) || cPv <= 0.05 || rPv <= 0.05
        y4 = ylim;
    else
        y4 = [0 0.1];
    end
    title('AE')
    set(gca,'tickdir','out','box','off','XTick',0:25:100)
    axis square
    
    % V1
    subplot(2,2,2)
    cPv = 1;
    rPv = 1;
    trPv = ones(4,1);
    hold on
    
    if inclConRadREV1(ch)
        if conDtDxPrefREV1(ch) == 1
            conDp(2:end) = squeeze(V4data.conRadRE.conNoiseDprime(:,1,1,ch));
        elseif conDtDxPrefREV1(ch) == 2
            conDp(2:end) = squeeze(V4data.conRadRE.conNoiseDprime(:,1,2,ch));
        elseif conDtDxPrefREV1(ch) == 3
            conDp(2:end) = squeeze(V4data.conRadRE.conNoiseDprime(:,2,1,ch));
        else
            conDp(2:end) = squeeze(V4data.conRadRE.conNoiseDprime(:,2,2,ch));
        end
        [conCorr,cPv] = corr(conDp,cohs');
        if cPv <=0.05
            plot(cohs, conDp, 'o-','color',[0.7 0 0.7])
        end
        
        if radDtDxPrefREV1(ch) == 1
            radDp(2:end) = squeeze(V4data.conRadRE.radNoiseDprime(:,1,1,ch));
        elseif radDtDxPrefREV1(ch) == 2
            radDp(2:end) = squeeze(V4data.conRadRE.radNoiseDprime(:,1,2,ch));
        elseif radDtDxPrefREV1(ch) == 3
            radDp(2:end) = squeeze(V4data.conRadRE.radNoiseDprime(:,2,1,ch));
        else
            radDp(2:end) = squeeze(V4data.conRadRE.radNoiseDprime(:,2,2,ch));
        end
        [radCorr,rPv] = corr(radDp,cohs');
        if rPv <=0.05
            plot(cohs, radDp, 'o-','color',[0 0.6 0.2])
        end
    end
    if incltrREV1(ch)
        for or = 1:4
            if trDtDxPrefREV1(ch,or) == 1
                trDpREV1(2:end) = squeeze(V4data.trRE.linNoiseDprime(or,:,1,1,ch));
            elseif trDtDxPrefREV1(ch,or) == 2
                trDpREV1(2:end) = squeeze(V4data.trRE.linNoiseDprime(or,:,1,2,ch));
            elseif trDtDxPrefREV1(ch,or) == 3
                trDpREV1(2:end) = squeeze(V4data.trRE.linNoiseDprime(or,:,2,1,ch));
            else
                trDpREV1(2:end) = squeeze(V4data.trRE.linNoiseDprime(or,:,2,2,ch));
            end
            [trCorr,trPv(or)] = corr(trDpREV1,cohs');
            if trPv(or) <= 0.05
                plot(cohs, trDpREV1, 'o-','color',cmap(or,:))
            end
            
        end
    end
    if any(trPv <= 0.05) || cPv <= 0.05 || rPv <= 0.05
        y2 = ylim;
    else
        y2 = [0 0.1];
    end
    title('AE')
    set(gca,'tickdir','out','box','off','XTick',0:25:100)
    axis square
    
    subplot(2,2,1)
    cPv = 1;
    rPv = 1;
    trPv = ones(4,1);
    hold on
    
    if inclConRadLEV1(ch)
        if conDtDxPrefLEV1(ch) == 1
            conDp(2:end) = squeeze(V4data.conRadLE.conNoiseDprime(:,1,1,ch));
        elseif conDtDxPrefLEV1(ch) == 2
            conDp(2:end) = squeeze(V4data.conRadLE.conNoiseDprime(:,1,2,ch));
        elseif conDtDxPrefLEV1(ch) == 3
            conDp(2:end) = squeeze(V4data.conRadLE.conNoiseDprime(:,2,1,ch));
        else
            conDp(2:end) = squeeze(V4data.conRadLE.conNoiseDprime(:,2,2,ch));
        end
        [conCorr,cPv] = corr(conDp,cohs');
        if cPv <=0.05
            plot(cohs, conDp, 'o-','color',[0.7 0 0.7])
        end
        
        
        if radDtDxPrefLEV1(ch) == 1
            radDp(2:end) = squeeze(V4data.conRadLE.radNoiseDprime(:,1,1,ch));
        elseif radDtDxPrefLEV1(ch) == 2
            radDp(2:end) = squeeze(V4data.conRadLE.radNoiseDprime(:,1,2,ch));
        elseif radDtDxPrefLEV1(ch) == 3
            radDp(2:end) = squeeze(V4data.conRadLE.radNoiseDprime(:,2,1,ch));
        else
            radDp(2:end) = squeeze(V4data.conRadLE.radNoiseDprime(:,2,2,ch));
        end
        [radCorr,rPv] = corr(radDp,cohs');
        if rPv <=0.05
            plot(cohs, radDp, 'o-','color',[0 0.6 0.2])
        end
    end
    if incltrLEV1(ch)
        for or = 1:4
            if trDtDxPrefLEV1(ch,or) == 1
                trDpLEV1(2:end) = squeeze(V4data.trLE.linNoiseDprime(or,:,1,1,ch));
            elseif trDtDxPrefLEV1(ch,or) == 2
                trDpLEV1(2:end) = squeeze(V4data.trLE.linNoiseDprime(or,:,1,2,ch));
            elseif trDtDxPrefLEV1(ch,or) == 3
                trDpLEV1(2:end) = squeeze(V4data.trLE.linNoiseDprime(or,:,2,1,ch));
            else
                trDpLEV1(2:end) = squeeze(V4data.trLE.linNoiseDprime(or,:,2,2,ch));
            end
            [trCorr,trPv(or)] = corr(trDpLEV1,cohs');
            if trPv(or) <= 0.05
                plot(cohs, trDpLEV1, 'o-','color',cmap(or,:))
            end
            
        end
        
    end
    if any(trPv <= 0.05) || cPv <= 0.05 || rPv <= 0.05
        y1 = ylim;
    else
        y1 = [0 0.1];
    end
    title('FE')
    set(gca,'tickdir','out','box','off','XTick',0:25:100)
    axis square
    
    ymin = min([y1(1), y2(1), y3(1), y4(1)]);
    ymax = max([y1(2), y2(2), y3(2), y4(2)]);
    txty = ymin + (ymin/4);
    
    subplot(2,2,1)
    ylim([ymin, ymax])
    xlim([0 100])
    ylabel('d''')
    text(-35, ymin+ymax/2,'V1','FontSize',18)

    subplot(2,2,2)
    ylim([ymin, ymax])
    xlim([0 100]) 
    
    subplot(2,2,3)
    ylim([ymin, ymax])
    xlim([0 100])
    ylabel('d''')
    xlabel('% coherence')
    text(-35, ymin+ymax/2,'V4','FontSize',18)
    
    text(30, txty,'Concentric','color',[0.7 0 0.7],'FontSize',12,'FontWeight','bold')
    text(70, txty,'Radial','color',[0 0.6 0.2],'FontSize',12,'FontWeight','bold')
    text(100,txty,sprintf('0%c',char(176)),'color',cmap(1,:),'FontSize',12,'FontWeight','bold')
    text(125,txty,sprintf('45%c',char(176)),'color',cmap(2,:),'FontSize',12,'FontWeight','bold')
    text(150,txty,sprintf('90%c',char(176)),'color',cmap(3,:),'FontSize',12,'FontWeight','bold')
    text(175,txty,sprintf('135%c',char(176)),'color',cmap(4,:),'FontSize',12,'FontWeight','bold')
    
    subplot(2,2,4)
    xlabel('% coherence')
    ylim([ymin, ymax])
    xlim([0 100])
    
    figName = [V4data.conRadRE.animal,'sigCohPlots_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
end





