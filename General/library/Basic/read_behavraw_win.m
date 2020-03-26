%READ_BEHAVRAW_WIN read data from behavraw experiments
%
%   This function reads data files generated on windows machines in the psychophysics setups.
%
%   Input:
%   read_behavraw_win(file)
%       file:   filename. E.g. peripho_ga.0055.psy
%
%   Output:
%   S = read_behavraw_win(..)
%       S:      structure with data from file
%
%   Example:
%
%     file = '/arc/2.5/p2/vnl/vnl/data/psycho/behavraw/el/peripho/peripho_el.0122.psy';
%
%     S = read_behavraw_win(file);
%
% TvG Aug 2017, copied from read_behaveraw

function S = read_behavraw_win(file)

%% initialize

% Optional flags
%beVerbose = false;

% Start a structure
S.SourceFile = file;

% open the file
fid = fopen(file,'r');

%% read line by line
%   Every section is separated by === SECTION NAME ===
%   If Section is encountered a new field will be created
%   Every section will be parsed differently. Every section is bound by the name and a new line

OK = true;
while OK
    L = fgetl(fid);
    if isnumeric(L) && L == -1
        OK = false;
        continue
    end
    SecHead = regexp(L,'^=== ([A-Z ]+) ===$','Tokens');
    isSecHead = ~isempty(SecHead) && ~isempty(SecHead{1});
    if isSecHead
        SectionName = SecHead{1}{1};
        % translate section name into field name
        switch SectionName
        case 'EXPERIMENT INFO'
            FieldName = 'ExpInfo';
        case 'BEHAVIOR INDICATORS'
            FieldName = 'BehavIndicators';
        case 'STIMULUS SETTINGS'
            FieldName = 'StimSet';
        case 'EXPERIMENT SETTINGS'
            FieldName = 'ExpSet';
        case 'SYSTEM SETTINGS'
            FieldName = 'SysSet';
        case 'SETUP INFO'
            FieldName = 'SetupInfo';
        case 'PERFORMANCE SUMMARY'
            FieldName = 'PerfSumm';
        case 'PERFORMANCE DETAILS'
            FieldName = 'PerfDetails';
        otherwise
            FieldName = '';
        end

        % parse according to field properties
        if ismember(FieldName,{'ExpInfo','BehavIndicators','StimSet','ExpSet','SysSet','SetupInfo'})
            S.(FieldName) = p_F_c_V_nl(fid); % parse: Field colon Value till New Line
        elseif ismember(FieldName,{'PerfSumm','PerfDetails'})
            [S.(FieldName).ColInfo,S.(FieldName).mtx] = p_H_nl_R_nl(fid); % parse: matrix-style
        else
            keyboard
            error([mfilename ':format'],'Format unknown')
        end
    elseif regexp(L,'^Session [0-9]{4} started...$') == 1
        S.Abort = true;
    else
        keyboard
        error([mfilename ':format'],'Format unknown')
    end
end

fclose(fid);





function [H,M] = p_H_nl_R_nl(fid)
    % parse header <CR> row <CR> ...
    OK = true;
    c=0;
    while OK
        c=c+1;
        L = fgetl(fid);
        if isempty(L)
            OK = false;
            continue
        end
        
        if c == 1
            H = textscan(L,'%s');
            % convert to proper cell
            H = H{1}';
            
            % HACK ALERT
            %   some column names get parsed into 2 columns. Here to fix it.
            
            %   "T ms"
            %   "RT ms"
            Fix = [
                {'T','ms'}
                {'RT','ms'}
                ];
            for iF = 1:size(Fix,1)
                ColNames = Fix(iF,:);
                sel_2col = ismember(H,ColNames);
                if any(sel_2col) && sum(sel_2col) == 2 && diff(find(sel_2col))==1 % adjacent
                    H = [H(1:find(sel_2col,1,'first')-1) [ColNames{1} '.' ColNames{2}] H(find(sel_2col,1,'last')+1:end)];
                end
            end
            % prepare matrix
            M = nan(1,numel(H));
        else
            val = textscan(L,'%f'); % asume matrix always has numeric values
            
            % check if nr of col is similar
            if numel(val{1}) ~= numel(H) || iscell(M)
                warning([mfilename ':headermatrixmismatch'],'The header and matrix have different number of columns. Likely some extra parsing needed.')
                
                if c==2
                    M = {}; % reconfigure M into cell array
                elseif ~iscell(M)
                    % it happened after we started filling M with doubles.
                    % Now we have to repair M too
                    M = arrayfun(@(i) M(i,:),[1:size(M,1)],'UniformOutput',false)';
                end
                val = {val}; % make rows of single cells
                
            end
            % add to M
            M(c-1,:) = val{1}';
        end
    end
    





function S = p_F_c_V_nl(fid)
    % parse field : value
    OK = true;
    while OK
        L = fgetl(fid);
        if isempty(L)
            OK = false;
            continue
        end
        
        T = regexp(L,'(.*) *\: (.*)','Tokens');
        
        F = T{1}{1};
        F = str2f(F);
        V = T{1}{2};
        while exist('S','var')==1 && isfield(S,F)
            c=1;
            F = sprintf('%s%03.0f',F,c);
            c=c+1;
        end
        S.(F) = V;
    end
    





function F = str2f(str)
    % String to fieldname
    
    % Field name, specified as a character vector. Valid field names begin with a letter, and can contain letters, digits, and underscores. The maximum length of a field name is the value that the namelengthmax function returns.
    
    F = deblanku(deblank(str));
    if isempty(F)
        F = 'empty';
        return
    end
    if ~isletter(F(1))
        F = ['NaN' F];
    end
    if numel(F) > 63 % MATLAB's maximum name length
        F = F(1:63-3); % -3 to allow for counter if field already exists
    end
    F=regexprep(F,'[^a-zA-Z0-9]','_');