% testing permutations with dummy data

%% make general fake spike matrix
stimParams = REspikes{1}(1:7,:);
dumm = zeros(10,size(stimParams,2));
REdummySpikes1Ch = [stimParams; dumm];
LEdummySpikes1Ch = [stimParams; dumm];

% % set all 0deg stimuli to a high spike count, leaving the alternatives low
% ndx0deg = stimParams(3,:) == 0;
% REdummySpikes1Ch(8:end,ndx0deg) = 25; 
% 
% % set all 0deg stimuli to 0 spike count, and all others to 10.
% ndx0deg = stimParams(3,:) ~= 0;
% LEdummySpikes1Ch(8:end,ndx0deg) = 25; 

ndx0deg = stimParams(3,:) == 0;
ndx1deg = stimParams(3,:) ~= 0;

for ch = 1:96
    for i = 1:size(stimParams,2)
        % make random low and high spikes
        randHighSpikes = randi([10 30],[10,1]);
        randLowSpikes = randi([0 2],[10,1]);
        
        % RE prefers 0deg
        % LE prefers the alternate orientation
        if stimParams(3,i) == 0
            REdummySpikes1Ch(8:end,i) = randHighSpikes;
            LEdummySpikes1Ch(8:end,i) = randLowSpikes;
        else
            LEdummySpikes1Ch(8:end,i) = randHighSpikes;
            REdummySpikes1Ch(8:end,i) = randLowSpikes;         
        end

    end
    REspikes{ch} = REdummySpikes1Ch;
    LEspikes{ch} = LEdummySpikes1Ch;
end
%%

for  ch = 1%:10
figure%(7)
clf

suptitle(sprintf('%s %s PSTHs ch %d', LEdata.animal, LEdata.array))

if LEdata.prefLoc(ch) == 1
    xNdx = LEdata.pos_x == locPair(1,1);
    yNdx = LEdata.pos_y == locPair(1,2);
elseif LEdata.prefLoc(ch) == 2
    xNdx = LEdata.pos_x == locPair(2,1);
    yNdx = LEdata.pos_y == locPair(2,2);
else
    xNdx = LEdata.pos_x == locPair(3,1);
    yNdx = LEdata.pos_y == locPair(3,2);
end

circNdx = LEdata.rf == 32;
circResp = nanmean(smoothdata(LEdata.bins((circNdx & xNdx & yNdx), 1:35 ,ch),'gaussian',3))./0.01;

subplot(3,2,1)
hold on

rfNdx = LEdata.rf == 4;
rot0Ndx = LEdata.orientation == 0;
rot1Ndx = LEdata.orientation == 45;

zeroResp = nanmean(smoothdata(LEdata.bins((rfNdx & xNdx & yNdx & rot0Ndx), 1:35 ,ch),'gaussian',3))./0.01;
otherResp = nanmean(smoothdata(LEdata.bins((rfNdx & xNdx & yNdx & rot1Ndx), 1:35 ,ch),'gaussian',3))./0.01;
zeroResp = zeroResp - circResp;
otherResp = otherResp - circResp;

plot(1:35,zeroResp,'b-','LineWidth',1);
plot(1:35,otherResp,'--b','LineWidth',1);

clear zeroResp otherResp

subplot(3,2,3)
hold on

rfNdx = LEdata.rf == 8;
rot0Ndx = LEdata.orientation == 0;
rot1Ndx = LEdata.orientation == 22.5;

zeroResp = nanmean(smoothdata(LEdata.bins((rfNdx & xNdx & yNdx & rot0Ndx), 1:35 ,ch),'gaussian',3))./0.01;
otherResp = nanmean(smoothdata(LEdata.bins((rfNdx & xNdx & yNdx & rot1Ndx), 1:35 ,ch),'gaussian',3))./0.01;
zeroResp = zeroResp - circResp;
otherResp = otherResp - circResp;

plot(1:35,zeroResp,'b-','LineWidth',1);
plot(1:35,otherResp,'--b','LineWidth',1);

clear zeroResp otherResp

subplot(3,2,5)
hold on

rfNdx = LEdata.rf == 16;
rot0Ndx = LEdata.orientation == 0;
rot1Ndx = LEdata.orientation == 11.25;

zeroResp = nanmean(smoothdata(LEdata.bins((rfNdx & xNdx & yNdx & rot0Ndx), 1:35 ,ch),'gaussian',3))./0.01;
otherResp = nanmean(smoothdata(LEdata.bins((rfNdx & xNdx & yNdx & rot1Ndx), 1:35 ,ch),'gaussian',3))./0.01;
zeroResp = zeroResp - circResp;
otherResp = otherResp - circResp;

plot(1:35,zeroResp,'b-','LineWidth',1);
plot(1:35,otherResp,'--b','LineWidth',1);

clear zeroResp otherResp

subplot(3,2,2)
hold on

rfNdx = REdata.rf == 4;
rot0Ndx = REdata.orientation == 0;
rot1Ndx = REdata.orientation == 45;

zeroResp = nanmean(smoothdata(REdata.bins((rfNdx & xNdx & yNdx & rot0Ndx), 1:35 ,ch),'gaussian',3))./0.01;
otherResp = nanmean(smoothdata(REdata.bins((rfNdx & xNdx & yNdx & rot1Ndx), 1:35 ,ch),'gaussian',3))./0.01;
zeroResp = zeroResp - circResp;
otherResp = otherResp - circResp;

plot(1:35,zeroResp,'r-','LineWidth',1);
plot(1:35,otherResp,'--r','LineWidth',1);

clear zeroResp otherResp

subplot(3,2,4)
hold on

rfNdx = REdata.rf == 8;
rot0Ndx = REdata.orientation == 0;
rot1Ndx = REdata.orientation == 22.5;

zeroResp = nanmean(smoothdata(REdata.bins((rfNdx & xNdx & yNdx & rot0Ndx), 1:35 ,ch),'gaussian',3))./0.01;
otherResp = nanmean(smoothdata(REdata.bins((rfNdx & xNdx & yNdx & rot1Ndx), 1:35 ,ch),'gaussian',3))./0.01;
zeroResp = zeroResp - circResp;
otherResp = otherResp - circResp;

plot(1:35,zeroResp,'r-','LineWidth',1);
plot(1:35,otherResp,'--r','LineWidth',1);

clear zeroResp otherResp

subplot(3,2,6)
hold on

rfNdx = REdata.rf == 16;
rot0Ndx = REdata.orientation == 0;
rot1Ndx = REdata.orientation == 11.25;

zeroResp = nanmean(smoothdata(REdata.bins((rfNdx & xNdx & yNdx & rot0Ndx), 1:35 ,ch),'gaussian',3))./0.01;
otherResp = nanmean(smoothdata(REdata.bins((rfNdx & xNdx & yNdx & rot1Ndx), 1:35 ,ch),'gaussian',3))./0.01;

zeroResp = zeroResp - circResp;
otherResp = otherResp - circResp;
plot(1:35,zeroResp,'r-','LineWidth',1);
plot(1:35,otherResp,'--r','LineWidth',1);
clear zeroResp otherResp

end