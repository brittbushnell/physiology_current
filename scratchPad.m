% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;
%%
chRanks = nan(3,96);
prefParams = trLE.prefParamsIndex;
for ch = 1:96
    chRanks(:,ch) = crLE.dPrimeRankBlank{prefParams(ch)}(:,ch);
end