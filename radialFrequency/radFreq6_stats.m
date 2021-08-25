clear
close all
%
files = {
%     'WU_BE_radFreq_allSF_bothArrays';
%     'WV_BE_radFreq_allSF_bothArrays';
    'XT_BE_radFreq_allSF_bothArrays';
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
    
    if ~contains(filename,'WU')
        v1REhighSF = V1data.REhighSF;
        v1RElowSF  = V1data.RElowSF;
        
        v1LEhighSF = V1data.LEhighSF;
        v1LElowSF  = V1data.LElowSF;
        
        v4REhighSF = V4data.REhighSF;
        v4RElowSF  = V4data.RElowSF;
        
        v4LEhighSF = V4data.LEhighSF;
        v4LElowSF  = V4data.LElowSF;
    end
    %% XT and WV different sensitivities for spatial frequency
    % need to have both lowSF and highSF data sets together.
    
    if ~contains(filename,'WU')
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
        fprintf('%s V1 IOD permutations done %.2f minutes\n',V1data.RE.animal, toc/60)
        
        [V4data.IODdpPval,V4data.IODdpSigPerms,V4data.IODcorrPval,V4data.IODcorrSigPerms,...
            V4data.IODmaxDpPopDiff,V4data.IODmaxDpChDiff, V4data.IODcorrChDiff,V4data.IODcorrPopDiff]...
            = radFreq_getLEvsREdPandCorr(V4data.LE,V4data.RE,numBoot);
        fprintf('%s V4 IOD permutations done %.2f minutes\n',V1data.RE.animal, toc/60)
    else
        [V1data.IOD.lowSFdpPval,V1data.IOD.lowSFdpSigPerms,V1data.IOD.lowSFcorrPval,...
            V1data.IOD.lowSFcorrSigPerms,V1data.IOD.lowSFmaxDpPopDiff,...
            V1data.IOD.lowSFmaxDpChDiff,V1data.IOD.lowSFcorrChDiff,V1data.IOD.lowSFcorrPopDiff]...
            = radFreq_getLEvsREdPandCorr(v1LElowSF,v1RElowSF,numBoot);
        fprintf('%s V1 lowSF IOD permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
        [V1data.IOD.highSFdpPval,V1data.IOD.highSFdpSigPerms,V1data.IOD.highSFcorrPval,...
            V1data.IOD.highSFcorrSigPerms,V1data.IOD.highSFmaxDpPopDiff,...
            V1data.IOD.highSFmaxDpChDiff,V1data.IOD.highSFcorrChDiff,V1data.IOD.highSFcorrPopDiff]...
            = radFreq_getLEvsREdPandCorr(v1LEhighSF,v1REhighSF,numBoot);
        fprintf('%s V1 highSF IOD permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
        [V4data.IOD.lowSFdpPval,V4data.IOD.lowSFdpSigPerms,V4data.IOD.lowSFcorrPval,...
            V4data.IOD.lowSFcorrSigPerms,V4data.IOD.lowSFmaxDpPopDiff,...
            V4data.IOD.lowSFmaxDpChDiff,V4data.IOD.lowSFcorrChDiff,V4data.IOD.lowSFcorrPopDiff]...
            = radFreq_getLEvsREdPandCorr(v4LElowSF,v4RElowSF,numBoot);
        fprintf('%s V4 lowSF IOD permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
        [V4data.IOD.highSFdpPval,V4data.IOD.highSFdpSigPerms,V4data.IOD.highSFcorrPval,...
            V4data.IOD.highSFcorrSigPerms,V4data.IOD.highSFmaxDpPopDiff,...
            V4data.IOD.highSFmaxDpChDiff,V4data.IOD.highSFcorrChDiff,V4data.IOD.highSFcorrPopDiff]...
            = radFreq_getLEvsREdPandCorr(v4LEhighSF,v4REhighSF,numBoot);
        fprintf('%s V4 highSF IOD permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
    end
    %% d' and correlations are higher in V4 than V1
    % need to access V1 and V4 at the same time to be able to run the eventual permutation tests on this
    if contains(filename,'WU')
        [data.LExArrayDpPval,data.LExArrayDpSigPerms,data.LExArrayCorrPval,...
            data.LExArrayCorrSigPerms, data.LExArrayMaxDpPopDiff,...
            data.LExArrayMaxDpChDiff,data.LExArrayCorrChDiff,data.LExArrayCorrPopDiff] = ...
            radFreq_V1vsV4dPrimeCorr(V1data.LE,V4data.LE,numBoot);
        fprintf('%s LE array permutations done %.2f minutes\n',V1data.RE.animal, toc/60)
        
        [data.RExArrayDpPval,data.RExArrayDpSigPerms,data.RExArrayCorrPval,...
            data.RExArrayCorrSigPerms,data.RExArrayMaxDpPopDiff,...
            data.RExArrayMaxDpChDiff,data.RExArrayCorrChDiff,data.RExArrayCorrPopDiff] = ...
            radFreq_V1vsV4dPrimeCorr(V1data.RE,V4data.RE,numBoot);
        fprintf('%s RE array permutations done %.2f minutes\n',V1data.RE.animal, toc/60)
    else
        [data.highSF.LExArrayDpPval,data.highSF.LExArrayDpSigPerms,data.highSF.LExArrayCorrPval,...
            data.highSF.LExArrayCorrSigPerms, data.highSF.LExArrayMaxDpPopDiff,...
            data.highSF.LExArrayMaxDpChDiff,data.highSF.LExArrayCorrChDiff,data.highSF.LExArrayCorrPopDiff] = ...
            radFreq_V1vsV4dPrimeCorr(v1LEhighSF,v4LEhighSF,numBoot);
        fprintf('%s LE highSF array permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
        [data.highSF.RExArrayDpPval,data.highSF.RExArrayDpSigPerms,data.highSF.RExArrayCorrPval,...
            data.highSF.RExArrayCorrSigPerms, data.highSF.RExArrayMaxDpPopDiff,...
            data.highSF.RExArrayMaxDpChDiff,data.highSF.RExArrayCorrChDiff,data.highSF.RExArrayCorrPopDiff] = ...
            radFreq_V1vsV4dPrimeCorr(v1REhighSF,v4REhighSF,numBoot);
        fprintf('%s RE highSF array permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
        [data.lowSF.LExArrayDpPval,data.lowSF.LExArrayDpSigPerms,data.lowSF.LExArrayCorrPval,...
            data.lowSF.LExArrayCorrSigPerms, data.lowSF.LExArrayMaxDpPopDiff,...
            data.lowSF.LExArrayMaxDpChDiff,data.lowSF.LExArrayCorrChDiff,data.lowSF.LExArrayCorrPopDiff] = ...
            radFreq_V1vsV4dPrimeCorr(v1LElowSF,v4LElowSF,numBoot);
        fprintf('%s LE lowSF array permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
        [data.lowSF.RExArrayDpPval,data.lowSF.RExArrayDpSigPerms,data.lowSF.RExArrayCorrPval,...
            data.lowSF.RExArrayCorrSigPerms, data.lowSF.RExArrayMaxDpPopDiff,...
            data.lowSF.RExArrayMaxDpChDiff,data.lowSF.RExArrayCorrChDiff,data.lowSF.RExArrayCorrPopDiff] = ...
            radFreq_V1vsV4dPrimeCorr(v1RElowSF,v4RElowSF,numBoot);
        fprintf('%s LE lowSF array permutations done %.2f minutes\n',v1RElowSF.animal, toc/60)
        
    end
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
    save(saveName,'data','-v7.3');
    fprintf('%.2f minutes to complete %s analysis\n',toc/60,filename)
end

    %% d' higher in XT, lowest in WV
    % need to access all data from all animals for this test.