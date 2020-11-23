% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%
files = {    
'XT_LE_mapNoiseRight_nsp1_20181105_003_thresh35_ogcorrupt_info3';
    'XT_LE_mapNoiseRight_nsp1_20181105_004_thresh35_ogcorrupt_info3';
    'XT_LE_mapNoiseRight_nsp1_20181120_001_thresh35_ogcorrupt_info3';
    'XT_LE_mapNoiseRight_nsp1_20181120_002_thresh35_ogcorrupt_info3';
    'XT_LE_mapNoiseRight_nsp1_20181120_003_thresh35_ogcorrupt_info3';
    'XT_LE_mapNoiseRight_nsp1_20181127_001_thresh35_ogcorrupt_info3';
    'XT_LE_mapNoise_nsp1_20181025_001_thresh35_ogcorrupt_info3';     
    'XT_RE_mapNoiseLeft_nsp1_20181026_001_thresh35_ogcorrupt_info3'; 
    'XT_RE_mapNoiseRight_nsp1_20181026_001_thresh35_ogcorrupt_info3';
    'XT_RE_mapNoiseRight_nsp1_20181026_003_thresh35_ogcorrupt_info3';
    'XT_RE_mapNoiseRight_nsp1_20181119_001_thresh35_ogcorrupt_info3';
    'XT_RE_mapNoise_nsp1_20181024_004_thresh35_ogcorrupt_info3';     
    'XT_LE_mapNoiseRight_nsp2_20181105_003_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181105_004_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181120_001_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181120_002_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181120_003_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181127_001_thresh35_info3';          
    'XT_LE_mapNoise_nsp2_20181023_002_thresh35_info3';               
    'XT_LE_mapNoise_nsp2_20181025_001_thresh35_info3';               
    'XT_LE_mapNoise_nsp1_20181023_001_thresh35_info3';               
    'XT_LE_mapNoise_nsp1_20181023_002_thresh35_info3';               
    'XT_RE_mapNoiseLeft_nsp2_20181026_001_thresh35_info3';           
    'XT_RE_mapNoiseRight_nsp2_20181026_001_thresh35_info3';          
    'XT_RE_mapNoiseRight_nsp2_20181026_003_thresh35_info3';          
    'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35_info3';          
    'XT_RE_mapNoise_nsp2_20181024_001_thresh35_info3';               
    'XT_RE_mapNoise_nsp2_20181024_002_thresh35_info3';               
    'XT_RE_mapNoise_nsp2_20181024_003_thresh35_info3';               
    'XT_LE_mapNoiseRight_nsp2_20181105_003_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181105_004_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181120_001_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181120_002_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181120_003_thresh35_info3';          
    'XT_LE_mapNoiseRight_nsp2_20181127_001_thresh35_info3';          
    'XT_LE_mapNoise_nsp1_20181023_001_thresh35_info3';               
    'XT_LE_mapNoise_nsp1_20181023_002_thresh35_info3';               
    'XT_LE_mapNoise_nsp2_20181023_002_thresh35_info3';               
    'XT_LE_mapNoise_nsp2_20181025_001_thresh35_info3';               
    'XT_RE_mapNoiseLeft_nsp2_20181026_001_thresh35_info3';           
    'XT_RE_mapNoiseRight_nsp2_20181026_001_thresh35_info3';          
    'XT_RE_mapNoiseRight_nsp2_20181026_003_thresh35_info3';          
    'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35_info3';          
    'XT_RE_mapNoise_nsp1_20181024_001_thresh35_info3';               
    'XT_RE_mapNoise_nsp1_20181024_002_thresh35_info3';               
    'XT_RE_mapNoise_nsp1_20181024_003_thresh35_info3';               
    'XT_RE_mapNoise_nsp2_20181024_001_thresh35_info3';               
    'XT_RE_mapNoise_nsp2_20181024_002_thresh35_info3';               
    'XT_RE_mapNoise_nsp2_20181024_003_thresh35_info3';                    
    };
for fi = 1:length(files)
     load(files{fi});
     
     if contains(files{fi},'LE')
         dataT = data.LE;
     else
         dataT = data.RE;
     end
     
     info.date{fi} = dataT.date2;
     info.run{fi} = dataT.runNum;
     info.eye{fi} = dataT.eye;
     info.xp{fi,:} = unique(dataT.pos_x);
     info.yp{fi,:} = unique(dataT.pos_y);
end
    
    