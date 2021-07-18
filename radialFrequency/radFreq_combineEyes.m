% radFreq_combineEyes
clear
close all

%%
% WU
% LEfile = 'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info_goodCh';
% REfile = 'WU_RE_radFreqLoc1_nsp2_June2017_info_goodCh';
% newName = 'WU_BE_radFreqLoc1_V4';

% LEfile = 'WU_LE_RadFreqLoc1_nsp1_20170626_002_thresh35_info_goodCh';
% REfile = 'WU_RE_radFreqLoc1_nsp1_June2017_info_goodCh';
% newName = 'WU_BE_radFreqLoc1_V1';
%% WV
% LEfile = 'WV_LE_RadFreqHighSF_nsp2_March2019_goodCh';
% REfile = 'WV_RE_RadFreqHighSF_nsp2_March2019_goodCh';
% newName = 'WV_BE_radFreqHighSF_V4';

% LEfile = 'WV_LE_RadFreqHighSF_nsp1_March2019_goodCh';
% REfile = 'WV_RE_RadFreqHighSF_nsp1_March2019_goodCh';
% newName = 'WV_BE_radFreqHighSF_V1';

% LEfile = 'WV_LE_RadFreqLowSF_nsp2_March2019_goodCh';
% REfile = 'WV_RE_RadFreqLowSF_nsp2_March2019_goodCh';
% newName = 'WV_BE_radFreqLowSF_V4';

% LEfile = 'WV_LE_RadFreqLowSF_nsp1_March2019_goodCh';
% REfile = 'WV_RE_RadFreqLowSF_nsp1_March2019_goodCh';
% newName = 'WV_BE_radFreqLowSF_V1';

%% XT
% LEfile = 'XT_LE_RadFreqLowSF_nsp2_Dec2018_info_goodCh';
% REfile = 'XT_RE_radFreqLowSF_nsp2_Dec2019_info_goodCh';
% newName = 'XT_BE_radFreqLowSF_V4';

% LEfile = 'XT_LE_RadFreqLowSF_nsp1_Dec2018_info_goodCh';
% REfile = 'XT_RE_radFreqLowSF_nsp1_Dec2019_info_goodCh';
% newName = 'XT_BE_radFreqLowSF_V1';

% LEfile = 'XT_LE_radFreqHighSF_nsp2_Jan2019_info_goodCh';
% REfile = 'XT_RE_radFreqHighSF_nsp2_Dec2018_info_goodCh';
% newName = 'XT_BE_radFreqHighSF_V4';

% LEfile = 'XT_LE_radFreqHighSF_nsp1_Jan2019_info_goodCh';
% REfile = 'XT_RE_radFreqHighSF_nsp1_Dec2018_info_goodCh';
% newName = 'XT_BE_radFreqHighSF_V1';

% LEfile = 'XT_LE_RadFreqLowSFV4_nsp2_Feb2019_info_goodCh';
% REfile = 'XT_RE_RadFreqLowSFV4_nsp2_Feb2019_info_goodCh';
% newName = 'XT_BE_radFreqLowSFV4_V4';

% LEfile = 'XT_LE_RadFreqLowSFV4_nsp1_Feb2019_info_goodCh';
% REfile = 'XT_RE_RadFreqLowSFV4_nsp1_Feb2019_info_goodCh';
% newName = 'XT_BE_radFreqLowSFV4_V1';

% LEfile = 'XT_LE_RadFreqHighSFV4_nsp2_March2019_info_goodCh';
% REfile = 'XT_RE_RadFreqHighSFV4_nsp2_March2019_info_goodCh';
% newName = 'XT_BE_radFreqHighSFV4_V4';

LEfile = 'XT_LE_RadFreqHighSFV4_nsp1_March2019_info_goodCh';
REfile = 'XT_RE_RadFreqHighSFV4_nsp1_March2019_info_goodCh';
newName = 'XT_BE_radFreqHighSFV4_V1';
%%
files = {LEfile; REfile};

for i = 1:2
    load(files{i,:});
    if isempty(data.LE)
        REdata = data.RE;
        if ~contains(REdata.animal,'XT')
            REdata.eye = 'AE';
        end
    else
        LEdata = data.LE;
        if ~contains(LEdata.animal,'XT')
            LEdata.eye = 'FE';
        end
        
        clear data
    end
end
tmp = strsplit(LEfile,'_');
LEdata.date2 = tmp{5};

tmp = strsplit(REfile,'_');
REdata.date2 = tmp{5};
%% exclude known funky channels from good ch
badCh = radFreq_ExcludeChs(LEdata);
LEdata.goodCh(badCh) = 0;
clear badCh
badCh = radFreq_ExcludeChs(REdata);
REdata.goodCh(badCh) = 0;
%% get stimulus locations
xPoss = unique(LEdata.pos_x);
yPoss = unique(LEdata.pos_y);
locPair = nan(1,2);

for xs = 1:length(xPoss)
    for ys = 1:length(yPoss)
        flerp = sum((LEdata.pos_x == xPoss(xs)) & (LEdata.pos_y == yPoss(ys)));
        if flerp >1
            locPair(end+1,:) = [xPoss(xs), yPoss(ys)];
        end
    end
end
locPair = locPair(2:end,:);
REdata.locPair = locPair;
LEdata.locPair = locPair;
%%
location = determineComputer;

if location == 1
    outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/RadialFrequency/bothEyes/%s/',REdata.array,REdata.animal);
    
elseif location == 0
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/RadialFrequency/bothEyes/%s/',REdata.array,REdata.animal);
end
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end
%%

data.RE = REdata;
data.LE = LEdata;

saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)
