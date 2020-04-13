function c=spinner(n)
if nargin < 1
    n = 1;
end
tag = '-spinner-';
prev=get(0,'UserData');
ix=strfind(prev,tag);
if isempty(ix)
    spinner = '|/-\';
else
    nS = str2double(prev(ix+numel(tag)));
    spinner = prev([1:nS] + ix+numel(tag));
    spinner = circshift(spinner,-n);
end

c = spinner(1);
data = sprintf('%s%.0f%s',tag,numel(spinner),spinner);
set(0,'userdata',data)

