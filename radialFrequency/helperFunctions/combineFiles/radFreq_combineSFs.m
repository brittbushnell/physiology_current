% lowSF   = 'WV_BE_radFreqLowSF_V4_LocSize_oriSF_tuning';
% highSF  = 'WV_BE_radFreqHighSF_V4_LocSize_oriSF_tuning';
% newName = 'WV_BE_radFreq_allSF_V4';

% lowSF   = 'WV_BE_radFreqLowSF_V1_LocSize_oriSF_tuning';
% highSF  = 'WV_BE_radFreqHighSF_V1_LocSize_oriSF_tuning';
% newName = 'WV_BE_radFreq_allSF_V1';

% lowSF   = 'XT_BE_radFreqLowSFV4_V4_LocSize_oriSF_tuning';
% highSF  = 'XT_BE_radFreqHighSFV4_V4_LocSize_oriSF_tuning';
% newName = 'XT_BE_radFreq_allSF_V4';

lowSF   = 'XT_BE_radFreqLowSF_V1_LocSize_oriSF_tuning';
highSF  = 'XT_BE_radFreqHighSF_V1_LocSize_oriSF_tuning';
newName = 'XT_BE_radFreq_allSF_V1';
%%
files = {lowSF; highSF};

for i = 1:2
    load(files{i,:});
    if i == 1
        LElowSF = data.LE;
        RElowSF = data.RE;
    else
        LEhighSF = data.LE;
        REhighSF = data.RE;
    end 
    clear data
end
%%
location = determineComputer;

if location == 1
    outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/RadialFrequency/comboData/');
    
elseif location == 0
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/RadialFrequency/comboData/');
end
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end
%%

data.RElowSF = RElowSF;
data.REhighSF = REhighSF;

data.LElowSF = LElowSF;
data.LEhighSF = LEhighSF;

saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)

