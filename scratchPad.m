files = {    % WV
%     'WV_LE_RadFreqHighSF_nsp2_March2019';
%     'WV_LE_RadFreqHighSF_nsp1_March2019';
%     
%     'WV_RE_RadFreqHighSF_nsp1_March2019';
%     'WV_RE_RadFreqHighSF_nsp2_March2019';
%     
%     'WV_LE_RadFreqLowSF_nsp2_March2019';
%     'WV_LE_RadFreqLowSF_nsp1_March2019';
%     
%     'WV_RE_RadFreqLowSF_nsp2_March2019';
%     'WV_RE_RadFreqLowSF_nsp1_March2019';
    
    % XT
    'XT_RE_radFreqLowSF_nsp2_Dec2019_info';
    'XT_RE_radFreqLowSF_nsp1_Dec2019_info';
    
    'XT_LE_RadFreqLowSF_nsp2_Dec2018_info';
    'XT_LE_RadFreqLowSF_nsp1_Dec2018_info';
    
    'XT_RE_radFreqHighSF_nsp2_Dec2018_info';
    'XT_RE_radFreqHighSF_nsp1_Dec2018_info';
    
    'XT_LE_radFreqHighSF_nsp2_Jan2019_info';
    'XT_LE_radFreqHighSF_nsp1_Jan2019_info';
    
    'XT_RE_RadFreqLowSFV4_nsp2_Feb2019_info';
    'XT_RE_RadFreqLowSFV4_nsp1_Feb2019_info';
    
    'XT_LE_RadFreqLowSFV4_nsp2_Feb2019_info';
    'XT_LE_RadFreqLowSFV4_nsp1_Feb2019_info';
    
    'XT_LE_RadFreqHighSFV4_nsp2_March2019_info';
    'XT_LE_RadFreqHighSFV4_nsp1_March2019_info';
    
    'XT_LE_RadFreqHighSFV4_nsp2_March2019_info';
    'XT_LE_RadFreqHighSFV4_nsp1_March2019_info';
    };
%%
location = determineComputer;

%%
for fi = 1:length(files)
    %%
    %try
    filename = files{fi};
    fparts = strsplit(filename,'_');
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
    
    if length(fparts) < 7
        dataT = load(filename);
    else
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
    end
    
    [stimLoc] = plotRadFreqLoc_relRFs(dataT);
    makeRadfreqHeatmaps(dataT,stimLoc)
    
end