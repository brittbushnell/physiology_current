clear
%%
files = {
    'WU_BE_radFreq_allSF_bothArrays';
%     'WV_BE_radFreq_allSF_bothArrays';
%     'XT_BE_radFreq_allSF_bothArrays';
};
nameEnd = 'stats';
%%
numBoot = 1000;
tic
%%
for fi = 1:length(files)
    %%
    filename = files{fi};
    fparts = strsplit(filename,'_');
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
    
    load(filename);
    V1data = data.V1;
    V4data = data.V4;
    clear data
    %% d' and correlations higher in FE than AE
    if contains(V1data.LE.animal,'WU')
        [V1data.IODdpPval,V1data.IODdpSigPerms,V1data.IODcorrPval,V1data.IODcorrSigPerms,...
            V1data.IODmaxDpPopDiff,V1data.IODmaxDpChDiff, V1data.IODcorrChDiff,V1data.IODcorrPopDiff]...
            = radFreq_getLEvsREdPandCorr(V1data.LE,V1data.RE,numBoot);
        
        [V4data.IODdpPval,V4data.IODdpSigPerms,V4data.IODcorrPval,V4data.IODcorrSigPerms,...
            V4data.IODmaxDpPopDiff,V4data.IODmaxDpChDiff, V4data.IODcorrChDiff,V4data.IODcorrPopDiff]...
            = radFreq_getLEvsREdPandCorr(V4data.LE,V4data.RE,numBoot);
    else
    end
    %% XT and WV different sensitivities for spatial frequency
    % need to have both lowSF and highSF data sets together.
    %% d' and correlations are higher in V4 than V1
    % need to access V1 and V4 at the same time to be able to run the eventual permutation tests on this
    [LEdata, REdata] = radFreq_PermuteMaxDpAndRFcorr(LEdata,REdata,numBoot);
    %% d' higher in XT, lowest in WV
    % need to access all data from all animals for this test.
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
    
    %     save(saveName,'data');
    %     fprintf('%s saved\n\n',saveName)
    
    fprintf('%.2f minutes to complete %s analysis\n',toc/60,filename)
end


