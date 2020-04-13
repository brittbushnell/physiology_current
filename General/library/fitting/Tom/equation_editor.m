%EQUATION_EDITOR   generates URL for LateX equations
%
%   This function generates an URL either for equation editing or for
%   displaying. Uses interface of
%   http://www.codecogs.com/latex/eqneditor.php.
%
% INPUT: 1 required arguments(s) and takes variable arguments.
%
%   [...] = equation_editor(LateX , <fontname> , <val> , <fontsize> , <val>
%   , <background> , <val> , <dpi> , <val> , <format> , <val> , <edit> ,
%   <val>)
%   fontname    - ['Latin Modern'],'Verdana','Comic Sans',
%               'Computer Modern','Helvetica'
%   fontsize    - 'Tiny','Small',['Normal'],'Large','Very Large','Huge'
%   background  - ['Transparant'],'White','Black','Red','Green','Blue'
%   dpi         - dots per inch, resolution/size. default [100]
%   format      - ['gif'],'png','pdf','swf','emf','svg'
%   edit        - true or [false]. alternative is to only show the result.
% 
%
% OUTPUT: 0 required argument(s) and returns variable arguments.
%
%   [<url>] = equation_editor(...)
%
%   V0: TvG Sep 2014, NYU


function varargout = equation_editor(LateX,varargin)

if nargin < 1
    LateX = 'd''(A) = d''_0 + \frac{(max_{d''} \cdot A^n)}{A_{halfmax}^n + A^n)}';
end

%% optional arguments
nArg = size(varargin,2);

% default values
Format      = 1;
FontName    = 1;
FontSize    = 3;
Background  = 1;
DPI         = 100;
flEdit      = false; % whether it is to edit or to show

if (nArg>0)
    if ~mod(nArg,2)
        for i=1:2:nArg
            switch lower(varargin{i})
                case 'format'
                    Format = varargin{i+1};
                case 'fontname'
                    FontName = varargin{i+1};
                case 'fontsize'
                    FontSize = varargin{i+1};
                case 'background'
                    Background = varargin{i+1};
                case 'dpi'
                    DPI = varargin{i+1};
                case 'edit'
                    flEdit = varargin{i+1};
            end
        end
    else
        error([mfilename ':input'],'Invalid number of arguments given.');
    end
end

%% parse arguments. use HashTables to translate
fmt = [
    {'gif'}
    {'png'}
    {'pdf'}
    {'swf'}
    {'emf'}
    {'svg'}
    ];

font = [
    {''}
    {' \fn_phv'}
    {' \fn_jvn'}
    {' \fn_cs'}
    {' \fn_cm'}
    ];

fontHashTable = [
    {'Latin Modern'}
    {'Verdana'}
    {'Comic Sans'}
    {'Computer Modern'}
    {'Helvetica'}
    ];

fsze = [
    {' \tiny'}
    {' \small'}
    {''}
    {' \large'}
    {' \LARGE'}
    {' \huge'}
    ];

sizeHashTable = [
    {'Tiny'}
    {'Small'}
    {'Normal'}
    {'Large'}
    {'Very Large'}
    {'Huge'}
    ];

back = [
    {''}
    {' \bg_white'}
    {' \bg_black'}
    {' \bg_red'}
    {' \bg_green'}
    {' \bg_blue'}
    ];

backHashTable = [
    {'Transparant'}
    {'White'}
    {'Black'}
    {'Red'}
    {'Green'}
    {'Blue'}
    ];

%% Translate to index
if ~isnumeric(Format)
    Format = find(strcmpi(fmt,Format));
end

if ~isnumeric(FontName)
    FontName = find(strcmpi(fontHashTable,FontName));
end

if ~isnumeric(FontSize)
    FontSize = find(strcmpi(sizeHashTable,FontSize));
elseif FontSize > numel(fsze)
    % fontsize is given in pt
    FontSize = find([5 9 10 12 18 20]==FontSize);
end

if ~isnumeric(Background)
    Background = find(strcmpi(backHashTable,Background));
end

%% create URLs
urlShow = @(ltx,fmt,dpi,fnt,sz,bck) sprintf('http://latex.codecogs.com/%s.latex?\\dpi{%.0f}%s%s%s %s',fmt,dpi,bck,fnt,sz,ltx);
urlEdit = @(ltx) sprintf('http://www.codecogs.com/eqnedit.php?latex=%s',ltx);

if ~flEdit
    cUrl = urlShow(LateX,fmt{Format},DPI,font{FontName},fsze{FontSize},back{Background});
    %cUrl = regexprep(cUrl,' ','%20');
else
    cUrl = regexprep(urlEdit(LateX),' ','&space;');
end

%% output
c=0;
if nargout == 0
    disp(cUrl)
end
if nargout>c
    c=c+1;
    varargout{c} = cUrl;
end
