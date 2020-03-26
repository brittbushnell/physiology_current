function spikeNum = GetSpikeNum(expoIn,chan,template)
%
%spikeNum = GetSpikeNum(expoIn,chan,template)
%
if nargin==1
    spikeNum = GetValidTemplates(expoIn);
else

    bind = expoIn.spiketimes.Channels == chan & ...
        expoIn.spiketimes.Templates == template;

    if sum(bind)==0
        %disp('Error in GetSpikeNum: invalid channel,template combo.')
        spikeNum = nan;
    elseif sum(bind)>1
        %disp('Error in GetSpikeNum: channel,template combo appears twice.')
        spikeNum = nan;
    else
        spikeNum = expoIn.spiketimes.IDs(bind);
    end

end