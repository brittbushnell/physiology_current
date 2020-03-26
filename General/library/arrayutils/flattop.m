function [img,mask] = flattop(img,amount)
% [img,mask]=flattop(img,amount)
% 
% Applies a flattop mask to an image. A flattop is basically an aperture
% whose outer 1/amount diameter is Gaussian feathered to zero over the remaining
% image size. So an amount value of 4 means the inner 50% of the image is
% at full value, while the outer half falls off with a Guassian profile.
thetype = class(img);
img = double(img);
[npixX,npixY] = size(img);
[x,y]=ndgrid(linspace(-1,1,npixX),linspace(-1,1,npixY));
[~,r] = cart2pol(x,y);
mask = exp(-0.5*((r-(1-2/amount))/((2/amount)/3)).^2);
mask(r<=(1-2/amount)) = 1;
img = eval(sprintf('%s(bsxfun(@times,img,mask))',thetype));