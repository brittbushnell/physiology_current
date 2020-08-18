%%
files = {
    'WU_RE_GlassTR_nsp2_20170829_001_s1_Permutations500';...
    'WU_RE_GlassTR_nsp2_20170828_003_s1_Permutations500';...
    'WU_RE_GlassTR_nsp2_20170828_002_s1_Permutations500';...
    'WU_RE_GlassTR_nsp2_20170825_001_s1_Permutations500';...
    
    'WU_LE_GlassTR_nsp2_20170825_002_s1_Permutations500';...
    'WU_LE_GlassTR_nsp2_20170824_001_s1_Permutations500';...
    };
%%

for fi = 1:size(files,1)
    %% Get basic information about experiments

        load(files{fi});
        filename = files{fi};
        fprintf('\n*** analyzing %s \n*** file %d/%d \n', filename,fi,size(files,1))
        
        if contains(filename,'RE')
            dataT = data.RE;
        else
            dataT = data.LE;
        end
        close all
        plotGlassPSTHs_Latency_AllStim(dataT)

end