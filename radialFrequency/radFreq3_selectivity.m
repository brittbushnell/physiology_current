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
%     % WU loc 2
%     'WU_RE_RadFreqLoc2_nsp1_July2017_info_goodCh';
%     'WU_RE_RadFreqLoc2_nsp2_July2017_info_goodCh';
%     
%     'WU_LE_RadFreqLoc2_nsp1_July2017_info_goodCh';
%     'WU_LE_RadFreqLoc2_nsp2_July2017_info_goodCh';
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
    };
%%
%%
for fi = 1:length(files)
    %%
    filename = files{fi};
    fparts = strsplit(filename,'_');
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));    
    
    load(filename);
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end  

    %% plot neurometric curves
[dataT.rfMeanZ, dataT.rfStErZ, dataT.circMeanZ, dataT.circStErZ] = radFreq_getMuSEzscores(dataT);
%% Get significant correlations for curves

%% d' vs blank


%% d' vs circle

    
    
    
end