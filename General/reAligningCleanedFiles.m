clear all
close all
clc
tic
%%
files = {
    %% glass patterns
    %'WU_LE_GlassTR_nsp2_20170822_002_thresh35.mat'; % for some reason the orienations are 0 and 1 - look into it in the parser.
    
    'WV_LE_glassCoh_nsp1_20190402_002_thresh35'
    'WV_LE_glassCoh_nsp1_20190402_003_thresh35'
    'WV_LE_glassCoh_nsp1_20190403_002_thresh35'
    'WV_LE_glassCoh_nsp1_20190404_001_thresh35'
    
    'WV_RE_glassCoh_nsp1_20190404_002_thresh35'
    'WV_RE_glassCoh_nsp1_20190404_003_thresh35'
    'WV_RE_glassCoh_nsp1_20190405_001_thresh35'
    
    'WV_LE_glassCohSmall_nsp1_20190425_002_thresh35'
    'WV_LE_glassCohSmall_nsp1_20190429_001_thresh35'
    'WV_LE_glassCohSmall_nsp1_20190429_002_thresh35'
    'WV_RE_glassCohSmall_nsp1_20190423_001_thresh35'
    'WV_RE_glassCohSmall_nsp1_20190423_002_thresh35'
    'WV_RE_glassCohSmall_nsp1_20190424_001_thresh35'
    
    'WV_LE_glassTRCoh_nsp1_20190411_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190412_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190415_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190415_003_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190416_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190416_002_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190416_003_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190417_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190417_002_thresh35'
    
    'WV_RE_glassTRCoh_nsp2_20190405_002_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190408_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190409_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190409_002_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190410_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190410_002_thresh35'
    
    'WV_LE_glassTRCohSmall_nsp1_20190429_003_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190429_004_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190430_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190430_002_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190430_003_thresh35'
    
    
    'XT_LE_Glass_nsp2_20190123_001_thresh35'
    'XT_LE_Glass_nsp2_20190124_001_thresh35'
    'XT_LE_Glass_nsp2_20190124_002_thresh35'
    'XT_LE_Glass_nsp2_20190124_003_thresh35'
    
    'XT_RE_Glass_nsp2_20190123_005_thresh35'
    'XT_RE_Glass_nsp2_20190123_006_thresh35'
    'XT_RE_Glass_nsp2_20190123_007_thresh35'
    'XT_RE_Glass_nsp2_20190123_008_thresh35'
    'XT_RE_Glass_nsp2_20190124_005_thresh35'
    
    'XT_RE_GlassCoh_nsp1_20190321_002_thresh35'
    
    'XT_LE_GlassCoh_nsp2_20190324_005_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_001_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_002_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_004_thresh35'
    
    'XT_RE_GlassCoh_nsp2_20190322_001_thresh35'
    
    'XT_LE_GlassTR_nsp1_20190130_001_thresh35'
    'XT_LE_GlassTR_nsp1_20190130_002_thresh35'
    'XT_LE_GlassTR_nsp1_20190130_003_thresh35'
    'XT_LE_GlassTR_nsp1_20190130_004_thresh35'
    
    'XT_RE_GlassTR_nsp2_20190125_001_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_002_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_003_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_004_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_005_thresh35'
    'XT_RE_GlassTR_nsp2_20190128_001_thresh35'
    'XT_RE_GlassTR_nsp2_20190128_002_thresh35'
    
    'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35'
    
    'XT_RE_GlassTRCoh_nsp2_20190322_002_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190322_003_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190322_004_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_002_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_003_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_004_thresh35'
    };
%%
for fi = 1:length(files)
    
    nev = string(files{fi});
    fprintf('\nRunning %s file %d/%d\n', nev,fi,length(files))
    
    short_name = strrep(nev,'_thresh35','');
    file_info = strsplit(short_name,'_');
    short_name = char(short_name);
    cleanDir = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/png/%s/%s/',file_info(4),file_info(1),file_info(2));
    
    date = str2double(file_info(5));
    if contains(file_info(1),'WU')
        blackrockDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
    elseif contains(file_info(1),'XT')
        if date <= 20190131
            blackrockDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        else
            blackrockDir = sprintf('/mnt/vnlstorage2/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        end
    elseif contains(file_info(1),'WV')
        if date <= 20190130
            blackrockDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        elseif date > 20190130 && date <= 20191603
            blackrockDir = sprintf('/mnt/vnlstorage2/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        else
            blackrockDir = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        end
    end
    
    
    cleaned_nev = fullfile(cleanDir,char(nev));
    cleaned_nev = [cleaned_nev,'.nev'];
    nsx_filename = fullfile(blackrockDir,short_name);
    nsx_filename = [nsx_filename,'.ns6'];
    
    nev_filename = fullfile(blackrockDir,short_name);
    nev_filename = [nev_filename,'.nev'];
    
    corruptednsx_cleanup(nev_filename,nsx_filename,cleaned_nev)
    
    fprintf('aligned %d/%d files\n',fi,length(files))
    clear nev_filename
    clear nsx_filename
end
toc/60


%%








