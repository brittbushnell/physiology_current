function dtDxPref = getPrefDtDx(stimNoiseDprime,includedCh)


dps = abs(squeeze(stimNoiseDprime(end,:,:,:)));

rDp = squeeze([squeeze(dps(1,1,:)),squeeze(dps(1,2,:)),squeeze(dps(2,1,:)),squeeze(dps(2,2,:))]); 
[~,rDp] = max(rDp,[],2);
dtDxPref = rDp(includedCh);





