function [params,rhat,errornansum,stats] = fit_gaussianrf(x_points,y_points,fr)
%% FITS A 2D gaussian receptive field model to the data to estimate RF location, skew
% INPUT:
%
%       x_points: screen coordinates sampled along horizontal axis. Can be
%       a matrix or a vector
%       y_points: screen coordinates sampled along vertical axis. Can be a
%       matrix or a vector
%       fr      : 2D matrix of responses of size x (m) by y (n). 

if isvector(x_points) && isvector(y_points)
    [x,y] = meshgrid(1:length(x_points),1:length(y_points));
    
    x_find = @(r1) interp1(x(1,:),x_points,r1,'linear','extrap');
    y_find = @(r2) interp1(y(:,1),y_points,r2,'linear','extrap');
    offset = mean(unique(diff(unique(x_points(:),'rows'))));
else
    [x,y] = meshgrid(1:length(x_points(1,:)),1:length(y_points(:,1)));
    x_find = @(r1) interp1(x(1,:),x_points(1,:),r1,'linear','extrap');
    y_find = @(r2) interp1(y(:,1),y_points(:,1),r2,'linear','extrap');
    offset = mean(unique(diff(unique(x_points,'rows'))));
end



lin = @(x) x(:);
func = @(P) gauss_rf(x,y,P);
weights = fr./nansum(fr(:));
error = @(P) nansum(weights(:).* lin((fr-func(P)).^2));
P0 = zeros(7,1);

%guess x0,y0
P0(1) = nansum(fr(:).*x(:))./nansum(fr(:));
P0(2) = nansum(fr(:).*y(:))./nansum(fr(:));
col = fr(:,round(P0(2)));
P0(3) = sqrt(nansum(abs(([1:length(col)]' - P0(2)).^2 .* col))/nansum(col));
row = fr(round(P0(1)),:)';
P0(4) = sqrt(nansum(abs(([1:length(row)]' - P0(2)).^2 .* row))/nansum(row));
P0(5)= 0;
P0(6) = max(fr(:));
P0(7) = min(fr(:));

      %x0  %y0  %rf1 
lb = [min(x(:))-1 min(y(:))-1   .1  .1   0      .1   0   ];
ub = [max(x(:))+1  max(x(:))+1   4   4   2*pi   Inf  Inf];

opts = optimoptions(@fmincon,'Algorithm','sqp');
problem = createOptimProblem('fmincon','objective',...
    error,'x0',P0,'lb',lb,'ub',ub,'options',opts);

[params,f] = run(GlobalSearch,problem);
rhat = func(params);

errornansum = f;
stats = struct;
stats.rfstds = offset*[params(3) params(4)]; %receptive field standard deviations
stats.rf_center = [x_find(params(1)) y_find(params(2))]; %receptive field center
stats.rotation = params(5); %receptive field rotation
stats.gain = params(6); %gain of response
stats.offset = params(7); % firing rate offset
stats.paramsadj = [stats.rf_center(:); stats.rfstds(:); lin(params(5:7))]; %adjusted parameters, reflecting things in degrees







end














