function [prefSf, prefSfLog] = prefSfFromFit(muy)
% Input: 
%   - muy - output parameterfrom FitDVMBlob(0-5). This is the peak SF in
%   the 0-13 'fake log' scale used to fit spatial frequency responses

if muy < 1
    prefSf = NaN;
    prefSfLog = NaN;
else
    %y = [1:13];                    % indexing scheme for fitting
    %logy = [-2:0.5:4];             % equivalent to -2 + (y-1)*0.5 - octave
    %                               % SFs that stimuli were sampled at
    prefSfLog = -2 + (muy-1)*0.5;
    prefSf = 2^prefSfLog;
end
    