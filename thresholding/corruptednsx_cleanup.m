function [adjusted_nev] = corruptednsx_cleanup(nev_filename,nsx_filename,cleaned_nev)
%CORRUPTEDNSX_CLEANUP: The hacky solution to instances in which there is an
%arbitrary offset in the nsx files. I pray you never encounter this but
%this is a potential patch. Scans the first 10 channels, figures out what
%the latency delay is between the NS6 and NEV file. Corrects for offsets
%and rewrites the cleaned NEV file. 


%load 10 first NSX channels.
%%
NS6 = openNSx('read',nsx_filename,'c:1:10');


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


%% load corresponding NEV
NEV = openNEV(nev_filename,'nosave');

%%
[b1,a1] = butter(2,[250 5000]/15000,'bandpass');

bad  = find(diff(double(NEV.Data.Spikes.TimeStamp))<0,1,'last');
if isempty(bad)
    fprintf('******** No bad timebins recognized ********\n')
end
offset_est = (NEV.Data.Spikes.TimeStamp(bad));


for jj = 1:10
    ch = NS6.Data(jj,:);
    ch_filt = filter(b1,a1,ch);
    stch = NEV.Data.Spikes.TimeStamp(NEV.Data.Spikes.Electrode==jj);
    wvch = NEV.Data.Spikes.Waveform(:,NEV.Data.Spikes.Electrode==jj);
    
    if length(stch)>100
        len = round(length(stch)/2);
        for kk = len:len+9
            max_before = double(stch(kk)-offset_est*2);
            max_end = double(double(stch(kk))+double(offset_est)*2);
            
            max_before = max(max_before,1);
            max_end = max(max_end,length(ch_filt));
            
            r = (stch(kk)-offset_est*2):(stch(kk)+offset_est*2);
            [istart,istop] = findsignal(ch_filt(r),double(wvch(:,kk)));
            d = double(istop)-double(istart);

            istart = istart+max_before-1;
            corrstore(kk-len+1) = corr(double(wvch(:,kk)),ch_filt(istart:istart+d)');
            store_start(kk-len+1) = istart;
            
        end
        assert(~any(corrstore<.9),'something is wrong')
        
        store_ch_offset(jj) = mode(store_start-double(stch(len:len+9)));
    else
        store_ch_offset(jj) = NaN;
    end
end
%%
%find mode
offset_secondary = mode(store_ch_offset)-offsets;

NEV2 = openNEV(cleaned_nev,'nosave','nomat');
NEV2.Data.Spikes.TimeStamp = uint32(NEV2.Data.Spikes.TimeStamp-offset_secondary);
bad = NEV2.Data.Spikes.TimeStamp==0;

NEV2.Data.Spikes.TimeStamp(bad) = [];
NEV2.Data.Spikes.Electrode(bad) = [];
NEV2.Data.Spikes.Unit(bad) = [];
NEV2.Data.Spikes.Waveform(:,bad) = [];
NEV2.MetaTags.PacketBytes = size(wvch,1)*2 +8; %packet size. 
[~,b] = fileparts(cleaned_nev);
NEV2.MetaTags.Filename = strrep(b,'.nev','_ogcorrupt.nev');
saveNEV(NEV2,strrep(cleaned_nev,'.nev','_ogcorrupt.nev'),'noreport');

adjusted_new = NEV2;
