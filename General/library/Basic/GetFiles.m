function filenames = GetFiles(varargin)
%

%% Default Flags
VERBOSE   = false;
FOUNDDIR  = false;
FOUNDTYPE = false;
XMLonly   = false;
MATonly   = false;


%% Parse arguments

for ii=1:nargin % for each additional parameter...
    switch(lower(varargin{ii}))
        case 'verbose'
            VERBOSE = true;
        case 'xml'
            XMLonly = true;
        case 'mat'
            MATonly = true;
        otherwise
            if exist(lower(varargin{ii}),'dir')&&~FOUNDDIR
                Directory = varargin{ii};
                if strcmp(Directory(end),filesep)
                    Directory = Directory(1:end-1);
                end
                FOUNDDIR = true;
            elseif ~FOUNDTYPE
                Filetype = varargin{ii};
                FOUNDTYPE = true;
            end
    end
end

if ~FOUNDDIR
    Directory = '.';
end
if ~FOUNDTYPE
    Filetype = '*';
end

if VERBOSE
    fprintf('Searching "%s" for a filename containing: "%s",\n',Directory,Filetype);
end


if XMLonly
    searchpath = [Directory filesep '*' Filetype '*.xml'];
elseif MATonly
    searchpath = [Directory filesep '*' Filetype '*.mat'];
else
    searchpath = [Directory filesep '*' Filetype '*'];
end
files = dir(searchpath);
nfiles = size(files,1);

filenames = cell(nfiles,1);
cnt = 0;
for ii=1:nfiles
    if ~strcmp(files(ii).name(1),'.')
        cnt = cnt + 1;
        filenames{cnt,1} = files(ii).name;
    end
end
if cnt == 0
    if VERBOSE
        fprintf('No files found in "%s"\n',searchpath);
    end
    filenames = [];
else
    filenames = {filenames{1:cnt,1}}';
end





