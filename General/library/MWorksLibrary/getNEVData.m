% getNEVData is a function that pulls out the information from .nev files
% for analysis. 

NEVfile = '/volumes/BBArrayData/TestData/WU_gratmap_test_20170110_003.nev';
nNEVfiles = 1;

%% Verify file

if ~exist(NEVfile, 'file')
    error ('MwksMergeMWKandNEV:NEVfile', 'File: %s was not found.\n', NEVfile)
else
    [pn,nn,en] = fileparts(NEVfile);
    if ~strcmpi(en, '.nev')
        error ('MwksMergeMWKandNEV:NEVfile', 'File: %s is not a NEV file.\n', NEVfile)
    end
    
    if isempty(pn)
        pn = pwd;
    end
    NEVfile = cat(2,pn,filesep,nn,en);
end




%% Reinstate once this is a function

%This is for concatenating multiple .nev files

% if ~ismember(nargin,[2 3 4])
%     error('Expo:ReadXMLandNEV','Please specify at least two or three files.');
% end

% nNEVfiles = 0; % set number of NEV files to 0
% nomat = 0;     % set default to using mat files if found (nomat = 1, means regenerate)
% nosave = 1;    % set default to saving mat files (nosave = 1, means to ignore saving .full file at end)
% regen   = 0;    % set default to not regenerating .full file.
% 
% for ii=1:nargin % for each argument
%     if strcmp(varargin{ii},'nomat') % see if the argument "nomat" was passed, and if it is, set variable nomat to 1.
%         nomat = 1;
%     elseif strcmp(varargin{ii},'save') % see if the argument "save" was passed, and if it is, set variable nosave to 0.
%         nosave = 0;
%     elseif strcmp(varargin{ii},'regen') % see if the argument "regen" was passed, and if it is, set variable regen to 1.
%         regen = 1;
%     else % otherwise check the following
%         [p,n,e] = fileparts(varargin{ii});  % assume the other arguments are filenames and break the filenames in to path, name, extension.
%         if isempty(p) % if the path is empty, use the present working directory
%             p = pwd;
%         end
%         %         if isempty(strfind(p(1:3),filesep))
%         %             p = cat(2,'.',filesep,p);
%         %         end
%         switch e % based on the extension do the following:
%             case '.nev'
%                 %disp('Found NEV file');
%                 nNEVfiles = nNEVfiles + 1; %increment the number of nev file found.
%                 filenameNEV{nNEVfiles} = [p filesep n e]; %remake the nev file with with fully qualified path
%         end
%     end
% end
% clear p n e ii;

%% Check if there's already a saved .mat file for the data set.

% if exist([filenameXML(1:end-4) '.full.mat'],'file')
%     tmp = dir([filenameXML(1:end-4) '.full.mat']);
%     fprintf('This file has already been processed on %s.\n',tmp.date);
%     if regen==0
%         fprintf('Loading the processed MAT.\nTo force regeneration of this file, append the parameter ''regen''\n');
%         load([filenameXML(1:end-4) '.full.mat']);
%         return;
%     else
%         fprintf('Regenerating this MAT file.\n');
%     end
% end

%%

for ii=1:nNEVfiles
    if exist([NEVfile{ii}(1:end-3) 'mat'],'file')
        fprintf('Found a preprocessed NEV file and ');
        if nomat
            fprintf('ignoring it!\n');
            % nomat = don't look for mat file.
            % nosave = don't save a mat file at the end.
            NEVimport{ii} = openNEV(NEVfile{ii},'report','8bits','nomat','nosave');
        else
            fprintf('using it!\n');
            % nosave = don't save a mat file at the end.
            NEVimport{ii} = openNEV(NEVfile{ii},'report','8bits','nosave');
        end
    else
        fprintf('Processing NEV file and saving it to a MAT file.\n');
        NEVimport{ii} = openNEV(NEVfile{ii},'report','8bits');
    end
end

% clear ii *argin;

%% Determine which one has the digital words

% NEV_digital contains digital sync pulses (thus called digital nev)
% NEV_rerun contains the "reran" sorted data without digital pulses.
% the only way to tell them apart is if the file contains digital pulses.

nNEV_digital = 0;
nNEV_rerun   = 0;

NEVimport_D = [];
NEVimport_R = [];


for ii=1:nNEVfiles
    if ~isempty(NEVimport{ii}.Data.SerialDigitalIO.UnparsedData)
        % found digital data!
        nNEV_digital = nNEV_digital + 1; % increment the number of digital nev files
        NEVimport_D = NEVimport{ii}; % save the last listed digital nev file
    else
        % found rerun data!
        nNEV_rerun = nNEV_rerun + 1;
        NEVimport_R = NEVimport{ii};
    end
end

if (nNEV_digital < 1)
    error('getNEVData','You did not supply a NEV file with digital timestamps.');
end

if (nNEV_digital > 1)
    warning('getNEVData','Found two NEV files, both with digital timestamps. Using the last one only!');
end

%%
% Combine NEVimport_D and NEVimport_R files into one file called NEVimport.

NEVimport = NEVimport_D;
clear NEVimport_D;
if nNEV_rerun
    NEVimport.ElectrodesInfo = NEVimport_R.ElectrodesInfo;
    NEVimport.Data.Spikes    = NEVimport_R.Data.Spikes;
end
clear NEVimport_R;

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

dwords = double(NEVimport.Data.SerialDigitalIO.UnparsedData);
times  = double(NEVimport.Data.SerialDigitalIO.TimeStampSec*10000);
samples = double(NEVimport.Data.SerialDigitalIO.TimeStamp);

if isfield(ExpoXMLimport.frames,'StartTimes')&&(~isnan(ExpoXMLimport.frames.StartTimes(1)))
    xmltimes = double(ExpoXMLimport.frames.StartTimes');
else
    xmltimes = double(ExpoXMLimport.frames.Times');
end


fprintf('-PRECORRECTION--------------------\n');
fprintf('%010d digital words received\n',size(dwords,2));
fprintf('%010d screen frames presented\n',ExpoXMLimport.frames.nticks);
fprintf('Digital Words:');
fprintf(' %d',unique(dwords));
fprintf('\n');
fprintf('----------------------------------\n');

% Sometimes we send out multiple digital outs (one for each tick, one for
% each pass, etc.. on different digital pins. Blackrock doesn't read the
% pin, but instead encodes all 16 digital ins as a 16 bit word. If expo
% doesn't set the pins faster than the sampling rate of Blackrock's digital
% acquisition, then a single 16-bit word will get split. The following code
% recombines digital words that happen to be within 10 samples of each
% other.

for ii=10:-1:1 % from 30 samples (1 ms) to 1 sample delays
    % find words that are ii samples apart.
    priorndx = find(diff(samples) == ii);
    % create a index of words that appeared delayed in time.
    badndx   = priorndx + 1;
    % goodndx contains all the other samples
    goodndx  = setdiff(1:length(dwords),badndx);
    % take the digital words at the correct time and add to them the
    % temporally displaced words (badndx).
    dwords(priorndx) = dwords(priorndx) + dwords(badndx);
    % remove the indecies of displaced words from dwords, times, and samples.
    dwords  = dwords(goodndx);
    times   = times(goodndx);
    samples = samples(goodndx);
end

% show the current number of digital words and the number of frames expo
% reports. They should match. Also display all the unique digital words
% (for most files, this will be 1.


fprintf('-POSTCORRECTION-------------------\n');
fprintf('%010d digital words received\n',size(dwords,2));
fprintf('%010d screen frames presented\n',size(xmltimes,2));
fprintf('Digital Words:');
fprintf(' %d',unique(dwords));
fprintf('\n');
fprintf('----------------------------------\n');

fprintf('Truncating to the same number of sync pulses.\n');
ntimes    = size(times,2);
nxmltimes = size(xmltimes,2);
if nxmltimes > ntimes
    % more xml pulses than blackrock received (i.e. blackrock probably
    % died). Truncate the XML pulses to match.
    fprintf('Found more Expo timestamps than Blackrock pulses.\n');
    xmltimes = xmltimes(1,1:ntimes);
elseif ntimes > nxmltimes
    % more blackrock pulses recived than expo claimed to have sent. This
    % should never happen, but occasionally expo sends out an extra pulse
    % at the end.
    fprintf('Found more Blackrock pulses than Expo pulses.\n');
    dwords  = dwords(1, 1:nxmltimes);
    times   = times(1,  1:nxmltimes);
    samples = samples(1,1:nxmltimes);
end

fprintf('-POSTTRUNCATION-------------------\n');
fprintf('%010d digital words received\n',size(dwords,2));
fprintf('%010d screen frames presented\n',size(xmltimes,2));
fprintf('Digital Words:');
fprintf(' %d',unique(dwords));
fprintf('\n');
fprintf('----------------------------------\n');


% This is dangerous, but...
% if we have more words than frames (this should never happen), then
% truncate the words to the number of frames. The reason for this is that
% occasionally Expo would generate a pulse without recording it in the XML
% file at the end. It's not suppose to, and will eventually get fixed. This is
% probably not the best solution, but it works for most files. The problem
% is if the expo dropped the recording of frames in the middle. That means
% the pulses in Blackrock are legit and truncating will cause problems.
%
% if 0 % set to 1 to include this code!
%     if (size(dwords,2) > ExpoXMLimport.frames.nticks)  % more words than frames??
%         fprintf('-FOUND TOO MANY DWORDS!-----------\n');
%         fprintf('%010d digital words before.\n',size(dwords,2));
%         truncate everything!
%         dwords  = dwords(1,1:ExpoXMLimport.frames.nticks);
%         times   = times(1,1:ExpoXMLimport.frames.nticks);
%         samples = samples(1,1:ExpoXMLimport.frames.nticks);
%         fprintf('%010d digital words after.\n',size(dwords,2));
%         fprintf('----------------------------------\n');
%     end
% end
%%
% find first and last "aligned tick!" (i.e. one without a timebase overrun! or short start)

firstaligned_NDX = find(diff(times)<(83.3+4)&diff(times)>(83.3-4),1,'first');
lastaligned_NDX  = find(diff(times)<(83.3+4)&diff(times)>(83.3-4),1,'last')+1;

firstaligned_xmlNDX = find(diff(xmltimes)<(83.3+4)&diff(xmltimes)>(83.3-4),1,'first');
lastaligned_xmlNDX  = find(diff(xmltimes)<(83.3+4)&diff(xmltimes)>(83.3-4),1,'last')+1;

% calc offset & scale
offset           = times(firstaligned_NDX)-xmltimes(firstaligned_xmlNDX);
times_offset     = times - offset;
scale            = (xmltimes(lastaligned_xmlNDX)-xmltimes(firstaligned_xmlNDX))/(times_offset(lastaligned_NDX) - times_offset(firstaligned_NDX));

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
fprintf('Processing Spikes...\n');
for curChan = NEV.uni_channel
    fprintf('CH %03d [',curChan);
    for curTempID = NEV.uni_templateID
        tempTimes = round(NEV.timestamps((NEV.templateID==curTempID)&(NEV.channel == curChan)));
        if ~isempty(tempTimes)
            ExpoXMLimport.spiketimes.Times{cnt} = tempTimes(tempTimes>0);
            ExpoXMLimport.spiketimes.Channels(cnt) = curChan;
            ExpoXMLimport.spiketimes.Templates(cnt) = curTempID;
            cnt = cnt + 1;
            if curTempID==0
                fprintf('0');
            else
                fprintf('.');
            end
        end
    end
    tempTimes = sort(round(NEV.timestamps((NEV.templateID~=255)&(NEV.channel == curChan))));
    if ~isempty(tempTimes)
        ExpoXMLimport.spiketimes.Times{cnt} = tempTimes(tempTimes>0);
        ExpoXMLimport.spiketimes.Channels(cnt) = curChan;
        ExpoXMLimport.spiketimes.Templates(cnt) = 256;
        cnt = cnt + 1;
        fprintf('*');
    end
    tempTimes = sort(round(NEV.timestamps((NEV.channel == curChan))));
    if ~isempty(tempTimes)
        ExpoXMLimport.spiketimes.Times{cnt} = tempTimes(tempTimes>0);
        ExpoXMLimport.spiketimes.Channels(cnt) = curChan;
        ExpoXMLimport.spiketimes.Templates(cnt) = 257;
        cnt = cnt + 1;
        fprintf('#');
    end
    fprintf('] ');
    if ~mod(curChan,8)
        fprintf('\n');
    end
end
ExpoXMLimport.spiketimes.IDs = 0:(cnt-2);
%%
ExpoXMLimport.blackrock.dwords  = dwords;
ExpoXMLimport.blackrock.samples = samples;
ExpoXMLimport.blackrock.times   = times;
ExpoXMLimport.blackrock.offset  = offset;
ExpoXMLimport.blackrock.scale   = scale;

if nosave
    fprintf('\nResults passed to output variable only.\n');
else
    fprintf('\nSaving Results in an *.full.mat file.\n');
    save([filenameXML(1:end-4) '.full.mat'],'ExpoXMLimport');
end



