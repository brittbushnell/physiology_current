clear all
close all
clc
%%
file = 'WU_RadFreqLoc2_V4_20170707_cleaned_goodCh_0730';

%%
load(file)

LEresps = cell2mat(LEcleanData.stimResps);
LEblanks = cell2mat(LEcleanData.blankResps);
LEbaseMu = nanmean(LEblanks(end-3,:));
LEbaseMd = nanmean(LEblanks(end-2,:));

REresps = cell2mat(REcleanData.stimResps);
REblanks = cell2mat(REcleanData.blankResps);
REbaseMu = nanmean(REblanks(end-3,:));
REbaseMd = nanmean(REblanks(end-2,:));


circNdx = find(LEresps(1,:) == 32);
LEcircResps = LEresps(:,circNdx); % matrix of just the responses to a circle

circNdx = find(REresps(1,:) == 32);
REcircResps = REresps(:,circNdx);

LErfResps = LEresps(:,(LEresps(1,:)~=32));
RErfResps = REresps(:,(REresps(1,:)~=32));

% reshape
rfNdx = length(unique(LErfResps(1,:)));
LErfResps = reshape(LErfResps,size(LEresps,1),(size(LErfResps,2)/rfNdx),rfNdx); % now RF responses are a 3d matrix: (responses,stim,rf)

rfNdx = length(unique(RErfResps(1,:)));
RErfResps = reshape(RErfResps,size(REresps,1),(size(RErfResps,2)/rfNdx),rfNdx); % now RF responses are a 3d matrix: (responses,stim,rf)


REcleanData.rfResp = RErfResps;
REcleanData.circleResps = REcircResps;

LEcleanData.rfResp = LErfResps;
LEcleanData.circleResps = LEcircResps;
%% Get stimulus information
rfs = unique(LErfResps(1,:));
amps = unique(LErfResps(2,:));
phase = unique(LErfResps(3,:));
sfs = unique(LErfResps(4,:));
rad = unique(LErfResps(5,:));
xloc = unique(LErfResps(6,:));
yloc = unique(LErfResps(7,:));

numRfs = length(rfs);
numAmps = length(amps);
numPhase = length(phase);
numSfs = length(sfs);
numRad = length(rad);
numXloc = length(xloc);
numYloc = length(yloc);
%% Combine across channels

useStim = find((LEcleanData.rfResp(6,:,1) == -3));
LEcenterRFs = LEcleanData.rfResp(:,useStim,:); %make a matrix of just the stimuli presented in the center position;
RFS = LEcenterRFs(1:7,:);
[eachRF,~,rfIDs] = unique(RFS','rows');

LEradfs = reshape(LEcenterRFs,size(LEcenterRFs,1),size(eachRF,1),96);
LErfs = nan((size(eachRF,2)+2),size(eachRF,1));
LErfs(1:7,:) = eachRF';

for a = 1:size(LEradfs,2)
    LErfs(8,a) = nanmean(LEradfs(end-3,a,:));
    LErfs(9,a) = nanmean(LEradfs(end-2,a,:));
end
LErfs = reshape(LErfs,size(LErfs,1),(size(LErfs,2)/3),3);

% circles
useCirc = find((LEcleanData.circleResps(6,:,1) == -3));
LEcenterCircles = LEcleanData.circleResps(:,useCirc,:); %make a matrix of just the stimuli presented in the center position;
circles = LEcenterCircles(1:7,:);
[eachCircle,~,circleIDs] = unique(circles','rows');

LEcircles = reshape(LEcenterCircles,size(LEcenterCircles,1),size(eachCircle,1),96);
LEcirc = nan((size(eachCircle,2)+2),size(eachCircle,1));
LEcirc(1:7,:) = eachCircle';

for a = 1:size(LEcircles,2)
    LEcirc(8,a) = nanmean(LEcircles(end-3,a,:));
    LEcirc(9,a) = nanmean(LEcircles(end-2,a,:));
end

%% RE
useStim = find((REcleanData.rfResp(6,:,1) == -3));
REcenterRFs = REcleanData.rfResp(:,useStim,:); %make a matrix of just the stimuli presented in the center position;
RFS = REcenterRFs(1:7,:);
[eachRF,~,rfIDs] = unique(RFS','rows');

REradfs = reshape(REcenterRFs,size(REcenterRFs,1),size(eachRF,1),96);
RErfs = nan((size(eachRF,2)+2),size(eachRF,1));
RErfs(1:7,:) = eachRF';

for a = 1:size(REradfs,2)
    RErfs(8,a) = nanmean(REradfs(end-3,a,:));
    RErfs(9,a) = nanmean(REradfs(end-2,a,:));
end
RErfs = reshape(RErfs,size(RErfs,1),(size(RErfs,2)/3),3);

% circles
useCirc = find((REcleanData.circleResps(6,:,1) == -3));
REcenterCircles = REcleanData.circleResps(:,useCirc,:);
circles = REcenterCircles(1:7,:);
[eachCircle,~,circleIDs] = unique(circles','rows');

REcircles = reshape(REcenterCircles,size(REcenterCircles,1),size(eachCircle,1),96);
REcirc = nan((size(eachCircle,2)+2),size(eachCircle,1));
REcirc(1:7,:) = eachCircle';

for a = 1:size(REcircles,2)
    REcirc(8,a) = nanmean(REcircles(end-3,a,:));
    REcirc(9,a) = nanmean(REcircles(end-2,a,:));
end
%% plot
xdata = [4,8,16,32,64,128];

for ch = 1:96
    REblankMus(1,ch) = REcleanData.blankResps{ch}(end-3);
    REblankMds(1,ch) = REcleanData.blankResps{ch}(end-2);
    
    LEblankMus(1,ch) = LEcleanData.blankResps{ch}(end-3);
    LEblankMds(1,ch) = LEcleanData.blankResps{ch}(end-2);
end
REblankMu = nanmean(REblankMus);
REblankMd = nanmean(REblankMds);

LEblankMu = nanmean(LEblankMus);
LEblankMd = nanmean(LEblankMds);
%%
for spf = 1:numSfs
    for rd = 1:numRad
        useStim = find((LErfs(4,:,1) == sfs(spf) & (LErfs(5,:,1) == rad(rd))));
        tmpL = LErfs(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
        tmpR = RErfs(:,useStim,:);
        
        useStim = find((LEcirc(4,:,1) == sfs(spf) & (LEcirc(5,:,1) == rad(rd))));
        tmpLC = LEcirc(:,useStim,:);
        tmpRC = REcirc(:,useStim,:);
        
        muRespsLC = tmpLC(end-1)-LEblankMu;
        muRespsRC = tmpRC(end-1)-REblankMu;
        
        medRespsLC = tmpLC(end)-LEblankMd;
        medRespsRC = tmpRC(end)-REblankMd;
        
        
        muRespsL = nan(3,(size(tmpL,2)/2));
        muRespsR = nan(3,(size(tmpR,2)/2));
        
        mdRespsL = nan(3,(size(tmpL,2)/2));
        mdRespsR = nan(3,(size(tmpR,2)/2));
        for i = 1:(size(tmpL,2)/2)
            for r = 1:3
                valsL = [tmpL(end-1,i,r);tmpL(end-1,i+1,r)]; % this will only work as long as there are two phases
                muRespsL(r,i) = nanmean(valsL)-LEblankMu;
                
                valsR = [tmpL(end-1,i,r);tmpR(end-1,i+1,r)]; 
                muRespsR(r,i) = nanmean(valsR)-REblankMu;
                
                valsL = [tmpL(end,i,r);tmpL(end,i+1,r)]; 
                mdRespsL(r,i) = nanmean(valsL)-LEblankMd;
                
                valsR = [tmpL(end,i,r);tmpR(end,i+1,r)]; 
                mdRespsR(r,i) = nanmean(valsR)-REblankMd;
            end
        end
        
        r = max(muRespsR(:));
        l = max(muRespsL(:));
        y = max(r,l);
        
        %% plot
        figure
        
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
