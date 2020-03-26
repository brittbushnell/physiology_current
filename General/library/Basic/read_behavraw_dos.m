%READ_BEHAVRAW_DOS read data from behavraw experiments
%
%   This function reads data files generated in the psychophysics setups on DOS machines.
%
%   Input:
%   read_behavraw_dos(file)
%       file:   filename. E.g. moto_ga.055
%
%   Output:
%   S = read_behavraw_dos(..)
%       S:      structure with data from file
%
%   Example:
%
%     file = '/arc/2.5/p2/vnl/vnl/data/psycho/behavraw/ga/peripho/perip_ga.363';
%
%     S = read_behavraw_dos(file);
%
%     [
%     S.Summary(:,8) ,...
%     nansum(S.isRight,2)
%     ]
% 
%     [
%     S.Summary(:,3) ,...
%     nansum(S.isCorrect,2)
%     ]
%
% TvG Oct 2016, NYU: Created
% TvG Nov 2016, NYU: 2 dimensional data

function S = read_behavraw_dos(file)

%% initialize

% Optional flags
beVerbose = false;

% Start a structure
S.SourceFile = file;

% open the file
fid = fopen(file,'r');

%% read header
%
% It looks something like:
%   PSYCHO:2.8.2 - 12/08/10 12:28:26PM
%   PSYCHO:2.8.2 - 12/09/10 11:31:24AM (INTERRUPTED SESSION!)
%   PSYCHO 2.5.5 - 05/19/04 03:47:07PM
%

% first line
HeaderStr       = isTag(fid,'PSYCHO[:]?',true);
Header          = regexp(HeaderStr,'PSYCHO[:]?|[ ]?(.*) - (.*)(AM|PM)[ ]?(.*)?','tokens');
% add to structure
S.Ver           = Header{2}{1};

% parse
if strcmp(S.Ver,'2.0.0')
    % slightly different: PSYCHO 2.0.0 - 08/13/96 11:25AM (Tue) (INTERRUPTED SESSION!)
    MoreHeader      = regexp(Header{2}{4},'\((.*)\) \((.*)\)','tokens');
    % dirty hack if pattern is just "(Tue)" instead of "(Tue) (bl bla)"
    if isempty(MoreHeader)
        MoreHeader = regexp(Header{2}{4},'\((.*)\)','tokens');
    else
        Header{2}{4}    = ['(' MoreHeader{1}{2} ')'];
    end
    S.TimeStampSer  = datenum([Header{2}{2:3} MoreHeader{1}{1}],'mm/dd/yy HH:MMAMddd');
else
    S.TimeStampSer  = datenum([Header{2}{2:3}],'mm/dd/yy HH:MM:SSAM');
end

% add to structure
S.TimeStamp     = datestr(S.TimeStampSer);
S.isInterrupted = strcmp(Header{2}{4},'(INTERRUPTED SESSION!)');

%% read info
%
% formatted as:
%   INFO:
%   <FIELD>:<value> <FIELD>:<value> <FIELD>:<value> ..
%   <FIELD>:<value> <FIELD>:<value> <FIELD>:<value> ..
%   ..

% tag
isTag(fid,'INFO:',beVerbose);

% data
Info = tillEmpty(fid);

% make single line 
Info = cellfun(@(in) [in ' '],Info,'uniformoutput',false); % add ' '
Info = [Info{:}];

% parse
% make fields in structure with names from info.
FieldIx = regexp(Info,'[A-Z-]*: ');     % only capitals
nF      = numel(FieldIx);
FieldIx = [FieldIx numel(Info)+1];      % empty line should also be end of field
for iF = 1:nF
    F=regexp(Info(FieldIx(iF):FieldIx(iF+1)-1),'([A-Z-]*): (.*)','tokens');
    eval(['S.' regexprep(F{1}{1},'[-]','_') '=deblank(F{1}{2});'])
end

% translate some fields
R           = regexp(S.REPEAT,'(\d*)/(\d*)','tokens');
S.Repeat    = str2double(R{1}); % first is max repeats, second is set repeats

%% read summary
%
% formatted as:
%   DATA-1D:
%   <colname> <colname> <colname> ..
%   <val> <val> <val> ..
%   <val> <val> <val> ..
%   ..
% or
%   DATA-2D:
%   <cond>                        <cond>
%   <colname> <colname> <colname> <colname> <colname> <colname> ..
%   <val> <val> <val> ..
%   <val> <val> <val> ..
%   ..

% tag
DataTag = isTag(fid,'DATA-[12]D:',beVerbose);

% number of dimensions in data
nDim        = regexp(DataTag,'DATA-(\d)D:','tokens');
nDim        = str2double(nDim{1});
S.nStimDim  = nDim;
if nDim == 1
    
    % column names
    DataHeaderStr   = fgetl(fid);
    DataHeader      = regexp(DataHeaderStr,'(\S*)','tokens');
    DataHeader      = cellfun(@(h) h,DataHeader);
    S.SummHead      = DataHeader;
    nCol            = numel(DataHeader);
    
    % data
    Info    = tillEmpty(fid);
    nRow    = numel(Info);
    S.nCond = nRow;
    
    % put data in matrix
    Data = nan(nRow,nCol);
    for iR = 1:nRow
        Data(iR,:) = cell2mat(cellfun(@(c) str2double(c{:}),regexp(Info{iR},'(\S*)','tokens'),'uniformoutput',false));
    end
    S.Summary = Data;
    
elseif nDim == 2
    
    % 2nd dim conditions names
    Dim2CondStr     = fgetl(fid);
    Dim2Cond        = regexp(Dim2CondStr,'(\S*)','tokens');
    nCondDim2       = numel(Dim2Cond);
    
    % column names
    DataHeaderStr   = fgetl(fid);
    DataHeader      = regexp(DataHeaderStr,'(\S*)','tokens');
    DataHeader      = cellfun(@(h) h,DataHeader);
    DataHeader      = reshape(DataHeader,[],nCondDim2)';
    
    % condense if all the same
    isSame = cellfun(@(h) all(strcmp(h,DataHeader)),DataHeader(1,:),'UniformOutput',false);
    if all(any(reshape([isSame{:}],size(DataHeader,2),[])))
        DataHeader = DataHeader(1,:);
        nCol        = numel(DataHeader);
    end
    
    % add to structure
    S.SummHead      = DataHeader;
    
    % data
    Info        = tillEmpty(fid);
    nRow        = numel(Info);
    S.nCondD1   = (nRow-2)/3; % -2 left and right
    S.nCondD2   = nCondDim2;
    
    % put data in matrix
    Data = nan(S.nCondD1,S.nCondD2,3,nCol); % third dimension is tot, left, right
    iD3 = 1; % 3rd dimension index
    iD1 = 0;
    for iR = 1:nRow
        iD1 = iD1 + 1;
        if ~isempty(regexp(Info{iR},'(Left:)|(Right:)','once'))
            % increase index third dimension
            iD3 = iD3 + 1;
            iD1 = 0;
        else
            D = reshape(cell2mat(cellfun(@(c) str2double(c{:}),regexp(Info{iR},'(\S*)','tokens'),'uniformoutput',false)),[],nCondDim2)';
            Data(iD1,:,iD3,:) = D;
        end
    end
    S.Summary = Data;

    S.nCond = S.nCondD1*S.nCondD2;
    
    %fclose(fid);
    %error([mfilename ':ndim'],'Stimulus matrix contains more than 1 dimensions, This is not supported (yet).')
end

%% read responses
%
% formatted as:
%   PATTERN:
%   1: +++++++-+--++- ..
%   2: ---++++-+--++- ..
%   ..
% or
%   1: LRLRlrlr ...
%   2: LrrRlrlr ...
%   ..

% tag
isTag(fid,'PATTERN:',beVerbose);

% data
Resp = char(ones(S.nCond,S.Repeat(2)).*double('?'));
OK=true;c=0;
while OK
    c=c+1;
    Info = fgetl(fid);
    % read till empty line
    if isempty(Info) || feof(fid)
        OK=false;
        if c < S.nCond
            fclose(fid);
            error([mfilename ':fileformat'],'In file \n\t%s\nthe number of conditions mismatch between the responses and the summary.',file)
        end
    elseif c > S.nCond
        fclose(fid);
        error([mfilename ':fileformat'],'In file \n\t%s\nthe number of conditions mismatch between the responses and the summary.',file)
    else
        % parse
        R = regexp(Info,'(\d*)[ ]*:[ ]*([RLrl+-]*)','tokens');
        if S.isInterrupted
            % incomplete run
            
            % NOTE: occasionally R{1}{1} is larger than number of
            % conditions this is an apparent bug in the DOS file format and
            % will not be fixed here. Please fix this after the structure
            % is returned by read_behavraw.
            
            cR = R{1}{2};
            Resp(str2double(R{1}{1}),1:numel(cR)) = cR;
            clear cR
        else
            Resp(str2double(R{1}{1}),:) = R{1}{2};
        end
    end
end
S.Resp = Resp;

% max nr of repeats
hasResp = mean(S.Resp ~= '?')>0;
if any(hasResp)
    S.Repeat(3) = find(hasResp,1,'last');
else
    S.Repeat(3) = 0;
end

%% read reaction time
%
% Some programs store reaction times
%
% formatted as:
%   REACTION TIME:
%      0.001   0.001 ...
%      0.001   0.001 ...
%   ...
% This is an optional section

% tag
fPos    = ftell(fid);
Tag     = isTag(fid,'REACTION TIME:',beVerbose);

% is optional
if strcmp(Tag,'REACTION TIME:')
    % do read reaction times
    if S.isInterrupted
        % do till empty line. Cannot use S.Repeat(3), because sometimes RT
        % has one extra repeat ...
        Info    = tillEmpty(fid);
        cRT     = cellfun(@(s) textscan(s,'%.3f'),Info);
        RT      = cRT{:};
    else
        % reshape if exp is completed. 
        cRT     = textscan(fid,'%.3f',S.Repeat(2)*S.nCond);
        RT      = cRT{:};
        RT      = reshape(RT,S.nCond,S.Repeat(2))';
        fgetl(fid); % should be empty
        fgetl(fid);
    end
    S.RT = RT;
else
    % rewind file
    fseek(fid, fPos, -1);
    if beVerbose
        fprintf(2,'That''s okay. I will skip reaction time.\n',Tag)
    end
end

%% read "returns"
%
% Some programs store "returns"
%
% formatted as:
%   RETURNS:
%        1 1 ...
%        1 1 ...
%   ...
% This is an optional section

% tag
fPos    = ftell(fid);
Tag     = isTag(fid,'RETURNS:',beVerbose);

% is optional
if strcmp(Tag,'RETURNS:')
    % do read returns
    Info        = tillEmpty(fid); 
    S.Returns   = Info';
else
    % rewind file
    fseek(fid, fPos, -1);
    if beVerbose
        fprintf(2,'That''s okay. I will skip returns.\n',Tag)
    end
end

%% read eye tracker
% Some programs store "returns"
%
% formatted as:
% formatted as:
%   EYE TRACKER CALIBRATION PARAMETERS:
%   Xoff   Yoff       Kxl      Kxr       Kyt       Kyb
%   5116   -351   -1.023   -0.982    2.298    1.371
% This is an optional section

% tag
fPos = ftell(fid);
Tag = isTag(fid,'EYE TRACKER CALIBRATION PARAMETERS:',beVerbose);

% is optional
if strcmp(Tag,'EYE TRACKER CALIBRATION PARAMETERS:')
    % do read eye tracker pars
    
    % column names
    DataHeaderStr   = fgetl(fid);
    DataHeader      = regexp(DataHeaderStr,'(\S*)','tokens');
    DataHeader      = cellfun(@(h) h,DataHeader);
    S.EyeTrackHead  = DataHeader;
    
    % data
    nCol    = numel(DataHeader);
    Info    = tillEmpty(fid);
    nRow    = numel(Info);
    
    % put data in matrix
    Data = nan(nRow,nCol);
    for iR = 1:nRow
        Data(iR,:) = cell2mat(cellfun(@(c) str2double(c{:}),regexp(Info{iR},'(\S*)','tokens'),'uniformoutput',false));
    end
    S.EyeTrackPar = Data;
else
    % rewind file
    fseek(fid, fPos, -1);
    if beVerbose
        fprintf(2,'That''s okay. I will skip eye tracker.\n',Tag)
    end
end


%% read parameters
%
% formatted as:
%   PARAMETERS: C:\PSYCHO\HOME\<subject>.EP
%   <par> : <val>
%   <par> : <val>
%   <par> : <val>
%
%   PARAMETERS: C:\PSYCHO\HOME\<exp-subject>.EP
%   <#@.><par> : <val>
%   <#@.><par> : <val>
%   <#@.><par> : <val>
%
% @: Left-Right parameter
% .: Read only

% First Parameter set

% tag
ParTag = isTag(fid,'PARAMETERS:',beVerbose);

% parse first line
SrcFile     = regexp(ParTag,'PARAMETERS:[ ]+(.*)','tokens');
S.ParFile1  = SrcFile{1}{:};

% data
OK=true;c=0;
Par = [{},{}];
while OK
    c=c+1;
    cPar = fgetl(fid);
    % read till empty line
    if isempty(cPar) || feof(fid)
        OK=false;
    else
        % parse
        P = regexp(cPar,'([ #@.\*][ #@.\*][ #@.\*])(.*)[ ]+:[ ]+(.*)','tokens');
        Par{c,1} = P{1}{1};
        Par{c,2} = P{1}{2};
        Par{c,3} = P{1}{3};
    end
end
S.Par1 = Par;


if ~feof(fid) % skip: sometimes file ends after one parameter set
    % Second Parameter set
    
    % tag
    ParTag = isTag(fid,'PARAMETERS:',beVerbose);
    
    % parse first line
    SrcFile     = regexp(ParTag,'PARAMETERS:[ ]+(.*)','tokens');
    S.ParFile2  = SrcFile{1}{:};
    
    % data
    OK=true;c=0;
    Par = [{},{}];
    while OK
        c=c+1;
        cPar = fgetl(fid);
        % read till empty line
        if isempty(cPar) || feof(fid)
            OK=false;
        else
            % parse
            P = regexp(cPar,'([ #@.\*][ #@.\*][ #@.\*])(.*)[ ]*:[ ]+(.*)','tokens');
            Par{c,1} = P{1}{1};
            Par{c,2} = P{1}{2};
            Par{c,3} = P{1}{3};
        end
    end
    S.Par2 = Par;
end


%% finalize: done reading?
if ~feof(fid)
    fclose(fid);
    error([mfilename ':fileformat'],'Did not get to end of file \n\t%s\nThere was more.',file)
end
fclose(fid);

%% processing

% basic processing
if ~strcmpi(S.Ver,'2.0.0') % no START or END in this version
    S.StartSer  = floor(S.TimeStampSer) + mod(datenum(S.START,'HH:MM:SS'),1);
    S.EndSer    = floor(S.TimeStampSer) + mod(datenum(S.END,'HH:MM:SS'),1);
    S.RunDur    = round((S.EndSer-S.StartSer) * 24*60*60); % in sec
end

% basic analyses
Corr                = double(lower(Resp) ~= Resp | Resp=='+');
Corr(Resp=='?')     = NaN;
Right               = double(lower(Resp) == 'r');
Right(Resp=='?')    = NaN;
S.isCorrect         = Corr;
S.isRight           = Right;
S.nTrials           = sum(Resp~='?',2);




%% subfunction
function TagLine=isTag(fid,tag,verbose)
% see if the next line contains a tag.

TagLine = fgetl(fid);
ixTag   = regexp(TagLine,tag);
if verbose && (isempty(ixTag) || ixTag~=1) % does not start with tag
    fprintf(2,'Tag\n\t%s\nnot found.\nFound\n\t%s\ninstead.\n',tag,TagLine)
end

function Info=tillEmpty(fid)
OK=true;c=0;Info={};
while OK
    c=c+1;
    Info{c} = fgetl(fid);
    % read till empty line
    if isempty(Info{c}) || feof(fid) % till EOF to avoid infinite loop
        OK=false;
        Info = Info(1:end-1); % trim last empty line
    end
end




%%
return


%% example
%file = '/arc/2.5/p2/vnl/vnl/data/psycho/behavraw/ga/moto/moto_ga.260';
file = '/arc/2.5/p2/vnl/vnl/data/psycho/behavraw/ga/peripho/perip_ga.363';
%file = '/arc/2.5/p2/vnl/vnl/data/psycho/behavraw/ga/a10/a10_ga.083';
S = read_behavraw_dos(file);
[
S.Summary(:,8) ,...
nansum(S.isRight,2)
]

[
S.Summary(:,3) ,...
nansum(S.isCorrect,2)
]