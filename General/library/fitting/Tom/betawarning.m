%BETAWARNING displays warning
%
%   reports that the parent function is beta.
%
%   Input:
%   betawarning
%       no arguments
%
%   Output:
%       warning message
%
% V0: TvG Mar 2017, NYU

function betawarning

% add name to suppress warning
SuppresWithUsers = {'tomvg'}; 

% get parent 
S = dbstack(1,'-completenames');
P = S(1); % Will give error when called from command line

if ~strcmpi(java.lang.System.getProperty('user.name'),SuppresWithUsers)
    fprintf(1,'[\bWarning: [%s] has BETA status]\b\n',P.name)
    fprintf(1,'[\b  In <a href="matlab: opentoline(''%1$s'',%2$g)">%3$s line %2$g</a>]\b\n',P.file,P.line,P.name)
    %warning('this function has BETA status')
end


