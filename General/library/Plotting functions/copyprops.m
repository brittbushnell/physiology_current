%COPYPROPS Copies properties of objects into other object
%
%   This function takes all properties and copies them into a different
%   object.
%
%   copyprop(Src,Dst,IgnoreFields) Copies properties of [Src] into [Dst],
%       and ignoring [IgnoreFields].
%
%   see also COPYOBJ
%  
%   v0: TvG Aug 2014, NYU

function copyprops(Src,Dst,IgnoreFields)

if nargin < 3
    IgnoreFields = {};
end


srcType = get(Src,'Type');

%% determine read only properties
switch lower(srcType)
    case 'axes'
        skipFields = [
            {'AspectRatio'} % obsolete
            {'BeingDeleted'}
            {'Children'}
            {'CurrentPoint'}
            {'Parent'}
            {'Selected'}
            {'SelectionHighlight'}
            {'TightInset'}
            {'Type'}
            {'UIContextMenu'}
            ];
    case 'legend'
        skipFields = [
            {'BeingDeleted'}
            {'Parent'}
            {'Children'}
            {'Type'}
            {'UIContextMenu'}
            ];
    case 'text';
        skipFields = [
            {'BeingDeleted'}
            {'Extent'}
            {'Parent'}
            {'Children'}
            {'Type'}
            {'UIContextMenu'}
            ];
    case 'line'
        skipFields = [
            {'BeingDeleted'}
            {'Annotation'}
            {'Type'}
            {'Children'}
            {'Parent'}
            ];
    otherwise
        %todo
        warning('copyprops:todo:types','need to work on %s',srcType)
        skipFields = [];
end
srcP = get(Src);
cpFields = setdiff(lower(fieldnames(srcP)),lower([skipFields;IgnoreFields]));
%%
for f = cpFields'
    cVal = get(Src,f{:});
    if verLessThan('matlab','8.4') %2014b
        %warning('matlab:version','In ver 2014b the graphics changed dramatically. This function no longer works. see: \n%s\n','http://blogs.mathworks.com/loren/2014/11/05/matlab-r2014b-graphics-part-3-compatibility-considerations-in-the-new-graphics-system/#58f41617-2084-4e2c-bdfa-01673213bba3')
        selDeeper = isscalar(cVal) && ishandle(cVal) && mod(cVal,1)~=0;
    else
        selDeeper = isobject(cVal);
        if ~selDeeper
            selDeeper1 = numel(cVal)==1 && ishandle(cVal) && ~isscalar(cVal);
            if selDeeper1
                selDeeper2 = ~strcmp(cVal.Type, 'figure')==false;
            else
                selDeeper2 = false;
            end
            selDeeper = selDeeper1 & selDeeper2;
        end
    end
    if selDeeper
        scrDeeper = cVal;
        dstDeeper = get(Dst,f{:});
        h=copyobj(scrDeeper,get(dstDeeper,'child'));
        %set(Dst,f{:},h)
    else
        set(Dst,f{:},cVal)
    end
end
