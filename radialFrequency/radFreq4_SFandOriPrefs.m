clear
close all
clc
tic
%%

files = {
    'WU_BE_radFreqLoc1_V4_LocSize';
    'WU_BE_radFreqLoc1_V1_LocSize';
    %     'WV_BE_radFreqHighSF_V4_LocSize';
    %     'WV_BE_radFreqHighSF_V1_LocSize';
    };
nameEnd = 'oriSF';
%%
plotNeuro = 0;
plotLocCh = 1;
%%
for fi = 1:length(files)
    %%
    filename = files{fi};
    fparts = strsplit(filename,'_');
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
    
    load(filename);
    REdata = data.RE;
    LEdata = data.LE;
    %% find preferred RF/Rotation combo
    [REdata.sigOri, LEdata.sigOri, REdata.oriCorrDiff, LEdata.oriCorrDiff, REdata.prefRot, LEdata.prefRot, REdata.oriCorr, LEdata.oriCorr] = radFreq_getFisherRFrot_BE(REdata, LEdata,0,1000);
    plotRF_SigOriBars(LEdata,REdata)
    %% find preferred spatial frequency
    [REdata.sigSF, LEdata.sigSF, REdata.SFcorrDiff, LEdata.SFcorrDiff, REdata.prefSF, LEdata.prefSF, REdata.SFcorr, LEdata.SFcorr] = radFreq_getFisherRFsf_BE(REdata, LEdata,1000);
    plotRF_SigSFbars(LEdata,REdata)
    %%
    location = determineComputer;
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',REdata.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',REdata.array);
    end
    
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
    end
    
    data.RE = REdata;
    data.LE = LEdata;
    
    fname2 = strrep(filename,'.mat','');
    saveName = [outputDir fname2 '_' nameEnd '.mat'];
    save(saveName,'data');
    fprintf('%s saved\n\n',saveName)
end