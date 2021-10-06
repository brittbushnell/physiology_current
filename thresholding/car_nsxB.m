function [clean_nev] = car_nsxB(nev_filename,nsx_filename,outpath,varargin)
%CAR_NS6: Applies common average subtraction to NS6 files, rethresholds the
%data on a per channel basis, and writes out an NEV file for further
%analysis. Uses the original NEV file as a scaffold to ease
%synchronization and ensure compatibility. 
%
% Inputs:
%       nev_filename: nev_filename, including path
%       ns6_filename: nsx_filename (i.e. .ns6 file), including path
%       outpath        
%
% Optional Inputs:
%       threshold   : scalar betwenn 1-n that uniquely determines the MAD
%                     threshold. Default is 4. 
%       filter_order: butterworth filter order (Default is 2)
%       filter_high : high pass filter cutoff (Default is 250)
%       filter_low  : lowpass filter cutoff (Default is 5000)



%% test inputs
[~,nev_pre] = fileparts(nev_filename);
[~,nsx_pre] = fileparts(nsx_filename);
assert(strcmp(nev_pre,nsx_pre),'ns6 and nev filenames are not matched')
assert(length(varargin)<=4,'too many inputs to function');
%% set params
default = [4 2 250 5000]; %2nd order butterworth filter with 250 Hz cutoff and 1 KhZ decimation rate.
params = default;
params(~cellfun(@isempty,varargin)) = deal(cell2mat(varargin));

%extract params
thr = params(1);
filt_ord = params(2);
filt_bounds = [params(3) params(4)];

%% open files
fprintf('loading nsx file. Takes forever\n')
tic;
NS6 = openNSx(nsx_filename);
toc;
%set filter properties
fs = NS6.MetaTags.SamplingFreq;
nyquist = fs/2;
[b,a] = butter(filt_ord,filt_bounds/nyquist);

%% check number of channels
NEV = openNEV(nev_filename,'nosave');
chcount = unique(NEV.Data.Spikes.Electrode);
%assert(mod(length(chcount),96)==0,'channel count should be a multiple of 96;');
assert(length(chcount)<=96*2,'were there three arrays?')
if length(chcount)>96 
    disp('two arrays, will compute CAR for each independently')
    ch_range = reshape(chcount,96,2);
else
    ch_range = [1:96]';
end
%clearvars NEV
%% check to make sure we don't have snippets, solution forthcoming here

if iscell(NS6.Data)
    
disp('presence of snippets, will attempt a patch')
lens = cellfun(@(x) size(x,2),NS6.Data);
[~,ind] = max(lens);
assert(ind==length(NS6.Data),'not sure how to process this file')
NS6.Data = NS6.Data{ind};
offsets = NS6.MetaTags.Timestamp-1;
offsets = offsets(ind);
lens_add = lens(ind-1);
else
    offsets = 0;
    lens_add = 0;
end


%%
%compute common average reference. 
fprintf('computing common average\n')
tic;
CAR = zeros(size(NS6.Data,2),size(ch_range,2));
for kk = 1:size(ch_range,2)
    for ii = 1:96
        CAR(:,kk) = CAR(:,kk)+transpose(double(NS6.Data(ii+96*(kk-1),:)));
    end
end
CAR = CAR/96;
toc;
%% go through each channel in the nsx file and rethreshold 

one_ms = round(fs*.001); %used to exclude spikes too close to one another
waveforms_unsorted = [];
timestamps_unsorted = [];
codes_unsorted = [];
fprintf('rethresholding channels\n')

tic;
for kk = 1:size(ch_range,2)
    for ii = 1:96
        
        
        %subtract CAR, filtert
        temp = transpose(double(NS6.Data(ii+96*(kk-1),:)));
        temp = temp(:)-CAR(:,kk);
        temp = filter(b,a,temp);
        
        %comment below and uncomment this to compute mad estimate of
        %threshold. Implements standard MAD estimator
        %thresh = median(abs(temp)/.6745) * thr;
        
        %standard blackrock threshold, as requested by TM
        x = sort(mean(reshape(temp(1:60000),600,100).^2));
        thresh = thr*sqrt(mean(x(6:25)));


        % now find the threshold crossing times
        %thresh2 = find(abs(temp)>=thresh); %acute team definition
        thresh2 = find(temp<=-thresh); %blackrock definition
        thresh2(thresh2<one_ms) = []; % takes care of initial transient caused by filtering process
        hstart = [thresh2(1); thresh2(find(diff(thresh2)>one_ms)+1)]; %find when there are threshold crossings, that are at least 1 ms apart
        
        %trim ends to take care of transients
        border = one_ms*(48/2)+1;
        hstart = hstart(hstart>border & hstart<(length(temp)-border));
        hstart2 = num2cell(hstart);
        
        % calculate waveforms, these times before and after the spike are
        % standards for blackrock
        aligned = cellfun(@(x) temp(x-11:x+36),hstart2,'UniformOutput',false);
        waveforms_unaligned = cellfun(@(x) x-11:x+36,hstart2,'UniformOutput',false);
        
        % align to peak. Needs to be updated.
        [v1,ind] = cellfun(@(x) min((x(5:30))),aligned); %make sure you avoid the ends
        ind = ind+4;
        ind = num2cell(ind);
        
        %realign all waveforms
        hstart3 = cellfun(@(x1,x2) x1(x2),waveforms_unaligned,ind);
        waveforms_temp = cell2mat(cellfun(@(x) temp(x-11:x+36),num2cell(hstart3,2),'UniformOutput',false)');
        timestamps_temp = hstart3;
 
        %take care of a case of 0 spikes detected (make up a fake spike)
        %and give channels ocdes
        
        if isempty(timestamps_temp)
            timestamps_temp = 1;
            waveforms_temp = zeros(48,1);
        end
        
        codes_temp  = ones(size(timestamps_temp))*double(ch_range(ii,kk));
       
        %concatenate results
        waveforms_unsorted = cat(2,waveforms_unsorted,waveforms_temp);
        timestamps_unsorted = cat(1,timestamps_unsorted,timestamps_temp);
        codes_unsorted = cat(1,codes_unsorted,codes_temp);     
        
        %be careful with memory
        clearvars waveforms_unaligned hstart* aligned* *temp*
    end
end
toc;

%% sort timestamps
[~,sort_ind] = sort(timestamps_unsorted);
codes = codes_unsorted(sort_ind);
waveforms = waveforms_unsorted(:,sort_ind);
timestamps = timestamps_unsorted(sort_ind);

timestamps = timestamps+offsets;
remove_ind = timestamps<lens_add;
codes(remove_ind) = [];
waveforms(:,remove_ind) = [];
timestamps(remove_ind) = [];

%%
%open NEV file and write these times into it
NEV = openNEV(nev_filename,'nosave');

%check for older NEV filespec version and flag if clock resets
times = double(NEV.Data.Spikes.TimeStamp);
if str2double(NEV.MetaTags.FileSpec)<2.3 
    disp('NEV filespec < 2.3')
    if any(diff(times)<0)
        disp('clock reset on this recording, please process with corruptednsx_cleanup')
    end
    
end

%% cast variables into the appropriate format
TimeStamp = uint32(timestamps');
electrode = uint16(codes');
unit = uint8(zeros(size(codes))');
waveform = int16(waveforms);
%%
NEV.Data.Spikes.TimeStamp = TimeStamp;
NEV.Data.Spikes.Unit = unit;
NEV.Data.Spikes.Electrode = electrode;
NEV.Data.Spikes.Waveform = waveform;
%% save out final file
% saveNEV(NEV,outpath,'noreport');
fParts = strsplit(nev_filename,'/');
shortName = strrep(fParts{end},'.nev',[]);
newName = [outpath,shortName,sprintf('_thresh%d',thr*10),'.nev'];
saveNEV(NEV,newName,'noreport',outpath);
end
