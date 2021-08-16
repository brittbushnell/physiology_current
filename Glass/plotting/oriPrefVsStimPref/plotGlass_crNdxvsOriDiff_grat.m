function [] = plotGlass_crNdxvsOriDiff_grat(V1data, V4data)
%%
[V1LEsort, V1REsort, V4LEsort, V4REsort,cmap,sortDps] = getGlassSortedMats(V1data,V4data);
%%
[v1LEconRadNdx] = getGlassConRadSigPerm(V1LEsort(:,1:2));%,V1data.trLE.animal,'V1','LE');
[v1REconRadNdx] = getGlassConRadSigPerm(V1REsort(:,1:2));%,V1data.trRE.animal,'V1','RE');
[v4LEconRadNdx] = getGlassConRadSigPerm(V4LEsort(:,1:2));%,V4data.trLE.animal,'V4','LE');
[v4REconRadNdx] = getGlassConRadSigPerm(V4REsort(:,1:2));%,V4data.trRE.animal,'V4','RE');
%%
% stimX = unique(V1data.trLE.pos_x);
% stimY = unique(V1data.trLE.pos_y);
%% load gratings information
if contains(V1data.trLE.animal,'WU')
    if contains(V1data.trLE.array,'V1')
        gratLE = load('WU_LE_Gratings_nsp1_20170731_001_thresh35_ori_pref');
        gratRE = load('WU_RE_Gratings_nsp1_20170725_001_thresh35_ori_pref');
    else
        gratLE = load('WU_LE_Gratings_nsp2_20170731_001_thresh35_ori_pref');
        gratRE = load('WU_RE_Gratings_nsp2_20170725_001_thresh35_ori_pref');
    end
elseif contains(V1data.trLE.animal,'WV')
    if contains(V1data.trLE.array,'V1')
        gratLE = load('WV_LE_gratings_nsp1_20190513_001_thresh35_ori_pref');
        gratRE = load('WV_RE_gratings_nsp1_20190509_001_thresh35_ori_pref');
    else
        gratLE = load('WV_LE_gratings_nsp2_20190205_003_thresh35_ori_pref');
        gratRE = load('WV_RE_gratings_nsp2_20190205_002_thresh35_ori_pref');
    end
else
    gratLE  = load('XT_LE_Gratings_nsp2_20190131_002_thresh35_ori_pref');
    gratRE = load('XT_RE_Gratings_nsp2_20190321_001_thresh35_ori_pref');
end
%%
% for each eye:
% x-axis: conRad index
% y-axis: difference between preferred gratings ori and local concentric
% ori

figure%(1)
clf
hold on

pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 700])
s = suptitle (sprintf('%s orientation differences from gratings vs concentric radial indices',V1data.trLE.animal));
s.Position(2) = s.Position(2)+0.022;

for eye = 1:2
    if eye == 1
        V1crData = V1data.conRadLE;
        V4crData = V4data.conRadLE;
        V1trData = gratLE;
        V4trData = gratLE;
        
        if contains(V1crData.animal,'XT')
            V1rfParamsOrig = V1data.chReceptiveFieldParamsBE;
            V4rfParamsOrig = V4data.chReceptiveFieldParamsBE;
        else
            V1rfParamsOrig = V1data.chReceptiveFieldParamsLE;
            V4rfParamsOrig = V4data.chReceptiveFieldParamsLE;
        end
    else
        V1crData = V1data.conRadRE;
        V4crData = V4data.conRadRE;
        V1trData = gratRE;
        V4trData = gratRE;
        
        if contains(V1crData.animal,'XT')
            V1rfParamsOrig = V1data.chReceptiveFieldParamsBE;
            V4rfParamsOrig = V4data.chReceptiveFieldParamsBE;
        else
            V1rfParamsOrig = V1data.chReceptiveFieldParamsRE;
            V4rfParamsOrig = V4data.chReceptiveFieldParamsRE;
        end
    end
    
    if contains(V1crData.animal,'XT')
        for ch = 1:96
            V1rfParamsRelGlassFix{ch}(1) = V1rfParamsOrig{ch}(1) + unique(V1crData.fix_x);
            V1rfParamsRelGlassFix{ch}(2) = V1rfParamsOrig{ch}(2) + unique(V1crData.fix_y);
            
            V4rfParamsRelGlassFix{ch}(1) = V4rfParamsOrig{ch}(1) + unique(V4crData.fix_x);
            V4rfParamsRelGlassFix{ch}(2) = V4rfParamsOrig{ch}(2) + unique(V4crData.fix_y);
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
    useChV1LE = find(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & V1trData.good_ch);
    useChV1RE = find(V1data.conRadRE.goodCh & V1data.conRadRE.inStim & V1trData.good_ch);
    
    useChV4LE = find(V4data.conRadLE.goodCh & V4data.conRadLE.inStim & V4trData.good_ch);
    useChV4RE = find(V4data.conRadRE.goodCh & V4data.conRadRE.inStim & V4trData.good_ch);
    
    if eye == 1
        if ~contains(V1data.trLE.animal,'XT')
            makeGlassPlots_crNdxVoriDiff(V1trData, v1LEconRadNdx, useChV1LE, V1rfParamsRelGlassFix, 1)
        end
        makeGlassPlots_crNdxVoriDiff(V4trData, v1REconRadNdx, useChV1RE, V1rfParamsRelGlassFix, 3)
    else
        if ~contains(V1data.trLE.animal,'XT')
            makeGlassPlots_crNdxVoriDiff(V1trData,  v4LEconRadNdx, useChV4LE, V4rfParamsRelGlassFix, 2)
        end
        makeGlassPlots_crNdxVoriDiff(V4trData,  v4REconRadNdx, useChV4RE, V4rfParamsRelGlassFix, 4)
    end
    
end
%%
%% save figure
figDir = '/Users/brittany/Dropbox/Thesis/Glass/figures/conRadvOri';
if~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

set(gcf,'InvertHardcopy','off','color','w')
figName = [V1data.trLE.animal,'_conRadNdxVStrOriDiff_Grat'];
print(gcf, figName,'-dpdf','-bestfit')