%MOVSHONIZE_GET_TICKLABELS return labels for ticks
%
%   This function creates strings for axis ticks to use as tick labels.
%
%   Input:
%   movshonize_get_tickslabels(ticks,flLog)
%       ticks :     vector with ticks
%       flLog :     True if scale is logaritmic
%                   False if scale is linear
%
%   Output:
%   ticklabels = movshonize_get_tickslabels(..)
%       ticklabels :    cell array with strings
%
% v0: TvG Oct 2015, NYU: outsourced from movshonize_get_ticks

function ticklabels = movshonize_get_tickslabels(ticks,flLog)
if ~flLog
    if any(ticks<0)
        ticklabels = [arrayfun(@(c) sprintf('%+.3g',c),ticks,'uniformoutput',false)];
    else
        ticklabels = [arrayfun(@(c) sprintf('%.3g',c),ticks,'uniformoutput',false)];
    end
else
    if any(log10(ticks)<0)
        ticklabels = [arrayfun(@(c) sprintf('10^{%+.3g}',c),log10(ticks),'uniformoutput',false)];
    else
        ticklabels = [arrayfun(@(c) sprintf('10^{%.3g}',c),log10(ticks),'uniformoutput',false)];
    end
end
