function [dataT] = getReceptiveFields(dataT)

%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Mapping/%s/RFMaps/',dataT.animal,dataT.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/Mapping/%s/RFmaps/',dataT.animal,dataT.array);
end
cd(figDir)

% go to date specific folder, if it doesn't exist, make it
folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))
%%
fixX = double(unique(dataT.fix_x));
fixY = double(unique(dataT.fix_y));
xPos = double(unique(dataT.pos_x));
yPos = double(unique(dataT.pos_y));

% adjust locations so they are relative to fixation, not to the center of the monitor (as they were in MWorks)
% graphically, this will make it so fixation is always at origin, and you can get
% a better sense of the actual eccentricies of the receptive fields.

if fixX ~= 0
    xPosRelFix = xPos-fixX;
else
    xPosRelFix = xPos;
end

if fixY ~= 0
    yPosRelFix = yPos-fixY;
else
    yPosRelFix = yPos;
end
%yPos = sort(yPos,'descend');

numXs = length(xPos);
numYs = length(yPos);
%%
if contains(dataT.programID,'grat','IgnoreCase',true)
    stimNdx  = dataT.spatial_frequency ~=0;
    blankNdx = dataT.spatial_frequency == 0;
else
    stimNdx = (dataT.stimulus == 1);
    blankNdx = (dataT.stimulus == 0);
end

for ch = 1:96
    for y = 1:numYs
        for x = 1:numXs
            xNdx = (dataT.pos_x == xPos(x));
            yNdx = (dataT.pos_y == yPos(y));
            blankResp(y,x,ch,:) = mean(smoothdata(dataT.bins(blankNdx, 1:35 ,ch),'gaussian',3))./0.01;
            stimResp(y,x,ch,:) = mean(smoothdata(dataT.bins(stimNdx & xNdx & yNdx, 1:35 ,ch),'gaussian',3))./0.01;
        end
    end
end

%% Get receptive field information
arrayRF = mean(dataT.locStimResps,3);
[params,rhat,errorsum,fullArray] = fit_gaussianrf(xPosRelFix,yPosRelFix,arrayRF);


for ch = 1:96
    chResps = squeeze(dataT.locStimResps(:,:,ch));
    [params,rhat,errorsum,cf] = fit_gaussianrf(xPosRelFix,yPosRelFix,chResps);
    chFit{ch} = cf.paramsadj;
end
%%
dataT.chReceptiveFieldParams = chFit;
dataT.arrayReceptiveFieldParams = fullArray.paramsadj;
dataT.xPosRelFix = xPosRelFix;
dataT.yPosRelFix = yPosRelFix;