function [m, ub, lb] = cimean(R, percentage, nBoot)
% Computes a bootstrapped confidence interval of the mean.
% Inputs:
%       - R = distribution of values
%       - percentage = % to calculate confidence interval. For example, a
%       value of 95 = compute 95% confidence interval (from 2.5% to 97.5%
%       of the bootstrapped mean distribution); this 95% of the
%       distribution in which we believe the true mean of the original
%       distrubtion R to lie.
%       - nBoot = number of times to run the bootstrap. Default is 10,000
%       if not supplied.
% Outputs:
%       - ub = upper bound (mean + CI)
%       - lb = lower bound (mean - CI)
if isempty(nBoot)
    nBoot = 10000;
end

% Create a bootstrapped distribution of means. 
% For each iteration, bootstrap a new distribution (sampling with
% replacement) 
B_mean      = NaN(1,nBoot);
nSamp       = length(R);
for iB = 1:nBoot
    B_dist      = datasample(R, nSamp);
    B_mean(iB)  = nanmean(B_dist);
end

% Calculate upper and lower percentiles of distribution
m   = nanmean(R);
ub  = prctile(B_mean, 50 + percentage/2);
lb  = prctile(B_mean, 50 - percentage/2);