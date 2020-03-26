function [y,varargout] = MakeBwRcBwFilteredStim(ppd,fps,imN,tN,...
    sfH,sfL,bwOrd,tfH,tfL,bwOrdT,oriC,oriPow,nS,stimEnv)

imagTol = 1e-2;

[H,D] = MakeBwRcBwFilterSpec(ppd,fps,imN,tN,sfH,sfL,bwOrd,...
    tfH,tfL,bwOrdT,oriC,oriPow);        

x = randn(imN,imN,tN,nS);
X = fft(fft2(x),[],3);
y = fftshift3d(ifft3_symcheck( bsxfun(@times,X,H), imagTol ));

if exist('stimEnv','var')
    y = bsxfun(@times,y,stimEnv);
end

stimStd = std(y(:));
y = y./stimStd;

if nargout>1
    varargout{1} = H;
end
if nargout>2
    varargout{2} = D;
end