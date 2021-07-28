function [v1LEsort, v1REsort, v4LEsort, v4REsort,cmap,sortDps] = getGlassSortedMats_grat(V1data,gratData)

%% get the input matrices for each eye and array using mean orientation
V1dataRE  = getGlassDprimeNoiseVectTriplots_meanOri(V1data.conRadRE.radNoiseDprime, V1data.conRadRE.conNoiseDprime, V1data.trRE.linNoiseDprime,...
    (V1data.conRadRE.goodCh & V1data.conRadRE.inStim), (gratData.good_ch));

V1dataLE  = getGlassDprimeNoiseVectTriplots_meanOri(V1data.conRadLE.radNoiseDprime, V1data.conRadLE.conNoiseDprime, V1data.trLE.linNoiseDprime,...
    (V1data.conRadLE.goodCh & V1data.trLE.goodCh), (V1data.conRadLE.inStim & V1data.trLE.inStim));
%% get the gray scaling across all 4
ndx1 = ones(size(V1dataLE,1),1);
ndx2 = ones(size(V1dataRE,1),1)+1;
ndx3 = ones(size(V4dataLE,1),1)+2;
ndx4 = ones(size(V4dataRE,1),1)+3;

catdps = cat(1,V1dataLE, V1dataRE, V4dataLE, V4dataRE);
catdps(:,4) = sqrt(catdps(:,1).^2 + catdps(:,2).^2 + catdps(:,3).^2); % vector sum of the responses to radial, concentric, and dipole used to rank order for colormapping
catdps(:,5) = [ndx1;ndx2;ndx3;ndx4];

[~,sortNdx] = sort(catdps(:,4),'descend');
sortDps = catdps(sortNdx,:);

cmap = gray(length(catdps));
sortDps(:,6:8) = cmap; % make black be highest, white lowest
%% break sortDps into smaller matrices for each of the subplots
v1LEsort = sortDps(sortDps(:,5) == 1,:);
v1REsort = sortDps(sortDps(:,5) == 2,:);
v4LEsort = sortDps(sortDps(:,5) == 3,:);
v4REsort = sortDps(sortDps(:,5) == 4,:);