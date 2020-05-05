clear all
close all
clc
%% V4
% % %WU
% % %AE
% files = {
%     'WU_RE_Glass_nsp2_20170818_002';...       %5 reps
%     'WU_RE_Glass_nsp2_20170818_001';...       %5 reps
%    };
% newName = 'WU_RE_Glass_nsp2_20170818_all';
% %%     %WV
% %     %AE
% %     'WV_RE_glassCoh_nsp2_20190404_003';...   %10 reps
% %     'WV_RE_glassCoh_nsp2_20190404_002';...   %10 reps
% %     };
% % newName = 'WV_RE_glassCoh_nsp2_20190404_all';
% %     %FE
% %     'WV_LE_GlassCoh_nsp2_20190402_002';...   %10 reps
% %     'WV_LE_glassCoh_nsp2_20190402_003';...   %4 reps
% %     'WV_LE_GlassCoh_nsp2_20190402_004';...   %1 reps
% %     };
% % newName = 'WV_LE_GlassCoh_nsp2_20190402_all';
% %
% %     'WV_LE_glassCoh_nsp2_20190403_002';...   %8 reps
% %     'WV_LE_glassCoh_nsp2_20190403_001';...   %5 reps
% %     };
% % newName = 'WV_LE_glassCoh_nsp2_20190403_all';
%
%     %FE smaller diameter stimulus
% %     'WV_LE_glassCohSmall_nsp2_20190425_001';...  %10 reps
% %     'WV_LE_glassCohSmall_nsp2_20190425_002';...  %5 reps
% %     'WV_LE_glassCohSmall_nsp2_20190425_003';...  %2 reps
% %     };
% % newName = 'WV_LE_glassCohSmall_nsp2_20190425_all';
%
% %     %AE smaller diameter stimulus
% %     'WV_RE_glassCohSmall_nsp2_20190423_002';... %10 reps
% %     'WV_RE_glassCohSmall_nsp2_20190423_001';... %10 reps
% %     };
% % newName = 'WV_RE_glassCohSmall_nsp2_20190423_all';
%
% %     %XT %%%
%     %RE
% %     'XT_RE_GlassCoh_nsp2_20190321_002';...  %15 reps
% %     'XT_RE_GlassCoh_nsp2_20190321_003';...  %9 reps
% %     };
% % newName = 'XT_RE_GlassCoh_nsp2_20190321_all';
%
% %     %LE
% %     'XT_LE_GlassCoh_nsp2_20190325_001';...  %15 reps
% %     'XT_LE_GlassCoh_nsp2_20190325_002';...  %9 reps
% %     'XT_LE_GlassCoh_nsp2_20190325_004';...  %2 reps
% %     };
% % newName = 'XT_LE_GlassCoh_nsp2_20190325_all';
%
% %     %RE high coh only
% %     'XT_RE_Glass_nsp2_20190123_008';...   %17 reps
% %     'XT_RE_Glass_nsp2_20190123_006';...   %14 reps
% %     'XT_RE_Glass_nsp2_20190123_005';...   %8 reps
% %     'XT_RE_Glass_nsp2_20190123_003';...  %4 reps
% %     };
% % newName = 'XT_RE_Glass_nsp2_20190123_all';
%
% %     %LE high coh only
% %     'XT_LE_Glass_nsp2_20190123_001';...   %15 reps
% %     'XT_LE_Glass_nsp2_20190123_002';...   %15 reps
% %     };
% % newName = 'XT_LE_Glass_nsp2_20190123_all';
%
%     'XT_LE_Glass_nsp2_20190124_002';...   %15 reps
%     'XT_LE_Glass_nsp2_20190124_001';...   %9 reps
%     'XT_LE_Glass_nsp2_20190124_003';   %6 reps
% };
% newName = 'XT_LE_Glass_nsp2_20190124_all';

%% V1
% %WU
% %AE
% files = {
%         'WU_RE_Glass_nsp1_20170818_002';...       %5 reps
%         'WU_RE_Glass_nsp1_20170818_001';...       %5 reps
%        };
%     newName = 'WU_RE_Glass_nsp1_20170818_all';
%%     %WV
%     %AE
%     'WV_RE_glassCoh_nsp1_20190404_003';...   %10 reps
%     'WV_RE_glassCoh_nsp1_20190404_002';...   %10 reps
%     };
% newName = 'WV_RE_glassCoh_nsp1_20190404_all';

%     %FE
%     'WV_LE_GlassCoh_nsp1_20190402_002';...   %10 reps
%     'WV_LE_glassCoh_nsp1_20190402_003';...   %4 reps
%     'WV_LE_GlassCoh_nsp1_20190402_004';...   %1 reps
%     };
% newName = 'WV_LE_GlassCoh_nsp1_20190402_all';

%     'WV_LE_glassCoh_nsp1_20190403_002';...   %8 reps
%     'WV_LE_glassCoh_nsp1_20190403_001';...   %5 reps
%     };
% newName = 'WV_LE_glassCoh_nsp1_20190403_all';

%FE smaller diameter stimulus
%     'WV_LE_glassCohSmall_nsp1_20190425_001';...  %10 reps
%     'WV_LE_glassCohSmall_nsp1_20190425_002';...  %5 reps
%     'WV_LE_glassCohSmall_nsp1_20190425_003';...  %2 reps
%     };
% newName = 'WV_LE_glassCohSmall_nsp1_20190425_all';

%     %AE smaller diameter stimulus
%     'WV_RE_glassCohSmall_nsp1_20190423_002';... %10 reps
%     'WV_RE_glassCohSmall_nsp1_20190423_001';... %10 reps
%     };
% newName = 'WV_RE_glassCohSmall_nsp1_20190423_all';

%     %XT %%%
%RE
%     'XT_RE_GlassCoh_nsp1_20190321_002';...  %15 reps
%     'XT_RE_GlassCoh_nsp1_20190321_003';...  %9 reps
%     };
% newName = 'XT_RE_GlassCoh_nsp1_20190321_all';

%     %LE
%     'XT_LE_GlassCoh_nsp1_20190325_001';...  %15 reps
%     'XT_LE_GlassCoh_nsp1_20190325_002';...  %9 reps
%     'XT_LE_GlassCoh_nsp1_20190325_004';...  %2 reps
%     };
% newName = 'XT_LE_GlassCoh_nsp1_20190325_all';

%     %RE high coh only
%     'XT_RE_Glass_nsp1_20190123_008';...   %17 reps
%     'XT_RE_Glass_nsp1_20190123_006';...   %14 reps
%     'XT_RE_Glass_nsp1_20190123_005';...   %8 reps
%     'XT_RE_Glass_nsp1_20190123_003';...  %4 reps
%     };
% newName = 'XT_RE_Glass_nsp1_20190123_all';

%     %LE high coh only
%     'XT_LE_Glass_nsp1_20190123_001';...   %15 reps
%     'XT_LE_Glass_nsp1_20190123_002';...   %15 reps
%     };
% newName = 'XT_LE_Glass_nsp1_20190123_all';

%     'XT_LE_Glass_nsp1_20190124_002';...   %15 reps
%     'XT_LE_Glass_nsp1_20190124_001';...   %9 reps
%     'XT_LE_Glass_nsp1_20190124_003';   %6 reps
% };
% newName = 'XT_LE_Glass_nsp1_20190124_all';


%% GlassTR
%  files = {
%     'WU_RE_GlassTR_nsp1_20170828_003';...
%     'WU_RE_GlassTR_nsp1_20170828_002';...
%     };
% newName = 'WU_RE_GlassTR_nsp1_20170828_all';

files = {
'WU_RE_GlassTR_nsp2_20170828_003';...
    'WU_RE_GlassTR_nsp2_20170828_002';...
    };
newName = 'WU_RE_GlassTR_nsp2_20170828_all';

% XT
% files = {
%         'XT_RE_GlassTR_nsp2_20190125_002';...
%         'XT_RE_GlassTR_nsp2_20190125_003';...
%         'XT_RE_GlassTR_nsp2_20190125_004';...
%         'XT_RE_GlassTR_nsp2_20190125_005';...
%     };
% newName = 'XT_RE_GlassTR_nsp2_20190125_all';
%
% files = {
%         'XT_RE_GlassTR_nsp2_20190128_001';...
%         'XT_RE_GlassTR_nsp2_20190128_002';...
%     };
%     newName = 'XT_RE_GlassTR_nsp2_20190128_all';
%
%     files = {
%         'XT_LE_GlassTR_nsp2_20190130_001';...
%         'XT_LE_GlassTR_nsp2_20190130_002';...
%         'XT_LE_GlassTR_nsp2_20190130_003';...
%         'XT_LE_GlassTR_nsp2_20190130_004';...
%     };
%     newName = 'XT_LE_GlassTR_nsp2_20190130_all';
%
%     files = {
%         'XT_RE_GlassTR_nsp1_20190125_002';...
%         'XT_RE_GlassTR_nsp1_20190125_003';...
%         'XT_RE_GlassTR_nsp1_20190125_004';...
%         'XT_RE_GlassTR_nsp1_20190125_005';...
%     };
%     newName = 'XT_RE_GlassTR_nsp1_20190125_all';
%
%     files = {
%         'XT_RE_GlassTR_nsp1_20190128_001';...
%         'XT_RE_GlassTR_nsp1_20190128_002';...
%     };
%     newName = 'XT_RE_GlassTR_nsp1_20190128_all';
%
%     files = {
%         'XT_LE_GlassTR_nsp1_20190130_001';...
%         'XT_LE_GlassTR_nsp1_20190130_002';...
%         'XT_LE_GlassTR_nsp1_20190130_003';...
%         'XT_LE_GlassTR_nsp1_20190130_004';...
%     };
%    newName = 'XT_LE_GlassTR_nsp1_20190130_all';

% files = {
%         'XT_RE_GlassTRCoh_nsp2_20190322_002';...
%         'XT_RE_GlassTRCoh_nsp2_20190322_003';...
%         'XT_RE_GlassTRCoh_nsp2_20190322_004';...
%         };
%     newName = 'XT_RE_GlassTRCoh_nsp2_20190322_all';
%
%     files = {
%         'XT_RE_GlassTRCoh_nsp2_20190324_002';...
%         'XT_RE_GlassTRCoh_nsp2_20190324_003';...
%         'XT_RE_GlassTRCoh_nsp2_20190324_004';...
%         };
%     newName = 'XT_RE_GlassTRCoh_nsp2_20190324_all'

% files = {
%         'XT_RE_GlassTRCoh_nsp1_20190322_002';...
%         'XT_RE_GlassTRCoh_nsp1_20190322_003';...
%         'XT_RE_GlassTRCoh_nsp1_20190322_004';...
%         };
%     newName = 'XT_RE_GlassTRCoh_nsp1_20190322_all';
%
%     files = {
%         'XT_RE_GlassTRCoh_nsp1_20190324_002';...
%         'XT_RE_GlassTRCoh_nsp1_20190324_003';...
%         'XT_RE_GlassTRCoh_nsp1_20190324_004';...
%         };
%     newName = 'XT_RE_GlassTRCoh_nsp1_20190324_all'
%% WV
% files = {
%         'WV_RE_glassTRCoh_nsp2_20190409_001';...
%         'WV_RE_glassTRCoh_nsp2_20190409_002';...
%     };
% newName = 'WV_RE_GlassTRCoh_nsp2_20190409_all';
%
% files = {
%         'WV_RE_glassTRCoh_nsp2_20190410_001';...
%         'WV_RE_glassTRCoh_nsp2_20190410_002';...
% };
% newName = 'WV_RE_GlassTRCoh_nsp2_20190410_all';
%
% files = {
%         'WV_LE_glassTRCoh_nsp2_20190415_001';...
%         'WV_LE_glassTRCoh_nsp2_20190415_002';...
%     };
% newName = 'WV_LE_GlassTRCoh_nsp2_20190415_all';
%
% files = {
%         'WV_LE_glassTRCoh_nsp2_20190416_001';...
%         'WV_LE_glassTRCoh_nsp2_20190416_002';...
%         'WV_LE_glassTRCoh_nsp2_20190416_003';...
%     };
% newName = 'WV_LE_glassTRCoh_nsp2_20190416_all';
%
% files = {
%         'WV_LE_glassTRCoh_nsp2_20190417_001';...
%         'WV_LE_glassTRCoh_nsp2_20190417_002';...
%     };
% newName = 'WV_LE_GlassTRCoh_nsp2_20190417_all';
%
% files = {
%         'WV_RE_glassTRCoh_nsp1_20190409_001';...
%         'WV_RE_glassTRCoh_nsp1_20190409_002';...
%     };
% newName = 'WV_RE_GlassTRCoh_nsp1_20190409_all';
%
% files = {
%         'WV_RE_glassTRCoh_nsp1_20190410_001';...
%         'WV_RE_glassTRCoh_nsp1_20190410_002';...
% };
% newName = 'WV_RE_GlassTRCoh_nsp1_20190410_all';
%
% files = {
%         'WV_LE_glassTRCoh_nsp1_20190415_001';...
%         'WV_LE_glassTRCoh_nsp1_20190415_002';...
%     };
% newName = 'WV_LE_GlassTRCoh_nsp1_20190415_all';
%
% files = {
%         'WV_LE_glassTRCoh_nsp1_20190416_001';...
%         'WV_LE_glassTRCoh_nsp1_20190416_002';...
%         'WV_LE_glassTRCoh_nsp1_20190416_003';...
%     };
% newName = 'WV_LE_glassTRCoh_nsp1_20190416_all';
%
% files = {
%         'WV_LE_glassTRCoh_nsp1_20190417_001';...
%         'WV_LE_glassTRCoh_nsp1_20190417_002';...
%     };
% newName = 'WV_LE_GlassTRCoh_nsp1_20190417_all';
%% XX
% files = {
%      'XX_LE_Glass_20200210_001_nsp1';
%     'XX_LE_Glass_20200210_002_nsp1';
%     'XX_LE_Glass_20200210_003_nsp1';
%     };
% newName = 'XX_LE_Glass_nsp1_20200210_all';

% files = {
%      'XX_LE_Glass_20200210_001_nsp2';
%     'XX_LE_Glass_20200210_002_nsp2';
%     'XX_LE_Glass_20200210_003_nsp2';
%     };
% newName = 'XX_LE_Glass_nsp2_20200210_all';

% files = {
%     'XX_RE_Glass_20200211_001_nsp1';
%     'XX_RE_Glass_20200211_002_nsp1';
%     'XX_RE_Glass_20200211_003_nsp1';
%     };
% newName = 'XX_RE_Glass_nsp1_20200211_all';

% files = {
%     'XX_RE_Glass_20200211_001_nsp2';
%     'XX_RE_Glass_20200211_002_nsp2';
%     'XX_RE_Glass_20200211_003_nsp2';
%     };
% newName = 'XX_RE_Glass_nsp2_20200211_all';
%%
location = determineComputer;
for fi = 1:size(files,1)
    filename = files{fi,:};
    data = load(filename);
    if contains(filename,'XX')
        data.fix_x = -1;
        data.fix_y = 2;
        if contains(filename,'nsp2')
            data.bins = data.binsV4;
        else
            data.bins = data.binsV1;
        end
    end
    dataComp{fi} = data;
end
%% Concatenate sections
action = [];
bins   = [];
filename = [];
fix_x = [];
fix_y = [];
pos_x = [];
pos_y = [];
rotation = [];
size_x  = [];
stimOn  = [];
stimOff = [];
t_stim  = [];


for i = 1:length(dataComp)
    bT     = dataComp{i}.bins;
    fnm    = dataComp{i}.filename;
    fx     = dataComp{i}.fix_x;
    fy     = dataComp{i}.fix_y;
    rot    = dataComp{i}.rotation;
    szx    = dataComp{i}.size_x;
    stmOn  = dataComp{i}.stimOn;
    stmOff = dataComp{i}.stimOff;
    tStim  = dataComp{i}.t_stim;
    xPos = dataComp{i}.pos_x;
    yPos = dataComp{i}.pos_y;
    
    
    bins = cat(1, bins, bT);
    fix_x = [fix_x, fx];
    fix_y = [fix_y, fy];
    rotation = [rotation,rot];
    size_x = [size_x,szx];
    stimOn = [stimOn, stmOn];
    stimOff = [stimOff, stmOff];
    t_stim = [t_stim, tStim];
    filename = cat(1, filename, fnm);
    pos_x = [pos_x, xPos];
    pos_y = [pos_y, yPos];
    
end
%% save new matrix
if contains(files(1,:),'V1') || contains(files(1,:),'nsp1')
    if location == 3
        cd /home/bushnell/matFiles/V1/
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Glass/mergedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/Glass/mergedMats/
    end
else
    if location == 3
        cd  /home/bushnell/matFiles/V4/
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Glass/mergedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/Glass/mergedMats/
    end
end
save(newName,'bins','fix_x','fix_y','rotation','size_x','stimOn','stimOff','t_stim','filename',...
    'pos_x','pos_y')
fprintf('file %s done \n', newName)







