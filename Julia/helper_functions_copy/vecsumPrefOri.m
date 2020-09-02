function prefOri = vecsumPrefOri(theta, oriRate)
% returns the preferred orientation indegrees as determined through component vector
% analysis.
% Inputs:
%       - theta -- vector of orientations sampled in degrees
%       - oriRate -- mean response at that orientation.

x = oriRate .* cosd(2*theta);           % x-coord on polar plot
y = oriRate .* sind(2*theta);           % y-coord on polar plot
xMean = mean(x);
yMean = mean(y);
prefOri = atan2d(yMean,xMean)/2;        % returns angle of resulting vector in degrees
if prefOri<0
    prefOri = prefOri + 180;
end
