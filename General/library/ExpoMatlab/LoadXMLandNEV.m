function varargout = LoadXMLandNEV(fileXML,fileNEV,varargin)
%
%ExpoXMLimport = LoadXMLandNEV('file.xml','file.nev')
%ExpoXMLimport = LoadXMLandNEV(...,'nomat');
%ExpoXMLimport = LoadXMLandNEV(...,'nosave');
%ExpoXMLimport = LoadXMLandNEV(...,'quiet');
%[timeAlignScale timeAlignOffset] = LoadXMLandNEV(...)

% This function is used to merge and synchronize Blackrock NEV files and
% Expo XML files. The first file needs to be the Expo exported XML file.
% The second file needs to be a Blackrock NEV file that contains Digital 
% Sync Pulses on Pin 0.
%
% The function returns a matlab structure (see ReadExpoXML). If two outputs
% are reqested, then only the scale and offset needed to align Expo and 
% Blackrock data are returned; no matlab structure is returned..
%
% By default, this function saves a matlab structure based on the XML file
% in the same directory as the XML file and a matlab file in same directory 
% as the NEV file. This can be avoided by appending the 'nosave' flag. If 
% the program detects a preprocessed mat file, it will use it instead of 
% parsing the XML or NEV files. To avoid this, append the 'nomat' flag. If
% the program is requested to use a preprocessed file, and that file
% exists, it will automatically set 'nosave' to 1.
%
% the 'quiet' flag means no output to stdout except errors.
%
% By default, the matlab structure is only passed as an output (no saving). 

%% Change Log
% 15 Nov 2013: changed output to varargout and added a break so that this
% function can return just the scale and offset needed to align Blakcrock
% and Expo data. (shooner)
%
% 15 Nov 2013: added (temporary) fix to correct for extra NEV timestamps:
% changed Romesh's original fix to discard timestamps within 100 samples of
% each other.  (shooner)
%
% 08 Jan 2014: this is revamped version that simplifies the inputs.

%% Defaults

SHOWFIGS = 0;
nomat    = 0; % set default to *using* mat files, (i.e. no preprocessing)
nosave   = 0; % set default to *saving* mat files (nomat = 1, mean not saving mat files)
noquiet  = 1; % set default to not being quiet

%% Parse input / output
% see if there are 1 or 2 outputs defined, otherwise throw an error...
switch nargout
    case 1
        doOnlyScaleAndOffset = 0;
    case 2
        doOnlyScaleAndOffset = 1;
    otherwise
        error('LoadXMLandNEV:NumOutputs','Please specify 1 or 2 outputs.');
end

% see if there are the correct number of arguments passed to the function, 
% otherwise throw an error...
if (nargin < 2) || (nargin > 4)
    error('LoadXMLandNEV:NumFiles','Incorrect number of parameters passed.');
end

% validate XML

if ~exist(fileXML,'file')
    error('LoadXMLandNEV:FileXML','File: %s was not found.\n',fileXML);
else
    [p,n,e] = fileparts(fileXML);
    if ~strcmpi(e,'.xml')
        error('LoadXMLandNEV:FileXML','File: %s is not an XML file.\n',fileXML);
    end
    if isempty(p)
        p = pwd;
    end
    fileXML = cat(2,p,filesep,n,e);
end

% validate NEV

if ~exist(fileNEV,'file')
    error('LoadXMLandNEV:FileNEV','File: %s was not found.\n',fileNEV);
else
    [p,n,e] = fileparts(fileNEV);
    if ~strcmpi(e,'.nev')
        error('LoadXMLandNEV:FileNEV','File: %s is not an NEV file.\n',fileNEV);
    end
    if isempty(p)
        p = pwd;
    end
    fileNEV = cat(2,p,filesep,n,e);
end

for ii=1:nargin-2 % for each argument
    switch lower(varargin{ii})
        case 'nomat' % see if the argument "nomat" was passed, and if it is, set variable nomat to 1.
            nomat = 1;
        case 'nosave' % see if the argument "nosave" was passed, and if it is, set variable regen to 1.
            nosave = 1;
        case 'quiet' % if quiet, set noquiet to 0.
            noquiet = 0;
    end
end
clear p n e ii;

%% see if the mat files exist

nomatXML = nomat; % if 0, read mat file, if 1, parse the original
nomatNEV = nomat; % if 0, read mat file, if 1, parse the original

% if you asked to read in the preprocessed XML file but it doesn't exist,
% flip the flag to reparse.

if ~nomatXML && ~exist([fileXML(1:end-3) 'mat'],'file')
    nomatXML = 1;
end

% if you asked to read in preprocessed NEV file but it doesn't exist,
% flip the flag to reparse.

if ~nomatNEV && ~exist([fileNEV(1:end-3) 'mat'],'file')
    nomatNEV = 1;
end
    
%%

% 'read','report' removed.

if nomatNEV
    % do not use any preprocessed MAT files!
    if nosave
        if noquiet,fprintf('Parsing NEV file. Not saving MAT.\n');end;
        NEVimport = openNEV(fileNEV,'8bits','nomat','nosave');
    else
        if noquiet,fprintf('Parsing NEV file. Saving MAT for future reads.\n');end;
        NEVimport = openNEV(fileNEV,'8bits','nomat');
    end
else
    % Use any MAT files if they exist
    if nosave
        if noquiet,fprintf('Existing parsed NEV file found. Loading it.\n');end;
        NEVimport = openNEV(fileNEV,'8bits','nosave');
    else
        if noquiet,fprintf('Existing parsed NEV file found. Loading it, and resaving.\n');end;
        NEVimport = openNEV(fileNEV,'8bits');
    end
    
end
    

if nomatXML
    % do not use any preprocessed MAT files!
    if nosave
        if noquiet,fprintf('Parsing XML file. Not saving MAT.\n');end;
        ExpoXMLimport = ReadExpoXML(fileXML,0,1);
    else
        if noquiet,fprintf('Parsing XML file. Saving MAT for future reads.\n');end;
        ExpoXMLimport = ReadExpoXML(fileXML,0,1);
        save([fileXML(1:end-3) 'mat'],'ExpoXMLimport'); 
    end
else
    % Use any MAT files if they exist
    if noquiet,fprintf('Existing parsed XML file found. Loading it.\n');end;
    load([fileXML(1:end-3) 'mat'],'ExpoXMLimport');
end

%% Check for sync signals
if isempty(NEVimport.Data.SerialDigitalIO.UnparsedData)
    error('Expo:LoadXMLandNEV','You did not supply a NEV file with digital syncs.');
end

%% Correct for overflow
NEVimport = fixnev(NEVimport);

%% Examine the digital pulses!

% For every new frame, Expo does some processing prior to sending the
% stimulus information to the video card. When this happens, digital out
% pin 1 goes high. The rising edge of this pulse is then detected by the
% blackrock system and timestamped in the data file.
%
%
% dwords = the digital words received
% times = the timestamp of the digital words in 1/10 ms resolution
% samples = the sample number of the digital word
% xmltimes = the timestamp of when expo claimed it displayed the stimulus in 1/10 ms resolution

dwords  = double(NEVimport.Data.SerialDigitalIO.UnparsedData);
times   = double(NEVimport.Data.SerialDigitalIO.TimeStampSec*10000);
samples = double(NEVimport.Data.SerialDigitalIO.TimeStamp);
if isfield(ExpoXMLimport.frames,'StartTimes')&&(~isnan(ExpoXMLimport.frames.StartTimes(1)))
    xmltimes = double(ExpoXMLimport.frames.StartTimes');
else
    xmltimes = double(ExpoXMLimport.frames.Times');
end


if noquiet
    fprintf('-<strong>PRECORRECTION</strong>--------------------\n');
    fprintf('%010d digital words received\n', size(dwords,2));
    fprintf('%010d screen frames presented, %d TBOs\n',ExpoXMLimport.frames.nticks,sum(ExpoXMLimport.frames.TBOs));
    fprintf('Digital Words:\n');
    for ii=unique(dwords)
        fprintf('%d : %d\n',ii,sum(dwords==ii));
    end
    fprintf('Should have: %d words\n',sum(ismember(dwords,1:2:15)));
    fprintf('----------------------------------\n');
end

if SHOWFIGS
    subplot(2,3,1);
    plot(times,dwords,'.');ylim([-1 5]);
    subplot(2,3,2);
   
    plot(times(1:end-1),diff(times),'k.');
    
    tmp  = diff(times);
    tmp2 = find((dwords(1:end-1) == 1));
    tmp3 = find((dwords(1:end-1) == 2));
    tmp4 = find((dwords(1:end-1) == 3));
    hold on;plot(times(tmp2),tmp(tmp2),'ro',times(tmp3),tmp(tmp3),'bo',times(tmp4),tmp(tmp4),'go');hold off;
    ylim([0 250]);
    line([times(1) times(end)],[100/3 100/3],'linestyle',':');
end

% Sometimes we send out multiple digital outs (one for each tick, one for
% each pass, etc.. on different digital pins. Blackrock doesn't read the
% pin, but instead encodes all 16 digital inputs as a 16 bit word. If expo
% doesn't set the pin faster than the sampling rate of Blackrock's digital
% acquisition, then a single 16-bit word will get split. The following code
% recombines digital words that happen to be within 100 samples of each
% other (100 samples is ~3.3 ms at 30Khz).

for ii=14:-2:2
    ndx = find(dwords==ii);    
    if isempty(ndx)
        continue;
    end    
    priorndx = ndx-1;    
    dwords(priorndx) = dwords(priorndx)+dwords(ndx);    
    dwords(ndx)  = [];
    times(ndx)   = [];
    samples(ndx) = [];
end

% for ii=100:-1:1 % from 100 samples (3.3 ms) to 1 sample delays 
%     % find words that are ii samples apart.
%     priorndx = find(diff(samples) == ii);
%     if isempty(priorndx)
%         continue;
%     else
%         % don't ndx the ones that resulted from TBOs.
%         if any(priorndx==1)
%             ndx1found = 1;
%         else
%             ndx1found = 0;
%         end
%         priorndx(priorndx==1) = [];
%         pre = priorndx-1;
%         priorndx(diff([samples(pre)' samples(priorndx)']')>(375)) = [];
%         if ndx1found
%             priorndx = cat(2,1,priorndx);
%         end
%     end
%     % create a index of words that appeared delayed in time.
%     badndx   = priorndx + 1;
%     
%     % goodndx contains all the other samples
%     goodndx  = setdiff(1:length(dwords),badndx);
%     
%     % take the digital words at the correct time and add to them the
%     % temporally displaced words (badndx).
%     % RDK - change 2014-01-09 to use bitwise operations.
%     %dwords(priorndx) = dwords(priorndx) + dwords(badndx);
%     %dwords(priorndx) = double(bitor(uint16(dwords(priorndx)),uint16(dwords(badndx))));
%     
%     % remove the indecies of displaced words from dwords, times, and samples.
%     dwords  = dwords(goodndx);
%     times   = times(goodndx);
%     samples = samples(goodndx);
% end

% show the current number of digital words and the number of frames expo
% reports. They should match. Also display all the unique digital words
% (for most files, this will be 1.

if noquiet
    fprintf('-<strong>POSTCORRECTION</strong>-------------------\n');
    fprintf('%010d digital words received\n',size(dwords,2));
    fprintf('%010d screen frames presented\n',size(xmltimes,2));
    fprintf('Digital Words:\n');
    for ii=unique(dwords)
        fprintf('%d : %d\n',ii,sum(dwords==ii));
    end
    fprintf('----------------------------------\n');
end

if SHOWFIGS
    subplot(2,3,4);
    plot(times,dwords,'.');ylim([-1 5]);
    subplot(2,3,5);
    plot(diff(times),'k.');
    ylim([0 250]);
end

ntimes    = size(times,2);
nxmltimes = size(xmltimes,2);

if SHOWFIGS
    subplot(2,3,3);
    plot(1:(nxmltimes-1),diff(xmltimes),'ro-',1:(ntimes-1),diff(times)-83,'ko-');
    axis tight;
    ylim([-100 400]);
    drawnow;
end


if noquiet,fprintf('Aligning sync pulses before truncation: ');end;
% offndx = offset in ndxs
[~,offndx]=max(xcorr(diff(xmltimes),diff(times)));
offndx=offndx-(nxmltimes-1);
if noquiet,fprintf('Offset: %d\n',offndx);end;

if offndx>0
    if noquiet,fprintf('Removing %d sync signal(s) from begining of XML.\n',offndx);end;
    xmltimes(1:offndx) = [];
end

if offndx<0
    if noquiet,fprintf('Removing %d sync signal(s) from begining of NEV.\n',offndx);end;
    times(  1:(-offndx)) = [];
    dwords( 1:(-offndx)) = [];
    samples(1:(-offndx)) = [];
end

ntimes    = size(times,2);
nxmltimes = size(xmltimes,2);

if nxmltimes==ntimes
    if noquiet,fprintf('Blackrock and Expo files contain the same number of sync pulses.\n');end;
else
    if noquiet,fprintf('Truncating to the same number of sync pulses.\n');end;
    if nxmltimes > ntimes
        % more xml pulses than blackrock received (i.e. blackrock probably
        % died). Truncate the XML pulses to match.
        if noquiet,fprintf('<strong>Found more Expo timestamps than Blackrock pulses.\nExpo probably stopped after Blackrock.</strong>\n');end;
        xmltimes = xmltimes(1,1:ntimes);
    elseif ntimes > nxmltimes
        % more blackrock pulses recived than expo claimed to have sent. This
        % should never happen, but occasionally expo sends out an extra pulse
        % at the end.
        if noquiet,fprintf('<strong>Found more Blackrock pulses than Expo pulses.\nBlackrock probably stopped after Expo.</strong>\n');end;
        dwords  = dwords(1, 1:nxmltimes);
        times   = times(1,  1:nxmltimes);
        samples = samples(1,1:nxmltimes);
    end
    if noquiet
        fprintf('-<strong>POSTTRUNCATION</strong>-------------------\n');
        fprintf('%010d digital words received\n',size(dwords,2));
        fprintf('%010d screen frames presented\n',size(xmltimes,2));
        fprintf('Digital Words:\n');
        for ii=unique(dwords)
            fprintf('%d : %d\n',ii,sum(dwords==ii));
        end
        fprintf('----------------------------------\n');
    end
end
%%
% find first and last "aligned tick!" (i.e. one without a timebase overrun! or short start)

firstaligned_NDX    = find(diff(times)<(83.3+4)&diff(times)>(83.3-4),1,'first')+1;
lastaligned_NDX     = find(diff(times)<(83.3+4)&diff(times)>(83.3-4),1,'last')+1;
firstaligned_xmlNDX = find(diff(xmltimes)<(83.3+4)&diff(xmltimes)>(83.3-4),1,'first')+1;
lastaligned_xmlNDX  = find(diff(xmltimes)<(83.3+4)&diff(xmltimes)>(83.3-4),1,'last')+1;

% calc offset & scale
offset           = times(firstaligned_NDX)-xmltimes(firstaligned_xmlNDX);
times_offset     = times - offset;
scale            = (xmltimes(lastaligned_xmlNDX)  - xmltimes(firstaligned_xmlNDX))...
                  /(times_offset(lastaligned_NDX) - times_offset(firstaligned_NDX));

if noquiet,fprintf('Scale: %.6fx,Offset: %.3f s.\n',scale,offset/10000);end;

if SHOWFIGS    
    subplot(2,3,6);
    plot(times,                 1.0.*ones(size(times)),   'k',...
        ((times-offset).*scale),1.5.*ones(size(times)),   'k',...
        xmltimes,              2.0.*ones(size(xmltimes)),'r',...
        [times(1) (times(1)-offset).*scale],[1 1.5],    'b');
    set(gca,'tickdir','out');
    axis([-xmltimes(floor(end/50)) xmltimes(floor(end/50)) 0 3]);
end

% If only computing scale and offset, return here:
if doOnlyScaleAndOffset
    varargout{1} = scale;
    varargout{2} = offset;
    return;
end

% apply offset & scale to all spikes

% convert 1/30000 resolution spike timestamps to 1/10000 resolution, apply
% offset and scale.
NEV.timestamps = round((double(NEVimport.Data.Spikes.TimeStamp)/3 - offset).*scale);
NEV.channel    = NEVimport.Data.Spikes.Electrode;
NEV.templateID = NEVimport.Data.Spikes.Unit;

NEV.uni_channel    = double(unique(NEV.channel));
NEV.uni_templateID = double(unique(NEV.templateID));

ExpoXMLimport.spiketimes_EXPO = ExpoXMLimport.spiketimes; % save old spike times (those acquired in EXPO)
ExpoXMLimport.spiketimes.IDs = 0:(length(unique([double(NEV.channel)*1000 + double(NEV.templateID) NEV.uni_channel]))-1);
ExpoXMLimport.spiketimes.Channels  = zeros(size(ExpoXMLimport.spiketimes.IDs));
ExpoXMLimport.spiketimes.Templates = zeros(size(ExpoXMLimport.spiketimes.IDs));
%%
cnt = 1;
if noquiet,
    fprintf('Processing Spikes...[0 =  unsorted, . = sorted unit, * = all but noise channel, # = all with noise channel]\n');
    fprintf('-----------------------------------------------------------------------------------------------------------\n');
end
for curChan = NEV.uni_channel
    if noquiet,fprintf('CH %03d [',curChan);end;
    for curTempID = NEV.uni_templateID
        tempTimes = round(NEV.timestamps((NEV.templateID==curTempID)&(NEV.channel == curChan)));
        if ~isempty(tempTimes)
            ExpoXMLimport.spiketimes.Times{cnt} = tempTimes(tempTimes>0);
            ExpoXMLimport.spiketimes.Channels(cnt) = curChan;
            ExpoXMLimport.spiketimes.Templates(cnt) = curTempID;
            cnt = cnt + 1;
            if noquiet,
                if curTempID==0
                    fprintf('0');
                else
                    fprintf('.');
                end
            end
        end
    end
    tempTimes = sort(round(NEV.timestamps((NEV.templateID~=255)&(NEV.channel == curChan))));
    if ~isempty(tempTimes)
        ExpoXMLimport.spiketimes.Times{cnt} = tempTimes(tempTimes>0);
        ExpoXMLimport.spiketimes.Channels(cnt) = curChan;
        ExpoXMLimport.spiketimes.Templates(cnt) = 256;
        cnt = cnt + 1;
        if noquiet,fprintf('*');end;
    end
    tempTimes = sort(round(NEV.timestamps((NEV.channel == curChan))));
    if ~isempty(tempTimes)
        ExpoXMLimport.spiketimes.Times{cnt} = tempTimes(tempTimes>0);
        ExpoXMLimport.spiketimes.Channels(cnt) = curChan;
        ExpoXMLimport.spiketimes.Templates(cnt) = 257;
        cnt = cnt + 1;
        if noquiet,fprintf('#');end;
    end
    if noquiet,fprintf('] ');end;
    if ~mod(curChan,8)
        if noquiet,fprintf('\n');end;
    end
end
if noquiet,fprintf('\n');end;
ExpoXMLimport.spiketimes.IDs = 0:(cnt-2);
%%
ExpoXMLimport.blackrock.dwords  = dwords;
ExpoXMLimport.blackrock.samples = samples;
ExpoXMLimport.blackrock.times   = times;
ExpoXMLimport.blackrock.offset  = offset;
ExpoXMLimport.blackrock.scale   = scale;
varargout{1} = ExpoXMLimport;
