function dataOut = callReceptiveFieldParameters(dataT)
% This function will get the receptive field parameters from previously
% analyzed data and save them into the current dataT structure.
% 
% Receptive field locations are relative to the center of the monitor, not
% the fixation point. If the fixation point was moved to allow for more
% space, then all points were adjusted so fixation = (0,0).

fprintf( 'Receptive field locations are relative to origin, not fixation point.\n') 

dataOut = dataT;
if contains(dataT.animal,'WU')
    if contains(dataT.eye,'LE')
        if contains(dataT.array,'V4')
            load('WU_LE_GratingsMapRF_nsp2_20170426_003_thresh35_info4_resps');
            rfData = data.LE;
        else
            load('WU_LE_GratingsMapRF_nsp1_20170426_003_thresh35_info4_resps');
            rfData = data.LE;
        end
    else
        if contains(dataT.array,'V4')
            load('WU_RE_GratmapRF_nsp2_April2017_all_thresh35_resps');
            rfData = data.RE;
        else
            load('WU_RE_GratmapRF_nsp1_April2017_all_thresh35_resps');
            rfData = data.RE;
        end
    end
elseif contains(dataT.animal,'WV')
    if contains(dataT.eye,'RE')
        if contains(dataT.array,'V4')
            load('WV_RE_MapNoise_nsp2_Jan2019_all_thresh35_resps');
            rfData = data.RE;
        else
            load('WV_RE_MapNoise_nsp1_Jan2019_all_thresh35_resps');
            rfData = data.RE;
        end
    else
        if contains(dataT.array,'V4')
            load('WV_LE_MapNoise_nsp2_Jan2019_all_thresh35_resps');
            rfData = data.LE;
        else
            load('WV_LE_MapNoise_nsp1_Jan2019_all_thresh35_resps');
            rfData = data.LE;
        end
    end
elseif contains(dataT.animal,'XT')
    if contains(dataT.eye,'RE')
        if contains(dataT.array,'V4')
            load('XT_BE_mapNoiseRight_V4_zeros');
            rfDataBE = data;
            rfData = data.RE;
        else
            load('XT_BE_mapNoise_V1_comboEyes');
            rfData = data.RE;
            rfDataBE = data;
        end
    else
        if contains(dataT.array,'V4')
            load('XT_BE_mapNoiseRight_V4_zeros');
            rfDataBE = data;
            rfData = data.LE;
            
        else
            load('XT_BE_mapNoise_V1_comboEyes');
            rfData = data.LE;
            rfDataBE = data;
        end
    end
    
else
    error('do not recognize animal')
end


dataOut.chReceptiveFieldParams = rfData.chReceptiveFieldParams;
if contains(dataT.animal,'XT')
    dataOut.chReceptiveFieldParamsBE = rfDataBE.chReceptiveFieldParams;
end

