%READ_BEHAVRAW read data from behavraw experiments
%
%   This function reads data files generated in the psychophysics setups.
%   This is a wrapper function for read_behavraw_dos and read_behavraw_win.
%   It will select the correct routine base on the input filename.
%
%   Input:
%   read_behavraw(file)
%       file:   filename. E.g. moto_ga.055 or moto_ga.0055
%
%   Output:
%   S = read_behavraw(..)
%       S:      structure with data from file
%
%   Example:
%
%     file = '/arc/2.5/p2/vnl/vnl/data/psycho/behavraw/ga/peripho/perip_ga.363';
%
%     S = read_behavraw(file);
%
%     [
%     S.Summary(:,8) ,...
%     nansum(S.isRight,2)
%     ]
% 
%     [
%     S.Summary(:,3) ,...
%     nansum(S.isCorrect,2)
%     ]
%
% TvG Aug 2017, NYU: initial


function S = read_behavraw(file)

if exist(file,'file')~=2
    error([mfilename ':filenotexist'],'The file does not exist.\n\t%s\n',file)
end

[~,~,e]=fileparts(file);
e=e(2:end); % remove .
if numel(e) == 3 && all(~isletter(e))
    S = read_behavraw_dos(file);
elseif numel(e) == 4 || (numel(e) == 3 && strcmpi(e,'psy'))
    S = read_behavraw_win(file);
end