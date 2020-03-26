function movshonize_plots(axs,method)
if ~strcmpi(java.lang.System.getProperty('user.name'),[{'tomvg'},{'add name to suppress warning'}])
    warning('this function has BETA status')
end
% Some just standardization & tips based on posters in the past. This
% applies for Adobe Illustrator CS3 and higher. If you're using some other
% software, you'll have to figure out how to make the equivalent.
% Specifically, if you're using Apple Pages or Microsoft Powerpoint to
% layout your poster, well then... May God have mercy on your soul.
% - Romesh
%
% - Document Color Mode
% CMYK (All colors will be given as C,M,Y,K)
% Unless specified all text should be black.
% Colors that show up well:
% Black:        (0,0,0,100)
% White:        (0,0,0,0)
% Red:          (0,100,100,0)
% Orange:       (0,50,100,0)
% Green:        (100,0,100,0)
% Cyan:         (100,0,0,0)
% Violet:       (50,100,0,0)
% "Pattern":    (0,82,93,0) - For pattern prediction, though pure red works well too.
% "Comp":"      (93,25,4,0) - For component prediction
%
% - Document Size
% Width:    68in (SFN)
% Height:   41in (SFN)
%
% - Section Headers
% Font:     Helvetica
% Style:    Bold
% Size:     32 pt
% Color:    Red (0,100,100,0)
%
% - General Text
% Font:     Helvetica
% Style:    Oblique
% Size:     10 pt
%
% - Emphasized Text
% Font:     Helvetica
% Style:    Bold Oblique
% Size:     10 pt
%
% - Figures
% Size: 4 x 4 in (without axes)
%
% - Axis Numbers & Labels
% Font:     Helvetica
% Style:    Oblique
% Size:     10 pt
% Notes:    Only the first letter of the label should be capitalized.
%
% - Axes
% Weigth:   1pt
% Color:    Black
% Cap:      Round
% Join:     Round
% Size:     10 pt
% Notes:    Axes for cartesian plots should not be attached at the origin.
%           Tick marks should face outwards.
%
% - Data lines
% weight: 5
%
% - Data points
% Edge color:   White
% Stroke:       1 pt
% Size:         0.2 in diameter
% Notes:        Should be a circular path.
%
% - Major ticks
% Max ticks:    6 ticks (with labels)
% tick lenght:  0.1 in
%
% - Minor ticks
% tick length: 0.05 in
%
% - Grid lines
% Weight:   1pt
% Dash:     2pt
% Gap:      4pt
% Cap:      Butt
% Join:     Round
%
% - Dashed lines
% Weight:   2 pt
% Dash:     6 pt
% Cap:      Butt
% Join:     Round
% Note:     Use For emphasizing statistical or categorical boundaries, etc.
%


if nargin < 2
    method = 'display';
end
if nargin < 1
    axs = gca;
end
if strcmpi(get(axs,'type') , 'figure')
    axs = get(axs,'children');
end
%%
for ax = axs(:)'
    set(ax,'Color','none')
    set(ax,'units','inches')
    %opos = get(ax,'OuterPosition');
    apos = get(ax,'Position');
    
    aW_fin = 4;
    aH_fin = 4;
    aW_ini = apos(3);
    aH_ini = apos(4);
    aW_dif = aW_fin-aW_ini;
    aH_dif = aH_fin-aH_ini;
    
    %opos_fin = opos+[0 0 aW_dif aH_dif];
    %apos_fin = apos+[0 0 aW_dif aH_dif];
    %set(ax,'OuterPosition',opos_fin,'Position',apos_fin)
    
    fpos = get(get(ax,'parent'),'position');
    fpos_fin = fpos .* ([1 1 1 1] + [0 0 (aW_dif*.75)/aW_ini (aH_dif*.75)/aH_ini]);
    %set(get(ax,'parent'),'position',fpos_fin)
    
    dpos = [0 0 diff(get(ax,'XLim')) diff(get(ax,'YLim'))];
    inch = dpos([3 4]) ./ apos([3 4]);
    
    %% set ticks
    if strcmpi(get(gca,'xscale'),'linear')
        ticks = movshonize_get_ticks(xlim);
        %set(gca,'xtick',ticks)
    end
    
    if  strcmpi(get(gca,'yscale'),'linear')
        ticks = movshonize_get_ticks(ylim);
        %set(gca,'xtick',ticks)
    end
    
    %% store ticks for later use
    xl = get(ax,'XLim');
    yl = get(ax,'YLim');
    xt = get(ax,'XTick');
    yt = get(ax,'YTick');
    xtl = get(ax,'XTickLabel');
    ytl = get(ax,'YTickLabel');
    switch get(gca,'XAxisLocation')
        case 'bottom'
            ybase = xl(1)-inch(1)*.1;
            yt_x = ybase+[0 -1]*inch(1)*.1;
            val = 'top';
        case 'top'
            ybase = xl(2)+inch(1)*.1;
            yt_x = ybase+[0 +1]*inch(1)*.1;
            val = 'bottom';
    end
    switch get(gca,'YAxisLocation')
        case 'left'
            xbase = yl(1)-inch(2)*.1;
            xt_y = xbase+[0 -1]*inch(2)*.1;
            hal = 'right';
            rot = +90;
        case 'right'
            xbase = yl(2)+inch(2)*.1;
            xt_y = xbase+[0 +1]*inch(2)*.1;
            hal = 'left';
            rot = -90;
    end
    
    %%
    set(ax, ...
        'TickDir','out',...
        'TickLength',[.05 .05],...
        'Box','off',...
        'FontName','Helvetica','FontAngle','Oblique','Fontsize',12, ...
        'units','normalized')
    if strcmpi('axes',get(ax,'Type')) % not colorbar
        set(ax ,...
            'XMinorTick','on',...
            'YMinorTick','on')
    end
    switch method 
        case 'print'            
            set(ax,'Visible','off')
            oldhold = ishold;
            hold on
            plot(xl,[1 1]*xbase,'-k','clipping','off')
            plot([1 1]*ybase,yl,'-k','clipping','off')
            plot(repmat(xt',1,2)',repmat(xt_y,numel(xt),1)','-k','clipping','off')
            plot(repmat(yt_x,numel(yt),1)',repmat(yt',1,2)','-k','clipping','off')
            Nxt = numel(xt);
            if ~isempty(xtl)
                for ixt = 1:Nxt
                    cxtl = deblank(xtl(ixt,:));
                    text(xt(ixt),xt_y(2),cxtl,'verticalalign',val,'horizontalalign','center','FontName','Helvetica','FontAngle','Oblique','Fontsize',12)
                end
            end
            Nyt = numel(yt);
            if ~isempty(ytl)
                for iyt = 1:Nyt
                    cytl = deblank(ytl(iyt,:));
                    text(yt_x(2),yt(iyt),cytl,'verticalalign','middle','horizontalalign',hal,'FontName','Helvetica','FontAngle','Oblique','Fontsize',12)
                end
            end
            
            text(mean(xl),xt_y(2),sprintf(['\n'   formatstr(get(get(ax,'xlabel'),'string')) ''   ]),'verticalalign',val,'horizontalalign','center','FontName','Helvetica','FontAngle','Oblique','Fontsize',12)
            text(yt_x(2),mean(yl),sprintf([''   formatstr(get(get(ax,'ylabel'),'string')) '\n' ]),'verticalalign','bottom','horizontalalign','center','FontName','Helvetica','FontAngle','Oblique','Fontsize',12,'Rotation',rot)
            text(mean(xl),max(yl),sprintf([''   formatstr(get(get(ax,'title'),'string'))  ''   ]),'verticalalign','bottom','horizontalalign','center','FontName','Helvetica','FontAngle','Oblique','Fontsize',12)
            if oldhold==0
                hold off
            end
        case 'display'
            set(get(gca,'xlabel'),'FontName','Helvetica','FontAngle','Oblique','FontWeight','bold','Fontsize',12)
            set(get(gca,'ylabel'),'FontName','Helvetica','FontAngle','Oblique','FontWeight','bold','Fontsize',12)
            set(get(gca,'zlabel'),'FontName','Helvetica','FontAngle','Oblique','FontWeight','bold','Fontsize',12)
            set(get(gca,'title'),'FontName','Helvetica','FontAngle','Oblique','FontWeight','bold','Fontsize',12)
            Scale = get(gca,'xscale');
            if strcmp(Scale,'log')
                Chld = get(gca,'child');
                if numel(Chld) > 1
                    selChld = ~ismember(get(Chld,'type'),'text');
                    Data = get(Chld(selChld),'xdata');
                else
                    Data = {get(Chld,'xdata')};
                end
                Data = cellfun(@(d) d(d>0 & d<inf),Data,'uniformoutput',false);
                Lim =[
                    min(cellfun(@min,Data))
                    max(cellfun(@max,Data))
                    ];
            else
                Lim = get(gca,'xlim');
            end
            set(gca,'xtick',movshonize_get_ticks(Lim,'scale',Scale))
            
            Scale = get(gca,'yscale');
            if strcmp(Scale,'log')
                Chld = get(gca,'child');
                if numel(Chld) > 1
                    selChld = ~ismember(get(Chld,'type'),'text');
                    Data = get(Chld(selChld),'ydata');
                else
                    Data = {get(Chld,'ydata')};
                end
                Data = cellfun(@(d) d(d>0 & d<inf),Data,'uniformoutput',false);
                Lim =[
                    min(cellfun(@min,Data))
                    max(cellfun(@max,Data))
                    ];
            else
                Lim = get(gca,'ylim');
            end
            set(gca,'ytick',movshonize_get_ticks(Lim,'scale',Scale))
    end
            
end

%%%%
function so = formatstr(si)

nl = size(si,1);
s_lines = cell(1,nl);
for iL = 1:nl
    str = si(iL,:);
    
    str = deblank(str);
    str = regexptranslate('escape',str);
    str = regexprep(str,'\\[','[');
    str = regexprep(str,'\\]',']');
    str = regexprep(str,'\\(','(');
    str = regexprep(str,'\\)',')');
    str = regexprep(str,'\\-','-');
    str = regexprep(str,'\\.','.');
    str = regexprep(str,'%','%%');
    
    s_lines{iL}=str;
end
so=sprintf('%s\\n',s_lines{:});
so = so(1:end-2);