function scatterplot(x,y,markerstyle)
if strcmp(get(gca,'nextplot'),'replace')
    clf;
end

xrange = range(x(:));
xminimum = min(x(:))-0.05*xrange;
xmaximum = max(x(:))+0.05*xrange;
xplotrange = xmaximum-xminimum;

yrange = range(y(:));
yminimum = min(y(:))-0.05*yrange;
ymaximum = max(y(:))+0.05*yrange;
yplotrange = ymaximum-yminimum;

% defaults

mcolor = 'k';
msize  = 1;
mtype  = 'o';

%%

if exist('markerstyle','var')
    if ~isempty(markerstyle)
        msize = str2double(markerstyle(regexp(markerstyle,'[\d\.]')));
        for ii=[1 length(markerstyle)]
            switch markerstyle(ii)
                case {'b','g','r','c','m','w','k','w'}
                    mcolor = markerstyle(ii);
                case {'o','s','^'}
                    mtype = markerstyle(ii);
            end
        end
    end
end

%%
switch mtype
    case 'o'
        [xvec,yvec] = pol2cart(linspace(0,2*pi,40),ones(1,40));
    case 's'
        xvec = [-1 1 1 -1];
        yvec = [-1 -1 1 1];
    case '^'
        xvec = [-1 0 1];
        yvec = [-sqrt(3)/2 sqrt(3)/2 -sqrt(3)/2];
end

xvec = xvec.*msize/100*xplotrange;
yvec = yvec.*msize/100*yplotrange;

h = zeros(size(x));
for ii=1:size(x,1)
    for jj=1:size(x,2)
        h(ii,jj)=patch(xvec+x(ii,jj),yvec+y(ii,jj),mcolor);
    end
end
set(h,'edgecolor','none');
    
