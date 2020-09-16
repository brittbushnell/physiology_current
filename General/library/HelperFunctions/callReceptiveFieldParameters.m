function dataOut = callReceptiveFieldParameters(dataT)
% This function will get the receptive field parameters from previously
% analyzed data and save them into the current dataT structure.
% 
% Receptive field locations are relative to fixation point, not center of
% the monitor. 

fprintf('\n *********UPDATE MAPPING FILES WITH FINALIZED AND CLEANED FILENAMES********* \n\n')
fprintf( 'Receptive field locations are relative to fixation point, not the center of the monitor.\n')

dataOut = dataT;
if contains(dataT.animal,'WU')
    if contains(dataT.eye,'LE')
        if contains(dataT.array,'V4')
            load('WU_LE_Gratmap_nsp2_20170424_001_thresh35_info_resps');
            rfData = data.LE;
        else
            load('WU_LE_Gratmap_nsp1_20170424_001_thresh35_info_resps');
            rfData = data.LE;
        end
    else
        if contains(dataT.array,'V4')
            load('WU_RE_Gratmap_nsp2_20170428_006_thresh35_info_resps');
            rfData = data.RE;
        else
            load('WU_RE_Gratmap_nsp1_20170428_006_thresh35_info_resps');
            rfData = data.RE;
        end
    end
elseif contains(dataT.animal,'WV')
    if contains(dataT.eye,'RE')
        if contains(dataT.array,'V4')
            load('WV_RE_MapNoise_nsp2_20190205_001_thresh35_info_resps');
            rfData = data.RE;
        else
            load('WV_RE_MapNoise_nsp1_20190205_001_thresh35_info_resps');
            rfData = data.RE;
        end
    else
        if contains(dataT.array,'V4')
            load('WV_LE_MapNoise_nsp2_20190204_002_thresh35_info_resps');
            rfData = data.LE;
        else
            load('WV_LE_MapNoise_nsp1_20190204_002_thresh35_info_resps');
            rfData = data.LE;
        end
    end
elseif contains(dataT.animal,'XT')
    if contains(dataT.eye,'RE')
        if contains(dataT.array,'V4')
            load('XT_RE_mapNoiseRight_nsp2_20181026_001_thresh35_info_resps');
            rfData = data.RE;
        else
            load('XT_RE_mapNoiseRight_nsp1_20181026_001_thresh35_info_resps');
            rfData = data.RE;
        end
    else
        if contains(dataT.array,'V4')
            load('XT_LE_mapNoiseRight_nsp2_20181120_002_thresh35_info_resps');
            rfData = data.LE;
        else
            load('XT_LE_mapNoiseRight_nsp1_20181120_002_thresh35_info_resps');
            rfData = data.LE;
        end
    end
    
else
    error('do not recognize animal')
end

dataOut.chReceptiveFieldParams = rfData.chReceptiveFieldParams;
dataOut.arrayReceptiveFieldParams = rfData.arrayReceptiveFieldParams;



