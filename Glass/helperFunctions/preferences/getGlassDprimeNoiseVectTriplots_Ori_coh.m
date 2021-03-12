function [stimDps] = getGlassDprimeNoiseVectTriplots_Ori_coh(data,eye,cohNdx,orNdx)
%%
% output is a matrix where each row is a different channel and columns are
% radial, concentric, and translational respectively.

%%
if contains(eye,'LE')
    conSig = data.conRadLE.conNoiseDprimeSig;
    radSig = data.conRadLE.radNoiseDprimeSig;
    trSig = data.trLE.linNoiseDprimeSig;
    
    radNoiseDprime = data.conRadLE.radNoiseDprime;
    conNoiseDprime = data.conRadLE.conNoiseDprime;
    trNoiseDprime = data.trLE.linNoiseDprime;
    goodCh = (data.conRadLE.goodCh .* data.trLE.goodCh);
    inStim = (data.conRadLE.inStim .* data.trLE.inStim);
else
    conSig = data.conRadRE.conNoiseDprimeSig;
    radSig = data.conRadRE.radNoiseDprimeSig;
    trSig = data.trRE.linNoiseDprimeSig;
    
    radNoiseDprime = data.conRadRE.radNoiseDprime;
    conNoiseDprime = data.conRadRE.conNoiseDprime;
    trNoiseDprime = data.trRE.linNoiseDprime;
    goodCh = (data.conRadRE.goodCh .* data.trRE.goodCh);
    inStim = (data.conRadRE.inStim .* data.trRE.inStim);
end

%%
% always want to use 100% coherence for determining significance.
conSg = squeeze(conSig(end,:,:,:));
cSg = squeeze([squeeze(conSg(1,1,:)),squeeze(conSg(1,2,:)),squeeze(conSg(2,1,:)),squeeze(conSg(2,2,:))]);
cSgCh = logical(sum(cSg,2).* inStim' .* goodCh');

radSg = squeeze(radSig(end,:,:,:));
rSg = squeeze([squeeze(radSg(1,1,:)),squeeze(radSg(1,2,:)),squeeze(radSg(2,1,:)),squeeze(radSg(2,2,:))]);
rSgCh = logical(sum(rSg,2).* inStim' .* goodCh');

trSg = squeeze(trSig(orNdx,end,:,:,:));
trSg = squeeze([squeeze(trSg(1,1,:)),squeeze(trSg(1,2,:)),squeeze(trSg(2,1,:)),squeeze(trSg(2,2,:))]);
trSgCh = logical(sum(trSg,2).* inStim' .* goodCh');

allSig = logical(cSgCh .* rSgCh .* trSgCh); %
%% get d' at the different coherence/orientations.
radDps = abs(squeeze(radNoiseDprime(cohNdx,:,:,:)));
conDps = abs(squeeze(conNoiseDprime(cohNdx,:,:,:)));
trDps = abs(squeeze(trNoiseDprime(orNdx,cohNdx,:,:,:)));

rDp = squeeze([squeeze(radDps(1,1,:)),squeeze(radDps(1,2,:)),squeeze(radDps(2,1,:)),squeeze(radDps(2,2,:))]);
rDp = rDp(allSig,:,:); % only include significant parameters/channels
rDp = max(rDp,[],2);

cDp = squeeze([squeeze(conDps(1,1,:)),squeeze(conDps(1,2,:)),squeeze(conDps(2,1,:)),squeeze(conDps(2,2,:))]);
cDp = cDp(allSig,:,:);
cDp = max(cDp,[],2);

tDp = squeeze([squeeze(trDps(1,1,:)),squeeze(trDps(1,2,:)),squeeze(trDps(2,1,:)),squeeze(trDps(2,2,:))]);
tDp = tDp(allSig,:,:);
tDp = max(tDp,[],2);

stimDps = [rDp,cDp,tDp];