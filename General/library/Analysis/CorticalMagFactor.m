function mmPerDeg = CorticalMagFactor(ecc)
% mmPerDeg = CorticalMagFactor(ecc)
% Cortical magnification factor for eccentricity ecc (in degrees)
% from
% Dow, Snyder, Vautin and Bauer (1981)
% Magnification Factor and Receptive Field Size in Foveal Striate Cortex of the Monkey
% Experimental Brain Research 44:213-228

mmPerDeg = 1./(10.^(0.8124 + 0.5324.*(log10(ecc*60)-1.5) + ...
    0.0648.*(log10(ecc*60)-1.5).^2 + 0.0788.*(log10(ecc*60)-1.5).^3)./60);

