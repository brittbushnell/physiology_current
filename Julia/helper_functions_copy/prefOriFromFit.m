function [prefOri, prefDir] = prefOriFromFit(sc1, sc2, mux)
% Inputs:
%   - sc1 = scaling factor for one direction
%   - sc2 = scaling factor for other direction
%   = mux = peak orientation

pk = mux / pi * 180;                % convert back to degrees from radians used in fitting
if sc1 >= sc2
    prefDir = pk;
else
    prefDir = pk + 180;
end

prefOri     = mod(prefDir, 180);
prefDir     = round(prefDir);
prefOri     = round(prefOri);
