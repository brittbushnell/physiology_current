function [prefOri,vectAngle] = getPrefOriVectAngle(oriTune)
% GETPREFORIVECTANGLE [prefOri,vectAngle] = getPrefOriVectAngle(oris)
% is a function that determines the preferred orientation of a channel
% based on the summed vector angles. 
%
% INPUT
%   Orientation matrix - may be either 0:180 or 0:360, orientation should
%   be in degrees
%
% OUTPUT
%   Preferred orientation in degrees.  Arc tangent of the sum of the vector
%   angles
%   vectAngle is a matrix with rows:
%      1) Orientations presented
%      2) Cosine * firing rate
%      3) Sine * firing rate
%      4) Sum of row 2
%      5) Sum or row 3
%
%  Written November 8, 2017 Brittany Bushnell

numOris = size(oriTune,2);
vectAngle = nan(3,numOris-1);
vectAngle(1,:) = oriTune(1,1:end-1);

for or = 1:numOris - 1;
    if or == 1 % combie 0 and 180 since they're the same stimulus.
        FR = mean([oriTune(3,1),oriTune(3,end)]);
    else
        FR = oriTune(3,or);
    end
    theta = oriTune(1,or);
    
    vectAngle(2,or) = FR * cosd(theta*2);        % x = FRa(COSa)
    vectAngle(3,or) = FR * sind(theta*2);        % y = FRa(SINa)
end

xSum = sum(vectAngle(2,:));
ySum = sum(vectAngle(3,:));

prefOri = atan2d(ySum,xSum);
if prefOri < 0
    prefOri =  + 180;
end