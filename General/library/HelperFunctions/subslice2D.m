function outputvar = subslice2D(inputvar,subsize,substep)

% takes a 2D image (X,Y) or a stack of 2D images (X,Y,nImages)
% and subsamples the images. Each subsample is "subsize" in
% size, and is shifted by "substep" in (X,Y).
%
% for example:
%
% subslice2D([1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16],2,1)
% results in:
%
% ans(:,:,1,1,1) = [ 1  2;  5  6];
% ans(:,:,1,2,1) = [ 2  3;  6  7];
% ans(:,:,1,3,1) = [ 3  4;  7  8];
% ans(:,:,2,1,1) = [ 5  6;  9 10];
% ans(:,:,2,2,1) = [ 6  7; 10 11];
% ans(:,:,2,3,1) = [ 7  8; 11 12];
% ans(:,:,2,1,1) = [ 9 10; 13 14];
% ans(:,:,2,2,1) = [10 11; 14 15];
% ans(:,:,2,3,1) = [11 12; 15 16];
%
% romesh.kumbhani@nyu.edu (romesh kumbhani) 2011-03-30

switch nargin
    case 0
        error('helper:subslice','No paramters given!');
    case 1
        error('helper:subslice','Input variable not defined.');
    case 2
        substep = subsize;
    case 3
        % all is well.
    otherwise
        error('helper:subslice','Too many parameters given.');
end

if ndims(inputvar) < 2
    error('helper:subslice','Input variable has less than two dimensions.');
end

if ndims(inputvar) > 3
    error('helper:subslice','Input variable has too many dimensions.');
end
if ndims(inputvar) == 3
    input_frames = size(inputvar,3);
else
    input_frames = 1;
end

%%
input_rows = size(inputvar,1);
input_cols = size(inputvar,2);

subslice_rows = subsize(1);

if size(subsize,2) == 1
    subslice_cols = subsize(1);
else
    subslice_cols = subsize(2);
end

subslicestep_rows = substep(1);
if size(substep,2) == 1
    subslicestep_cols = substep(1);
else
    subslicestep_cols = substep(2);
end

n_subrows = ceil((input_rows + subslicestep_rows - subslice_rows) ./ (subslicestep_rows));
n_subcols = ceil((input_cols + subslicestep_cols - subslice_cols) ./ (subslicestep_cols));
%%

outputvar = nan(subslice_rows,subslice_cols,n_subrows,n_subcols,input_frames);
%%

start_R = 1:subslicestep_rows:(input_rows-1);
stop_R  = min((1:subslicestep_rows:(input_rows-1))+subslice_rows-1,input_rows);
start_C = 1:subslicestep_cols:(input_cols-1);
stop_C  = min((1:subslicestep_cols:(input_cols-1))+subslice_rows-1,input_cols);
[rows,cols]=ndgrid(1:input_rows,1:input_cols,1:input_frames);
%%
for ii=1:n_subrows
    for jj=1:n_subcols
        outputvar(1:(stop_R(ii)-start_R(ii)+1),...
            1:(stop_C(jj)-start_C(jj)+1),...
            ii,jj,1:input_frames) = ...
            reshape(inputvar(...
            (rows>=start_R(ii))&...
            (rows<=stop_R(ii))&...
            (cols>=start_C(jj))&...
            (cols<=stop_C(jj))),...
            stop_R(ii)-start_R(ii)+1,...
            stop_C(jj)-start_C(jj)+1,...
            input_frames);
    end
end
