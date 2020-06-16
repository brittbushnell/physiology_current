clear all
close all
clc
%%
files = {
    %'WU_RE_Glass_nsp2_20170818_002';
    %'WU_RE_Glass_nsp2_20170818_001';
    %'WU_RE_Glass_nsp1_20170818_002'; can't run
    'WU_RE_Glass_nsp1_20170818_001';
    'WU_LE_GlassTR_nsp1_20170825_002';
    };
%%
for fi = 1:size(files,1)
    filename = files{fi};
    fprintf('*** running file %s ***\n %d/%d ',filename,fi,size(files,1))
    threshold = 3.5;
    if contains(filename,'nsp1')
        array = 'nsp1';
    else
        array = 'nsp2';
    end
    ns6 = sprintf('/km/vs/array/bushnell_arrays/%s/%s_blackrock/WU/%s.ns6',array,array,filename);
    nev = sprintf('/km/vs/array/bushnell_arrays/%s/%s_blackrock/WU/%s.nev',array,array,filename);
    
    for thresh = 1:length(threshold)
        output = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/%s_thresh%.1f',array,filename,threshold(thresh));
        car_nsx(nev,ns6,output,threshold(thresh));
        
    end
end