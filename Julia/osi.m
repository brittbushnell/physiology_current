function [OSI, DSI] = osi(zz, x)
% The reference here is Ringach, Hawken, Shapley (1997) Nature
% Worth checking I implemented this right.
% input:
%       zz = matrix of response values.
%       y = vector of orientations, in degrees
% Output:
% OSI, DSI (from circular variance)

if(size(zz,1) > size(zz,2))
    zz = zz';
end

x = x/180 * pi;

j  = sqrt(-1);
OSI = abs( sum(zz .* exp(j*(2*x))) / sum(zz) );
DSI = abs( sum(zz .* exp(j*(1*x))) / sum(zz) );

% x = 0:15:345;
% x = x/180 * pi;
% xx = repmat(x, [14 1]);
% y = 0:13;
% yy = repmat(y', [1 24]);
% [~, ii] = max(zz(:));
% [iy, ix] = ind2sub(size(zz), ii);
% base = min(zz(:));
% zz = zz - base;
% j = sqrt(-1);
% optimal_ori = sum(zz(iy,:) .* exp(j*(2*xx(iy,:))));
% OSI = abs(sum(zz(iy,:) .* exp(j*(2*xx(iy,:))))) / sum(zz(iy,:));
% DSI = abs(sum(zz(iy,:) .* exp(j*(1*xx(iy,:))))) / sum(zz(iy,:));