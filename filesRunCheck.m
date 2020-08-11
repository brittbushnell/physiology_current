clear
clc
%%
animalMtx = {
%    'WV'; 
%    'WU';
    'XT'
    };

mountMtx = {
    'vnlstorage';
    'vnlstorage2';
%    'vnlstorage3';
    };

progMtx = {
    'map';
    'glass';
    'tr';
    'edge';
    'rad';
    'pas';
    'tex';
    'cont';
    'grat';
    }; % which file types do you want to run? Case doesn't matter in this scenario
%%
for an = 1:length(animalMtx)
    try
    animal = animalMtx{an};
    for pt = 1:length(progMtx)
        progType = progMtx{pt};
        for mt = 1:length(mountMtx)
            mount = mountMtx{mt};
            for a = 1:2 % arrays
                %%
                if a == 1
                    array = 'nsp2';
                else
                    array = 'nsp1';
                end
                %dataDir = sprintf('/mnt/%s/bushnell_arrays/%s/%s_blackrock/%s/',mount,array,array,animal);
                if contains(mount,'2') || contains(mount,'3')
                    dataDir = sprintf('/users/bushnell/Desktop/my_zemina/%s/bushnell_arrays/%s/%s_blackrock/%s/',mount,array,array,animal);
                else
                    dataDir = sprintf('/users/bushnell/Desktop/my_vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
                end
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
            end
            numL = sum(contains(files,'LE'));
            fprintf('%s %d LE %s files in %s %s\n',animal,numL,progType,mount,array)
            
            numR = sum(contains(files,'RE'));
            fprintf('%s %d RE %s files in %s %s\n\n',animal,numR,progType,mount,array)
        end
    end
    catch
        
    end
end