clear
close all
clc
tic
%%
animal = 'WU';
prog = { % which file types do you want to run? Case doesn't matter in this scenario
    'edge'
    };
%%
failNdx = 0;
for a = 1:2 % arrays
    try
        %%
        if a == 1
            array = 'nsp2';
        else
            array = 'nsp1';
        end
        dataDir = sprintf('/km/gr/awake/%s/recordings/%sRaw/',animal, array);
        %             dataDir = sprintf('/km/gr/awake/%s/recordings/%sReThreshold/gratingsAndEdges/%s/',animal, array,eye);
        cd(dataDir)
        %%
        files = {};
        tmpDir = dir;
        ndx = 1;
        for i = 1:length(tmpDir)
            fname = tmpDir(i).name;
            if contains(fname,prog,'IgnoreCase',true)
                if contains(fname,'.nev') % doesn't matter which of the files, going to strip the end
                    fname = strrep(fname,'.nev','');
                    files{ndx} = fullfile(dataDir,fname);
                    ndx = ndx+1;
                end
            end
        end
        files = files';
        
        %%
        files(contains(files,'Bar')) = [];
        files(contains(files,'test')) = [];
        files(contains(files,'BE')) = [];
        %%
        %threshold = 3.5;
        reThreshold(files);
    catch ME
        failNdx = failNdx+1;
        failedFiles{failNdx} = ME;
        fprintf('%s failed\n\n',fname)
    end
end
% end