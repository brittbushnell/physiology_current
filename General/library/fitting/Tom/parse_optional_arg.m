%PARSE_OPTIONAL_ARG   Parses optional arguments.
%
%   This function is a helper function to parse input arguments.
%
% INPUT:
%   parse_optional_arg(Default,..);
%       First argument sets default values. This is a nx3 sized cell array,
%       where n is the number of possible 'tags'.
%       Default{:,1} :  indices where this tag should be in the output.
%       Default{:,2} :  tag names
%       Default{:,3} :  default values
%       e.g. Default = [
%                           {1,'xaxis','log'}
%                           {2,'yaxis','lin'}
%                           {3,'zaxis',[]}
%                           {4,'verbose',true}
%                           {4,'debug',true}
%                       ];
%   parse_optional_arg(Default,'variable1',value1,'variable2',value2);
%       The arguments after the first are the values that override the
%       default values. A string 'tag' needs to be paired by a value. The
%       'tag' has to exist in second row of the first input.
%
% OUTPUT:
%   [..] = parse_optional_arg(..);
%       Outputs are returned after parsing the input arguments. The maximal
%       number of outputs is the maximum in the first column of the first
%       input.
%       e.g. (following the example above)
%       [ xScale, ...
%         yScale, ...
%         zScale, ...
%         flPlot ] = parse_optional_arg(Default,...
%                                       'verbose',false, ...
%                                       'xaxis','lin' );
%       returns
%           xScale = 'lin'
%           yScale = 'lin'
%           zScale = []
%           flPlot = 0
%
%   V0: TvG Mar 2015, NYU


function varargout = parse_optional_arg(Default,varargin)

% split input
VarIx       = [Default{:,1}];
VarNames    = Default(:,2);
VarVal      = Default(:,3);

% find number of optional arguments
nvarargin = size(varargin,2);

% If there are optional arguments, let's parse them
if (nvarargin>0)
    if ~mod(nvarargin,2) % number of arguments have to be in pairs!
        for i=1:2:nvarargin % for each pair
            
            % see if name in input arguments exists
            selName = strcmpi(VarNames,varargin{i});
            if ~any(selName)
                error('input:arg_name','[%s] is not listed in Default variables',varargin{i})
            end
            
            % select all variables that can be set with this tag and apply
            % paired value
            selVar = VarIx == VarIx(selName);
            VarVal(selVar) = varargin(i+1);
            
        end
    else
        error('input:nr_of_arg','Invalid number of arguments given.');
    end
end
%% output
for c = unique(VarIx)
    if nargout > c-1
        varargout(c) = VarVal(find(VarIx == c,1,'first')); % take first. Should be ok.
    end 
end


