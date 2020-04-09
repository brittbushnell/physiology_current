function out = absdeg(in)

%ABSDEG     absolute value of angles
%
%   ABSDEG(X) Converts negative angles (X) to positive angles based on cirle. 
%   Angles >360 are reduced to smallest angle.
%
%   e.g.
%       ABSDEG
%   
% V0: TvG Nov 2013, NYU
% V1: TvG Mar 2016, NYU: used mod 

out         = mod(in,360);
%out         = in;
%sel         = in<0;
%out(sel)    = 360+in(sel);
% sel         = in>=360;
% out(sel)    = in(sel)-360;
