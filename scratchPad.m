conSig = V4data.conRadRE.conNoiseDprimeSig;
radSig = V4data.conRadRE.radNoiseDprimeSig;
trSig = V4data.trRE.linNoiseDprimeSig(;

radNoiseDprime = V4data.conRadRE.radNoiseDprime;
conNoiseDprime = V4data.conRadRE.conNoiseDprime;
trNoiseDprime = V4data.trRE.linNoiseDprime;
goodCh = (V4data.conRadRE.goodCh & V4data.trRE.goodCh);
inStim = (V4data.conRadRE.inStim & V4data.trRE.inStim);
cohNdx = 4;
%
radDps = abs(squeeze(radNoiseDprime(cohNdx,:,:,:)));
conDps = abs(squeeze(conNoiseDprime(cohNdx,:,:,:)));
trDps = abs(squeeze(trNoiseDprime(:,cohNdx,:,:,:)));
trDps = squeeze(mean(trDps,1));


rDp = squeeze([squeeze(radDps(1,1,:)),squeeze(radDps(1,2,:)),squeeze(radDps(2,1,:)),squeeze(radDps(2,2,:))]); 
rSg = squeeze([squeeze(radSig(1,1,:)),squeeze(radSig(1,2,:)),squeeze(radSig(2,1,:)),squeeze(radSig(2,2,:))]); 
[rDp2,rNdx] = max(rDp,[],2);
rDp = rDp(goodCh == 1 & inStim == 1);
rDp = rDp';

cDp = squeeze([squeeze(conDps(1,1,:)),squeeze(conDps(1,2,:)),squeeze(conDps(2,1,:)),squeeze(conDps(2,2,:))]);
cSg = squeeze([squeeze(conSig(1,1,:)),squeeze(conSig(1,2,:)),squeeze(conSig(2,1,:)),squeeze(conSig(2,2,:))]); 
cDp = max(cDp,[],2);
cDp = cDp(goodCh == 1 & inStim == 1);
cDp = cDp';

tDp = squeeze([squeeze(trDps(1,1,:)),squeeze(trDps(1,2,:)),squeeze(trDps(2,1,:)),squeeze(trDps(2,2,:))]);
tSg = squeeze([squeeze(trSig(1,1,:)),squeeze(trSig(1,2,:)),squeeze(trSig(2,1,:)),squeeze(trSig(2,2,:))]); 
tDp = max(tDp,[],2);
tDp = tDp(goodCh == 1 & inStim == 1);
tDp = tDp';

stimDps = [rDp,cDp,tDp]; % t