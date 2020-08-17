clear 
clc

monk = {'WU'; 'WV';'XT'};

ndx = 1;
fNdx = 0;
for a = 1:3
    try
    animal = monk{a};
    for e = 1:2
        if e == 1
            eye = 'LE';
        else
            eye = 'RE';
        end
        useDir = sprintf('/Users/brittany/Dropbox/ArrayData/matFiles/reThreshold/png/%s/V4/Glass/%s',animal,eye);
        cd(useDir)
        
        files = {};
        tmpDir = dir;
        ndx = 1;
        
        for i = 1:length(tmpDir)
            fname = tmpDir(i).name;
            if contains(fname,animal,'IgnoreCase',true)
                load(fname)
                
                for l = 1:size(filename,1)
                    [type, numDots, dx, coh, sample] = parseGlassName(filename(l,:));
                    
                    %  type: numeric versions of the first letter of the pattern type
                    %     0:  noise
                    %     1: concentric
                    %     2: radial
                    %     3: translational
                    %     100:blank
                    type(1,ndx)    = type;
                    numDots(1,ndx) = numDots;
                    dx(1,ndx)      = dx;
                    coh(1,ndx)     = coh;
                    sample(1,ndx)  = sample;
                    ndx = ndx+1;
                end
                stims = unique(type)
                
                if sum(ismember(stims,[1 2 3])) == 3
                    fprintf('%s has all three Glass types \n',fname)
                    all3Files{ndx} = fname;
                    ndx = ndx+1;
                
                end
                
            end
        end
    end
    catch ME
        fNdx = fNdx+1;
        failedFile{fNdx} = ME;
        
    end
end
