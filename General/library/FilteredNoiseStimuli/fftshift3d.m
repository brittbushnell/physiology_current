function b = fftshift3d(a)
% b = fftshift3d(a)
% Perform 3D fftshift on every block of a

aRs = reshape(a,size(a,1),size(a,2),size(a,3),[]);
bRs = aRs;
for i = 1:size(aRs,4)
    bRs(:,:,:,i) = fftshift(aRs(:,:,:,i));
end
b = reshape(bRs,size(a));

