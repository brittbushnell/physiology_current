function [location] = determineComputer()

tmp = char(java.net.InetAddress.getLocalHost.getHostName);

if contains(tmp,'laca')
    location = 1;
elseif contains(tmp,'zemina')
    location = 3;
else
    location = 0;
end
    