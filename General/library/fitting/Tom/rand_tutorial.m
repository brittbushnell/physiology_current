%RAND_TUTORIAL tutorial about implementation of random
%
%   This scripts illustrates the basics of using random numbers in by
%   creating a github-style avatar.
%
% v0: TvG Aug 2017, NYU

%% avatar properties
AvWidth     = 5;
Dens        = [0.2 0.8];

%% create the avatar

% start with left side:

% Empty matrix
LeftSide    = zeros(AvWidth,ceil(AvWidth/2));
% calculate the number of elements that needs to be filled
nLeft       = numel(LeftSide);
nFillRange  = nLeft * Dens;
nFill       = round(min(nFillRange)+rand(1)*abs(diff(nFillRange)));

% fill the leftside

% shuffle indices
iFill = randperm(nLeft);
% select indices and toggle elements in left side
iFill = iFill(1:nFill);
LeftSide(iFill) = true;

% copy it to the right side
RightSide = fliplr(LeftSide(:,1:floor(AvWidth/2)));

% combine
Avatar = [LeftSide, RightSide];

%% color
Color = rand(3,1);
% increase 3rd dimension: RGB
Avatar = repmat(Avatar,1,1,3);
Avatar(:,:,1) = Avatar(:,:,1) * Color(1);
Avatar(:,:,2) = Avatar(:,:,2) * Color(2);
Avatar(:,:,3) = Avatar(:,:,3) * Color(3);
% white background
Avatar(Avatar==0) = 1;

%% display
figure
imagesc(Avatar)
ax=gca;
ax.Visible = 'off';
ax.Units = 'Normalized';
ax.Position = [0 0 1 1];