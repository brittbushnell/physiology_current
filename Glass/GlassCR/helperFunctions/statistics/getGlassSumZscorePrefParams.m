function [V1, V4] = getGlassSumZscorePrefParams(V1,V4)
%% V1 LE
radZ = squeeze(V1.conRadLE.radZscore (end,:,:,:,:));
conZ = squeeze(V1.conRadLE.conZscore (end,:,:,:,:));
if contains(V1.conRadLE.animal,'XT')
    nozZ = squeeze(V1.conRadLE.noiseZscore(:,:,:,:));
else
    nozZ = squeeze(V1.conRadLE.noiseZscore(1,:,:,:,:));
end

ndx = 1;
for ch = 1:96
    if V1.trLE.inStimCenter(ch) == 1 && V1.trRE.goodCh(ch) == 1
        if V1.trLE.prefParamsIndex(ch) == 1
            prefConZs(ndx,:) = squeeze(conZ(1,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,1,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(1,1,ch,:));
        elseif V1.trLE.prefParamsIndex(ch) == 2
            prefConZs(ndx,:) = squeeze(conZ(1,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,2,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(1,2,ch,:));
        elseif V1.trLE.prefParamsIndex(ch) == 3
            prefConZs(ndx,:) = squeeze(conZ(2,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,1,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(2,1,ch,:));
        else
            prefConZs(ndx,:) = squeeze(conZ(2,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,2,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(2,2,ch,:));
        end
        ndx = ndx+1;
    end
end
V1prefConZsLE = nansum(prefConZs,2);
V1prefRadZsLE = nansum(prefRadZs,2);
V1prefNozZsLE = nansum(prefNozZs,2);

clear prefConZs; clear prefRadZs; clear prefNozZs
%% V1 RE
radZ = squeeze(V1.conRadRE.radZscore (end,:,:,:,:));
conZ = squeeze(V1.conRadRE.conZscore (end,:,:,:,:));
if contains(V1.conRadRE.animal,'XT')
    nozZ = squeeze(V1.conRadRE.noiseZscore(:,:,:,:));
else
    nozZ = squeeze(V1.conRadRE.noiseZscore(1,:,:,:,:));
end

ndx = 1;
for ch = 1:96
    if V1.trRE.inStimCenter(ch) == 1 && V1.trRE.goodCh(ch) == 1
        if V1.trRE.prefParamsIndex(ch) == 1
            prefConZs(ndx,:) = squeeze(conZ(1,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,1,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(1,1,ch,:));
        elseif V1.trRE.prefParamsIndex(ch) == 2
            prefConZs(ndx,:) = squeeze(conZ(1,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,2,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(1,2,ch,:));
        elseif V1.trRE.prefParamsIndex(ch) == 3
            prefConZs(ndx,:) = squeeze(conZ(2,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,1,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(2,1,ch,:));
        else
            prefConZs(ndx,:) = squeeze(conZ(2,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,2,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(2,2,ch,:));
        end
        ndx = ndx+1;
    end
end
V1prefConZsRE = nansum(prefConZs,2);
V1prefRadZsRE = nansum(prefRadZs,2);
V1prefNozZsRE = nansum(prefNozZs,2);

clear prefConZs; clear prefRadZs; clear prefNozZs
%% V4 LE
radZ = squeeze(V4.conRadLE.radZscore (end,:,:,:,:));
conZ = squeeze(V4.conRadLE.conZscore (end,:,:,:,:));
if contains(V4.conRadLE.animal,'XT')
    nozZ = squeeze(V4.conRadLE.noiseZscore(:,:,:,:));
else
    nozZ = squeeze(V4.conRadLE.noiseZscore(1,:,:,:,:));
end

ndx = 1;
for ch = 1:96
    if V4.trLE.inStimCenter(ch) == 1 && V1.trRE.goodCh(ch) == 1
        if V4.trLE.prefParamsIndex(ch) == 1
            prefConZs(ndx,:) = squeeze(conZ(1,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,1,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(1,1,ch,:));
        elseif V4.trLE.prefParamsIndex(ch) == 2
            prefConZs(ndx,:) = squeeze(conZ(1,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,2,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(1,2,ch,:));
        elseif V4.trLE.prefParamsIndex(ch) == 3
            prefConZs(ndx,:) = squeeze(conZ(2,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,1,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(2,1,ch,:));
        else
            prefConZs(ndx,:) = squeeze(conZ(2,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,2,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(2,2,ch,:));
        end
        ndx = ndx+1;
    end
end
V4prefConZsLE = nansum(prefConZs,2);
V4prefRadZsLE = nansum(prefRadZs,2);
V4prefNozZsLE = nansum(prefNozZs,2);

clear prefConZs; clear prefRadZs; clear prefNozZs
%% V4 RE
radZ = squeeze(V4.conRadRE.radZscore (end,:,:,:,:));
conZ = squeeze(V4.conRadRE.conZscore (end,:,:,:,:));
if contains(V4.conRadRE.animal,'XT')
    nozZ = squeeze(V4.conRadRE.noiseZscore(:,:,:,:));
else
    nozZ = squeeze(V4.conRadRE.noiseZscore(1,:,:,:,:));
end

ndx = 1;
for ch = 1:96
    if V4.trRE.inStimCenter(ch) == 1 && V1.trRE.goodCh(ch) == 1
        if V4.trRE.prefParamsIndex(ch) == 1
            prefConZs(ndx,:) = squeeze(conZ(1,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,1,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(1,1,ch,:));
        elseif V4.trRE.prefParamsIndex(ch) == 2
            prefConZs(ndx,:) = squeeze(conZ(1,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,2,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(1,2,ch,:));
        elseif V4.trRE.prefParamsIndex(ch) == 3
            prefConZs(ndx,:) = squeeze(conZ(2,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,1,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(2,1,ch,:));
        else
            prefConZs(ndx,:) = squeeze(conZ(2,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,2,ch,:));
            prefNozZs(ndx,:) = squeeze(nozZ(2,2,ch,:));
        end
        ndx = ndx+1;
    end
end
V4prefConZsRE = nansum(prefConZs,2);
V4prefRadZsRE = nansum(prefRadZs,2);
V4prefNozZsRE = nansum(prefNozZs,2);

clear prefConZs; clear prefRadZs; clear prefNozZs
%% commit to structures
V1.conRadRE.prefConZsInCenter = V1prefConZsRE;
V1.conRadRE.prefRadZsInCenter = V1prefRadZsRE;
V1.conRadRE.prefNozZsInCenter = V1prefNozZsRE;

V1.conRadLE.prefConZsInCenter = V1prefConZsLE;
V1.conRadLE.prefRadZsInCenter = V1prefRadZsLE;
V1.conRadLE.prefNozZsInCenter = V1prefNozZsLE;

V4.conRadRE.prefConZsInCenter = V4prefConZsRE;
V4.conRadRE.prefRadZsInCenter = V4prefRadZsRE;
V4.conRadRE.prefNozZsInCenter = V4prefNozZsRE;

V4.conRadLE.prefConZsInCenter = V4prefConZsLE;
V4.conRadLE.prefRadZsInCenter = V4prefRadZsLE;
V4.conRadLE.prefNozZsInCenter = V4prefNozZsLE;