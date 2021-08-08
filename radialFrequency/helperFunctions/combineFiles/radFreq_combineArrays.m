% V1 = 'XT_BE_radFreq_allSF_V1';
% V4 = 'XT_BE_radFreq_allSF_V4';
% newName = 'XT_BE_radFreq_allSF_bothArrays';

% V1 = 'WV_BE_radFreq_allSF_V1';
% V4 = 'WV_BE_radFreq_allSF_V4';
% newName = 'WV_BE_radFreq_allSF_bothArrays';

V4 = 'WU_BE_radFreqLoc1_V4_LocSize_oriSF_tuning';
V1 = 'WU_BE_radFreqLoc1_V1_LocSize_oriSF_tuning';
newName = 'WU_BE_radFreq_allSF_bothArrays';
%%
files = {V1; V4};

for i = 1:2
    load(files{i,:});
    if i == 1
        V1data = data;
    else
        V4data = data;
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
data.V1 = V1data;
data.V4 = V4data;

saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)

