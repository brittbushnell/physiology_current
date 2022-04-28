cd '/Local/Users/bushnell/Dropbox/behavior/Peripho/XT/1019/LE1019'

ndx = 1;
tmpDir = dir;

for i = 1:length(tmpDir)
    fname = tmpDir(i).name;
    if contains(fname,'.fit')
        if ~contains(fname,'foo')
        files{ndx} = fullfile(pwd,fname);
        ndx = ndx+1;
        end
    end
end
%%

for f = 1%:length(files)
    fid = fopen(files{f},'r')
    
    
end
