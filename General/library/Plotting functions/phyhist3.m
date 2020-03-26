function h=phyhist3(x,y,width,axislim,colors,varargin)

set(gcf,'color','w');
[rowx,colx]=size(x);
[rowy,coly]=size(y);

if rowx > 1
    error('phyhist3:numedges','too many rows of edges/centers; only one please!');
end

if colx == (coly + 1)
    edges = x;
elseif colx == coly
    centers = x;
else
    error('phyhist3:numcol','number of columns for the labels and data are not valid');
end

if ~exist('width','var')||isempty(width)
    width = 1;
end
if exist('colors','var')&&~isempty(colors)
    cmap = colors;
else
    cmap = [.5 .5 .5;0 0 1;1 0 0];
end

if exist('axislim','var')&&~isempty(axislim)
    minX = axislim(1);
    minY = axislim(3);
    maxX = axislim(2);
    maxY = axislim(4);
else
    minX = min(x(:));
    minY = min(y(:));
    maxX = max(x(:));
    maxY = max(y(:));
end

if exist('edges','var')
    for jj=1:colx-1
        temp = range(edges(jj+[0 1])).*(width)/2*[-1 -1 1 1]+mean(edges(jj+[0 1]));
        patch(temp,[0 y(1,jj) y(1,jj) 0],'w','edgecolor',cmap(1,:),'facecolor',cmap(1,:),'linewidth',1,'facealpha',.5,'edgealpha',.5);
    end
    for jj=1:colx-1
        temp = range(edges(jj+[0 1])).*(width)/3*[-1 -1 0 0]+mean(edges(jj+[0 1]));
        patch(temp,[0 y(2,jj) y(2,jj) 0],'w','edgecolor',cmap(2,:),'facecolor',cmap(2,:));
    end
    for jj=1:colx-1
        temp = range(edges(jj+[0 1])).*(width)/3*[0 0 1 1]+mean(edges(jj+[0 1]));
        patch(temp,[0 y(3,jj) y(3,jj) 0],'w','edgecolor',cmap(3,:),'facecolor',cmap(3,:));
    end
elseif exist('centers','var')
    dcenters = diff(centers)/2;
    dcenters = dcenters([1:end end]);
    for jj=1:colx
        temp = centers(jj)+dcenters(jj).*width.*[-1 -1 1 1];
        A=patch(temp,[0 y(1,jj) y(1,jj) 0],'w','edgecolor',cmap(1,:),'facecolor',cmap(1,:));
        alpha(A,.5);
    end
    for jj=1:colx
        temp = centers(jj)+dcenters(jj).*width.*[-1 -1 1 1];
        patch(temp,[0 y(2,jj) y(2,jj) 0],'w','edgecolor',cmap(2,:),'facecolor',cmap(2,:));
    end
    for jj=1:colx
        temp = centers(jj)+dcenters(jj).*width.*[-1 -1 1 1];
        patch(temp,[0 y(3,jj) y(3,jj) 0],'w','edgecolor',cmap(3,:),'facecolor',cmap(3,:));
    end
end



minX = minX-0.03.*range(x(:));
%minY = minY-0.04.*range(y(:));
%line([minX minX],[minY maxY],'color','k');
%line([minX maxX],[minY minY],'color','k');
%patch([minX minX 0 0],[minY 0 0 minY],'w','edgecolor','w');
set(gca,'tickdir','out','xlim',[minX maxX],'ylim',[minY maxY]);
nparams = nargin-5;
if mod(nparams,2)
    error('phyplot3:nparams','Need value for each extra parameter');
end

ii = 1;
while ii<nparams
    switch varargin{ii}
        case 'xscale'
            switch varargin{ii+1}
                case 'log'
                    set(gca,'xtick',10.^linspace(floor(log10(minX)),floor(log10(maxX)),(floor(log10(maxX))-floor(log10(minX)))*10+1));
                    set(gca,'xticklabel',{'.1' '' '.3' '' '' '' '' '' '' '1' '' '3' '' '' '' '' '' '' '10' '' '30' '' '' '' '' '' '' '100'});
            end
        otherwise
            set(gca,varargin{ii},varargin{ii+1});
    end
    ii = ii + 2;
end

