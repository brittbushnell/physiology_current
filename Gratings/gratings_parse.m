clear
close all
clc
%%
files = {
    'WU_RE_GratingsCon_nsp2_20170809_003_thresh35'
    };
%%

for fi = 1:length(files)
    filename = files{fi};
    fprintf('\n**** Parsing grating data %s file number %d/%d**** \n', filename, fi,length(files))
    load(filename)
  
end