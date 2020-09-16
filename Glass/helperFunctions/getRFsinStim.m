function [rfQuadrant] = getRFsinStim(dataT)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
%
% TO DO:
%    - limit to receptive fields within the stimulus boundaries
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

% glassLeft   = glassX2 - 4;
% glassRight  = glassX2 + 4;
% glassTop    = glassY2 + 4;
% glassBottom = glassY2 - 4;
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

rfQuadrant = nan(1,96);
for ch = 1:96
    rfX = rfParams{ch}(1);
    rfY = rfParams{ch}(2);
    %fprintf('ch %d (%.1f, %.1f)\n', ch, rfX, rfY)
    
    if rfX > 0
        if rfY > 0  % RF is in the top right quadrant
            if abs(rfX) < 4 && abs(rfY) <4
                rfQuadrant(ch) = 1;
            end
        else % bottom right
            if abs(rfX) < 4 && abs(rfY) <4
                rfQuadrant(ch) = 4;
            end
        end
    else
        if rfY > 0  % RF is in the top left quadrant
            if abs(rfX) < 4 && abs(rfY) <4
                rfQuadrant(ch) = 2;
            end
        else % bottom left
            if abs(rfX) < 4 && abs(rfY) <4
                rfQuadrant(ch) = 3;
            end
        end
    end
end
