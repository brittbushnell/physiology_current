%VERWARNING displays warning
%
%   Reports the parent function uses the "New MATLAB graphics system".
%   Following the warning the parent may crash.
%
%   See
%       http://blogs.mathworks.com/loren/2014/10/03/matlab-r2014b-graphics-part-1-features-of-the-new-graphics-system/
%       http://blogs.mathworks.com/loren/2014/10/14/matlab-r2014b-graphics-part-2-using-graphics-objects/
%       http://blogs.mathworks.com/loren/2014/11/05/matlab-r2014b-graphics-part-3-compatibility-considerations-in-the-new-graphics-system/
%
%
%   Input:
%   verwarning
%       no arguments
%
%   Output:
%       warning message
%
% V0: TvG Mar 2017, NYU


function verwarning

% add name to suppress warning
SuppresWithUsers = {''}; 

% get parent 
S = dbstack(1,'-completenames');
P = S(1); % errors is called from command line

% current version
V=ver('MATLAB');

if ~strcmpi(java.lang.System.getProperty('user.name'),SuppresWithUsers) && verLessThan('matlab','8.4') %2014b
    fprintf(1,'[\bWarning: Since version 2014b the MATLAB graphics system changed dramatically.\n[%s] might not work with your Matlab version (%s).]\b\n',P.name,V.Version)
    fprintf(1,'[\b  In <a href="matlab: opentoline(''%1$s'',%2$g)">%3$s line %2$g</a>]\b\n',P.file,P.line,P.name)
    %warning('this function has BETA status')
end


