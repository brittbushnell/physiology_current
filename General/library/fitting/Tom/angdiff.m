%ANGDIFF   Caclulates angular difference
%
%   This function calculates the smallest (sharpest) angle between two
%   angles.
%
% INPUT: 2 required arguments
%
%   [...] = angdiff(ang1 , ang2)
%       ang1 and ang2 are angles in degrees.
%
% OUTPUT: 1 required argument.
%
%   [Out1] = angdiff(...)
%
%   V0: TvG Nov 2014, NYU
%   V1: TvG Apr 2015, NYU: made multi dimensional possible.


function out = angdiff(ang1,ang2)

U = [cosd(ang1(:)) sind(ang1(:))];
V = [cosd(ang2(:)) sind(ang2(:))];

out = acosd(dot(U,V,2)./(hypot(U(:,1),U(:,2)).*(hypot(V(:,1),V(:,2)))));

out = reshape(out,size(ang1));
end
