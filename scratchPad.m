zs1 = LEzTR(:,:,:,2,:,(LEprefLoc == 1));
zs1 = reshape(zs1,1,numel(zs1));
zs2 = LEzTR(:,:,:,2,:,(LEprefLoc == 2));
zs2 = reshape(zs2,2,numel(zs2));
zs3 = LEzTR(:,:,:,2,:,(LEprefLoc == 3));
zs3 = reshape(zs3,1,numel(zs3));
zs = [zs1 zs2 zs3];