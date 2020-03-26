function outputVersion = ExpandVersion(inputVersion)
%function outputVersion = ExpandVersion(inputVersion)
%
% This expo help function converts string versions in to numerical
% equivalents. Unlike str2num, this allows for subversions.
%
%   Author:      Romesh Kumbhani
%	Version:     1.5.14
%   Last updated:  2013-06-10
%   E-mail:      romesh.kumbhani@nyu.edu
%


nDots = numel(strfind(inputVersion,'.'));
versionformat = '%d';

for ii=1:nDots
    versionformat = cat(2,versionformat,'.%d');
end

temp = sscanf(inputVersion,versionformat);

outputVersion = 0;
for ii=0:(size(temp,1)-1)
    outputVersion = outputVersion + temp(ii+1)./(100^ii);
end
        