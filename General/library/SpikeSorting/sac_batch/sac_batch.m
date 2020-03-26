function sac_batch(filenames, chanlist, pathname)
%usage: sac_batch(filenames,chanlist,pathname)
%       filenames is a cell array of strings corresponding to filenames of
%       nev files
%       chanlist is an array of channels to sort (default is all present channels)
%       pathname is a string corresponding to the path the files reside at
%       pathname must have a trailing slash if a directory
%       e.g. sac_batch({'33.nev','35.nev','37.nev'},'/tmp/565r001p')

%
%
% LAST REVISION:
%
% 21Aug2013 - default is now to display all active channels and sort all
% active channels. previously defaulted to 1:96. Also pathname is now the 
% 3rd command line value so you can specify channels without a path (MAS)
%

%
%

global FileInfo %contains infrmation about the file/s
global WaveformInfo %Contains Waveform information
global ClusterInfo % Contains channel/classification information
global Handles % Plot/menu handles

%% intialize variables
FileInfo=struct(...
    'filename',[],...
    'format','.nev',...
    'HeaderSize',0,...
    'PacketSize',0,...
    'ActiveChannels',[],...
    'PacketOrder',uint8([]),...
    'SpikesNumber',[],...
    'BytesPerSample',0); %initialize FileInfo structure

%%
if nargin < 3
    pathname = './';
end

% if trailing file seperator isn't present, add it.
if strcmp(pathname(end),filesep) 
    pathname = cat(2,pathname,filesep);
end


nFiles = length(filenames);

for ii=1:nFiles
    FileInfo(ii).filename=[pathname  filenames{ii}] ;
end

sac_nevscan(1);
ActiveChannelList=FileInfo(ii).ActiveChannels;
for ii=2:nFiles
    sac_nevscan(ii);
    ActiveChannelList=union(FileInfo(ii).ActiveChannels, ActiveChannelList);
end 

if length(unique([FileInfo(:).PacketSize]))~=1
    error('Variable Packet Sizes');
end

if (nargin < 2) % keep only active channels
    newchanlist = ActiveChannelList; %changed to all channels 20AUG2013 -MAS
else
    % only run channels that exist in the file
    newchanlist = intersect(chanlist,ActiveChannelList); 
end

nChannels = length(newchanlist);

% print the list of channels to sort nicely formatted
fprintf('SAC_BATCH\nThese channels will be sorted:\n');
fprintf([repmat('%3d ',1,8) '\n'],newchanlist);

howmany = zeros(nChannels,nFiles);
ChannelString = cell(nChannels,1);
%for every channel
for ii=newchanlist(:)' % force row vector.
    % for every file
    for jj=1:nFiles
        % homany = # of spikes
        howmany(ii,jj) = FileInfo(jj).SpikesNumber(ii);
    end
    ChannelString{ii} = sprintf(['%d (' repmat('%d',1,nFiles-1) '%d )'],ii,howmany(ii,:));
    %[num2str(ii) ' (' num2str(howmany(ii,:)) ')'];
end
%set(Handles.channel,'String',ChannelString);
%set(Handles.channel,'UserData',{ActiveChannelList,howmany});
%set(Handles.channel,'Value',1);

for ii=newchanlist(:)'
%for i=1:length(ActiveChannelList)
    try
        fprintf('\nChannel %i\n',ii);
        %% get
       
        ChannelNumber = ii; % ActiveChannelList(i);
        TotalNumber   = sum(howmany(ii,:));
        GetNumber     = [50 40]; % [Number of Waveform groups, Number of Waveform loaded per group]
	    % 50 40 (2000) is default, could try 8000 instead with next line
        %GetNumber=[200 40]; % [Number of Waveform groups, Number of Waveform loaded per group]

        fprintf('loading...\n');
        sac_get_waveforms_batch(ChannelNumber,TotalNumber,GetNumber);
        WaveformInfo.Unit = (WaveformInfo.Unit(:))'; % force into row vector
        unitsmenuString=cat(2,{'noise'},{'unsorted'},num2cell(num2str(setdiff(unique(WaveformInfo.Unit),[0 255]),'%1d')));
    %    set(Handles.unitsmenu,'String',unitsmenuString);
    %    set(Handles.unitsmenu,'Value',2);
        ClusterInfo=[];
        if ~strcmpi(FileInfo(jj).Application(1:8),'nsxtonev')
            sac_align(0);
        end
        ClusterInfo.Units=unique(WaveformInfo.Unit);
        for j=1:length(ClusterInfo.Units)
            ndx = (WaveformInfo.Unit==ClusterInfo.Units(j));
            ClusterInfo.Centers(j,:) = mean(WaveformInfo.Waveforms(ndx,:),1);
            ClusterInfo.Sigma{j}     = cov( WaveformInfo.Waveforms(ndx,:));
            ClusterInfo.Proportions  = sum(ndx)/length(WaveformInfo.Unit);
        end
        ClusterInfo.ChannelNumber    = ChannelNumber;
        ClusterInfo.microVperBit     = FileInfo(1).nVperBit(ChannelNumber)/1000;
        ClusterInfo.Threshold        = FileInfo(1).LowThresh(ClusterInfo.ChannelNumber)/FileInfo(1).nVperBit(ClusterInfo.ChannelNumber)*1000;
    
        %    sac_gui redraw
        fprintf('sorting...\n');

        %% sort        
        unitnum=sac_t_master_batch; %the actual computation
    %    unit_num=max(mod(ClusterInfo.Units,255));
    %    unitsmenuString=cat(2,{'noise'},{'unsorted'},num2cell(num2str(1:unit_num,'%1d')));
    %    set(Handles.unitsmenu,'String',unitsmenuString);
    %    set(Handles.unitsmenu,'Value',min([2,max(unique(WaveformInfo.Unit))+1]));
    %    sac_gui redraw

        %% write
        fprintf('writing...\n');
        sac_write_batch;
    catch ERR
        fprintf('Errors on channel %d\nNumber of Waveforms = %d\n',ii,size(WaveformInfo.Waveforms,1));
    end
end
