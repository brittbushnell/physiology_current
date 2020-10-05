% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;
%%
monks = {
 %   'WU';
     'WV';
%     'XT';
    };
ez = {
   % 'LE';
    'RE';
    };
brArray = {
  'V4';
  % 'V1';
    };
%%
nameEnd = 'info';
numPerm = 2000;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
for an = 1:length(monks)
    monk = monks{an};
    for ey = 1:length(ez)
        eye = ez{ey};
        for ar = 1:length(brArray)
            area = brArray{ar};
            %%
            if location == 0
                dataDir = sprintf('~/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            else
                dataDir = sprintf('/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            end
            cd(dataDir);
            
            tmp = dir;
            ndx = 1;
            corNdx = 1;
            filesT = {};
            filesC = {};
            %%
            for t = 1:size(tmp,1)
                if contains(tmp(t).name,'.mat')
                    if strcmp(tmp(t).name,'WU_LE_GlassTR_nsp2_20170822_002_thresh35.mat')
                    elseif contains(tmp(t).name,'_og')
                        % make a list of all of the files that have
                        % been realigned
                        filesC{corNdx,1} = tmp(t).name;
                        corNdx = corNdx+1;
                    else
                        % list of un-aligned files
                        filesT{ndx,1} = tmp(t).name;
                        ndx = ndx+1;
                    end
                end
            end
            
            for c = 1:length(filesC)
                shortName = strrep(filesC{c,1},'_ogcorrupt','');
                %remove from the list any _thresh35 files that were
                %later realigned.  No reason to run through everything
                %on all of them.
                filesT(strcmp(shortName,filesT)) = [];
            end
            
            files = cat(1,filesC,filesT);
            
            if location == 0
                listDir ='~/Dropbox/ArrayData/matFiles/reThreshold/listMatrices/Glass/';
            else
                listDir = '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/listMatrices/Glass/';
            end
            
            mtxSaveName = [listDir,monk,'_',eye,'_',area,'_Glass_','FileList.mat'];
            save(mtxSaveName,'files')
            
            clear tmp
            clear ndx
        end
    end
end

files