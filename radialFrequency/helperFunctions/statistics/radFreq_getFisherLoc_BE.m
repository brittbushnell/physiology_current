function  [REprefLoc, LEprefLoc] = radFreq_getFisherLoc_BE(REdata, LEdata)
%%
location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/location',LEdata.animal,LEdata.array);
    elseif contains(LEdata.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/location',LEdata.animal,LEdata.array);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/location',LEdata.animal,LEdata.array);
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/BE/location',LEdata.animal,LEdata.array);
    elseif contains(LEdata.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/BE/location',LEdata.animal,LEdata.array);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/BE/location',LEdata.animal,LEdata.array);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)
%%
%(RF,ori,amp,sf,radius,location, ch)
REspikes = REdata.RFspikeCount;
REzTr = nan(3,96);
REprefLoc = nan(1,96);

LEspikes = LEdata.RFspikeCount;
LEzTr = nan(3,96);
LEprefLoc = nan(1,96);

locPair = LEdata.locPair;
amps48 = [6.25 12.5 25 50 100 200];
amps16 = [3.12 6.25 12.5 25 50 100];
xs = 1:6;
%%
for ch = 1:96
    ndx2 = 1;
    
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
    for foo = 1:6
        subplot(3,2,foo)
        mygca(1,foo) = gca;
    end
    
    for ey = 1:2
        if ey == 1
            dataT = LEdata;
            scCh = LEspikes{ch};
            ndx = 1;
        else
            dataT = REdata;
            scCh = REspikes{ch};
            ndx = 2;
        end
        
        if dataT.goodCh(ch) == 1
            
            muSc = nan(size(locPair,1),6);
            corrP = nan(3,2);
            
            for loc = 1:size(locPair,1)
                for amp = 1:6
                    % get spike counts for the applicable stimuli
                    noCircNdx = (scCh(1,:) < 32);
                    circNdx = (scCh(1,:) == 32);
                    locNdx = (scCh(6,:) == locPair(loc,1)) & (scCh(7,:) == locPair(loc,2));
                    ampNdx = (scCh(2,:) == amps48(amp)) | (scCh(2,:) == amps16(amp));
                    stimSpikes = squeeze(scCh(8:end,locNdx & ampNdx & noCircNdx));
                    circSpikes = squeeze(scCh(8:end,locNdx & circNdx));
                    
                    % get mean spike count for each amplitude and subtract
                    % response to circle from that.
                    muSc(loc,amp) = (nanmean(stimSpikes,'all')) - (nanmean(circSpikes,'all'));
                end
                
                % get the correlation, and p-value
                
                muScLoc = squeeze(muSc(loc,:));
                [corMtx,corPmtx] = corrcoef(xs,muScLoc);
                sCorr = corMtx(2);
                corrP(loc,1) = corPmtx(2);
                
                % make a logical for whether or not the correlation is
                % significant. This is just to make it easier to determine if
                % there are more than one  significant locations and if I need
                % to use the max response to pick preferred location
                if corrP(loc,1) <= 0.05
                    corrP(loc,2) = 1;
                else
                    corrP(loc,2) = 0;
                end
                
                % get the Fisher r to z transform
                if ey == 1
                    zCh = atanh(sCorr);
                    LEzTr(loc,ch) = zCh;
                else
                    zCh = atanh(sCorr);
                    REzTr(loc,ch) = zCh;
                end
                
                % plot mean spike counts as a function of amplitude. This is
                % really just a sanity check figure
                h = subplot(3,2,ndx);
                hold on
                if contains(dataT.eye,'LE') || contains(dataT.eye,'FE')
                    plot(muScLoc,'o-b')
                else
                    plot(muScLoc,'o-r')
                end
                
                xlim([0.5 6.5])
                
                title(sprintf('r %.2f  Fisher z %.2f', sCorr, zCh), 'FontSize',12,'FontWeight','normal');
                
                if ndx == 3
                    ylabel('mean spike count circle subtracted')
                end
                
                if ndx == 5 || ndx == 6
                    xlabel('amplitude')
                end
                set(gca,'XTick',1:6,'XTickLabel',1:6,'tickdir','out','FontSize',10,'FontAngle','italic')
                
                mygca(1,ndx2) = gca;
                b = get(gca,'YLim');
                yMaxs(ndx2) = b(2);
                yMins(ndx2) = b(1);
                
                h.Position(1) = h.Position(1) + 0.05;
                h.Position(2) = h.Position(2) - 0.02;
                
                if ndx == 1
                    lbl = text(-0.75,(b(1)+b(2))/2,'Location 1','FontWeight','bold','FontSize',12);
                    lbl.Rotation = 90;
                elseif ndx == 3
                    lbl = text(-0.75,(b(1)+b(2))/2,'Location 2','FontWeight','bold','FontSize',12);
                    lbl.Rotation = 90;
                elseif ndx == 5
                    lbl = text(-0.75,(b(1)+b(2))/2,'Location 3','FontWeight','bold','FontSize',12);
                    lbl.Rotation = 90;
                end
                
                % make a text in each figure, then once you know which
                % location is preferred, make * in the other subplots not
                % visible
                if loc == 1
                    t1 = text(6,b(1),'*','FontSize',24);
                elseif loc == 2
                    t2 = text(6,b(1),'*','FontSize',24);
                else
                    t3 = text(6,b(1),'*','FontSize',24);
                end
                
                ndx = ndx+2;
                ndx2 = ndx2+1;
            end
            
            if ey == 1
                if sum(corrP(:,2)) == 1
                    ploc = find(corrP(:,2) == 1);
                    LEprefLoc(1,ch) = ploc;

                elseif sum(corrP(:,2)) > 1
                    [~,mxNdx] = max(muSc,[],'all','linear');
                    [ploc,~] = ind2sub(size(muSc),mxNdx);
                    LEprefLoc(1,ch) = ploc;
                elseif sum(corrP(:,2)) == 0
                    [~,mxNdx] = max(muSc,[],'all','linear');
                    [ploc,~] = ind2sub(size(muSc),mxNdx);
                    LEprefLoc(1,ch) = ploc;
                end
            else
                if sum(corrP(:,2)) == 1
                    ploc = find(corrP(:,2) == 1);
                    REprefLoc(1,ch) = ploc;
 
                elseif sum(corrP(:,2)) > 1
                    [~,mxNdx] = max(muSc,[],'all','linear');
                    [ploc,~] = ind2sub(size(muSc),mxNdx);
                    REprefLoc(1,ch) = ploc;
                elseif sum(corrP(:,2)) == 0
                    [~,mxNdx] = max(muSc,[],'all','linear');
                    [ploc,~] = ind2sub(size(muSc),mxNdx);
                    REprefLoc(1,ch) = ploc;
                end
            end
            
            
            if ploc == 1
%                 t1.Position(2) = minY+abs((minY/4));
                t1.FontWeight = 'bold';
                
                t2.Visible = 'off';
                t3.Visible = 'off';
            elseif ploc == 2
%                 t2.Position(2) = minY+abs((minY/4));
                t2.FontWeight = 'bold';
                
                t1.Visible = 'off';
                t3.Visible = 'off';
                
            else
%                 t3.Position(2) = minY+abs((minY/4));
                t3.FontWeight = 'bold';
                
                t1.Visible = 'off';
                t2.Visible = 'off';
            end
            clear ploc;
        end
    end
    
    minY = min(yMins);
    maxY = max(yMaxs);
    yLimits = ([minY maxY]);
    set(mygca,'YLim',yLimits);
    
    figName = [LEdata.animal,'_BE_',LEdata.array,'_FisherT_location_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
end
%% Plot relative number of channels with each location preference
location = determineComputer;

if location == 1
    if contains(REdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    elseif contains(REdata.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    end
elseif location == 0
    if contains(REdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    elseif contains(REdata.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)

figure(2)
clf
s = suptitle(sprintf('%s %s number of channels that prefer each location',dataT.animal, dataT.array));
s.Position(2) = s.Position(2) +0.02;
s.FontSize = 14;

subplot(2,1,1)
hold on

bar(1,sum(LEprefLoc == 1)/sum(LEdata.goodCh),'FaceColor','b')
bar(2,sum(LEprefLoc == 2)/sum(LEdata.goodCh),'FaceColor','b')
bar(3,sum(LEprefLoc == 3)/sum(LEdata.goodCh),'FaceColor','b')

set(gca,'XTick',1:3,'tickdir','out','FontSize',10,'FontAngle','italic')
if contains(dataT.animal,'XT')
    title('LE','FontSize',12,'FontAngle','italic')
else
    title('FE','FontSize',12,'FontAngle','italic')
end
ylabel('proportion of channels')

ylim([0 0.5])

subplot(2,1,2)
hold on

bar(1,sum(REprefLoc == 1)/sum(LEdata.goodCh),'FaceColor','r')
bar(2,sum(REprefLoc == 2)/sum(LEdata.goodCh),'FaceColor','r')
bar(3,sum(REprefLoc == 3)/sum(LEdata.goodCh),'FaceColor','r')

set(gca,'XTick',1:3,'tickdir','out','FontSize',10,'FontAngle','italic')
if contains(dataT.animal,'XT')
    title('RE','FontSize',12,'FontAngle','italic')
else
    title('AE','FontSize',12,'FontAngle','italic')
end
xlabel('location')
ylabel('proportion of channels')
ylim([0 0.5])

figName = [LEdata.animal,'_BE_',LEdata.array,'_FisherT_location_Prefs','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')