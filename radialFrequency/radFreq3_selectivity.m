clear
close all
clc
tic
%%

files = {
    % WU loc1
     'WU_RE_radFreqLoc1_nsp2_June2017_info_goodCh';
     'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info_goodCh';
%     
%     'WU_RE_radFreqLoc1_nsp1_June2017_info_goodCh';
%     'WU_LE_RadFreqLoc1_nsp1_20170626_002_thresh35_info_goodCh';
%     
%     % WV
%     'WV_LE_RadFreqHighSF_nsp2_March2019_goodCh';
%     'WV_LE_RadFreqHighSF_nsp1_March2019_goodCh';
%     
%     'WV_RE_RadFreqHighSF_nsp1_March2019_goodCh';
%     'WV_RE_RadFreqHighSF_nsp2_March2019_goodCh';
%     
%     'WV_LE_RadFreqLowSF_nsp2_March2019_goodCh';
%     'WV_LE_RadFreqLowSF_nsp1_March2019_goodCh';
%     
%     'WV_RE_RadFreqLowSF_nsp2_March2019_goodCh';
%     'WV_RE_RadFreqLowSF_nsp1_March2019_goodCh';
%
%     % XT
%     'XT_RE_radFreqLowSF_nsp2_Dec2019_info_goodCh';
%     'XT_RE_radFreqLowSF_nsp1_Dec2019_info_goodCh';
%     
%     'XT_LE_RadFreqLowSF_nsp2_Dec2018_info_goodCh';
%     'XT_LE_RadFreqLowSF_nsp1_Dec2018_info_goodCh';
%     
%     'XT_RE_radFreqHighSF_nsp2_Dec2018_info_goodCh';
%     'XT_RE_radFreqHighSF_nsp1_Dec2018_info_goodCh';
%     
%     'XT_LE_radFreqHighSF_nsp2_Jan2019_info_goodCh';
%     'XT_LE_radFreqHighSF_nsp1_Jan2019_info_goodCh';
%     
%     'XT_RE_RadFreqLowSFV4_nsp2_Feb2019_info_goodCh';
%     'XT_RE_RadFreqLowSFV4_nsp1_Feb2019_info_goodCh';
%     
%     'XT_LE_RadFreqLowSFV4_nsp2_Feb2019_info_goodCh';
%     'XT_LE_RadFreqLowSFV4_nsp1_Feb2019_info_goodCh';
%     
%     'XT_LE_RadFreqHighSFV4_nsp2_March2019_info_goodCh';
%     'XT_LE_RadFreqHighSFV4_nsp1_March2019_info_goodCh';
%     
%     'XT_LE_RadFreqHighSFV4_nsp2_March2019_info_goodCh';
%     'XT_LE_RadFreqHighSFV4_nsp1_March2019_info_goodCh';
    };
%%
plotNeuro = 0;
%%
for fi = 1:length(files)
    %%
    filename = files{fi};
    fparts = strsplit(filename,'_');
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));    
    
    load(filename);
    if contains(filename,'RE')
        dataT = data.RE;
        if ~contains(dataT.animal,'XT')
            dataT.eye = 'AE';
        end
    else
        dataT = data.LE;
        if ~contains(dataT.animal,'XT')
            dataT.eye = 'FE';
        end
    end  
%% get spike count matrices
% rfSCmtx: (repeats, RF, ori, amp, sf, radius, location, ch)
% blankSCmtx: (repeats, ch)
% circSCmtx: (repeats, sf, radius, location, ch)

    dataT = radFreq_getSpikeCountCondMtx(dataT);
%% plot neurometric curves
    [dataT.rfMuZ, dataT.rfStErZ, dataT.circMuZ, dataT.circStErZ,...
     dataT.rfMuSc, dataT.rfStErSc, dataT.circMuSc, dataT.circStErSc] = radFreq_getMuSerrSCandZ(dataT,plotNeuro);
%% get fisher transformed correlations
    dataT.FisherTrCorr = radFreq_getCorrFisherTr(dataT);
%% find preferred location

%% find preferred RF and phase pairing

%% find preferred spatial frequency
end