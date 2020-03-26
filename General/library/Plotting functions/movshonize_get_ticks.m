
%MOVSHONIZE_GET_TICKS helper function for movshonize_plots
%
%   movshonize_get_ticks(X) calculates tick locations in the range of X
%
%   from plot instructions:
%       - Major ticks
%       Max ticks:    6 ticks (with labels)
%       tick lenght:  0.1 in
%       - Minor ticks
%       tick length: 0.05 in
%
%   Input:
%   movshonize_get_ticks(lim)
%       lim :   Limits
%       optional arguments: these come in pairs
%           'nticks':   number of ticks. Default 6
%           'scale':    Scale of axis
%               'log' - logarithmic
%               Default 'lin' - linear
%
%   Output:
%   ticks = movshonize_get_ticks(..)
%       ticks : axis ticks
%   [ticks,ticklabels] = movshonize_get_ticks(..)
%       Optional output
%       ticklabels :    Labels of ticks
%
% v1: TvG Oct 2015, NYU: added help. Added labels. and outsourced again


function [ticks,varargout] = movshonize_get_ticks(lim,varargin)

%% find number of optional arguments and parse them
Default = [
    {1,'nticks',6}          % Number of ticks
    {2,'scale','lin'}       % scale. Alternative 'log'
    ];
[
    nticks,...
    scale,...
    ] = parse_optional_arg(Default,varargin{:});

flLog = ismember(scale,[{'log'},{'logarithmic'}]);


%% set ticks
MinAx = min(lim);
MaxAx = max(lim);
Range = MaxAx-MinAx;
if ~flLog
    logRange = floor(log10(Range/nticks));
    Step = 10^(logRange);
    %Step  = floor(Range/10^logRange)*10^(logRange-1);
    Steps = [ceil(MinAx/Step)*Step:Step:floor(MaxAx/Step)*Step];
    if numel(Steps) < nticks
        c = 1;
        while numel(Steps) < nticks
            c=c*2;
            Steps = [Steps(1):Step/c:Steps(end)];
            if c>100
                % break loop
                nticks = -inf;
            end
        end
    else
        c = 1;
        while numel(Steps) > nticks
            c=c*2;
            rm = true(1,numel(Steps));
            rm(1:2:end) = false;
            Steps = Steps(~rm);
            if c>100
                % break loop
                nticks = +inf;
            end
        end
    end
    
    ticks = Steps;
else
    c=2;
    Steps = round(log10(MinAx)*c:log10(MaxAx)*c)/c;
    while numel(Steps) > nticks
        c=c/2;
        Steps = round(log10(MinAx)*c:log10(MaxAx)*c)/c;
        if c>100
            % break loop
            nticks = -inf;
        end
    end
    ticks = round(10.^Steps,1,'significant');
end

%% labels
if nargout == 2
    varargout{1} = movshonize_get_tickslabels(ticks,flLog);
end
