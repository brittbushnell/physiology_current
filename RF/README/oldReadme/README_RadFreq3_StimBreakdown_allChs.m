
%README_RadFreq3_StimBreakdown_allChs

% Written by Brittany Bushnell, NYU
%% MATRICES THAT ARE SAVED IN CLEANDATA (_RFxAmp)
% rfResps: 3D matrix of mean responses on each presentation to each unique RF
% stimulus, following the same parameters as created in parseRadFreqStimResp.
% This matrix does not include responses to circles or blanks.
% 
% circleResps: 3D matrix of mean responses to each presentation to each 
% unique circles. This matrix does not include responses to RF stimuli or 
% blanks.
% 
% rfPhases: version of rfResps collapsed across phases.
% 
% rfLocsMuPhases: 4D matrix, where rfPhases has been further broken down so 
% the 4th dimension is location. The second of three locations is always the 
% central location. 
% 
% circleLocsMuPhases: also a 4D matrix, where the circles are broken down by 
% location. 
%% GET BLANK RESPONSES 
% The goal is to get the response to blank stimuli across all channels, so
% first, we take cleanData.blankResps and concatentate. cell2mat
% concatenates by taking each cell and turning them into columns in one
% matrix. So blanks goes from a 96 cell array with each cell being n-trialsx1
% to a n-trialsx96 matrix.

% Then, get a grand mean of the means (end-3) and a mean of the medians (end-2)
% across all channels. LEbaseMu and LEbaseMd (and their RE versions) should
% each just be one number. These two numbers should be very close to one
% another. If there is a large difference between them, there's an outlier
% messing up the signal. Most likely this is caused by some artifact that's
% leading to abnormally high firing rates.
%% Get responses to RF stimuli
% Using cat instead of cell2mat creates a 3D matrix instead of a cell
% array so it's n-trials x n-stimuli x n-channels, then get the mean
% responses across channels (this makes it a 2D array).

% Next, we want to separate out the responses to the circles from the
% responses to the radial frequency stimuli, so we find the columns where
% the first row == 32, and create two matrices, one that is just the RF
% stimuli, and one that is just the circle stimuli. 

% To make the data more user friendly, we reshape the RF matrix to create a
% 3D matrix where the third dimension is RF. This way,
% LErfResps(:,:,1) will be the responses to all of the RF4 stimuli for ex.

% Next, we collapse across phases. To do this, first the stimuli has to be 
% sorted so the data is grouped by phase. This is done first by making each
% RF into its own matrix, sorting that, then re-concatenating them to
% recreate the 3D matrix strucutre. Next, create a 4th dimension that is
% phase, so we can collapse across it to go back down to a 3D matrix that
% is the mean responses to each unique stimulus.

% Finally, we divide the data into matrices based on the location the
% stimulus was presented at. Locations 1 and 2 are arbitrarily defined by
% the minimum and maximum x locations used. The center location is
% determined by finding the one that is the mean of the minimum and maximum
% x locations. This works because the locations used are defined as being
% equidistant in opposite directions from the center. 
%% Plot data
% The goal with these plots are to determine if there's a difference
% between the mean and median responses. If there is a difference between
% them, then there is something funky happening in the responses that was
% not cleaned up in step1.  Need to go through the original data and likely
% do manual artifact rejection.
