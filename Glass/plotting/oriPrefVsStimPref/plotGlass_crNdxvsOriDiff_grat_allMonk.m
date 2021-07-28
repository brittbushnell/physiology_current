function [] = plotGlass_crNdxvsOriDiff_grat_allMonk(XTV4,WUV1, WUV4,WVV1, WVV4)
%% load gratings information

WUV1gratLE = load('WU_LE_Gratings_nsp1_20170731_001_thresh35_ori_pref');
WUV1gratRE = load('WU_RE_Gratings_nsp1_20170725_001_thresh35_ori_pref');

WUV4gratLE = load('WU_LE_Gratings_nsp2_20170731_001_thresh35_ori_pref');
WUV4gratRE = load('WU_RE_Gratings_nsp2_20170725_001_thresh35_ori_pref');

WVV1gratLE = load('WV_LE_gratings_nsp1_20190513_001_thresh35_ori_pref');
WVV1gratRE = load('WV_RE_gratings_nsp1_20190509_001_thresh35_ori_pref');

WVV4gratLE = load('WV_LE_gratings_nsp2_20190205_003_thresh35_ori_pref');
WVV4gratRE = load('WV_RE_gratings_nsp2_20190205_002_thresh35_ori_pref');


XTV4gratLE  = load('XT_LE_Gratings_nsp2_20190131_002_thresh35_ori_pref');
XTV4gratRE  = load('XT_RE_Gratings_nsp2_20190321_001_thresh35_ori_pref');
%% get conRad matrix
XTv4LEconRadDps = getGlassDprimeConRad_allCh(XTV4.conRadLE.conNoiseDprime,XTV4.conRadLE.radNoiseDprime);
XTv4REconRadDps = getGlassDprimeConRad_allCh(XTV4.conRadRE.conNoiseDprime,XTV4.conRadRE.radNoiseDprime);

WUv1LEconRadDps = getGlassDprimeConRad_allCh(WUV1.conRadLE.conNoiseDprime,WUV1.conRadLE.radNoiseDprime);
WUv1REconRadDps = getGlassDprimeConRad_allCh(WUV1.conRadRE.conNoiseDprime,WUV1.conRadRE.radNoiseDprime);

WUv4LEconRadDps = getGlassDprimeConRad_allCh(WUV4.conRadLE.conNoiseDprime,WUV4.conRadLE.radNoiseDprime);
WUv4REconRadDps = getGlassDprimeConRad_allCh(WUV4.conRadRE.conNoiseDprime,WUV4.conRadRE.radNoiseDprime);

WVv1LEconRadDps = getGlassDprimeConRad_allCh(WVV1.conRadLE.conNoiseDprime,WVV1.conRadLE.radNoiseDprime);
WVv1REconRadDps = getGlassDprimeConRad_allCh(WVV1.conRadRE.conNoiseDprime,WVV1.conRadRE.radNoiseDprime);

WVv4LEconRadDps = getGlassDprimeConRad_allCh(WVV4.conRadLE.conNoiseDprime,WVV4.conRadLE.radNoiseDprime);
WVv4REconRadDps = getGlassDprimeConRad_allCh(WVV4.conRadRE.conNoiseDprime,WVV4.conRadRE.radNoiseDprime);
%%
XTv4LEconRadNdx = getGlassConRadSigPerm(XTv4LEconRadDps,XTV4.trLE.animal,'V4','LE');
XTv4REconRadNdx = getGlassConRadSigPerm(XTv4REconRadDps,XTV4.trRE.animal,'V4','RE');

WUv1LEconRadNdx = getGlassConRadSigPerm(WUv1LEconRadDps,WUV1.trLE.animal,'V1','LE');
WUv1REconRadNdx = getGlassConRadSigPerm(WUv1REconRadDps,WUV1.trRE.animal,'V1','RE');
WUv4LEconRadNdx = getGlassConRadSigPerm(WUv4LEconRadDps,WUV4.trLE.animal,'V4','LE');
WUv4REconRadNdx = getGlassConRadSigPerm(WUv4REconRadDps,WUV4.trRE.animal,'V4','RE');

WVv1LEconRadNdx = getGlassConRadSigPerm(WVv1LEconRadDps,WVV1.trLE.animal,'V1','LE');
WVv1REconRadNdx = getGlassConRadSigPerm(WVv1REconRadDps,WVV1.trRE.animal,'V1','RE');
WVv4LEconRadNdx = getGlassConRadSigPerm(WVv4LEconRadDps,WVV4.trLE.animal,'V4','LE');
WVv4REconRadNdx = getGlassConRadSigPerm(WVv4REconRadDps,WVV4.trRE.animal,'V4','RE');
%%
% XTstimX = unique(XTV4.trLE.pos_x);
% XTstimY = unique(XTV4.trLE.pos_y);
%
% WUstimX = unique(WUV4.trLE.pos_x);
% WUstimY = unique(WUV4.trLE.pos_y);
%
% WVstimX = unique(WVV4.trLE.pos_x);
% WVstimY = unique(WVV4.trLE.pos_y);
%%
for monk = 1:3
    for eye = 1:2
        if monk == 1
            V1data = [];
            V4data = XTV4;
            stimX = unique(XTV4.trLE.pos_x);
            stimY = unique(XTV4.trLE.pos_y);
        elseif monk == 2
            V1data = WUV1;
            V4data = WUV4;
            stimX = unique(WUV4.trLE.pos_x);
            stimY = unique(WUV4.trLE.pos_y);
        else
            V1data = WVV1;
            V4data = WVV4;
            stimX = unique(WVV4.trLE.pos_x);
            stimY = unique(WVV4.trLE.pos_y);
        end
        
        if eye == 1
            if contains(V4data.trLE.animal,'XT')
                V4rfParamsOrig = V4data.chReceptiveFieldParamsBE;
            else
                V1rfParamsOrig = V1data.chReceptiveFieldParamsLE;
                V4rfParamsOrig = V4data.chReceptiveFieldParamsLE;
            end
        else
            if contains(V4data.trLE.animal,'XT')
                V4rfParamsOrig = V4data.chReceptiveFieldParamsBE;
            else
                V1rfParamsOrig = V1data.chReceptiveFieldParamsRE;
                V4rfParamsOrig = V4data.chReceptiveFieldParamsRE;
            end
        end
        
        if contains(V4data.trLE.animal,'XT')
            for ch = 1:96
                V4rfParamsRelGlassFix{ch}(1) = V4rfParamsOrig{ch}(1) + stimX;
                V4rfParamsRelGlassFix{ch}(2) = V4rfParamsOrig{ch}(2) + stimY;
            end
        else
            for ch = 1:96
                V1rfParamsRelGlassFix{ch}(1) = V1rfParamsOrig{ch}(1);
                V1rfParamsRelGlassFix{ch}(2) = V1rfParamsOrig{ch}(2);
                
                V4rfParamsRelGlassFix{ch}(1) = V4rfParamsOrig{ch}(1);
                V4rfParamsRelGlassFix{ch}(2) = V4rfParamsOrig{ch}(2);
            end
        end
        %%
        if monk == 2
            useChV1LE = find(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & WUV1gratLE.good_ch);
            useChV1RE = find(V1data.conRadRE.goodCh & V1data.conRadRE.inStim & WUV1gratRE.good_ch);
            
            useChV4LE = find(V4data.conRadLE.goodCh & V4data.conRadLE.inStim & WUV4gratLE.good_ch);
            useChV4RE = find(V4data.conRadRE.goodCh & V4data.conRadRE.inStim & WUV4gratRE.good_ch);
        elseif monk == 3
            useChV1LE = find(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & WVV1gratLE.good_ch);
            useChV1RE = find(V1data.conRadRE.goodCh & V1data.conRadRE.inStim & WVV1gratRE.good_ch);
            
            useChV4LE = find(V4data.conRadLE.goodCh & V4data.conRadLE.inStim & WVV4gratLE.good_ch);
            useChV4RE = find(V4data.conRadRE.goodCh & V4data.conRadRE.inStim & WVV4gratRE.good_ch);
        else
            useChV4LE = find(V4data.conRadLE.goodCh & V4data.conRadLE.inStim & XTV4gratLE.good_ch);
            useChV4RE = find(V4data.conRadRE.goodCh & V4data.conRadRE.inStim & XTV4gratRE.good_ch);
        end
        
        %     inputs: V1trData, XTv1LEconRadNdx, useChV1LE, V1rfParamsRelGlassFix, 1)
        if monk == 1
            if eye == 2
                XTv4RE.trData    = XTV4gratRE;
                XTv4RE.conRadNdx = XTv4REconRadNdx;
                XTv4RE.useCh     = useChV4RE;
                XTv4RE.rfParams  = V4rfParamsRelGlassFix;
            else
                XTv4LE.trData    = XTV4gratLE;
                XTv4LE.conRadNdx = XTv4LEconRadNdx;
                XTv4LE.useCh     = useChV4LE;
                XTv4LE.rfParams  = V4rfParamsRelGlassFix;
            end
        elseif monk == 2
            if eye == 2
                WUv1RE.trData    = WUV1gratRE;
                WUv1RE.conRadNdx = WUv1REconRadNdx;
                WUv1RE.useCh     = useChV1RE;
                WUv1RE.rfParams  = V4rfParamsRelGlassFix;
                
                WUv4RE.trData    = WUV4gratRE;
                WUv4RE.conRadNdx = WUv4REconRadNdx;
                WUv4RE.useCh     = useChV4RE;
                WUv4RE.rfParams  = V4rfParamsRelGlassFix;
            else
                WUv1LE.trData    = WUV1gratLE;
                WUv1LE.conRadNdx = WUv1LEconRadNdx;
                WUv1LE.useCh     = useChV1LE;
                WUv1LE.rfParams  = V1rfParamsRelGlassFix;
                
                WUv4LE.trData    = WUV4gratLE;
                WUv4LE.conRadNdx = WUv4LEconRadNdx;
                WUv4LE.useCh     = useChV4LE;
                WUv4LE.rfParams  = V4rfParamsRelGlassFix;
            end
        else
            if eye == 2
                WVv1RE.trData    = WVV1gratRE;
                WVv1RE.conRadNdx = WVv1REconRadNdx;
                WVv1RE.useCh     = useChV1RE;
                WVv1RE.rfParams  = V1rfParamsRelGlassFix;
                
                WVv4RE.trData    = WVV4gratRE;
                WVv4RE.conRadNdx = WVv4REconRadNdx;
                WVv4RE.useCh     = useChV4RE;
                WVv4RE.rfParams  = V4rfParamsRelGlassFix;
            else
                WVv1LE.trData    = WVV1gratLE;
                WVv1LE.conRadNdx = WVv1LEconRadNdx;
                WVv1LE.useCh     = useChV1LE;
                WVv1LE.rfParams  = V1rfParamsRelGlassFix;
                
                WVv4LE.trData    = WVV4gratLE;
                WVv4LE.conRadNdx = WVv4LEconRadNdx;
                WVv4LE.useCh     = useChV4LE;
                WVv4LE.rfParams  = V4rfParamsRelGlassFix;
            end
            clear useChV4 V4rfParamsRelGlassFix
            if monk ~=1
                clear useChV1 V1rfParamsRelGlassFix
            end
        end
    end
end
