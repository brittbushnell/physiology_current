function b = ifft3_symcheck(a,tol)
% b = ifft3_symcheck(a)
% Perform ifft3, forcing symmetry only if 
% mean(abs(imag(ifft3()))) / mean(abs(real(ifft3()))) < tol

b = ifft(ifft2(a),[],3);
x = mean(abs(imag(b(:))))./mean(abs(real(b(:))));
if x<tol
    b = ifft(ifft2(a,'symmetric'),[],3,'symmetric');
else
    disp(['ifft3_symcheck: sum(abs(imag(ifft3()))) = ',num2str(x)])
    b=[];
end