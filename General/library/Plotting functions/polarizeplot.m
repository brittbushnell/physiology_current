%POLARIZEPLOT converts to a polar plot
%
%   This function convert a regular axis into a polar plot axis.
%
%   Input:
%   polarizeplot(axSrc,axDst)
%       axSrc : Handle of source axis
%               If ommited current axis is used.
%       axDst : Handle of destination axis.
%           	If ommited a new figure will be created.
%       optional inputs: these come in pairs
%           'spokeres' or 'spokeresolution': Resolution of spokes
%
%   Output:
%   h =  polarizeplot(..)
%       h :     figure handle
%
%   Example:
%        figure
%        x = rand(10,1)*randi(10);
%        y = rand(10,1)*randi(10);
%        plot(x,y)
%        title('title')
%        ylabel('y-lab')
%        xlabel('xlabel')
%        movshonize_plots
%        h=polarizeplot;
%        set(h,'position',[-1600 855 560 420])
%
% V0 TvG July, 2015, NYU: created
%   TODO: not create a new figure, but convert the current figure.

function varargout = polarizeplot(axSrc,axDst,varargin)


%% input
if nargin < 1
    axSrc = gca;
end
if nargin < 2
    figure
    axDst = gca;
end

Default = [
    {1,'spokeresolution',30}
    {1,'spokeres',30}
];

[PhiResS] = parse_optional_arg(Default,varargin{:});

%% prepare

% circle
circ        = @(p,r) [cosd(p)*r;sind(p)*r];

% Ring resolution
PhiResR     = 3; % degrees
PhiStepsR   = linspace(0,360,round(360/PhiResR)+1);
PhiStepsR   = PhiStepsR(1:end-1);

% Spoke resolution
%PhiResS     = 30; % degrees
PhiStepsS   = linspace(0,180,round(180/PhiResS)+1);
PhiStepsS   = PhiStepsS(1:end-1);

% position of ticks and labels
PhiTickLabel = 90 - PhiResS/3; % 1/3 off first tick
PhiLabel   = 300 + PhiResS/3;

% properties of old axies
rmax    = max(hypot(xlim(axSrc),ylim(axSrc))); % take diagonal
%rmax    = max(abs([xlim(axSrc),ylim(axSrc)]));
radii   = movshonize_get_ticks([0 rmax]);
radii   = radii(2:end); % exclude zero

% TODO: add extra ring. rmax might be a weird value
% if rmax > max(radii)

% properties to be copied
FontProp = {
    'FontAngle'
    'FontName'
    'FontSize'
    'FontUnits'
    'FontWeight'
    'FontSmoothing'
    };

% store state
oldHold = ishold(axSrc);

%% copy properties and objects
hChilds = get(axSrc,'children');
copyobj(hChilds,axDst);
copyprops(axSrc,axDst); % Also copies titles and axis labels
hold(axDst,'on')

%% titles and labels
h = get(axDst,'title');
p = get(h,'position');
p(1) = 0;
p(2) = rmax*1.2; % shift up
set(h,'position',p,'visible','on')

h = get(axDst,'xlabel');
xy = circ(PhiLabel,-rmax*1.2);
p = get(h,'position');
p(1) = xy(2);
p(2) = xy(1);
set(h,'position',p,'visible','on','horizontalalign','left')

h = get(axDst,'ylabel');
xy = circ(PhiLabel,+rmax*1.2);
p = get(h,'position');
p(1) = xy(2);
p(2) = xy(1);
set(h,'position',p,'visible','on','horizontalalign','right','rotation',0)

%% legend
hSibls = get(get(axSrc,'parent'),'child');
if numel(hSibls) > 1
    hLegSrc = hSibls(ismember(get(hSibls,'type'),'legend'));
else
    % only one child
    hLegSrc = hSibls(strcmp(get(hSibls,'type'),'legend'));
end
if ~isempty(hLegSrc)
    hLegDst = legend(axDst,...
        hChilds(~ismember(get(hChilds,'type'),'text')),...
        hLegSrc.String);
    copyprops(hLegSrc,hLegDst)
end

%% create grid

% store new graphics
hBottom = [];

% outer ring
xy = circ(PhiStepsR([1:end 1]),rmax);
hp = patch(xy(1,:),xy(2,:),'r','parent',axDst);
set(hp,'facecolor','w','edgecolor',[1 1 1]*.8,'linewidth',1)

hBottom = [hBottom;hp];

% r-ticks (rings)
for r = radii
    % rings
    xy = circ(PhiStepsR([1:end 1]),r);
    hp = patch(xy(1,:),xy(2,:),'r','parent',axDst);
    set(hp,'facecolor','none','edgecolor',[1 1 1]*.8,'linewidth',1)
    hBottom = [hBottom;hp];


    % labels
    xy = circ(PhiTickLabel,r);
    h = text(xy(1), xy(2),sprintf('%g\n',r),...
        'horizontalalign','center',...
        'verticalalign','middle');
    cellfun(@(p) set(h,p,get(axSrc,p)),FontProp)
    hBottom = [hBottom;h];

end

% phi-ticks (spokes)
for s = PhiStepsS
    xy = circ (s,[-1 +1]*rmax);
    hp = plot(xy(1,:),xy(2,:),'r','parent',axDst);
    set(hp,'color',[1 1 1]*.8,'linewidth',1)
    hBottom = [hBottom;hp];

    % labels
    xy = circ(s,rmax*1.1);
    h = text(xy(1), xy(2),sprintf('%g',s),...
        'horizontalalign','center',...
        'verticalalign','middle');
    cellfun(@(p) set(h,p,get(axSrc,p)),FontProp)
    
    xy = circ(s,-rmax*1.1);
    h = text(xy(1), xy(2),sprintf('%g',s+180),...
        'horizontalalign','center',...
        'verticalalign','middle');
    cellfun(@(p) set(h,p,get(axSrc,p)),FontProp)
end

uistack(flipud(hBottom),'bottom')

%% finalize

% square
axis(axDst,'square')

% limits
set(axDst,'xlim',[-1 +1]*rmax,'ylim',[-1 +1]*rmax,'visible','off')

% shrink to fit labels
rect = get(axDst,'position');
Shrink = 0.9;
rectNew = rect;
rectNew(1) = rect(1) + (rect(3) - rect(3) * Shrink)/2;
% commented out: move lateral only, not up-down
%rectNew(2) = rect(2) + (rect(4) - rect(4) * Shrink)/2;
rectNew([3 4]) = rect([3 4]) * Shrink;
set(axDst,'position',rectNew)

% turn hold off if it was off
if ~oldHold
    hold(axDst,'off')
end

%% output
c=0;
if nargout > 0
    c=c+1;
    varargout{c} = get(axDst,'parent');
end

return
%% example
close all
figure
x = rand(10,1)*randi(10);
y = rand(10,1)*randi(10);
plot(x,y)
title('title')
ylabel('y-lab')
xlabel('xlabel')
movshonize_plots
h=polarizeplot;

set(h,'position',[-1600 855 560 420])
