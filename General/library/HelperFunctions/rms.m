function y = rms(x,dim)
%function y = rms(x,dim)
%
% Calculates the RMS (root-mean-square) in the Dimension, dim, of the
% matrix X.
%
y = sqrt(mean(x.^2,dim));
end
