clear
close all
clc
%% RF
 files = {
%     'WU_RE_RadFreqLoc1_nsp2_20170627_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc1_nsp2_20170628_002_thresh35_info.mat';
%     'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc1_nsp1_20170627_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc1_nsp1_20170628_002_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp2_20170703_003_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp2_20170704_005_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp2_20170705_005_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp2_20170706_004_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp2_20170707_002_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170703_003_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170705_005_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170706_004_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170707_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170704_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170704_003_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170705_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170706_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170707_005_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp1_20170705_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp1_20170706_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp1_20170707_005_thresh35_info.mat';
%
%     'WV_LE_RadFreqHighSF_nsp2_20190313_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqHighSF_nsp2_20190313_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqHighSF_nsp2_20190315_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqHighSF_nsp1_20190313_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqHighSF_nsp1_20190315_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqHighSF_nsp1_20190313_001_thresh35_info.mat';
%     'WV_RE_RadFreqHighSF_nsp1_20190315_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqHighSF_nsp1_20190318_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqHighSF_nsp1_20190318_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqHighSF_nsp1_20190319_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqHighSF_nsp1_20190319_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqHighSF_nsp2_20190315_002_thresh35_info.mat';
%     'WV_RE_RadFreqHighSF_nsp2_20190318_001_thresh35_info.mat';
%     'WV_RE_RadFreqHighSF_nsp2_20190318_002_thresh35_info.mat';
%     'WV_RE_RadFreqHighSF_nsp2_20190319_001_thresh35_info.mat';
%     'WV_RE_RadFreqHighSF_nsp2_20190319_002_thresh35_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190328_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190328_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190329_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190329_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190401_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp2_20190402_001_thresh35_ogcorrupt_info.mat'
%     'WV_LE_RadFreqLowSF_nsp1_20190328_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp1_20190328_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp1_20190329_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp1_20190329_002_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp1_20190401_001_thresh35_ogcorrupt_info.mat';
%     'WV_LE_RadFreqLowSF_nsp1_20190402_001_thresh35_ogcorrupt_info.mat'
%     'WV_RE_RadFreqLowSF_nsp2_20190320_001_thresh35_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190321_001_thresh35_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190321_002_thresh35_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190322_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190325_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190325_003_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190327_001_thresh35_info.mat';
%     'WV_RE_RadFreqLowSF_nsp2_20190327_002_thresh35_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190320_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190321_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190321_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190322_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190325_002_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190325_003_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190327_001_thresh35_ogcorrupt_info.mat';
%     'WV_RE_RadFreqLowSF_nsp1_20190327_002_thresh35_ogcorrupt_info.mat'
%
%     'XT_RE_radFreqLowSF_nsp2_20181217_002_thresh35_info.mat';
%     'XT_RE_radFreqLowSF_nsp2_20181217_003_thresh35_info.mat';
%     'XT_RE_radFreqLowSF_nsp2_20181217_004_thresh35_info.mat';
%     'XT_RE_radFreqLowSF_nsp2_20181217_005_thresh35_info.mat';

%     'XT_RE_radFreqLowSF_nsp1_20181217_002_thresh35_ogcorrupt_info.mat';
%     'XT_RE_radFreqLowSF_nsp1_20181217_003_thresh35_ogcorrupt_info.mat';
%     'XT_RE_radFreqLowSF_nsp1_20181217_004_thresh35_ogcorrupt_info.mat';
%     'XT_RE_radFreqLowSF_nsp1_20181217_005_thresh35_ogcorrupt_info.mat';

%     'XT_LE_RadFreqLowSF_nsp2_20181211_001_thresh35_info.mat';
%     'XT_LE_RadFreqLowSF_nsp2_20181211_002_thresh35_info.mat';
%     'XT_LE_RadFreqLowSF_nsp2_20181213_001_thresh35_info.mat';
%     'XT_LE_RadFreqLowSF_nsp2_20181213_002_thresh35_info.mat';

%     'XT_LE_RadFreqLowSF_nsp1_20181211_001_thresh35_ogcorrupt_info.mat';
%     'XT_LE_RadFreqLowSF_nsp1_20181211_002_thresh35_ogcorrupt_info.mat';
%     'XT_LE_RadFreqLowSF_nsp1_20181213_001_thresh35_ogcorrupt_info.mat';
%     'XT_LE_RadFreqLowSF_nsp1_20181213_002_thresh35_ogcorrupt_info.mat';

%     'XT_RE_radFreqHighSF_nsp2_20181227_001_thresh35_info.mat';
%     'XT_RE_radFreqHighSF_nsp2_20181228_001_thresh35_info.mat';
%     'XT_RE_radFreqHighSF_nsp2_20181228_002_thresh35_info.mat';
%     'XT_RE_radFreqHighSF_nsp2_20181231_001_thresh35_info.mat';

% 'XT_RE_radFreqHighSF_nsp1_20181227_001_thresh35_ogcorrupt_info.mat';
'XT_RE_radFreqHighSF_nsp1_20181228_001_thresh35_ogcorrupt_info.mat';
% 'XT_RE_radFreqHighSF_nsp1_20181228_002_thresh35_ogcorrupt_info.mat';
% 'XT_RE_radFreqHighSF_nsp1_20181231_001_thresh35_ogcorrupt_info.mat';

%     'XT_LE_radFreqHighSF_nsp2_20190102_001_thresh35_info.mat';
%     'XT_LE_radFreqHighSF_nsp2_20190102_002_thresh35_info.mat';
%     'XT_LE_radFreqHighSF_nsp2_20190103_001_thresh35_info.mat';
%     'XT_LE_radFreqHighSF_nsp2_20190103_002_thresh35_info.mat';

%     'XT_LE_radFreqHighSF_nsp1_20190102_001_thresh35_ogcorrupt_info.mat';
%     'XT_LE_radFreqHighSF_nsp1_20190102_002_thresh35_ogcorrupt_info.mat';
%     'XT_LE_radFreqHighSF_nsp1_20190103_001_thresh35_ogcorrupt_info.mat';
%     'XT_LE_radFreqHighSF_nsp1_20190103_002_thresh35_ogcorrupt_info.mat';

%     'XT_RE_RadFreqLowSFV4_nsp2_20190228_001_thresh35_info.mat';
%     'XT_RE_RadFreqLowSFV4_nsp2_20190228_002_thresh35_info.mat';
%     'XT_RE_RadFreqLowSFV4_nsp2_20190301_001_thresh35_info.mat';
%     'XT_RE_RadFreqLowSFV4_nsp2_20190301_002_thresh35_info.mat';
%     'XT_RE_RadFreqLowSFV4_nsp2_20190304_001_thresh35_info.mat';

%     'XT_RE_RadFreqLowSFV4_nsp1_20190301_002_thresh35_ogcorrupt_info.mat';
%     'XT_RE_RadFreqLowSFV4_nsp1_20190228_001_thresh35_info.mat';
%     'XT_RE_RadFreqLowSFV4_nsp1_20190228_002_thresh35_info.mat';
%     'XT_RE_RadFreqLowSFV4_nsp1_20190301_001_thresh35_info.mat';
%     'XT_RE_RadFreqLowSFV4_nsp1_20190304_001_thresh35_info.mat';

%     'XT_LE_RadFreqLowSFV4_nsp2_20190226_002_thresh35_info.mat';
%     'XT_LE_RadFreqLowSFV4_nsp2_20190226_003_thresh35_info.mat';
%     'XT_LE_RadFreqLowSFV4_nsp2_20190227_001_thresh35_info.mat';
%     'XT_LE_RadFreqLowSFV4_nsp2_20190227_002_thresh35_info.mat';
%     'XT_LE_RadFreqLowSFV4_nsp2_20190227_003_thresh35_info.mat';

%     'XT_LE_RadFreqLowSFV4_nsp1_20190226_002_thresh35_ogcorrupt_info.mat';
%     'XT_LE_RadFreqLowSFV4_nsp1_20190226_003_thresh35_ogcorrupt_info.mat';
%     'XT_LE_RadFreqLowSFV4_nsp1_20190227_001_thresh35_ogcorrupt_info.mat';
%     'XT_LE_RadFreqLowSFV4_nsp1_20190227_002_thresh35_ogcorrupt_info.mat';
%     'XT_LE_RadFreqLowSFV4_nsp1_20190227_003_thresh35_ogcorrupt_info.mat';

%     'XT_RE_RadFreqHighSFV4_nsp2_20190304_002_thresh35_info.mat';
%     'XT_RE_RadFreqHighSFV4_nsp2_20190305_002_thresh35_info.mat';
%     'XT_RE_RadFreqHighSFV4_nsp2_20190306_001_thresh35_info.mat';
%     'XT_RE_RadFreqHighSFV4_nsp2_20190306_002_thresh35_info.mat';
%     'XT_LE_RadFreqHighSFV4_nsp2_20190306_003_thresh35_info.mat';
%     'XT_LE_RadFreqHighSFV4_nsp2_20190307_001_thresh35_info.mat';

%     'XT_RE_RadFreqHighSFV4_nsp1_20190304_002_thresh35_info.mat';
%     'XT_RE_RadFreqHighSFV4_nsp1_20190305_002_thresh35_info.mat';
%     'XT_RE_RadFreqHighSFV4_nsp1_20190306_001_thresh35_info.mat';
%     'XT_RE_RadFreqHighSFV4_nsp1_20190306_002_thresh35_info.mat';
%     'XT_LE_RadFreqHighSFV4_nsp1_20190307_002_thresh35_info.mat';

%     'XT_LE_RadFreqHighSFV4_nsp2_20190306_003_thresh35_info.mat';
%     'XT_LE_RadFreqHighSFV4_nsp2_20190307_001_thresh35_info.mat';

%     'XT_LE_RadFreqHighSFV4_nsp1_20190306_003_thresh35_ogcorrupt_info.mat';
%     'XT_LE_RadFreqHighSFV4_nsp1_20190307_001_thresh35_ogcorrupt_info.mat';
     };
%% Glass
% files = {
%     'WU_LE_GlassTR_nsp2_20170824_001_thresh35_DxComp';
%     'WU_LE_GlassTR_nsp2_20170825_002_thresh35_DxComp';
%     'WU_LE_GlassTR_nsp1_20170824_001_thresh35_DxComp';
%     'WU_LE_GlassTR_nsp1_20170825_002_thresh35_DxComp';
%     
%     'XT_RE_Glass_nsp1_20190123_007_thresh35_ogcorrupt_info3';
%     'XT_RE_Glass_nsp1_20190124_005_thresh35_ogcorrupt_info3';
%     'XT_RE_Glass_nsp2_20190123_007_thresh35_ogcorrupt_info3';
%     'XT_RE_Glass_nsp2_20190124_005_thresh35_ogcorrupt_info3';
%     'XT_LE_Glass_nsp1_20190124_001_thresh35_ogcorrupt_info3';
%     'XT_LE_Glass_nsp1_20190124_002_thresh35_ogcorrupt_info3';
%     'XT_LE_Glass_nsp1_20190124_003_thresh35_ogcorrupt_info3';
%     'XT_LE_Glass_nsp2_20190124_001_thresh35_ogcorrupt_info3';
%     'XT_LE_Glass_nsp2_20190124_002_thresh35_ogcorrupt_info3';
%     'XT_LE_Glass_nsp2_20190124_003_thresh35_ogcorrupt_info3';
%     'XT_RE_GlassTR_nsp2_20190125_002_thresh35_ogcorrupt_info3';
%     'XT_RE_GlassTR_nsp2_20190125_003_thresh35_ogcorrupt_info3';
%     'XT_RE_GlassTR_nsp2_20190125_005_thresh35_ogcorrupt_info3';
%     'XT_RE_GlassTR_nsp2_20190128_001_thresh35_ogcorrupt_info3';
%     'XT_RE_GlassTR_nsp2_20190128_002_thresh35_ogcorrupt_info3';
%     'XT_LE_GlassTR_nsp1_20190130_001_thresh35_ogcorrupt_info3';
%     'XT_LE_GlassTR_nsp1_20190130_002_thresh35_ogcorrupt_info3';
%     'XT_LE_GlassTR_nsp1_20190130_003_thresh35_ogcorrupt_info3';
%     'XT_LE_GlassTR_nsp1_20190130_004_thresh35_ogcorrupt_info3';
%     'XT_LE_GlassTR_nsp2_20190130_001_thresh35_info3';
%     'XT_LE_GlassTR_nsp2_20190130_002_thresh35_info3';
%     'XT_LE_GlassTR_nsp2_20190130_003_thresh35_info3';
%     'XT_LE_GlassTR_nsp2_20190130_004_thresh35_info3';
%     
%     'WV_LE_glassCoh_nsp1_20190402_002_thresh35_ogcorrupt_info3';
%     'WV_LE_glassCoh_nsp1_20190402_003_thresh35_ogcorrupt_info3';
%     'WV_LE_glassCoh_nsp1_20190403_002_thresh35_ogcorrupt_info3';
%     'WV_LE_glassCoh_nsp2_20190402_002_thresh35_info3';
%     'WV_LE_glassCoh_nsp2_20190402_003_thresh35_info3';
%     'WV_LE_glassCoh_nsp2_20190403_002_thresh35_info3';
%     'WV_RE_glassCoh_nsp2_20190404_002_thresh35_info3';
%     'WV_RE_glassCoh_nsp2_20190404_003_thresh35_info3';
%     'WV_RE_glassCoh_nsp2_20190405_001_thresh35_info3';
%     'WV_RE_glassCoh_nsp1_20190404_002_thresh35_ogcorrupt_info3';
%     'WV_RE_glassCoh_nsp1_20190404_003_thresh35_ogcorrupt_info3';
%     'WV_RE_glassCoh_nsp1_20190405_001_thresh35_ogcorrupt_info3';
%     'WV_LE_glassTRCoh_nsp1_20190411_001_thresh35_ogcorrupt_info3';
%     'WV_LE_glassTRCoh_nsp1_20190412_001_thresh35_ogcorrupt_info3';
%     'WV_LE_glassTRCoh_nsp1_20190415_001_thresh35_ogcorrupt_info3';
%     'WV_LE_glassTRCoh_nsp1_20190415_002_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp1_20190416_001_thresh35_ogcorrupt_info3';
%     'WV_LE_glassTRCoh_nsp1_20190416_002_thresh35_ogcorrupt_info3';
%     'WV_LE_glassTRCoh_nsp1_20190416_003_thresh35_ogcorrupt_info3';
%     'WV_LE_glassTRCoh_nsp1_20190417_001_thresh35_ogcorrupt_info3';
%     'WV_LE_glassTRCoh_nsp1_20190417_002_thresh35_ogcorrupt_info3';
%     'WV_LE_glassTRCoh_nsp2_20190411_001_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp2_20190412_001_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp2_20190415_001_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp2_20190415_002_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp2_20190416_001_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp2_20190416_002_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp2_20190416_003_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp2_20190417_001_thresh35_info3';
%     'WV_LE_glassTRCoh_nsp2_20190417_002_thresh35_info3';
%     'WV_RE_glassTRCoh_nsp1_20190405_002_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp1_20190408_001_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp1_20190409_001_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp1_20190409_002_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp1_20190410_001_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp1_20190410_002_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp2_20190405_002_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp2_20190408_001_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp2_20190409_001_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp2_20190409_002_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp2_20190410_001_thresh35_ogcorrupt_info3';
%     'WV_RE_glassTRCoh_nsp2_20190410_002_thresh35_ogcorrupt_info3';
%     
%     'WU_LE_GlassTR_nsp1_20170824_001_thresh35_info3';
%     'WU_LE_GlassTR_nsp1_20170825_002_thresh35_info3';
%     'WU_LE_GlassTR_nsp2_20170824_001_thresh35_info3';
%     'WU_LE_GlassTR_nsp2_20170825_002_thresh35_info3';
%     'WU_RE_GlassTR_nsp1_20170825_001_thresh35_info3';
%     'WU_RE_GlassTR_nsp1_20170828_002_thresh35_info3';
%     'WU_RE_GlassTR_nsp1_20170828_003_thresh35_info3';
%     'WU_RE_GlassTR_nsp1_20170829_001_thresh35_info3';
%     'WU_RE_GlassTR_nsp2_20170825_001_thresh35_info3';
%     'WU_RE_GlassTR_nsp2_20170828_002_thresh35_info3';
%     'WU_RE_GlassTR_nsp2_20170828_003_thresh35_info3';
%     'WU_RE_GlassTR_nsp2_20170829_001_thresh35_info3';
%     'WU_LE_Glass_nsp1_20170817_001_thresh35_info3';
%     'WU_LE_Glass_nsp1_20170821_002_thresh35_info3';
%     'WU_LE_Glass_nsp1_20170822_001_thresh35_info3';
%     'WU_LE_Glass_nsp2_20170817_001_thresh35_info3';
%     'WU_LE_Glass_nsp2_20170821_002_thresh35_info3';
%     'WU_LE_Glass_nsp2_20170822_001_thresh35_info3';
%     'WU_RE_Glass_nsp1_20170817_002_thresh35_info3';
%     'WU_RE_Glass_nsp1_20170818_001_thresh35_info3';
%     'WU_RE_Glass_nsp1_20170821_001_thresh35_info3';
%     'WU_RE_Glass_nsp2_20170817_002_thresh35_info3';
%     'WU_RE_Glass_nsp2_20170818_001_thresh35_info3';
%     'WU_RE_Glass_nsp2_20170821_001_thresh35_info3';
%     };
%%
%  test = [1 24 72];
for fi = 1:length(files)  %length(test)
    %     t = test(fi);
    filename = files{fi};
    %     filename = files{t};
    load(filename)
    RFphase = determineComputer;
    
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    
    amap = getBlackrockArrayMap(files(fi,:));
    %     amap = getBlackrockArrayMap(files(t,:));
    %%
    figure(1)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2), 1200, 900],'PaperOrientation','landscape')
    
    s = suptitle(sprintf('%s ',filename));
    s.Position(2) = s.Position(2)+0.02;
    s.Interpreter = 'none';
    for ch = 1:96
        chSpikes = dataT.bins(:,5:25,ch);
        muSpike  = smooth(mean(chSpikes,2));
        
        subplot(amap,10,10,ch)
        plot(muSpike)
        set(gca,'box','off','FontSize',8.5)
        title(ch)
    end
    %% go to correct directory
    if contains(filename,'RadFreq','IgnoreCase',true)
        stim = 'RadialFrequency';
    elseif contains(filename,'glass','IgnoreCase',true)
        stim = 'Glass';
    end
    
    figDir =  sprintf('~/Dropbox/Figures/SpikeCheck/%s/%s/%s',stim,dataT.animal,dataT.array);
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    
    cd(figDir)
    %% save
    if contains(filename,'radFreq','IgnoreCase',true)
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_radFreq_',dataT.date2,'_',dataT.runNum,'_spikesXtrials','.pdf'];
    else
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_Glass_',dataT.date2,'_',dataT.runNum,'_spikesXtrials','.pdf'];
    end
    print(gcf, figName,'-dpdf','-fillpage')
    %% make matching PSTH
    figure(2);
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 1200 900])
    set(gcf,'PaperOrientation','Landscape');
    
    s = suptitle(sprintf('%s ',filename));
    s.Position(2) = s.Position(2)+0.02;
    s.Interpreter = 'none';
    
    for ch = 1:96
        
        subplot(amap,10,10,ch)
        hold on;
        
        if contains(filename,'RadFreq','IgnoreCase',true)
            blankResp = nanmean(smoothdata(dataT.bins((dataT.rf == 10000), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(dataT.bins((dataT.rf ~= 10000), 1:35 ,ch),'gaussian',3))./0.01;
        else
            blankResp = nanmean(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(dataT.bins((dataT.numDots > 0), 1:35 ,ch),'gaussian',3))./0.01;
        end
        
        plot(1:35,blankResp,'Color',[0.2 0.2 0.2],'LineWidth',0.5);
        plot(1:35,stimResp,'-k','LineWidth',2);
        
        title(ch)
        
        set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');
        ylim([0 inf])
    end
    
    if contains(filename,'radFreq','IgnoreCase',true)
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RadFreq_',dataT.date2,'_',dataT.runNum,'_PSTH','.pdf'];
    else
        figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_Glass_',dataT.date2,'_',dataT.runNum,'_PSTH','.pdf'];
    end
    print(gcf, figName,'-dpdf','-fillpage')
    
    clear amap
end