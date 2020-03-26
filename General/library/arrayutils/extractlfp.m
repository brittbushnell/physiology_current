function [LFP,LFPndxs]=extractlfp(monkey,hemi,experiment)
%
%       Author: Romesh Kumbhani
%        Email: romesh.kumbhani@nyu.edu
%      Version: 1.0
% Last updated: 2014-11-05

%%
% clear all;
% monkey = 646;
% hemi   = 'l2';
% exp    = 6;

starttime = tic;
[~,cname]=system('uname -n');

if strcmp(cname(1:end-1),'zemina') % on zemina
    expofilename = sprintf('/home/romesh/Matlab/analysis/m%d/mat/m%d%s#%d[LSRC].mat',monkey,monkey,hemi,experiment);
    nsfilename = sprintf('/experiments/m%d_array/recordings/ns2/m%d%s#%03d.ns2',monkey,monkey,hemi,experiment);
else
    expofilename = sprintf('/scratch/rdk214/analysis/m%d/mat/m%d%s#%d[LSRC].mat',monkey,monkey,hemi,experiment);
    nsfilename = sprintf('/scratch/rdk214/analysis/m%d/ns2/m%d%s#%03d.ns2',monkey,monkey,hemi,experiment);
end

load(expofilename);
[nsdata,nsheader] = getNSxData(nsfilename);

%%
segment     = 1; % assume no pauses;
flog        = 1;

%% define default values
n_cutoffs   =  1;
low_cutoff  = 20; % 300 Hz
high_cutoff = 90; % 6000 Hz


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
FrameSyncST = floor((nsheader.SamplingFreq/10000)*(((FrameSyncST - FrameSyncST(1))./scale) + FrameSyncST(1)));
FrameSyncST = [FrameSyncST;FrameSyncST(end)+floor((nsheader.SamplingFreq/120))]+1;

binsperpass = histc(floor(ExpoXMLimport.frames.Times),sort([ExpoXMLimport.passes.StartTimes ExpoXMLimport.passes.EndTimes]));
binsperpass = binsperpass(1:2:end);

tmp = 1;
LFP        = zeros(size(FrameSyncST,1)-1,96,n_cutoffs);
LFPndxs    = cell(1,length(binsperpass));
for ii = 1:length(binsperpass)
    LFPndxs{ii} = tmp:(tmp-1)+binsperpass(ii);
    tmp          = (tmp+binsperpass(ii));
end

%%
for curchannel = 1:96
    aa=tic;
    fprintf(flog,'Channel %02d:',curchannel);
    voltage     = cat(2,zeros(1,nsdata.TimeStamps(segment)),(double(nsdata.raw{segment}(curchannel,:))),zeros(1,60));
    % ------------------------------------------------------------------
    for curband = 1:n_cutoffs
        fprintf(flog,' [FILTERING]');
        if (low_cutoff(curband)<200)&&(nsheader.SamplingFreq>20000)
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
        parfor ii = 1:size(FrameSyncST,1)-1
            p(ii) = mean(voltage(FrameSyncST(ii):FrameSyncST(ii+1)));
        end
        % ------------------------------------------------------------------
        LFP(:,curchannel,curband) = p;
        fprintf(flog,' [STORED]');
    end
    fprintf(flog,' %05.2f s\n',toc(aa));
end
fprintf(flog,'---------------------------------\n');

%%
%plot(sqrt(LFP(:,1,1)));
stoptime = toc(starttime);
fprintf('Totaltime: %.0fh, %.0fm, %.2fs',floor(stoptime/3600),mod(stoptime,3600)/60,mod(stoptime,60))
if flog ~= 1
    fclose(flog);
end

