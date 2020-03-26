function [nsdata, nsheader] = rethreshold(nsfilename,varargin)
% [nsdata,nsheader] = rethreshold(filename,...)
% Use this function to rethreshold an NSx file.
%
% This file returns two structures. nsdata contains the raw data and
% nsheader contains header information (the length of the recording, the
% sample rate used, the date the file was recorded, etc..
%
% The NSx files *do not* contain synchronization pulses. If you plan to
% make a new nev file at a different threshold, please use NSxToNev
% instead. It will call this function and merge it with an old NEV file.
%
% see also NSxToNev.
%
%       Author: Romesh Kumbhani
%        Email: romesh.kumbhani@nyu.edu
%      Version: 1.3
% Last updated: 2014-04-14

%% define default values
threshold   = -5;   % -5 std
low_cutoff  = 200;  % 200 Hz
high_cutoff = 3000; % 3000 Hz

% search for minima/maxima within this window (units of "samples")
lags        = -12:12; % @ 30Khz, this is +/- 0.4 ms

% parent location of NSx data directory. Used if path is not provided.
pnamestr    = '/Volumes/NSP2/nsp2_blackrock/WU_ArrayData/'; 
logname     = '/tmp/%s.log';

% filter data flag
doFilter = 1;

%% VALIDATION OF INPUTS
% get path, name, extension
[pname,fname,ext] = fileparts(nsfilename); 

% setup log file
logfilename = sprintf(logname,fname);
flog = fopen(logfilename,'w');
if flog==-1
    error('rethreshold:logcreation','Couldn''t create log file in /tmp');
end

switch ext(1:3) % NS
    case '.ns' % found raw
        filetype = ext(2:4); % e.g. NS6
    otherwise
        error('rethreshold:filevalid','The following file is of unknown type: %s',nsfilename);
end

% if path wasn't given, supply it
if isempty(pname)
    pname = sprintf(pnamestr,fname(2:4),filetype);
end

nsfilename = [pname filesep fname ext];

if ~exist(nsfilename,'file') % if the file exists
    error('rethreshold:file_exists_check','The following file was not found: %s',nsfilename);
end

% check parameters
if ~mod(nargin,2) % if even number of arguments, then error!
    error('rethreshold:paramerror','Incorrect number of parameters given');
else
    for ii=2:2:nargin
        param = varargin{ii-1};
        value = varargin{ii};
        switch param
            case 'threshold'
                threshold = value;
            case 'bandpass'
                if numel(value) ~= 2
                    error('rethreshold:paramerror','Incorrect number of frequency bands. You supplied %d value(s) instead of 2.',numel(value));
                end
                low_cutoff  = value(1);
                high_cutoff = value(2);
            case 'lowpass'
                if numel(value) ~= 1
                    error('rethreshold:paramerror','Incorrect number of frequency bands. You supplied %d value(s) instead of 1.',numel(value));
                end
                low_cutoff  = nan;
                high_cutoff = value(1);
            case 'highpass'
                if numel(value) ~= 1
                    error('rethreshold:paramerror','Incorrect number of frequency bands. You supplied %d value(s) instead of 1.',numel(value));
                end
                low_cutoff  = value(1);
                high_cutoff = nan;
            otherwise
                error('rethreshold:paramerror','Unknown parameter: %s',param);
        end
    end
end

fprintf(flog,[...
    'Processing file: %s\n'...
    'with the following settings:\n'],...
    nsfilename);

if all(isnan([low_cutoff high_cutoff]))
    doFilter = 0;
    fprintf(flog,'Both high and low pass cutoffs are nan! No filtering is beign done.\n');
elseif isnan(low_cutoff)
    fprintf(flog,'Lowpass Filter: 0 Hz to %.1f Hz\n',high_cutoff);
elseif isnan(high_cutoff)
    fprintf(flog,'Highpass Filter: %.1f Hz to Nyquist\n',low_cutoff);
else
    fprintf(flog,'Bandpass Filter: %.1f Hz to %.1f Hz\n',low_cutoff,high_cutoff);
end

fprintf(flog,'Threshold: %.1f std\n',threshold);

%% PROCESSING FILE

[nsdata,nsheader] = getNSxData(nsfilename);
nsheader.filename = nsfilename;
%%

if isnan(low_cutoff)
    [b,a]=butter(4,high_cutoff./(nsheader.SamplingFreq/2),'low');
elseif isnan(high_cutoff)
    [b,a]=butter(4,low_cutoff./(nsheader.SamplingFreq/2),'high');
else
    [b,a]=butter(4,[low_cutoff high_cutoff]./(nsheader.SamplingFreq/2));
end
%%
nsdata.snippets   = cell(nsheader.ChannelCount,1);
nsdata.timestamps = cell(nsheader.ChannelCount,1);
%%
bb=tic;
for segment = 1: nsdata.segments
    for curchannel = 1: nsheader.ChannelCount
        aa=tic;
        fprintf(flog,'Channel %02d:',curchannel);
        voltage     = cat(2,zeros(1,nsdata.TimeStamps(segment)),(double(nsdata.raw{segment}(curchannel,:))),zeros(1,60));
        nsheader.ElectrodesInfo(curchannel).HighFreqCorner = low_cutoff*1000;
        nsheader.ElectrodesInfo(curchannel).HighFreqOrder  = 4;
        nsheader.ElectrodesInfo(curchannel).HighFreqType   = 1;
        nsheader.ElectrodesInfo(curchannel).LowFreqCorner  = high_cutoff*1000;
        nsheader.ElectrodesInfo(curchannel).LowFreqOrder   = 4;
        nsheader.ElectrodesInfo(curchannel).LowFreqType    = 1;
        % ------------------------------------------------------------------
        if curchannel==97
            fprintf(flog,' [~FILTERING]');
        else
            if doFilter
                fprintf(flog,' [FILTERING]');
                voltage    = FiltFiltM(b,a,voltage);
            else
                fprintf(flog,' [~FILTERING]');
            end
        end
        
        % ------------------------------------------------------------------
        fprintf(flog,'[STD]');
        voltagestd  = std(voltage,0,2);
        % ------------------------------------------------------------------
        if curchannel==97
            fprintf(flog,'[THRESH @ %.1f STD]',1);
            nsheader.ElectrodesInfo(curchannel).HighThreshold = voltagestd;
            nsheader.ElectrodesInfo(curchannel).LowThreshold  = 0;
            ndxs = find(voltage>voltagestd);
        else
            fprintf(flog,'[THRESH @ %.1f STD]',threshold);
            possiblendxs = 1+find(diff(sign(diff(voltage)))==(-2*sign(threshold)));
            switch sign(threshold)
                case -1
                    nsheader.ElectrodesInfo(curchannel).HighThreshold = 0;
                    nsheader.ElectrodesInfo(curchannel).LowThreshold  = voltagestd*threshold;
                    ndxs = possiblendxs(voltage(possiblendxs)<(voltagestd*threshold));                    
                    %ndxs = find((voltage)<(voltagestd*threshold));
                case 1
                    nsheader.ElectrodesInfo(curchannel).HighThreshold = voltagestd*threshold;
                    nsheader.ElectrodesInfo(curchannel).LowThreshold  = 0;
                    %ndxs = find((voltage)>(voltagestd*threshold));
                    ndxs = possiblendxs(voltage(possiblendxs)>(voltagestd*threshold));                    
            end
        end
        if ~isempty(ndxs)
            % force threshold crossings to be at least 6 samples (0.2 ms @ 30Khz) apart
            ndxs = ndxs([true diff(ndxs)>6])'; 
            ndxs(ndxs<(-lags(1))) = []; % kill threshold crossings within the first 12 samples
            ndxs(ndxs>(size(voltage,2)-39)) = []; % the the last 12 samples.
        end
        % ------------------------------------------------------------------
        fprintf(flog,'[WAVEFORMS/ALIGNING]');
        if ~isempty(ndxs)
            nsnippets = size(ndxs,1);
            snippets = reshape(voltage(:,bsxfun(@plus,ndxs,-9:38)),nsnippets,48);
        else
            nsnippets = 0;
            snippets  = [];
        end
        %snippets = zeros(nsnippets,size(lags,2));
        %for ii=1:nsnippets
        %    snippets(ii,:) = voltage(1,ndxs(ii)+(lags));
        %end
        %snippets = reshape(voltage(:,bsxfun(@plus,ndxs,-9:38)),nsnippets,48);
        %snippets = snippets.*double(nsheader.ElectrodesInfo(curchannel).DigitalFactor)/1000;
        % ------------------------------------------------------------------
        %fprintf(flog,'[ALIGNING]');
        %if nsnippets>0
        %    if (curchannel == 97)
        %        [~,lag] = max(snippets,[],2);
        %    else
        %        switch sign(threshold)
        %            case -1
        %                [~,lag]=min(snippets,[],2);
        %            case 1
        %                [~,lag]=max(snippets,[],2);
        %        end
        %    end
        %    laglist = lags(lag)';
        %    ndxs = ndxs + laglist;
        %    ndxs = unique(ndxs);
        %    
        %    switch sign(threshold)
        %        case -1
        %            ndxs(voltage(1,ndxs)>voltage(1,ndxs+1)) = [];
        %        case 1
        %            ndxs(voltage(1,ndxs)<voltage(1,ndxs+1)) = [];
        %    end            
        %                
        %    snippets = zeros(size(ndxs,1),48);
        %    for ii=1:size(snippets,1)
        %        snippets(ii,:) = voltage(1,ndxs(ii)+(-9:38));
        %    end
        %    % convert snippets into uV. (digitalfactor is nV/digitalization value)
        %    snippets = snippets.*double(nsheader.ElectrodesInfo(curchannel).DigitalFactor)/1000;            
        %end
        % ------------------------------------------------------------------
        fprintf(flog,'[%06d snippets] %.1f s\n',nsnippets,toc(aa));
        nsdata.timestamps{curchannel,1} = ndxs;
        nsdata.snippets{curchannel}     = snippets;        
    end
end
fprintf(flog,'---------------------------------\n%.1f s\n',toc(bb));
nsdata = rmfield(nsdata,'raw');
fclose(flog);
