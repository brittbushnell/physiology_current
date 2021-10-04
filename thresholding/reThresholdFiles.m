clear
close all
clc
tic
%%
animal = 'XT';
prog = { % which file types do you want to run? Case doesn't matter in this scenario
   'gratings'
    };
%%

for a = 1:2 % arrays
    %%
    if a == 1
        array = 'nsp2';
    else
        array = 'nsp1';
    end
    dataDir = sprintf('/v/awake/%s/recordings/%sRaw/',animal, array);
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
end