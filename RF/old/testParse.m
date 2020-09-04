clear all
close all
%clc
%%
file = 'WU_RadFreqLoc2_V4_20170707_cleaned_goodCh_0730';

%%
load(file)

numCh = size(REdata.bins,3);
LEcircResps = cell(1,numCh);
LErfResps = cell(1,numCh);
REcircResps = cell(1,numCh);
RErfResps = cell(1,numCh);

for ch = 1:numCh
    LEresps = LEcleanData.stimResps{ch};
    REresps = REcleanData.stimResps{ch};
    
    
    circNdx = find(LEresps(1,:) == 32);
    LEcircResps{ch} = LEresps(:,circNdx); % matrix of just the responses to a circle
    
    circNdx = find(REresps(1,:) == 32);
    REcircResps{ch} = REresps(:,circNdx);
    
    LErfResps{ch} = LEresps(:,(LEresps(1,:)~=32));
    RErfResps{ch} = REresps(:,(REresps(1,:)~=32));
    
    rfs = unique(LErfResps{ch}(1,:));
    amps = unique(LErfResps{ch}(2,:));
    phase = unique(LErfResps{ch}(3,:));
    sfs = unique(LErfResps{ch}(4,:));
    rad = unique(LErfResps{ch}(5,:));
    xloc = unique(LErfResps{ch}(6,:));
    yloc = unique(LErfResps{ch}(7,:));
    
    % reshape
    rfNdx = length(unique(LErfResps{ch}(1,:)));
    LErfResps{ch} = reshape(LErfResps{ch},size(LEresps,1),(size(LErfResps{ch},2)/rfNdx),rfNdx); % now RF responses are a 3d matrix: (responses,stim,rf)
    
    rfNdx = length(unique(RErfResps{ch}(1,:)));
    RErfResps{ch} = reshape(RErfResps{ch},size(REresps,1),(size(RErfResps{ch},2)/rfNdx),rfNdx); % now RF responses are a 3d matrix: (responses,stim,rf)
end

REcleanData.rfResp = RErfResps;
REcleanData.circleResps = REcircResps;

LEcleanData.rfResp = LErfResps;
LEcleanData.circleResps = LEcircResps;
%% narrow down to specific stimuli, and plot
numRfs = length(rfs);
numAmps = length(amps);
numPhase = length(phase);
numSfs = length(sfs);
numRad = length(rad);
numXloc = length(xloc);
numYloc = length(yloc);

xdata = [4,8,16,32,64,128];

for ch = [50 48 52]
    
    useStim = find((LEcleanData.rfResp{ch}(6,:,1) == -3));
    LEcenterRFs = LEcleanData.rfResp{ch}(:,useStim,:); %make a matrix of just the stimuli presented in the center position;
    REcenterRFs = REcleanData.rfResp{ch}(:,useStim,:);
    
    useCirc = find((LEcleanData.circleResps{ch}(6,:,1) == -3));
    LEcenterCircles = LEcleanData.circleResps{ch}(:,useCirc,:); %make a matrix of just the stimuli presented in the center position;
    REcenterCircles = REcleanData.circleResps{ch}(:,useCirc,:);
    
    for spf = 1:numSfs
        for rd = 1:numRad
            figure
            useStim = find((LEcenterRFs(4,:,1) == sfs(spf) & (LEcenterRFs(5,:,1) == rad(rd))));
            tmpL = LEcenterRFs(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
            tmpR = REcenterRFs(:,useStim,:);
            
            useStim = find((LEcenterCircles(4,:,1) == sfs(spf) & (LEcenterCircles(5,:,1) == rad(rd))));
            tmpLC = LEcenterCircles(:,useStim,:);
            tmpRC = REcenterCircles(:,useStim,:);
            
            muRespsLC = tmpLC(end-3)-LEcleanData.blankResps{ch}(end-3);
            muRespsRC = tmpRC(end-3)-REcleanData.blankResps{ch}(end-3);
            
            medRespsLC = tmpLC(end-2)-LEcleanData.blankResps{ch}(end-2);
            medRespsRC = tmpRC(end-2)-REcleanData.blankResps{ch}(end-2);
            
            
            muRespsL = nan(3,(size(tmpL,2)/2));
            muRespsR = nan(3,(size(tmpR,2)/2));
            
            mdRespsL = nan(3,(size(tmpL,2)/2));
            mdRespsR = nan(3,(size(tmpR,2)/2));
            for i = 1:(size(tmpL,2)/2)
                for r = 1:3
                    valsL = [tmpL(end-3,i,r);tmpL(end-3,i+1,r)]; % this will only work as long as there are two phases
                    muRespsL(r,i) = nanmean(valsL)-LEcleanData.blankResps{ch}(end-3);
                    
                    valsR = [tmpL(end-3,i,r);tmpR(end-3,i+1,r)]; % this will only work as long as there are two phases
                    muRespsR(r,i) = nanmean(valsR)-REcleanData.blankResps{ch}(end-3);
                    
                    valsL = [tmpL(end-2,i,r);tmpL(end-2,i+1,r)]; % this will only work as long as there are two phases
                    mdRespsL(r,i) = nanmean(valsL)-LEcleanData.blankResps{ch}(end-2);
                                useStim = find((LEcenterRFs(4,:,1) == sfs(spf) & (LEcenterRFs(5,:,1) == rad(rd))));
            tmpL = LEcenterRFs(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
            tmpR = REcenterRFs(:,useStim,:);
            
            useStim = find((LEcenterCircles(4,:,1) == sfs(spf) & (LEcenterCircles(5,:,1) == rad(rd))));
            tmpLC = LEcenterCircles(:,useStim,:);
            tmpRC = REcenterCircles(:,useStim,:);
            
            muRespsLC = tmpLC(end-3)-LEcleanData.blankResps{ch}(end-3);
            muRespsRC = tmpRC(end-3)-REcleanData.blankResps{ch}(end-3);
            
            medRespsLC = tmpLC(end-2)-LEcleanData.blankResps{ch}(end-2);
            medRespsRC = tmpRC(end-2)-REcleanData.blankResps{ch}(end-2);
            
            
            muRespsL = nan(3,(size(tmpL,2)/2));
            muRespsR = nan(3,(size(tmpR,2)/2));
            
            mdRespsL = nan(3,(size(tmpL,2)/2));
            mdRespsR = nan(3,(size(tmpR,2)/2));
            for i = 1:(size(tmpL,2)/2)
                for r = 1:3
                    valsL = [tmpL(end-3,i,r);tmpL(end-3,i+1,r)]; % this will only work as long as there are two phases
                    muRespsL(r,i) = nanmean(valsL)-LEcleanData.blankResps{ch}(end-3);
                    
                    valsR = [tmpL(end-3,i,r);tmpR(end-3,i+1,r)]; % this will only work as long as there are two phases
                    muRespsR(r,i) = nanmean(valsR)-REcleanData.blankResps{ch}(end-3);
                    
                    valsL = [tmpL(end-2,i,r);tmpL(end-2,i+1,r)]; % this will only work as long as there are two phases
                    mdRespsL(r,i) = nanmean(valsL)-LEcleanData.blankResps{ch}(end-2);
                    
                    valsR = [tmpL(end-2,i,r);tmpR(end-2,i+1,r)]; % this will only work as long as there are two phases
                    mdRespsR(r,i) = nanmean(valsR)-REcleanData.blankResps{ch}(end-2);
                end
            end
                    valsR = [tmpL(end-2,i,r);tmpR(end-2,i+1,r)]; % this will only work as long as there are two phases
                    mdRespsR(r,i) = nanmean(valsR)-REcleanData.blankResps{ch}(end-2);
                end
            end
            r = max(muRespsR(:));
            l = max(muRespsL(:));
            y = max(r,l);
            
            subplot(2,3,1)
            hold on
            plot(xdata, muRespsL(1,:),'b-o')
            plot(xdata, mdRespsL(1,:),'k-o')
            plot(2,medRespsLC,'ko')
            plot(2,muRespsLC,'bo')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf4')
            ylim([0 y]);
            axis square
            
            
            subplot(2,3,2)
            hold on
            plot(xdata, muRespsL(2,:),'b-o')
            plot(xdata, mdRespsL(2,:),'k-o')
            plot(2,medRespsLC,'bo')
            plot(2,muRespsLC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf8')
            ylim([0 y]);
            axis square
            
            subplot(2,3,3)
            hold on
            plot(xdata, muRespsL(3,:),'b-o')
            plot(xdata, mdRespsL(3,:),'k-o')
            plot(2,medRespsLC,'bo')
            plot(2,muRespsLC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf16')
            ylim([0 y]);
            axis square
            
            subplot(2,3,4)
            hold on
            plot(xdata, muRespsR(1,:),'r-o')
            plot(xdata, mdRespsR(1,:),'k-o')
            plot(2,medRespsRC,'ko')
            plot(2,muRespsRC,'ro')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf4')
            ylim([0 y]);
            axis square
            
            
            subplot(2,3,5)
            hold on
            plot(xdata, muRespsR(2,:),'r-o')
            plot(xdata, mdRespsR(2,:),'k-o')
            plot(2,muRespsRC,'ro')
            plot(2,medRespsRC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf8')
            ylim([0 y]);
            axis square
            
            subplot(2,3,6)
            hold on
            plot(xdata, muRespsR(3,:),'r-o')
            plot(xdata, mdRespsR(3,:),'k-o')
            plot(2,muRespsRC,'ro')
            plot(2,medRespsRC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf16')
            ylim([0 y]);
            axis square
            
            annotation('textbox',...
                [0.2 0.96 0.65 0.05],...
                'LineStyle','none',...
                'String',sprintf('sf%d size%d',spf,rd),...
                'Interpreter','none',...
                'FontSize',14,...
                'FontAngle','italic',...
                'FontName','Helvetica Neue');
        end
    end
end