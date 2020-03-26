function snr = getSNR(W)

W = double(W);

W_bar = mean(W);

A = max(W_bar) - min(W_bar);

if ~isempty(W) %added isempty condition to handle a rare bug when only one spike happened on the channel. -03Apr2013 Adam C. Snyder
    e = W - repmat(W_bar,size(W,1),1);
    e = reshape(e,size(e,1)*size(e,2),1);
    snr = A/(2*std(e));
else
    snr = nan;
end;