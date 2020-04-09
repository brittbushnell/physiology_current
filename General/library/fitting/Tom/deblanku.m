function s = deblanku(x,c)
%DEBLANKU Convert string by substituting blanks with underscores.
%   S = DEBLANKU(X) is the string X converted.
%   If X is a cell array, each cell ids converted as above.
%
%   S = DEBLANKU(X,C) is the string X converted. Blanks are substituted
%   with character C.
%       e.g. S=deblanku('a  b','.') returns S = 'a..b';
%   
%       
%   If X is a cell array, each cell ids converted as above.
%
% V0: addapted from deblankl, TvG Oct 2013, NYU
% V1: added blanking character. Issue: will not check size c is > 1

if nargin < 2
    c = '_';
end

if ~iscell(x)
    if ~isempty(x)
        s = x;
        s(s==' ') = c;
    else
        s = [];
    end
else
    s = x;
    if ~isempty(x)
        for j = 1:length(x)
            s{j} = deblanku(x{j},c);
        end
    else
        s = {};
    end
end
