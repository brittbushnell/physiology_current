function [location] = determineComputer()

tmp = char(java.net.InetAddress.getLocalHost.getHostName);

if strcmp(tmp,'laca')
    location = 1;
elseif strcmp(tmp,'zemina')
    location = 3;
else
    location = 0;
end
    