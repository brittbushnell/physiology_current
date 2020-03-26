function [ExpoPLXimport,ExpoXMLimport,nfiles] = preprocess(dirname,varargin)
% function [ExpoPLXimport,ExpoXMLimport,nfiles] = preprocess(dirname,...)
% where ... can be 'spikes','wideband', and/or 'events', or leave blank for
% all.
%%
a = dir(cat(2,dirname,'/*.plx'));
plxfilenames = {a(:).name};

cnt = 1;
for ii=1:size(plxfilenames,2)
    xmlfilenames = cat(2,dirname,'/',plxfilenames{ii}(1:end-3),'xml');
    if exist(xmlfilenames,'file')
        validfiles{cnt} = cat(2,dirname,'/',plxfilenames{ii}(1:end-4));
        cnt = cnt + 1;
    end
end
nfiles = cnt-1;

ExpoPLXimport = cell(nfiles,1);
ExpoXMLimport = cell(nfiles,1);

for ii = 1:nfiles
    [ExpoPLXimport{ii},ExpoXMLimport{ii}] = loadfiles(validfiles{ii},varargin{:});
end
    