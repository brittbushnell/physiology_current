function varargout = GetData(Filename,varargin)
% function ExpoXMLimport = GetData(Filename,...)
%  
%     This Expo utility parses an XML file, saves the content in MAT container,
%     and optionally returns parsed XML Matlab structure.
%
%     Input Variables
%     -----------------------------------------------------------------------
%     Filename is the name (including path if not in the current directory)
%     of the xml file to be parsed. Optionally, it can be a MAT file which
%     contains the parsed XML Matlab structure. If a MAT of the same name
%     exists in the same directory as the XML file, it will be loaded
%     instead. Use the "refresh" flag to prevent this behavior (see below).
%     If the filename is empty, a dialog box will open to allow you to
%     select an XML or MAT file.
%
%     Optional Flags
%     -----------------------------------------------------------------------
%     GetData(...,'verbose')
%       turns on commenting.
%     GetData(...,'refresh')
%       ignores preexisting MAT file and forces the regeneration of a new
%       MAT file.
%     GetData(...,'spikewaveforms')
%       loads spike waveforms. By default, spike waveforms are not parsed
%       from XML files. If a MAT file exists, it will be loaded but it's
%       spike waveforms will be emptied. If the flag is present, then spike
%       waveforms will be parsed, saved and used. One cannot recover spike
%       waveforms from an XML or MAT file if they have been stripped out.
%  
%     Output Variables
%     -----------------------------------------------------------------------
%     ExpoXMLimport is the parsed XML matlab structure
%  
%     Author:        Romesh Kumbhani
%     Version:       1.0
%     Last updated:  2011-04-22
%     E-mail:        romesh.kumbhani@nyu.edu

%% Default Flags
VERBOSE = false;
REFRESH = false;
SWF     = false;

%% Parse arguments

if nargin > 1 % there are additional parameters
    for ii=1:nargin-1 % for each additional parameter...
        switch(lower(varargin{ii}))
            case 'spikewaveforms'
                SWF = true;
            case 'verbose'
                VERBOSE = true;
            case 'refresh'
                REFRESH = true;
        end
    end
end

%% Retrieve Data file
if ~exist('Filename','var')||isempty(Filename)
    %must get file
    [f,p] = uigetfile(...
        {'*.xml;*.XML','XML files (*.xml)';...
        '*.mat;*.MAT','MAT-files (*.mat)'},...
        'Pick a file');
    Filename = [p f];
end

% Check to see if the files exist.
if ~exist(Filename,'file')
    error('Basic:GetData','Filename "%s" not found',Filename);
else
    % if a preprocessed MAT file exist in the same directory...
    if exist([Filename(1:end-3) 'mat'],'file')&&~REFRESH
        if VERBOSE
            fprintf('Found %s.\n',[Filename(1:end-3) 'mat']);
            fprintf('Loading %s.\n',[Filename(1:end-3) 'mat']);
        end
        temp=load([Filename(1:end-3) 'mat'],'ExpoXMLimport');
        ExpoXMLimport = temp.ExpoXMLimport;
        if ~SWF
            ExpoXMLimport.waveforms = [];
        end
        clear temp;
    % else if the XML file exists...
    elseif exist([Filename(1:end-3) 'xml'],'file')
        if VERBOSE
            if REFRESH
                fprintf('Reparsing %s.\n',Filename);
            else
                fprintf('Parsing %s.\n',Filename);
            end
        end
        try
            ExpoXMLimport = ReadExpoXML(Filename,SWF,VERBOSE); 
        catch me
            error('Basic:GetData','Could not parse %s. Pleaes check XML.\n',Filename);
        end
        if VERBOSE
            fprintf('Saving %s.\n',[Filename(1:end-3) 'mat']);
        end
        save([Filename(1:end-3) 'mat'],'ExpoXMLimport');
    else
        error('Basic:GetData','Please specify a valid XML or MAT file');
    end
end

%% Setup output

switch nargout
    case 0
    case 1
        varargout(1) = {ExpoXMLimport};
end

