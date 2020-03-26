function [dirPref,orisel,dirsel] = GetOriTuneStats(theta,rho)

if nargin==0
    test
    return
end

%%% Taken from pepini/oritun.m, shooner %%%

% function [oripref, dirpref, orisel, dirsel] = oritun(theta,rho)
% output = [oripref, dirpref, orisel, dirsel];

% theta is passed in degrees
srho = sum(rho);

% convert theta, rho to x and y
[cx,cy] = pol2cart(deg2rad(theta), rho);

% sum up the vectors
sx = sum(cx);
sy = sum(cy);
[vtheta, vrho] = cart2pol(sx, sy);

% vtheta is dir of vector sum
vtheta = rad2deg(vtheta);
dirPref = mod(vtheta,360);
% pref =mod(vtheta,360);

% directionality is the length of the summed vector 
%    over the total response sum
direct = vrho / srho;


% STRETCH AROUND 360 TWICE AND DO AGAIN
theta = mod((theta.*2),360);
th = mod(theta,360);
[cx,cy] = pol2cart(deg2rad(th), rho);
sx = sum(cx);
sy = sum(cy);
[vtheta, vrho] = cart2pol(sx, sy);
vtheta = rad2deg(vtheta);
pref = vtheta/2;
oriwid = vrho / srho;

dirsel = direct;
orisel = oriwid;
oriPref = mod(pref,180);

if orisel>dirsel
    dirPref = oriPref;
end


function test

ori = 20:20:360;
r = zeros(1,numel(ori));
% r = ones(1,numel(ori));
r(1) = 10;
r(10) = 10;

[dirPref,orisel,dirsel] = GetOriTuneStats(ori,r)