clear all
close all
clc
tic
%%  Progress notes

% WU nsp2 mapping - Laca crashed while running, so will need to complete it.



%%
animal = 'WV';
mountMtx = {
    'vnlstorage';
    'vnlstorage2';
    'vnlstorage3';
            };
        
progType = 'TR'; % which file types do you want to run? Case doesn't matter in this scenario
%%
for mt = 1:length(mountMtx)
    mount = mountMtx{mt};
    for a = 1:2 % arrays
        %%
        if a == 1
            array = 'nsp2';
        else
            array = 'nsp1';
        end
        dataDir = sprintf('/mnt/%s/bushnell_arrays/%s/%s_blackrock/%s/',mount,array,array,animal);
        %cd '/km/vs/array/bushnell_arrays/nsp1/nsp1_blackrock/XT'
        cd(dataDir)
        %%
        files = {};
        tmpDir = dir;
        ndx = 1;
        for i = 1:length(tmpDir)
            fname = tmpDir(i).name;
            if contains(fname,progType,'IgnoreCase',true)
                if contains(fname,'.nev') % doesn't matter which of the files, going to strip the end
                    fname = strrep(fname,'.nev','');
                    files{ndx} = fullfile(dataDir,fname);
                    ndx = ndx+1;
                end
            end
        end
        %%
        files(contains(files,'Bar')) = [];
        files(contains(files,'test')) = [];
        files(contains(files,'BE')) = [];
        
        %%
        %threshold = 3.5;
        reThreshold(files);
    end
end