
inclConRadLEV1 = (V1data.conRadLE.goodCh == 1) & (V1data.conRadLE.inStim == 1);
incltrLEV1 = (V1data.trLE.goodCh == 1) & (V1data.trLE.inStim == 1);

conDLEV1 = abs(squeeze(V1data.conRadLE.conNoiseDprime(end,:,:,:)));
cDpLEV1 = squeeze([squeeze(conDLE(1,1,:)),squeeze(conDLE(1,2,:)),squeeze(conDLE(2,1,:)),squeeze(conDLE(2,2,:))]);
[~,conDtDxPrefLEV1] = max(cDpLE,[],2);
% conDtDxPref = cDp(inclConRadLE);

radDLEV1 = abs(squeeze(V1data.conRadLE.radNoiseDprime(end,:,:,:)));
rDpLEV1 = squeeze([squeeze(radDLEV1(1,1,:)),squeeze(radDLEV1(1,2,:)),squeeze(radDLEV1(2,1,:)),squeeze(radDLEV1(2,2,:))]);
[~,radDtDxPrefLEV1] = max(rDpLEV1,[],2);
% radDtDxPref = rDp(inclConRadLE);

for o = 1:4
    trDLEV1 = abs(squeeze(V1data.trLE.linNoiseDprime(o,end,:,:,:)));
    trDpLEV1 = squeeze([squeeze(trDLEV1(1,1,:)),squeeze(trDLEV1(1,2,:)),squeeze(trDLEV1(2,1,:)),squeeze(trDLEV1(2,2,:))]);
    [~,trDtDxPrefLEV1(:,o)] = max(trDpLEV1,[],2);
end

inclConRadREV1 = (V1data.conRadRE.goodCh == 1) & (V1data.conRadRE.inStim == 1);
incltrREV1 = (V1data.trRE.goodCh == 1) & (V1data.trRE.inStim == 1);

conDREV1 = abs(squeeze(V1data.conRadRE.conNoiseDprime(end,:,:,:)));
cDpREV1 = squeeze([squeeze(conDREV1(1,1,:)),squeeze(conDREV1(1,2,:)),squeeze(conDREV1(2,1,:)),squeeze(conDREV1(2,2,:))]);
[~,conDtDxPrefREV1] = max(cDpREV1,[],2);
% conDtDxPref = cDp(inclConRadRE);

radDRE = abs(squeeze(V1data.conRadRE.radNoiseDprime(end,:,:,:)));
rDpRE = squeeze([squeeze(radDRE(1,1,:)),squeeze(radDRE(1,2,:)),squeeze(radDRE(2,1,:)),squeeze(radDRE(2,2,:))]);
[~,radDtDxPrefREV1] = max(rDpRE,[],2);
% radDtDxPref = rDp(inclConRadRE);

for o = 1:4
    trDREV1 = abs(squeeze(V1data.trRE.linNoiseDprime(o,end,:,:,:)));
    trDpREV1 = squeeze([squeeze(trDREV1(1,1,:)),squeeze(trDREV1(1,2,:)),squeeze(trDREV1(2,1,:)),squeeze(trDREV1(2,2,:))]);
    [~,trDtDxPrefREV1(:,o)] = max(trDpREV1,[],2);
end