xLE = [0 1 0];
yLE = [0 1 1];
xRE = [0 1 1];
yRE = [0 0 1];

arrayInfo = [REdata.array,REdata.animal];
amap = getBlackrockArrayMap(arrayInfo);

numRE = REdata.numRFsSigHighAmp;
numLE = LEdata.numRFsSigHighAmp;

LEsigStimID = LEdata.RFcorrSigPerms;
REsigStimID = REdata.RFcorrSigPerms;

faceColors = [
    0 0 1;
    0 0.6 0.2;
    0.7 0 0.7];
%%
fg = figure(2);
clf
pos = fg.Position;
fg.Position = [pos(1) pos(2) 1200 1200];
% fg.InnerPosition = [60 1 1500 1500];

st = suptitle(sprintf('%s %s preferred RF for na',REdata.animal, REdata.array));
st.Position(2) = st.Position(2) + 0.035;
% st.Position(1) = st.Position(1) - 0.05;
for ch = 1:96
    
    sp = subplot(amap,10,10,ch);
    sp.Position(3) = 0.065;
    sp.Position(4) = 0.065;
    hold on
    box off
    %
    %     LE = numLE(ch);
    %     RE = numRE(ch);
    
    RFle = find(LEsigStimID(:,ch) == 1);
    RFre = find(REsigStimID(:,ch) == 1);
    
    if length(RFle) == 1
        %         if RFle == 1
        patch(xLE,yLE,faceColors(RFle,:),'FaceAlpha',0.5)
        %         end
    end
    
    if length(RFre) == 1
        %         if RFle == 1
        patch(xRE,yRE,faceColors(RFre,:),'FaceAlpha',0.5)
    end
    
    axis square
    axis off
    axis tight
end