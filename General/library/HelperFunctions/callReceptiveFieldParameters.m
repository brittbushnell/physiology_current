function dataOut = callReceptiveFieldParameters(dataT)
% This function will get the receptive field parameters from previously
% analyzed data and save them into the current dataT structure.
%
dataOut = dataT;

if contains(dataT.animal,'WU')
    if contains(dataT.eye,'LE')
        if contains(dataT.array,'V4')
            load('WU_LE_GratingsMapRF_nsp2_20170620_001_thresh35_info_resps');
            rfData = data.LE;
        else
            load('WU_LE_GratingsMapRF_nsp1_20170620_001_thresh35_info_resps');
            rfData = data.LE;
        end
    else
        if contains(dataT.array,'V4')
            load('WU_RE_GratingsMapRF_nsp2_20170814_all_thresh35_info_resps');
            rfData = data.RE;
        else
            load('WU_RE_GratingsMapRF_nsp1_20170814_all_thresh35_info_resps');
            rfData = data.RE;
        end
    end
elseif contains(dataT.animal,'WV')
    if contains(dataT.eye,'RE')
        if contains(dataT.array,'V4')
            load('WV_RE_MapNoise_nsp2_Jan2019_all_thresh35_info_resps');
            rfData = data.LE;
        else
            load('WV_RE_MapNoise_nsp1_Jan2019_all_thresh35_info_resps');
            rfData = data.LE;
        end
    else
        if contains(dataT.array,'V4')
            load('WV_LE_MapNoise_nsp2_20190204_all_raw');
            rfData = data.RE;
        else
            load('WV_LE_MapNoise_nsp1_20190204_all_raw');
            rfData = data.RE;
        end
    end
elseif contains(dataT.animal,'XT')
    if contains(dataT.eye,'RE')
        if contains(dataT.array,'V4')
            load('XT_RE_mapNoiseRight_nsp2_nov2018_all_thresh35_info_resps');
            rfData = data.LE;
        else
            load('XT_RE_mapNoiseRight_nsp1_nov2018_all_thresh35_info_resps');
            rfData = data.LE;
        end
    else
        if contains(dataT.array,'V4')
            load('XT_LE_mapNoiseRight_nsp2_nov20182_all_thresh35_info_resps');
            rfData = data.RE;
        else
            load('XT_LE_mapNoiseRight_nsp1_nov20182_all_thresh35_info_resps');
            rfData = data.RE;
        end
    end
    
else
    error('do not recognize animal')
end

dataOut.chReceptiveFieldParams = rfData.chReceptiveFieldParams;
dataOut.arrayReceptiveFieldParams = rfData.arrayReceptiveFieldParams;



