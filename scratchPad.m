
for ch = 1:96
    if V1.trLE.prefParamsIndex(ch) == 1 && V1.conRadLE.inStim(ch) == 1
        V1radLE = abs(squeeze(V1.conRadLE.radBlankDprime(end,1,1,ch)));
        V1conLE = abs(squeeze(V1.conRadLE.conBlankDprime(end,1,1,ch)));
        V1nozLE = abs(squeeze(V1.conRadLE.noiseBlankDprime(1,1,1,ch)));
    elseif V1.trLE.prefParamsIndex(ch) == 2 && V1.conRadLE.inStim(ch) == 1
        V1radLE = abs(squeeze(V1.conRadLE.radBlankDprime(end,1,2,ch)));
        V1conLE = abs(squeeze(V1.conRadLE.conBlankDprime(end,1,2,ch)));
        V1nozLE = abs(squeeze(V1.conRadLE.noiseBlankDprime(1,1,2,ch)));
    elseif V1.trLE.prefParamsIndex(ch) == 3 && V1.conRadLE.inStim(ch) == 1
        V1radLE = abs(squeeze(V1.conRadLE.radBlankDprime(end,2,1,ch)));
        V1conLE = abs(squeeze(V1.conRadLE.conBlankDprime(end,2,1,ch)));
        V1nozLE = abs(squeeze(V1.conRadLE.noiseBlankDprime(1,2,1,ch)));
    elseif V1.trLE.prefParamsIndex(ch) == 2 && V1.conRadLE.inStim(ch) == 1
        V1radLE = abs(squeeze(V1.conRadLE.radBlankDprime(end,2,2,ch)));
        V1conLE = abs(squeeze(V1.conRadLE.conBlankDprime(end,2,2,ch)));
        V1nozLE = abs(squeeze(V1.conRadLE.noiseBlankDprime(1,2,2,ch)));
    end
        
end
%%
rDp = squeeze([squeeze(V1radLE(1,1,:)),squeeze(V1radLE(1,2,:)),squeeze(V1radLE(2,1,:)),squeeze(V1radLE(2,2,:))]);
rDp = max(rDp');
rDp = rDp';
cDp = squeeze([squeeze(V1conLE(1,1,:)),squeeze(V1conLE(1,2,:)),squeeze(V1conLE(2,1,:)),squeeze(V1conLE(2,2,:))]);
cDp = max(cDp');
cDp = cDp';
nDp = squeeze([squeeze(V1nozLE(1,1,:)),squeeze(V1nozLE(1,2,:)),squeeze(V1nozLE(2,1,:)),squeeze(V1nozLE(2,2,:))]);
nDp = max(nDp');
nDp = nDp';

dps = [rDp,cDp,nDp];


V1.trLE.prefParamsIndex