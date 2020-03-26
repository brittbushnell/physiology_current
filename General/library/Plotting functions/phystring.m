function h = phystring(location,string)
%PHYSTRING adds text to the figure at the appropriate location without modifying current attributes.
% 
% phystring(location string), where string is the text to be placed and
% location is one of the following:
% 
% 'title','xlabel','ylabel'
%
% if an output argument is given, phystring returns a handle to the object 
%
% h=phytitle(...), where h is the handle to the object.
%
% Ex:
%   x = 0:15:360;
%   y = 50.*exp(cosd(x-180));
%   phyplot(x,y,'k','xticks',0:90:360,'yticks',0:50:150,'width',4,'fontsize',22,'fontname','Times','fontangle','normal','fontweight','bold');
%   phystring('title','This is a plot!');
% 
% see also phyplot.
%
% version 1.0 - romesh.kumbhani@nyu.edu - 2010-10-08

try
    hh=get(gca,location);
catch ME
    error('ExpoMatlab:phystring','The location ''%s'' is invalid. Please choose: ''title'', ''xlabel'', or ''ylabel'' ',location);
end

try 
    set(hh, 'string', string);
catch ME
    error('ExpoMatlab:phystring','The string could not be set. Please check to make sure it''s a character string.');
end

if nargout > 0
  h = hh;
end