function [PSTH,PSTHndxs]=extractpower(ExpoXMLimport)
%
%       Author: Romesh Kumbhani
%        Email: romesh.kumbhani@nyu.edu
%      Version: 1.3
% Last updated: 2014-04-14

%%
[~,n,e]=fileparts(ExpoXMLimport.FileName);
filename = [n e];
re = regexp(filename,'m(\d+)(\w+)\#(\d+)\[','tokens');
monkey = re{1}{1}; %strings
hemi   = re{1}{2}; %strings
exp    = re{1}{3}; %strings

% NS2 file...

nsfilename = sprintf('/experiments/m%s_array/recordings/ns6/m%s%s#%03d.ns6',monkey,monkey,hemi,str2double(exp));

%% PROCESSING FILE
[nsdata,nsheader] = getNSxData(nsfilename);

%% define default values
n_cutoffs   = 2;
low_cutoff  = [20 300]; % 300 Hz
high_cutoff = [90 6000]; % 6000 Hz
segment     = 1; % assume no pauses;
flog        = 1;


poles = 4;
a = zeros(n_cutoffs,2*poles+1);
b = zeros(n_cutoffs,2*poles+1);
for ii=1:n_cutoffs
    [b(ii,:),a(ii,:)]=butter(poles,[low_cutoff(ii) high_cutoff(ii)]./(nsheader.SamplingFreq/2));
end

%%

scale       = ExpoXMLimport.blackrock.scale;
offset      = ExpoXMLimport.blackrock.offset;
FrameSyncST = ExpoXMLimport.frames.Times+offset;
FrameSyncST = floor(.1*(((FrameSyncST - FrameSyncST(1))./scale) + FrameSyncST(1)));
FrameSyncST = [FrameSyncST;FrameSyncST(end)+8.333]+1;

binsperpass = histc(floor(ExpoXMLimport.frames.Times),sort([ExpoXMLimport.passes.StartTimes ExpoXMLimport.passes.EndTimes]));
binsperpass = binsperpass(1:2:end);

tmp = 1;
PSTH        = zeros(size(FrameSyncST,1)-1,96,n_cutoffs);
PSTHndxs    = cell(1,length(binsperpass));
for ii = 1:length(binsperpass)
    PSTHndxs{ii} = tmp:(tmp-1)+binsperpass(ii);
    tmp          = (tmp+binsperpass(ii));
end

%%
for curchannel = 1%:96
    aa=tic;
    fprintf(flog,'Channel %02d:',curchannel);
    voltage     = cat(2,zeros(1,nsdata.TimeStamps(segment)),(double(nsdata.raw{segment}(curchannel,:))),zeros(1,60));
    % ------------------------------------------------------------------
    for curband = 1:n_cutoffs
        fprintf(flog,' [FILTERING]');
        if low_cutoff(curband)<200
            voltage     = filtfilt(b(curband,:),a(curband,:),voltage);
        else
            voltage     = FiltFiltM(b(curband,:),a(curband,:),voltage);
        end
        % ------------------------------------------------------------------
        fprintf(flog,' [SQUARING]');
        voltage     = voltage.^2;
        % ------------------------------------------------------------------
        fprintf(flog,' [BINNING]');
        p = zeros(1,size(FrameSyncST,1)-1);
        for ii = 1:size(FrameSyncST,1)-1
            p(ii) = mean(voltage(FrameSyncST(ii):FrameSyncST(ii+1)));
        end
        % ------------------------------------------------------------------
        PSTH(:,curchannel,curband) = p;
        fprintf(flog,' [STORED]\n');
    end
    fprintf(flog,' %05.2f s\n',toc(aa));
end
fprintf(flog,'---------------------------------\n');
plot(sqrt(PSTH(:,1,1)))
%%
if flog ~= 1
    fclose(flog);
end

