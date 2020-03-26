function varargout = GetOri16(filename,varargin)

VERBOSE = 1;

%% Parse arguments

if nargin > 1 % there are additional parameters
    for ii=1:nargin-1 % for each additional parameter...
        switch(lower(varargin(ii)))
            case 'verbose'
        end
    end
end

%% Retrieve Data file
if ~exist('filename','var')
    %must get file
    [f,p] = uigetfile(...
        {'*[ori16].xml;*[ori16].XML','Ori16 XML files (*.xml)';...
        '*[ori16].mat;*[ori16].MAT','Ori16 MAT-files (*.mat)'},...
        'Pick a file');
    filename = [p f];
end

% Check to see if the files exist.
if ~exist(filename,'file')
    error('Basic:GetOri16','Filename "%s" not found',filename);
else
    % if a preprocessed MAT file exist in the same directory...
    if exist([filename(1:end-3) 'mat'],'file')
        if VERBOSE, fprintf('Found %s.\n',[filename(1:end-3) 'mat']); end
    % else if the XML file exists...
    elseif exist([filename(1:end-3) 'xml'],'file')
        if VERBOSE, fprintf('Parsing %s.\n',filename); end
        ExpoXMLimport = ReadExpoXML(filename,0,0);
        save([filename(1:end-3) 'mat'],'ExpoXMLimport');
        if VERBOSE, fprintf('Saving %s.\n',[filename(1:end-3) 'mat']); end
    else
        error('Basic:GetOri16','Please specify a valid XML or MAT file');
    end
end
clear ExpoXMLimport;

% Files should all exist! Let's load them.
if VERBOSE, fprintf('Loading %s.\n',[filename(1:end-3) 'mat']); end
temp=load([filename(1:end-3) 'mat'],'ExpoXMLimport');
ExpoXMLimport = temp.ExpoXMLimport;

%% Setup basic structures

NumDimensions = size(ExpoXMLimport.matrix.Dimensions);







%% Setup output

switch nargout
    case 1
        varargout(1) = {ExpoXMLimport};
    case 2
        varargout(1) = {ExpoXMLimport};
        varargout(2) = {BestOrientation};
end

