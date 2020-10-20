function [rfQuadrant,rfParams, inStim] = getRFsinStim(dataT)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
%
% TO DO:
%    - for each quadrant add in the proportion of those channels that
%    prefer radial or concentric

%%
glassX = unique(dataT.pos_x);
glassY = unique(dataT.pos_y);
rfParams = dataT.chReceptiveFieldParams;

if glassX ~= 0
    glassX2 = glassX - glassX;
    for ch = 1:96
        rfParams{ch}(1) = rfParams{ch}(1) - glassX;
    end
else
    glassX2 = glassX;
end

if glassY ~= 0
    glassY2 = glassY - glassY;
    for ch = 1:96
        rfParams{ch}(2) = rfParams{ch}(2) - glassY;
    end
else
    glassY2 = glassY;
end
%% make dummy plot to get stimulus bounds
location = determineComputer;
if length(dataT.inStim) > 96 % running on a single session rather than merged data
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/%s/singleSession/ch/',dataT.animal,dataT.programID, dataT.array, dataT.eye);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/%s/singleSession/ch/',dataT.animal, dataT.programID, dataT.array, dataT.eye);
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/%s/ch/',dataT.animal,dataT.programID, dataT.array, dataT.eye);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/%s/ch/',dataT.animal, dataT.programID, dataT.array, dataT.eye);
    end
end
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
figure(80)
vs = viscircles([0,0],4,...
    'color',[0.6 0.6 0.0]);
xlim([-10,10])
ylim([-10,10])

%close(figure(80)) % don't actually need to see it, just want to have the vs info

%% determine what quadrant of the stimulus the receptive field is in

% glassAngles = 1 means the receptive field is in either top right or
% bottom left quadrants. Here, the local orientations from the radial
% patterns are 45 and 225.

% glassAngles = 2 means the receptive field is in either the top left or
% bottom right quadrants. Here, the local orientations from the radial
% patterns are 135 and 315.
%
%  Quadrants:        2 | 1
%                   -------
%                    3 | 4
%

stimX = vs.get.Children(2).XData;
stimY = vs.get.Children(2).YData;

rfQuadrant = nan(1,96);
inStim = zeros(1,96);

for ch = 1:96
    rfX = rfParams{ch}(1);
    rfY = rfParams{ch}(2);
    %fprintf('ch %d (%.1f, %.1f)\n', ch, rfX, rfY)
    
    if rfX > 0
        if rfY > 0  % RF is in the top right quadrant (+,+)
            rfQuadrant(ch) = 1;
        else % bottom right (+,-)
            rfQuadrant(ch) = 4;
        end
    else
        if rfY > 0  % RF is in the top left quadrant (-,+)
            rfQuadrant(ch) = 2;
        else % bottom left (-,-)
            rfQuadrant(ch) = 3;
        end
    end
    fprintf('ch %d quadrant %d   (%.1f, %.1f)\n',ch, rfQuadrant(ch), rfX, rfY)
end
dataT.rfQuadrant = rfQuadrant;
%% determine what is and is not in the circle
stimX = [4, -4, 2];
stimY = [4, -4, -2]; 

for ch = 1:96
    rfX = rfParams{ch}(1);
    rfY = rfParams{ch}(2);
    isIn = iscircle(stimX,stimY,rfX,rfY); % 0 = in, 1 = on line, -1 = out
    if isIn == -1
        inStim(1,ch) = 0;
    else
        inStim(1,ch) = 1;
    end
end
