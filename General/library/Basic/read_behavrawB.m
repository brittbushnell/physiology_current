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
%
% Aug 2022 edited by Brittany to work with different if statements that are
% more inclusive.


function S = read_behavrawB(file)

if exist(file,'file')~=2
    fprintf([mfilename ':filenotexist'],'\n The file does not exist.\n\t%s\n',file)
%     keyboard
end

% [~,~,e]=fileparts(file);
% e=e(2:end); % remove .
% fprintf('reading file %s \n', file)

if contains(file,'psy') % run on Windows
    S = read_behavraw_win3(file);
else
    S = read_behavraw_dos(file);
end
