% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;
%%
rfParams = dataT.rfParams;

stimX = [4, -4, 2];
stimY = [4, -4, -2]; 

for ch = 1:96
    rfX = rfParams{ch}(1);
    rfY = rfParams{ch}(2);
    isIn = iscircle(stimX,stimY,rfX,rfY); % 0 = in, 1 = on line, -1 = out
    if isIn == -1
        inStim(1,ch) = 0;
    else
        inStim(1,ch) = 1;
    end
end
