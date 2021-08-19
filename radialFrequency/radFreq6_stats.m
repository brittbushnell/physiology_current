clear
close all
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
    %% XT and WV different sensitivities for spatial frequency
    % need to have both lowSF and highSF data sets together.
    
    if ~contains(filename,'WU')
        v1REhighSF = V1data.REhighSF;
        v1RElowSF  = V1data.RElowSF;
        v1LEhighSF = V1data.LEhighSF;
        v1LElowSF  = V1data.LElowSF;
        
        [V1data.RESF.dpPval,V1data.RESF.dpSigPerms,V1data.RESF.corrPval,...
            V1data.RESF.corrSigPerms, V1data.RESF.maxDpPopDiff,V1data.RESF.maxDpChDiff,...
            V1data.RESF.corrChDiff,V1data.RESF.corrPopDiff,V1data.RESF.corrSigCh] =...
            radFreq_highSFvslowSFdPandCorr(v1REhighSF,v1RElowSF,numBoot);
        
        fprintf('%s V1 AE SF permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
        [V1data.LESF.dpPval,V1data.LESF.dpSigPerms,V1data.LESF.corrPval,...
            V1data.LESF.corrSigPerms, V1data.LESF.maxDpPopDiff,V1data.LESF.maxDpChDiff,...
            V1data.LESF.corrChDiff,V1data.LESF.corrPopDiff,V1data.LESF.corrSigCh] =...
            radFreq_highSFvslowSFdPandCorr(v1LEhighSF,v1LElowSF,numBoot);
        fprintf('%s V1 FE SF permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
        plotRF_SigSFbars_XTWV(V1data)
        %%
        v4REhighSF = V4data.REhighSF;
        v4RElowSF  = V4data.RElowSF;
        v4LEhighSF = V4data.LEhighSF;
        v4LElowSF  = V4data.LElowSF;
        
        [V4data.RESF.dpPval,V4data.RESF.dpSigPerms,V4data.RESF.corrPval,...
            V4data.RESF.corrSigPerms, V4data.RESF.maxDpPopDiff,V4data.RESF.maxDpChDiff,...
            V4data.RESF.corrChDiff,V4data.RESF.corrPopDiff,V4data.RESF.corrSigCh] =...
            radFreq_highSFvslowSFdPandCorr(v4REhighSF,v4RElowSF,numBoot);
        fprintf('%s V4 AE SF permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
        [V4data.LESF.dpPval,V4data.LESF.dpSigPerms,V4data.LESF.corrPval,...
            V4data.LESF.corrSigPerms, V4data.LESF.maxDpPopDiff,V4data.LESF.maxDpChDiff,...
            V4data.LESF.corrChDiff,V4data.LESF.corrPopDiff,V4data.LESF.corrSigCh] =...
            radFreq_highSFvslowSFdPandCorr(v4LEhighSF,v4LElowSF,numBoot);
        fprintf('%s V4 FE SF permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        plotRF_SigSFbars_XTWV(V4data)
    end
    %% d' and correlations higher in FE than AE
    if contains(filename,'WU')
        [V1data.IODdpPval,V1data.IODdpSigPerms,V1data.IODcorrPval,V1data.IODcorrSigPerms,...
            V1data.IODmaxDpPopDiff,V1data.IODmaxDpChDiff, V1data.IODcorrChDiff,V1data.IODcorrPopDiff]...
            = radFreq_getLEvsREdPandCorr(V1data.LE,V1data.RE,numBoot);
        
        [V4data.IODdpPval,V4data.IODdpSigPerms,V4data.IODcorrPval,V4data.IODcorrSigPerms,...
            V4data.IODmaxDpPopDiff,V4data.IODmaxDpChDiff, V4data.IODcorrChDiff,V4data.IODcorrPopDiff]...
            = radFreq_getLEvsREdPandCorr(V4data.LE,V4data.RE,numBoot);
    else
    end
    %% d' and correlations are higher in V4 than V1
    % need to access V1 and V4 at the same time to be able to run the eventual permutation tests on this
    if contains(filename,'WU')
        [LExArrayDpPval,LExArrayDpSigPerms,LExArrayCorrPval,LExArrayCorrSigPerms, LExArrayMaxDpPopDiff,...
            LExArrayMaxDpChDiff,LExArrayCorrChDiff,LExArrayCorrPopDiff] = ...
            radFreq_V1vsV4dPrimeCorr(V1data.LE,V4data.LE,numBoot);
        
        [RExArrayDpPval,RExArrayDpSigPerms,RExArrayCorrPval,RExArrayCorrSigPerms, RExArrayMaxDpPopDiff,...
            RExArrayMaxDpChDiff,RExArrayCorrChDiff,RExArrayCorrPopDiff] = ...
            radFreq_V1vsV4dPrimeCorr(V1data.RE,V4data.RE,numBoot);
    else
    end
    %% d' higher in XT, lowest in WV
    % need to access all data from all animals for this test.
    %%
    location = determineComputer;
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/radialFrequency/info/');
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles//radialFrequency/info/');
    end
    
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
    end
    
    data.V1 = V1data;
    data.V4 = V4data;
    
    fname2 = strrep(filename,'.mat','');
    saveName = [outputDir fname2 '_' nameEnd '.mat'];
    
    fprintf('%.2f minutes to complete %s analysis\n',toc/60,filename)
end


