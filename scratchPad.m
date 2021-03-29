% debugging/figuring out GlassCoh and why some match perfectly
ch = 29;
conV1RE = squeeze(V1data.conRadRE.conNoiseDprime(:,:,:,ch));
conV4RE = squeeze(V4data.conRadRE.conNoiseDprime(:,:,:,ch));

V1a = (squeeze(conV1RE(:,1,1)));
V1b = (squeeze(conV1RE(:,1,2)));
V1c = (squeeze(conV1RE(:,2,1)));
V1d = (squeeze(conV1RE(:,2,2)));

V4a = (squeeze(conV4RE(:,1,1)));
V4b = (squeeze(conV4RE(:,1,2)));
V4c = (squeeze(conV4RE(:,2,1)));
V4d = (squeeze(conV4RE(:,2,2)));

conBA = [V1a, V4a, V1b, V4b, V1c, V4c, V1d, V4d];
