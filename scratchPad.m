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
    tmpFile = files{f};
    fid = fopen(tmpFile,'r');
    while (~feof(fid)) % not end of file
        line = fgetl(fid);
        % find the x and y values of the psychometric curve
        if contains(line, 'SE(Y)')
            
        end
    end
end
