% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.

clear
close all
clc
location = determineComputer;
%%
ndx = 1;
files = {};
for an = 1:3
    if an == 1
        monk = 'WU';
    elseif an == 2
        monk = 'WV';
    else
        monk = 'XT';
    end
    for ey = 1:2
        if ey == 1
            eye = 'LE';
        else
            eye = 'RE';
        end
        for ar = 1:2
            if ar == 1
                area = 'V4';
            else
                area = 'V1';
            end
            %%
            if location == 0
                dataDir = sprintf('~/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            else
                dataDir = sprintf('/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            end
            cd(dataDir);
            tmp = dir;
            %%
            for t = 1:size(tmp,1)
                if contains(tmp(t).name,'.mat')
                    files{ndx,1} = tmp(t).name;
                    ndx = ndx+1;
                end
            end
        end
    end
end