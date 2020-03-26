function [dc,fx,phz]=GetHarmonics(psth,Fs,FF)
% function [dc,ff,phz] = GetHarmonics(psth,FS,FF)
%
% Inputs:
% psth - each data set is organized in columns,
%        each row is a new data set
%        
% Fs   - Sampling Frequency (1/time period of each data point)
% FF   - Fundamental Frequency (e.g. temporal frequency)
%
% Outputs:
% dc   - DC/Mean component of the response
% fx   - first harmonic component of the response at the FF.
% phz  - phase of the fx response
%

if ~exist('Fs','var')
    Fs = 1000; % default to 1000Hz (or 1 ms bins)
end
if ~exist('FF','var')
    FF = 1; % default to 1 cycle per Fs points
end

[N,L] = size(psth); 
% rows = number of psths; 
% cols = psth length

if (length(FF) == 1) && (N > 1)
    FF = repmat(FF,N,1);
end

if length(FF) ~= N
    error ('ExpoMatlab:GetHarmonics','Incorrect number of FFs given.');
end

j       = complex(0,1);
timevec = repmat(0:L-1,N,1);
dc      = mean(psth,2);
fx      = zeros(N,1);
phz     = zeros(N,1);
for ii = 1:N
    fx(ii,1)  = 2*abs(sum(psth(ii,:).*exp((-2*pi*j/Fs)*FF(ii).*timevec(ii,:)),2)/L);
    phz(ii,1) = angle(sum(psth(ii,:).*exp((-2*pi*j/Fs)*FF(ii).*timevec(ii,:)),2)/L);
end